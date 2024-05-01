import SwiftUI
import AVFoundation

struct Lobby: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    @EnvironmentObject var game: GameService
    @Binding var startGame: Bool
    @State var selectedChar: String
    @StateObject var connectionManager: MPConnectionManager
    @State var isInvited = false
    @State private var audioPlayer2: AVAudioPlayer?

    @State var opacityScale: Double = 0.2
    @State var scaleEffect: Double = 0.9

    init(selectedChar: String, startGame: Binding<Bool>) {
        self.selectedChar = selectedChar
        self._startGame = startGame
        _connectionManager = StateObject(wrappedValue: MPConnectionManager(yourName: selectedChar))
    }

    func dismissed() {
        mode.wrappedValue.dismiss()
        game.emptyIngredients()
    }

    var body: some View {
        ZStack {
            Image("bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            VStack {
                HStack {
                    UserCharacter(imgName: self.connectionManager.myPeerId.displayName, selectedChar: self.$selectedChar, isSheetOpen: .constant(false))
                        .padding()
                        .background(Color("base"))
                        .cornerRadius(50)
                        .frame(width: 140, height: 140)

                    HStack(alignment: .bottom, spacing: 12) {
                        if self.connectionManager.availablePeers.count == 0 {
                            Image("white_user")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .opacity(self.opacityScale)
                                .scaleEffect(self.scaleEffect)
                                .onAppear {
                                    let baseAnimation = Animation.easeInOut(duration: 2)
                                    let repeated = baseAnimation.repeatForever(autoreverses: true)

                                    withAnimation(repeated) {
                                        self.opacityScale = 0.5
                                        self.scaleEffect = 1
                                    }
                                }
                            Image("white_user")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .opacity(self.opacityScale)
                                .scaleEffect(self.scaleEffect)
                            Image("white_user")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .opacity(self.opacityScale)
                                .scaleEffect(self.scaleEffect)
                        }
                        ForEach(self.connectionManager.availablePeers, id: \.self) {
                            peer in
                            Button(action: {
                                self.connectionManager.nearbyServiceBrowser.invitePeer(peer, to: self.connectionManager.session, withContext: nil, timeout: 30)
                                Sound.playClick()
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
                    .alert("Received Invitation from \(self.connectionManager.receivedInviteFrom?.displayName ?? "Unknown")",
                           isPresented: self.$connectionManager.receivedInvite)
                    {
                        Button("Reject") {
                            if let invitationHandler = connectionManager.invitationHandler {
                                invitationHandler(false, nil)
                            }
                        }
                        Button("Accept") {
                            if let invitationHandler = connectionManager.invitationHandler {
                                invitationHandler(true, self.connectionManager.session)
                            }
                        }
                    }
                }
                Button {
                    self.dismissed()
                    Sound.playClick()
                } label: {
                    Image("back_button")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                }
            }
            .offset(y: 32)
        }
        .onAppear {
            Sound.playClick()
            self.connectionManager.setupGame(game: self.game)
            self.connectionManager.isAvailableToPlay = true
            self.connectionManager.startBrowsing()
        }
        .onDisappear {
            self.connectionManager.stopBrowsing()
            self.connectionManager.stopAdvertising()
            self.connectionManager.isAvailableToPlay = false
        }
        .onChange(of: connectionManager.paired) { newValue in
            self.startGame = newValue
        }
        .onChange(of: connectionManager.isPlayAgain) {
            newValue in
            if newValue {
                self.dismissed()
                self.connectionManager.isPlayAgain = false
                self.connectionManager.playerFinished = []
            }
        }
        .fullScreenCover(isPresented: $startGame) {
            Game(dismissed: self.dismissed)
                .environmentObject(self.game)
                .environmentObject(self.connectionManager)
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
