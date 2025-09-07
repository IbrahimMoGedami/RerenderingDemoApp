//
//  ProfileView.swift
//  DemoApp
//
//  Created by Ibrahim Mo Gedami on 04/09/2025.
//

import Foundation
import SwiftUI
import AVKit

struct ContentView: View {
    var body: some View {
        NavigationView {
            ProfileView()
        }
    }
}

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var selectedTab = 0
    @State private var debugColors: [Color] = [.red, .green, .blue, .orange, .purple, .pink]
    @State private var currentDebugColor = Color.clear
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ProfileHeaderView(viewModel: viewModel)
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .background(Color(.systemBackground))
                
                // Tab Selection
                HStack(spacing: 0) {
                    ForEach(0..<3) { index in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedTab = index
                                viewModel.loadContentForTab(index)
                                
                                // Debug: Change color on tab switch
                                currentDebugColor = debugColors.randomElement()?.opacity(0.3) ?? Color.gray.opacity(0.3)
                            }
                        }) {
                            VStack(spacing: 8) {
                                Text(viewModel.tabTitle(for: index))
                                    .font(.system(size: 16, weight: selectedTab == index ? .semibold : .regular))
                                    .foregroundColor(selectedTab == index ? .blue : .gray)
                                
                                if selectedTab == index {
                                    Capsule()
                                        .fill(Color.blue)
                                        .frame(height: 3)
                                        .transition(.scale)
                                } else {
                                    Divider()
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding(.top, 16)
                .background(Color(.systemBackground))
                
                // Debug indicator
                HStack {
                    Text("Pagination Debug:")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Circle()
                        .fill(currentDebugColor)
                        .frame(width: 20, height: 20)
                    
                    Text(viewModel.isLoading ? "Loading..." : "Idle")
                        .font(.caption)
                        .foregroundColor(viewModel.isLoading ? .blue : .gray)
                    
                    Text("Page: \(viewModel.currentPage)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(8)
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .padding(.top, 8)
                
                // Tab Content based on selection
                Group {
                    switch selectedTab {
                    case 0:
                        UploadedView(
                            videos: viewModel.uploadedVideos,
                            isLoading: viewModel.isLoading,
                            canLoadMore: viewModel.canLoadMore,
                            loadMoreVideos: {
                                viewModel.loadMoreUploadedVideos()
                                // Debug: Change color on pagination
                                currentDebugColor = debugColors.randomElement()?.opacity(0.3) ?? Color.gray.opacity(0.3)
                            }
                        )
                        .background(debugColors.randomElement()?.opacity(0.1))
                    case 1:
                        DraftsView(drafts: viewModel.draftVideos)
                        .background(debugColors.randomElement()?.opacity(0.1))
                    case 2:
                        LikesView(
                            videos: viewModel.likedVideos,
                            isLoading: viewModel.isLoading,
                            canLoadMore: viewModel.canLoadMore,
                            loadMoreVideos: {
                                viewModel.loadMoreLikedVideos()
                                // Debug: Change color on pagination
                                currentDebugColor = debugColors.randomElement()?.opacity(0.3) ?? Color.gray.opacity(0.3)
                            }
                        )
                        .background(debugColors.randomElement()?.opacity(0.1))
                    default:
                        UploadedView(
                            videos: viewModel.uploadedVideos,
                            isLoading: viewModel.isLoading,
                            canLoadMore: viewModel.canLoadMore,
                            loadMoreVideos: {
                                viewModel.loadMoreUploadedVideos()
                                currentDebugColor = debugColors.randomElement()?.opacity(0.3) ?? Color.gray.opacity(0.3)
                            }
                        )
                        .background(debugColors.randomElement()?.opacity(0.1))
                    }
                }
                .frame(minHeight: UIScreen.main.bounds.height * 0.6)
            }
        }
        .background(Color(currentDebugColor))
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            if viewModel.uploadedVideos.isEmpty {
                viewModel.loadInitialContent()
                // Initial debug color
                currentDebugColor = debugColors.randomElement()?.opacity(0.3) ?? Color.gray.opacity(0.3)
            }
        }
    }
}

// MARK: - Updated ViewModel with Debug Info
class ProfileViewModel: ObservableObject {
    @Published var uploadedVideos: [Video] = []
    @Published var likedVideos: [Video] = []
    @Published var draftVideos: [Video] = []
    @Published var isLoading = false
    @Published var canLoadMore = true
    @Published var currentPage = 0 // Debug property
    
    private var currentUploadedPage = 0
    private var currentLikedPage = 0
    
    func loadInitialContent() {
        isLoading = true
        currentPage = 0 // Reset page counter
        print("🔄 Loading initial content - Page: \(currentPage)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.uploadedVideos = self.generateVideos(page: 0, type: "Uploaded")
            self.likedVideos = self.generateVideos(page: 0, type: "Liked")
            self.draftVideos = self.generateVideos(page: 0, type: "Draft")
            self.isLoading = false
            self.currentUploadedPage = 1
            self.currentLikedPage = 1
            self.currentPage = 1
            print("✅ Initial content loaded - Current Page: \(self.currentPage)")
        }
    }
    
    func loadContentForTab(_ tabIndex: Int) {
        print("🔍 Switching to tab: \(tabTitle(for: tabIndex))")
        
        switch tabIndex {
        case 0 where uploadedVideos.isEmpty:
            loadInitialUploadedVideos()
        case 2 where likedVideos.isEmpty:
            loadInitialLikedVideos()
        default:
            print("📊 Tab \(tabTitle(for: tabIndex)) already has content")
        }
    }
    
    func loadInitialUploadedVideos() {
        isLoading = true
        currentPage = 0
        print("🔄 Loading initial uploaded videos - Page: \(currentPage)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.uploadedVideos = self.generateVideos(page: 0, type: "Uploaded")
            self.currentUploadedPage = 1
            self.currentPage = 1
            self.isLoading = false
            print("✅ Initial uploaded videos loaded - Page: \(self.currentPage)")
        }
    }
    
    func loadInitialLikedVideos() {
        isLoading = true
        currentPage = 0
        print("🔄 Loading initial liked videos - Page: \(currentPage)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.likedVideos = self.generateVideos(page: 0, type: "Liked")
            self.currentLikedPage = 1
            self.currentPage = 1
            self.isLoading = false
            print("✅ Initial liked videos loaded - Page: \(self.currentPage)")
        }
    }
    
    func loadMoreUploadedVideos() {
        guard !isLoading && canLoadMore else {
            print("⏸️ Cannot load more uploaded videos - Loading: \(isLoading), CanLoadMore: \(canLoadMore)")
            return
        }
        
        isLoading = true
        print("🔄 Loading more uploaded videos - Current Page: \(currentUploadedPage)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let moreVideos = self.generateVideos(page: self.currentUploadedPage, type: "Uploaded")
            self.uploadedVideos.append(contentsOf: moreVideos)
            self.currentUploadedPage += 1
            self.currentPage = self.currentUploadedPage
            
            if self.currentUploadedPage >= 5 {
                self.canLoadMore = false
                print("⏹️ Reached max pages for uploaded videos")
            }
            
            self.isLoading = false
            print("✅ Loaded more uploaded videos - New Page: \(self.currentUploadedPage), Total Videos: \(self.uploadedVideos.count)")
        }
    }
    
    func loadMoreLikedVideos() {
        guard !isLoading && canLoadMore else {
            print("⏸️ Cannot load more liked videos - Loading: \(isLoading), CanLoadMore: \(canLoadMore)")
            return
        }
        
        isLoading = true
        print("🔄 Loading more liked videos - Current Page: \(currentLikedPage)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let moreVideos = self.generateVideos(page: self.currentLikedPage, type: "Liked")
            self.likedVideos.append(contentsOf: moreVideos)
            self.currentLikedPage += 1
            self.currentPage = self.currentLikedPage
            
            if self.currentLikedPage >= 12 {
                self.canLoadMore = false
                print("⏹️ Reached max pages for liked videos")
            }
            
            self.isLoading = false
            print("✅ Loaded more liked videos - New Page: \(self.currentLikedPage), Total Videos: \(self.likedVideos.count)")
        }
    }
    
    private func generateVideos(page: Int, type: String) -> [Video] {
        print("🎬 Generating videos for \(type) - Page: \(page)")
        
        let baseTitles = [
            "Mountain Sunrise", "Ocean Waves", "Forest Walk", "City Time Lapse",
            "Desert Dunes", "Underwater Life", "Night Sky", "Aurora Borealis"
        ]
        
        let baseDurations = ["0:48", "1:15", "2:30", "3:45", "4:20", "5:10"]
        
        return baseTitles.map { title in
            Video(
                title: "\(type): \(title) \(page + 1)",
                thumbnailURL: URL(string: "https://picsum.photos/300/200?random=\(Int.random(in: 1...1000))")!,
                videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!,
                duration: baseDurations.randomElement() ?? "1:00",
                views: Int.random(in: 1000...10000)
            )
        }
    }
    
    func tabTitle(for index: Int) -> String {
        switch index {
        case 0: return "Uploaded"
        case 1: return "Drafts"
        case 2: return "Likes"
        default: return ""
        }
    }
}

// MARK: - Updated Tab Views with Debug Visuals
struct LikesView: View {
    let videos: [Video]
    let isLoading: Bool
    let canLoadMore: Bool
    let loadMoreVideos: () -> Void
    
    var columns: [GridItem] {
        let minWidth: CGFloat = 150
        let count = max(3, Int(UIScreen.main.bounds.width / minWidth))
        return Array(repeating: GridItem(.flexible(), spacing: 5), count: count)
    }
    
    var body: some View {
        VStack {
            if videos.isEmpty && isLoading {
                ProgressView("Loading videos...")
                    .padding()
            } else if videos.isEmpty {
                Text("No liked videos yet")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                LazyVGrid(columns: columns, spacing: 5) {
                    ForEach(Array(videos.enumerated()), id: \.element.id) { index, video in
                        VideoCard(video: video)
                            .onAppear {
                                if index >= videos.count - 5 && !isLoading && canLoadMore {
                                    print("📱 Liked video appeared at index \(index), triggering pagination")
                                    loadMoreVideos()
                                }
                            }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, 16)
                
                if isLoading {
                    ProgressView()
                        .padding()
                }
                
                if !canLoadMore {
                    Text("No more videos to load")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}

struct UploadedView: View {
    let videos: [Video]
    let isLoading: Bool
    let canLoadMore: Bool
    let loadMoreVideos: () -> Void
    
    var columns: [GridItem] {
        let minWidth: CGFloat = 150
        let count = max(3, Int(UIScreen.main.bounds.width / minWidth))
        return Array(repeating: GridItem(.flexible(), spacing: 5), count: count)
    }
    
    var body: some View {
        VStack {
            if videos.isEmpty && isLoading {
                ProgressView("Loading videos...")
                    .padding()
            } else if videos.isEmpty {
                Text("No uploaded videos yet")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                LazyVGrid(columns: columns, spacing: 5) {
                    ForEach(Array(videos.enumerated()), id: \.element.id) { index, video in
                        VideoCard(video: video)
                            .onAppear {
                                if index >= videos.count - 5 && !isLoading && canLoadMore {
                                    print("📱 Uploaded video appeared at index \(index), triggering pagination")
                                    loadMoreVideos()
                                }
                            }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, 16)
                
                if isLoading {
                    ProgressView()
                        .padding()
                }
                
                if !canLoadMore {
                    Text("No more videos to load")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}

// MARK: - Keep the rest of the code the same (DraftsView, ProfileHeaderView, VideoCard, etc.)
struct DraftsView: View {
    let drafts: [Video]
    
    var body: some View {
        ScrollView {
            VStack {
                if drafts.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "doc.text")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        
                        Text("No drafts yet")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Text("Videos you save as drafts will appear here")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .padding(.top, 50)
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(drafts) { video in
                            DraftVideoCard(video: video)
                        }
                    }
                    .padding()
                }
            }
            .frame(maxWidth: .infinity, minHeight: 300)
        }
        .background(Color(.systemGroupedBackground))
    }
}

struct ProfileHeaderView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            // Profile Image and Stats
            HStack(spacing: 16) {
                // Profile Image
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.gray.opacity(0.3))
                    .overlay(
                        Circle()
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                    .clipShape(Circle())
                
                // User Stats
                VStack(spacing: 8) {
                    HStack(spacing: 20) {
                        VStack {
                            Text("\(viewModel.uploadedVideos.count)")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Videos")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        
                        VStack {
                            Text("1.2K")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Followers")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        
                        VStack {
                            Text("456")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Following")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            
            // User Bio
            VStack(spacing: 8) {
                Text("John Appleseed")
                    .font(.system(size: 18, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Travel enthusiast ✈️ | Nature lover 🌿 | Creating content that inspires others to explore the world 🌎")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(3)
                
                Text("Los Angeles, CA")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // Edit Profile Button
            Button(action: {
                // Edit profile action
            }) {
                Text("Edit Profile")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .padding(.vertical, 16)
    }
}

// ... (Keep the rest of your existing DraftVideoCard, VideoCard, VideoPlayerView, and Video structs the same)

// MARK: - Supporting Views
struct DraftVideoCard: View {
    let video: Video
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: video.thumbnailURL) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                } else {
                    Color.gray
                }
            }
            .frame(width: 100, height: 60)
            .cornerRadius(8)
            .clipped()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(video.title)
                    .font(.system(size: 16, weight: .semibold))
                    .lineLimit(1)
                
                Text(video.duration)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Menu {
                Button("Edit", action: {})
                Button("Delete", role: .destructive, action: {})
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(.gray)
                    .padding(8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

struct VideoCard: View {
    let video: Video
    @State private var isPlaying = false
    @State private var thumbnailImage: UIImage?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .center) {
                if let image = thumbnailImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                } else {
                    Color.gray
                        .overlay(ProgressView())
                        .onAppear {
                            loadImage()
                        }
                }
                
                Circle()
                    .fill(Color.black.opacity(0.6))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "play.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                    )
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: 120)
            .clipped()
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(video.title)
                    .font(.system(size: 14, weight: .semibold))
                    .lineLimit(1)
                
                HStack {
                    Text("\(video.views) views")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(video.duration)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }
            .padding(.top, 8)
        }
        .padding(.bottom, 8)
        .onTapGesture {
            isPlaying = true
        }
        .sheet(isPresented: $isPlaying) {
            VideoPlayerView(videoURL: video.videoURL)
        }
    }
    
    private func loadImage() {
        URLSession.shared.dataTask(with: video.thumbnailURL) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.thumbnailImage = image
                }
            }
        }.resume()
    }
}

struct VideoPlayerView: View {
    let videoURL: URL
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VideoPlayer(player: AVPlayer(url: videoURL))
                .edgesIgnoringSafeArea(.all)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
                .onAppear {
                    AVPlayer(url: videoURL).play()
                }
        }
    }
}

struct Video: Identifiable {
    let id = UUID()
    let title: String
    let thumbnailURL: URL
    let videoURL: URL
    let duration: String
    let views: Int
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
