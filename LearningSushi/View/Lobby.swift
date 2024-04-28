//
//  Lobby.swift
//  Multipeer
//
//  Created by Kurnia Kharisma Agung Samiadjie on 27/04/24.
//

import SwiftUI

struct Lobby: View {
    @EnvironmentObject var game: GameService
    @Binding var startGame: Bool
    @State var selectedChar: String
    @StateObject var connectionManager: MPConnectionManager
    @State var isInvited = false

    init(selectedChar: String, startGame: Binding<Bool>) {
        self.selectedChar = selectedChar
        self._startGame = startGame
        _connectionManager = StateObject(wrappedValue: MPConnectionManager(yourName: selectedChar))
    }

    var body: some View {
        ZStack {
            Image("bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            HStack {
                UserCharacter(imgName: connectionManager.myPeerId.displayName, selectedChar: $selectedChar, isSheetOpen: .constant(false))
                    .padding()
                    .background(Color("base"))
                    .cornerRadius(20)
                    .frame(width: 140, height: 140)

                HStack(alignment: .bottom, spacing: 12) {
                    if connectionManager.availablePeers.count == 0 {
                        Text("Waiting for players...")
                            .font(.title)
                            .fontWeight(.semibold)
                            .padding(.bottom, 12)
                            .foregroundColor(.black)
                    }
                    ForEach(connectionManager.availablePeers, id: \.self) {
                        peer in
                        Button(action: {
//                            If peer character was the same, then don't play
                            connectionManager.nearbyServiceBrowser.invitePeer(peer, to: connectionManager.session, withContext: nil, timeout: 30)
                        }) {
                            Image(peer.displayName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    Spacer()
                }
                .padding()
                .frame(height: 140)
                .frame(maxWidth: 500)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(24)
                .padding(.leading, 20)
                .alert("Received Invitation from \(connectionManager.receivedInviteFrom?.displayName ?? "Unknown")",
                       isPresented: $connectionManager.receivedInvite)
                {
                    Button("Accept") {
                        if let invitationHandler = connectionManager.invitationHandler {
                            invitationHandler(true, connectionManager.session)
                        }
                    }
                    Button("Reject") {
                        if let invitationHandler = connectionManager.invitationHandler {
                            invitationHandler(false, nil)
                        }
                    }
                }
            }
        }
        .onAppear {
            connectionManager.setup(game: game)
            connectionManager.isAvailableToPlay = true
            connectionManager.startBrowsing()
        }
        .onDisappear {
            connectionManager.stopBrowsing()
            connectionManager.stopAdvertising()
            connectionManager.isAvailableToPlay = false
        }
        .onChange(of: connectionManager.paired) { newValue in
            startGame = newValue
        }
        .fullScreenCover(isPresented: $startGame) {
            Game()
                .environmentObject(game)
                .environmentObject(connectionManager)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Lobby(selectedChar: "red_user", startGame: .constant(false))
            .environmentObject(MPConnectionManager(yourName: "Sample"))
            .environmentObject(GameService())
    }
}

//                if connectionManager.receivedInvite {
//                    HStack {
//                        Image(connectionManager.receivedInviteFrom?.displayName ?? "")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                        Spacer()
//                        HStack {
//                            Button(action: {
//                                if let invitationHandler = connectionManager.invitationHandler {
//                                    invitationHandler(false, nil)
//                                }
//                            }) {
//                                Image(systemName: "x.square.fill")
//                                    .foregroundStyle(Color.red)
//                            }
//                            .padding(.trailing, 12)
//
//                            Button(action: {
//                                if let invitationHandler = connectionManager.invitationHandler {
//                                    invitationHandler(true, connectionManager.session)
//                                }
//                            }) {
//                                Image(systemName: "checkmark.square.fill")
//                                    .foregroundStyle(Color.green)
//                            }
//                        }
//                    }
//                    .padding(12)
//                    .background(Color.white)
//                    .cornerRadius(12)
//                    .frame(width: 160, height: 100)
//                    .overlay( /// apply a rounded border
//                        RoundedRectangle(cornerRadius: 12)
//                            .stroke(.green, lineWidth: 1)
//                    )
//                }
