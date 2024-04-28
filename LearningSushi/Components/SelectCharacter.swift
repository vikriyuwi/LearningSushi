//
//  SelectCharacter.swift
//  Multipeer
//
//  Created by Kurnia Kharisma Agung Samiadjie on 28/04/24.
//

import SwiftUI

struct SelectCharacter: View {
    @Binding var isSheetOpen: Bool
    @Binding var selectedChar: String
    var body: some View {
        VStack {
            UserCharacter(imgName: selectedChar != "" ? selectedChar : "red_user", isFlying: true, selectedChar: $selectedChar, isSheetOpen: $isSheetOpen)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(20)
                .frame(width: 120, height: 120)
        }
        .sheet(isPresented: $isSheetOpen) {
            VStack {
                Text("Select your character")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.bottom, 12)
                HStack {
                    UserCharacter(imgName: "white_user", selectedChar: $selectedChar, isSheetOpen: $isSheetOpen)
                        .padding()
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(20)
                        .frame(width: 100, height: 100)

                    UserCharacter(imgName: "orange_user", selectedChar: $selectedChar, isSheetOpen: $isSheetOpen)
                        .padding()
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(20)
                        .frame(width: 100, height: 100)

                    UserCharacter(imgName: "yellow_user", selectedChar: $selectedChar, isSheetOpen: $isSheetOpen)
                        .padding()
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(20)
                        .frame(width: 100, height: 100)
                }

                HStack {
                    UserCharacter(imgName: "blue_user", selectedChar: $selectedChar, isSheetOpen: $isSheetOpen)
                        .padding()
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(20)
                        .frame(width: 100, height: 100)
                    UserCharacter(imgName: "red_user", selectedChar: $selectedChar, isSheetOpen: $isSheetOpen)
                        .padding()
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(20)
                        .frame(width: 100, height: 100)

                    UserCharacter(imgName: "green_user", selectedChar: $selectedChar, isSheetOpen: $isSheetOpen)
                        .padding()
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(20)
                        .frame(width: 100, height: 100)
                }
            }
            .padding(60)
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
