import SwiftUI
import AVFoundation

struct ContentView: View {
    @State var selectedChar: String = "white_user"
    @State var isSheetOpen = false
    @State var startGame = false
    @StateObject var game = GameService()
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        NavigationView {
            ZStack {
                Image("bg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                VStack {
                    SelectCharacter(isSheetOpen: self.$isSheetOpen, selectedChar: self.$selectedChar)
                    NavigationLink {
                        Lobby(selectedChar: self.selectedChar, startGame: self.$startGame)
                    } label: {
                        Image("play")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 80)
                            .padding(.top)
                    }
                }
            }
        }
        .onAppear {
            Sound.playBackground()
            print(UIScreen.main.bounds.height)
        }
        .environmentObject(game)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ContentView()
}
