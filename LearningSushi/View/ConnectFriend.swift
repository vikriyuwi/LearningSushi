//
//  ConnectFriend.swift
//  LearningSushi
//
//  Created by win win on 27/04/24.
//

import SwiftUI

struct ConnectFriend: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Environment(\.dismiss) private var dismiss
    
//    @StateObject var nearestdevices = DeviceFinderViewModel()
    @EnvironmentObject var nearestdevices: DeviceFinderViewModel
    
    @State var avaUser = UserDefaults.standard.string(forKey: "SUSHI_AVA")
    @State var changeAvaSheet:Bool = false
    
    
    @State var scale:Double = 0.9
    
    var body: some View {
        NavigationStack(path: $nearestdevices.joinedPeer) {
            HStack {
                VStack {
                    Button {
                        changeAvaSheet = true
                    } label: {
                        Image(avaUser ?? "AvaDefault")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .scaledToFit()
                            .padding(20)
                            .background(.accent)
                            .cornerRadius(50)
                            .scaleEffect(scale)
                            .onAppear {
                                let baseAnimation = Animation.spring(duration: 2)
                                let repeated = baseAnimation.repeatForever(autoreverses: true)

                                withAnimation(repeated) {
                                    scale = 1
                                }
                            }
                    }
                    Button {
                        nearestdevices.startBrowsing()
                        nearestdevices.isAdvertised.toggle()
                    } label: {
                        Image(nearestdevices.isAdvertised ? "ButtonStop" : "ButtonPlay")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                VStack {
                    List(nearestdevices.peers) { peer in
                        let image = peer.peerId.displayName
                        HStack {
                            Image(image)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .scaledToFit()
                                .clipped()
                                .padding(10)
                                .cornerRadius(60)
                        }
                        .padding(.bottom,16)
                        .onTapGesture {
                            nearestdevices.selectedPeer = peer
                        }
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                    .alert(item: $nearestdevices.permissionRequest, content: { request in
                        Alert(
                            title: Text("Do you want to join \(request.peerId.displayName)"),
                            primaryButton: .default(Text("Yes"), action: {
                                request.onRequest(true)
                                nearestdevices.show(peerId: request.peerId)
                            }),
                            secondaryButton: .cancel(Text("No"), action: {
                                request.onRequest(false)
                            })
                        )
                    })
                    .navigationDestination(for: PeerDevice.self, destination: { peer in
                        GamePlayView()
                    })
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.clear)
                .padding(16)
                .cornerRadius(16)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Image("Background").resizable().scaledToFill()
            )
            .ignoresSafeArea()
            .sheet(isPresented: $changeAvaSheet, content: {
                ChangeAvaView(currentAva: $avaUser)
                    .presentationDetents([.medium, .large])
                    .presentationCornerRadius(40)
            })
        }
        
        .navigationBarBackButtonHidden(true)
//        NavigationStack {
//            VStack {
//                Spacer()
//                HStack(spacing: 26) {
//                    Image(avaUser ?? "AvaDefault")
//                        .resizable()
//                        .frame(width: 150, height: 150)
//                        .scaledToFit()
//                        .padding(10)
//                        .padding()
//                        .background(.accent)
//                        .cornerRadius(60)
//                        .scaleEffect(scale)
//                        .onAppear {
//                            let baseAnimation = Animation.spring(duration: 2)
//                            let repeated = baseAnimation.repeatForever(autoreverses: true)
//
//                            withAnimation(repeated) {
//                                scale = 1
//                            }
//                        }
//                }
//                if nearestdevices.joinedPeer.count > 0 {
//                    HStack {
//                        ForEach(nearestdevices.joinedPeer) { peer in
//                            let image = peer.peerId.displayName
//                            NavigationLink(destination: GamePlayHostView(peerToConnect: peer), label: {
//                                Image(image)
//                                    .resizable()
//                                    .frame(width: 150, height: 150)
//                                    .scaledToFit()
//                                    .clipped()
//                                    .padding(10)
//                                    .cornerRadius(60)
//                            })
//                            .controlSize(.extraLarge)
//                            .buttonStyle(.bordered)
//                        }
//                        
//                    }
//                    .frame(maxHeight: 200)
//                    .padding(32)
//                    .background(.accent)
//                    .cornerRadius(60)
//                }
//                if nearestdevices.peers.count > 0 {
//                    HStack {
//                        ForEach(nearestdevices.peers) { peer in
//                            let image = peer.peerId.displayName
//                            Button {
//                                nearestdevices.selectedPeer = peer
//                            } label: {
//                                Image(image)
//                                    .resizable()
//                                    .frame(width: 150, height: 150)
//                                    .scaledToFit()
//                                    .clipped()
//                                    .padding(10)
//                                    .cornerRadius(60)
//                            }
//                            .controlSize(.extraLarge)
//                            .buttonStyle(.bordered)
//                        }
//                        
//                    }
//                    .frame(maxHeight: 200)
//                    .padding(32)
//                    .background(.white)
//                    .cornerRadius(60)
//                }
//                Button {
//                    nearestdevices.finishBrowsing()
//                    nearestdevices.isAdvertised = false
//                    mode.wrappedValue.dismiss()
//                } label: {
//                    Image(systemName: "arrow.left")
//                }
//                .padding()
//                Spacer()
//            }
//            .padding()
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(
//                Image("Background").resizable().scaledToFill()
//            )
//            .ignoresSafeArea()
//        }
//        .onAppear{
//            nearestdevices.isAdvertised = true
//            nearestdevices.startBrowsing()
//        }
//        .sheet(item: $nearestdevices.permissionRequest, content: { request in
//            VStack {
//                Image(request.peerId.displayName)
//                    .resizable()
//                    .frame(width: 200, height: 200)
//                    .scaledToFit()
//                    .padding(10)
//                    .scaleEffect(scale)
//                    .onAppear {
//                        let baseAnimation = Animation.spring(duration: 0.5)
//                        let repeated = baseAnimation.repeatForever(autoreverses: true)
//
//                        withAnimation(repeated) {
//                            scale = 1
//                        }
//                    }
//                HStack {
//                    Button {
//                        nearestdevices.permissionRequest = nil
//                        request.onRequest(false)
////                        request = nil
//                    } label: {
//                        Image(systemName: "xmark")
//                    }
//                    .controlSize(.extraLarge)
//                    .buttonStyle(.bordered)
//                    Button {
//                        request.onRequest(true)
//                        nearestdevices.show(peerId: request.peerId)
////                        request = nil
//                    } label: {
//                        Image(systemName: "checkmark")
//                    }
//                    .controlSize(.extraLarge)
//                    .buttonStyle(.bordered)
////                    NavigationLink(destination: GamePlayView(), label: {
////                        Image(systemName: "checkmark")
////                    })
////                    .controlSize(.extraLarge)
////                    .buttonStyle(.borderedProminent)
////                            Button {
////                                request.onRequest(true)
////                                nearestdevices.show(peerId: request.peerId)
////                            } label: {
////
////                            }
//                    
//                }
//            }
//            .padding(26)
//        })
//        .navigationBarBackButtonHidden(true)
    }
}
//
//#Preview {
//    ConnectFriend()
//}
