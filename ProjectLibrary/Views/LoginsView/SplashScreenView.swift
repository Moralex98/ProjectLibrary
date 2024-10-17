//
//  SplashScreenView.swift
//  MyProjectLibrary
//
//  Created by Freddy Morales on 17/09/24.
//

import SwiftUI

struct SplashScreenView: View {
    @State var isActive : Bool = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    // Customise your SplashScreen here
    var body: some View {
        ZStack {
            if isActive {
                LoginView()
            } else {
                VStack {
                    VStack {
                        Image(systemName: "hare.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.red)
                        Text("Tilines INC.")
                            .font(Font.custom("Baskerville-Bold", size: 7))
                            .foregroundColor(.gray.opacity(0.90))
                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.8)) {
                            self.size = 6.5
                            self.opacity = 1.00
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
            }
        }
        .preferredColorScheme(.light) // Fuerza el modo claro en esta vista
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
            .previewInterfaceOrientation(.landscapeLeft)
        
    }
}
