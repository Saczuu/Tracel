//
//  Loading.swift
//  Kasmos
//
//  Created by Maciej Sączewski on 12/23/19.
//  Copyright © 2019 Maciej Sączewski. All rights reserved.
//

import SwiftUI

struct Loading: View {
    
    
    @State var rotateIndicator: Bool = false
    @State var showCompletion: Bool = false
    var showError: Bool!
    var errorString: String!
    var onErrorHandler: () -> Void?
    var onSuccessHandler: () -> Void?
    
    var body: some View {
        VStack {
            if showError {
                VStack {
                    Text(errorString)
                    Divider()
                    Button(action: {
                        self.onErrorHandler()
                    }) {
                        Text("Retry")
                    }
                }.padding()
                
            } else if showCompletion {
                VStack {
                    Text("Complete")
                        .onAppear{
                            self.onSuccessHandler()
                    }
                }.padding()
            } else {
                HStack {
                    Image(systemName: "arrow.2.circlepath")
                        .rotationEffect(.degrees(self.rotateIndicator ? 0 : -360))
                        .scaleEffect(2)
                        .animation(Animation.linear(duration: 0.5).repeatForever(autoreverses: false).speed(0.3))
                        .onAppear {
                            self.rotateIndicator.toggle()
                    }
                    Text("Loading")
                        .padding()
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
                .shadow(color: .gray, radius: 25, x: 0, y: 2)
                .frame(minWidth: 350, maxWidth: 750, minHeight: 120, maxHeight:350)
        )
            .animation(.spring())
        
    }
}

struct Loading_Previews: PreviewProvider {
    static var previews: some View {
        Loading(onErrorHandler: {
            print("Error")
        }, onSuccessHandler: {
            print("Success")
        })
    }
}
