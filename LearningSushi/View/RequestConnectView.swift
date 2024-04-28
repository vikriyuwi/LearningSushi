//
//  RequestConnectView.swift
//  LearningSushi
//
//  Created by win win on 27/04/24.
//

import SwiftUI

struct RequestConnectView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var nearestdevices: DeviceFinderViewModel
    
    @State var scale:Double = 0.9
    
    var body: some View {
        VStack {
            Image(nearestdevices.permissionRequest!.peerId.displayName)
                .resizable()
                .frame(width: 200, height: 200)
                .scaledToFit()
                .padding(10)
                .scaleEffect(scale)
                .onAppear {
                    let baseAnimation = Animation.spring(duration: 0.5)
                    let repeated = baseAnimation.repeatForever(autoreverses: true)

                    withAnimation(repeated) {
                        scale = 1
                    }
                }
            HStack {
                Button {
                    nearestdevices.permissionRequest!.onRequest(false)
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
                .controlSize(.extraLarge)
                .buttonStyle(.bordered)
                NavigationLink(destination: GamePlayView(), label: {
                    Image(systemName: "checkmark")
                })
                .controlSize(.extraLarge)
                .buttonStyle(.borderedProminent)
//                            Button {
//                                request.onRequest(true)
//                                nearestdevices.show(peerId: request.peerId)
//                            } label: {
//
//                            }
                
            }
        }
        .padding(26)
    }
}
//
//#Preview {
//    RequestConnectView()
//}
