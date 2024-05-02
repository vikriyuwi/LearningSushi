import SwiftUI

struct SelectCharacter: View {
    @Binding var isSheetOpen: Bool
    @Binding var selectedChar: String
    
    @State var breathScale:Double = 0.9
    @State var paddingChar:CGFloat = 17.6
    
    var body: some View {
        VStack {
            UserCharacter(imgName: selectedChar != "" ? selectedChar : "red_user", isFlying: true, selectedChar: $selectedChar, isSheetOpen: $isSheetOpen)
                .padding(paddingChar)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(40)
                .frame(width: 120, height: 120)
                .scaleEffect(breathScale)
                .onAppear {
                    let baseAnimation = Animation.spring(duration: 2)
                    let repeated = baseAnimation.repeatForever(autoreverses: true)

                    withAnimation(repeated) {
                        breathScale = 1
                        paddingChar = 16
                    }
                }
        }
        .sheet(isPresented: $isSheetOpen) {
            VStack {
//                Text("Select your character")
//                    .font(.title)
//                    .fontWeight(.semibold)
//                    .padding(.bottom, 12)
                HStack {
                    UserCharacter(imgName: "white_user", selectedChar: $selectedChar, isSheetOpen: $isSheetOpen)
                        .padding()
                        .background(selectedChar == "white_user" ? Color.base : Color.black.opacity(0.1))
                        .cornerRadius(40)
                        .frame(width: 100, height: 100)

                    UserCharacter(imgName: "orange_user", selectedChar: $selectedChar, isSheetOpen: $isSheetOpen)
                        .padding()
                        .background(selectedChar == "orange_user" ? Color.base : Color.black.opacity(0.1))
                        .cornerRadius(40)
                        .frame(width: 100, height: 100)

                    UserCharacter(imgName: "yellow_user", selectedChar: $selectedChar, isSheetOpen: $isSheetOpen)
                        .padding()
                        .background(selectedChar == "yellow_user" ? Color.base : Color.black.opacity(0.1))
                        .cornerRadius(40)
                        .frame(width: 100, height: 100)
                }

                HStack {
                    UserCharacter(imgName: "blue_user", selectedChar: $selectedChar, isSheetOpen: $isSheetOpen)
                        .padding()
                        .background(selectedChar == "blue_user" ? Color.base : Color.black.opacity(0.1))
                        .cornerRadius(40)
                        .frame(width: 100, height: 100)
                    UserCharacter(imgName: "red_user", selectedChar: $selectedChar, isSheetOpen: $isSheetOpen)
                        .padding()
                        .background(selectedChar == "red_user" ? Color.base : Color.black.opacity(0.1))
                        .cornerRadius(40)
                        .frame(width: 100, height: 100)

                    UserCharacter(imgName: "green_user", selectedChar: $selectedChar, isSheetOpen: $isSheetOpen)
                        .padding()
                        .background(selectedChar == "green_user" ? Color.base : Color.black.opacity(0.1))
                        .cornerRadius(40)
                        .frame(width: 100, height: 100)
                }
            }
            .padding(60)
            .onAppear(){
                Sound.playClick()
            }
        }
    }
}

struct SelectCharacter_Previews: PreviewProvider {
    @State var isSheetOpen = false
    @State var selectedChar = "red_user"
    static var previews: some View {
        SelectCharacter(isSheetOpen: .constant(false), selectedChar: .constant("red_user"))
    }
}
