//
//  ViewRerender.swift
//  DemoApp
//
//  Created by Ibrahim Mo Gedami on 07/09/2025.
//

// MARK: - Reference
///*** https://medium.com/@tungvt.it.01/avoiding-unnecessary-view-re-renders-in-swiftui-47c2ecdd1fb1

import SwiftUI

struct ViewRerender: View {
    
    @StateObject var viewModel: ViewRerenderViewModel = .init()
    
    var body: some View {
        let _ = Self._printChanges()
        VStack {
            EmailViewRerender(viewModel: viewModel)
            PasswordViewRerender(viewModel: viewModel)
            DoNotUseViewModelViewRerender()
        }
        .environmentObject(viewModel)
    }
    
}

final class ViewRerenderViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    
}

struct EmailViewRerender: View {
    
    @ObservedObject var viewModel: ViewRerenderViewModel
    
    var body: some View {
        let _ = Self._printChanges()
        TextField("Enter email", text: $viewModel.email)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(50)
            .overlay(
                RoundedRectangle(cornerRadius: 50)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .padding(.horizontal)
    }
}

struct PasswordViewRerender: View {
    
    @ObservedObject var viewModel: ViewRerenderViewModel
    
    var body: some View {
        let _ = Self._printChanges()
        SecureField("Enter password", text: $viewModel.password)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(50)
            .overlay(
                RoundedRectangle(cornerRadius: 50)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .padding(.horizontal)
    }
    
}

// 🚫📦  This view does not use any part of the view model's data
struct DoNotUseViewModelViewRerender: View {
    
    @EnvironmentObject var viewModel: ViewRerenderViewModel
    
    var body: some View {
        let _ = Self._printChanges()
        Text("Do Not Use View Model View")
    }
    
}

/*
 The Problem:-
 
 ⁉️ Why this happens?
 This happens because when any @Puhlished property changes, the ObservableObject sends a change notification to all views observing it . Views that observe the object via property wrappers like @StateObject @ObservedObject and @EnvironmentObject will re-render regardless of which property actually changed or whether the view even uses that property at all.

 ⚙️ What’s Actually Happening Behind the Scenes?
 When you mark a property with @Published Swift automatically injects code that calls objectWillChange.send() every time that property changes. This is how SwiftUI knows to trigger a view re-render.
 
 ViewRerender: _viewModel changed.
 EmailView: _viewModel changed.
 PasswordView: _viewModel changed.
 DoNotUseViewModelView: _viewModel changed.
 ViewRerender: _viewModel changed.
 EmailView: _viewModel changed.
 PasswordView: _viewModel changed.
 DoNotUseViewModelView: _viewModel changed.
 ViewRerender: _viewModel changed.
 EmailView: _viewModel changed.
 PasswordView: _viewModel changed.
 DoNotUseViewModelView: _viewModel changed.
 
 */

// MARK: First Solution

final class AuthViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    
}

struct AuthView: View {
    
    @StateObject var viewModel: AuthViewModel = .init()

    var body: some View {
        let _ = Self._printChanges()
        VStack {
            EmailView(email: $viewModel.email)
            PasswordView(password: $viewModel.password)
            DoNotUseViewModelView()
        }
        .environmentObject(viewModel)
    }
}

struct EmailView: View {
    
    @Binding var email: String

    var body: some View {
        let _ = Self._printChanges()

        TextField("Enter email", text: $email)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(50)
            .overlay(
                RoundedRectangle(cornerRadius: 50)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .padding(.horizontal)
    }

}

struct PasswordView: View {
    
    @Binding var password: String

    var body: some View {
        let _ = Self._printChanges()
        SecureField("Enter password", text: $password)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(50)
            .overlay(
                RoundedRectangle(cornerRadius: 50)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .padding(.horizontal)
    }
}

// 👉 This view no longer observes the ViewModel.
struct DoNotUseViewModelView: View {
    
    var body: some View {
        let _ = Self._printChanges()
        Text("Do Not Use View Model View")
    }

}

// MARK: Second Solution: Use the Observation framework
@Observable
class ObservableSignUpViewModel {
    
    var email: String = ""
    var password: String = ""
    
}

struct ObservableSignUpView: View {
    
    @State var viewModel: ObservableSignUpViewModel = .init()

    var body: some View {
        let _ = Self._printChanges()
        VStack {
            ObservableEmailView(viewModel: viewModel)
            ObservablePasswordView(viewModel: viewModel)
            ObservableDoNotUseViewModelView(viewModel: viewModel)
        }
    }
    
}

struct ObservableEmailView: View {
    
    @Bindable var viewModel: ObservableSignUpViewModel

    var body: some View {
        let _ = Self._printChanges()

        TextField("Enter email", text: $viewModel.email)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(50)
            .overlay(
                RoundedRectangle(cornerRadius: 50)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .padding(.horizontal)
    }

}

struct ObservablePasswordView: View {
    
    @Bindable var viewModel: ObservableSignUpViewModel

    var body: some View {
        let _ = Self._printChanges()
        SecureField("Enter password", text: $viewModel.password)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(50)
            .overlay(
                RoundedRectangle(cornerRadius: 50)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .padding(.horizontal)
    }
    
}

struct ObservableDoNotUseViewModelView: View {
    
    var viewModel: ObservableSignUpViewModel
    
    var body: some View {
        let _ = Self._printChanges()
        Text("Do Not Use View Model View")
    }

}
