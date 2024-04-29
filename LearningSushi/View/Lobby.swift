import SwiftUI

struct Lobby: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @EnvironmentObject var game: GameService
    @Binding var startGame: Bool
    @State var selectedChar: String
    @StateObject var connectionManager: MPConnectionManager
    @State var isInvited = false
    
    @State var opacityScale:Double = 0.2
    @State var scaleEffect:Double = 0.9

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
            VStack {
                HStack {
                    UserCharacter(imgName: connectionManager.myPeerId.displayName, selectedChar: $selectedChar, isSheetOpen: .constant(false))
                        .padding()
                        .background(Color("base"))
                        .cornerRadius(50)
                        .frame(width: 140, height: 140)

                    HStack(alignment: .bottom, spacing: 12) {
                        if connectionManager.availablePeers.count == 0 {
                            Image("white_user")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .opacity(opacityScale)
                                .scaleEffect(scaleEffect)
                                .onAppear {
                                    let baseAnimation = Animation.easeInOut(duration: 2)
                                    let repeated = baseAnimation.repeatForever(autoreverses: true)

                                    withAnimation(repeated) {
                                        opacityScale = 0.5
                                        scaleEffect = 1
                                    }
                                }
                            Image("white_user")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .opacity(opacityScale)
                                .scaleEffect(scaleEffect)
                            Image("white_user")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .opacity(opacityScale)
                                .scaleEffect(scaleEffect)
                        }
                        ForEach(connectionManager.availablePeers, id: \.self) {
                            peer in
                            Button(action: {
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
                Button {
                    self.mode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                }
                .buttonStyle(.bordered)
                .padding(.top,20)
            }
            .offset(y: 32)
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
        .navigationBarBackButtonHidden(true)
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
