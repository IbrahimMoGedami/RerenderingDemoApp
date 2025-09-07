//
//  ContentView.swift
//  DemoApp
//
//  Created by Ibrahim Mo Gedami on 03/09/2025.
//

import SwiftUI
import AVKit

//struct ContentView: View {
//    var body: some View {
//        NavigationView {
//            VideoGalleryView()
//                .navigationTitle("Video Gallery")
//                .navigationBarTitleDisplayMode(.large)
//        }
//    }
//}
//struct VideoGalleryView: View {
//    @StateObject private var viewModel = VideoGalleryViewModel()
//    @State private var isLoading = false
//    @State private var prefetchThreshold = 8
//    
//    var columns: [GridItem] {
//        let minWidth: CGFloat = 150
//        let count = max(3, Int(UIScreen.main.bounds.width / minWidth))
//        return Array(repeating: GridItem(.flexible(), spacing: 5), count: count)
//    }
//    
//    var body: some View {
//        ZStack {
//            Color(.systemGroupedBackground)
//                .ignoresSafeArea()
//            
//            ScrollView {
//                LazyVGrid(columns: columns, spacing: 5) {
//                    ForEach(Array(viewModel.videos.enumerated()), id: \.element.id) { index, video in
//                        VideoCard(video: video)
//                            .onAppear {
//                                // Load more content before user reaches the end
//                                if index >= viewModel.videos.count - prefetchThreshold && !isLoading && viewModel.canLoadMore {
//                                    loadMoreVideos()
//                                }
//                            }
//                    }
//                }
//                .padding(.horizontal, 12)
//            }
//            
//            if isLoading {
//                ProgressView("Loading more videos...")
//                    .padding()
//                    .background(.regularMaterial)
//                    .cornerRadius(10)
//                    .transition(.opacity)
//            }
//        }
//        .onAppear {
//            if viewModel.videos.isEmpty {
//                loadVideos()
//            }
//        }
//    }
//    
//    private func loadVideos() {
//        isLoading = true
//        viewModel.loadVideos {
//            withAnimation(.easeInOut(duration: 0.3)) {
//                isLoading = false
//            }
//        }
//    }
//    
//    private func loadMoreVideos() {
//        guard !isLoading && viewModel.canLoadMore else { return }
//        isLoading = true
//        
//        viewModel.loadMoreVideos {
//            withAnimation(.easeInOut(duration: 0.3)) {
//                isLoading = false
//            }
//        }
//    }
//}
//
//class VideoGalleryViewModel: ObservableObject {
//    @Published var videos: [Video] = []
//    @Published var canLoadMore = true
//    private var currentPage = 0
//    private let pageSize = 12
//    
//    func loadVideos(completion: @escaping () -> Void) {
//        // Simulate network request
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            self.videos = self.generateVideos(page: 0)
//            self.currentPage = 1
//            completion()
//        }
//    }
//    
//    func loadMoreVideos(completion: @escaping () -> Void) {
//        guard canLoadMore else {
//            completion()
//            return
//        }
//        
//        // Simulate network request
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            let moreVideos = self.generateVideos(page: self.currentPage)
//            self.videos.append(contentsOf: moreVideos)
//            self.currentPage += 1
//            
//            // Stop loading after 10 pages for demonstration
//            // In a real app, you'd check if the server has more content
//            if self.currentPage >= 10 {
//                self.canLoadMore = false
//            }
//            
//            completion()
//        }
//    }
//    
//    private func generateVideos(page: Int) -> [Video] {
//        // Generate unique videos for each page
//        let baseTitles = [
//            "Mountain Sunrise", "Ocean Waves", "Forest Walk", "City Time Lapse",
//            "Desert Dunes", "Underwater Life", "Night Sky", "Aurora Borealis",
//            "Waterfall Beauty", "Sunset Beach", "Winter Wonderland", "Autumn Colors"
//        ]
//        
//        let baseDurations = ["0:48", "1:15", "2:30", "3:45", "4:20", "5:10", "6:05", "7:22"]
//        
//        return baseTitles.map { title in
//            Video(
//                title: "\(title) \(page + 1)",
//                thumbnailURL: URL(string: "https://picsum.photos/300/200?random=\(Int.random(in: 1...1000))")!,
//                videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!,
//                duration: baseDurations.randomElement() ?? "1:00",
//                views: Int.random(in: 1000...10000)
//            )
//        }
//    }
//}
//
//struct VideoCard: View {
//    let video: Video
//    @State private var isPlaying = false
//    @State private var thumbnailImage: UIImage?
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 0) {
//            // Thumbnail with play button
//            ZStack(alignment: .center) {
//                // Optimized image loading
//                if let image = thumbnailImage {
//                    Image(uiImage: image)
//                        .resizable()
//                        .scaledToFill()
//                } else {
//                    Color.gray
//                        .overlay(ProgressView())
//                        .onAppear {
//                            loadImage()
//                        }
//                }
//                
//                // Play button overlay
//                Circle()
//                    .fill(Color.black.opacity(0.6))
//                    .frame(width: 50, height: 50)
//                    .overlay(
//                        Image(systemName: "play.fill")
//                            .foregroundColor(.white)
//                            .font(.title3)
//                    )
//            }
//            .frame(minWidth: 0, maxWidth: .infinity)
//            .frame(height: 150)
//            .clipped()
//            .cornerRadius(10)
//            
//            // Video info
//            VStack(alignment: .leading, spacing: 4) {
//                Text(video.title)
//                    .font(.system(size: 16, weight: .semibold))
//                    .foregroundColor(.primary)
//                    .lineLimit(1)
//                
//                HStack {
//                    Text(video.duration)
//                        .font(.system(size: 14))
//                        .foregroundColor(.secondary)
//                    
//                    Spacer()
//                    
//                    Text("\(video.views) views")
//                        .font(.system(size: 14))
//                        .foregroundColor(.secondary)
//                }
//            }
//            .frame(height: 50)
//            .padding(.horizontal, 8)
//            .padding(.vertical, 4)
//        }
//        .background(Color(.systemBackground))
//        .cornerRadius(10)
//        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
//        .onTapGesture {
//            isPlaying = true
//        }
//        .sheet(isPresented: $isPlaying) {
//            VideoPlayerView(videoURL: video.videoURL)
//        }
//    }
//    
//    private func loadImage() {
//        URLSession.shared.dataTask(with: video.thumbnailURL) { data, _, _ in
//            if let data = data, let image = UIImage(data: data) {
//                DispatchQueue.main.async {
//                    self.thumbnailImage = image
//                }
//            }
//        }.resume()
//    }
//}
//
//struct VideoPlayerView: View {
//    let videoURL: URL
//    @Environment(\.dismiss) var dismiss
//    
//    var body: some View {
//        NavigationView {
//            VideoPlayer(player: AVPlayer(url: videoURL))
//                .edgesIgnoringSafeArea(.all)
//                .navigationBarTitleDisplayMode(.inline)
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Button("Done") {
//                            dismiss()
//                        }
//                    }
//                }
//                .onAppear {
//                    AVPlayer(url: videoURL).play()
//                }
//        }
//    }
//}
//
//struct Video: Identifiable, Equatable {
//    let id = UUID()
//    let title: String
//    let thumbnailURL: URL
//    let videoURL: URL
//    let duration: String
//    let views: Int
//    
//    static var mockData: [Video] {
//        [
//            Video(
//                title: "Mountain Sunrise",
//                thumbnailURL: URL(string: "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80")!,
//                videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!,
//                duration: "2:15",
//                views: 1245
//            ),
//            Video(
//                title: "Ocean Waves",
//                thumbnailURL: URL(string: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80")!,
//                videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")!,
//                duration: "1:42",
//                views: 2876
//            ),
//            Video(
//                title: "Forest Walk",
//                thumbnailURL: URL(string: "https://images.unsplash.com/photo-1448375240586-882707db888b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80")!,
//                videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4")!,
//                duration: "3:22",
//                views: 5321
//            ),
//            Video(
//                title: "City Time Lapse",
//                thumbnailURL: URL(string: "https://images.unsplash.com/photo-1477959858617-67f85cf4f1df?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80")!,
//                videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4")!,
//                duration: "0:48",
//                views: 9876
//            ),
//            Video(
//                title: "Desert Dunes",
//                thumbnailURL: URL(string: "https://images.unsplash.com/photo-1509316785289-025f5b846b35?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80")!,
//                videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4")!,
//                duration: "2:05",
//                views: 3421
//            ),
//            Video(
//                title: "Underwater Life",
//                thumbnailURL: URL(string: "https://images.unsplash.com/photo-1439405326854-014607f694d7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80")!,
//                videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4")!,
//                duration: "1:53",
//                views: 6543
//            )
//        ]
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
