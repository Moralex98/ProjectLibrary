//
//  LoadingView.swift
//  MyProjectLibrary
//
//  Created by Freddy Morales on 17/09/24.
//

import SwiftUI

struct LoadingView: View {
    @Binding var isLoading: Bool
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()
            
            
            if isLoading {
                ZStack {
                    Color(.systemBackground)
                        .ignoresSafeArea()
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(4)
                }
            }
        }
        .onAppear { startFakeNetworkCall() }
    }
    
    private func startFakeNetworkCall() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                isLoading = false
                isLoggedIn = true
            }
        }
    }
}

struct LoadingView_Preview: View {
    @State private var isLoading = true
    @State private var isLoggedIn = false

    var body: some View {
        LoadingView(isLoading: $isLoading, isLoggedIn: $isLoggedIn)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView_Preview()
    }
}

