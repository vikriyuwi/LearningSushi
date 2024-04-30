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
            if let url = Bundle.main.url(forResource: "background", withExtension: "mp3") {
                                        do {
                                            audioPlayer = try AVAudioPlayer(contentsOf: url)
                                            audioPlayer?.numberOfLoops = -1
                                            audioPlayer?.play()
                                        } catch {
                                            print("Error: \(error.localizedDescription)")
                                        }
                                    } else {
                                        print("Error: file not found")
                                    }
            print(UIScreen.main.bounds.height)
        }
        .environmentObject(game)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ContentView()
}
