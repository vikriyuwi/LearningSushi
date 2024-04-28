//
//  UserCharacter.swift
//  Multipeer
//
//  Created by Kurnia Kharisma Agung Samiadjie on 27/04/24.
//

import SwiftUI

struct UserCharacter: View {
    var imgName: String
    @State private var scaleBase: CGFloat = 0.9
    @State var isFlying: Bool = false
    @Binding var selectedChar: String
    @Binding var isSheetOpen: Bool

    var body: some View {
        Button(action: {
            selectedChar = imgName
            isSheetOpen.toggle()

        }) {
            Image(imgName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(scaleBase)
        }
    }
}

struct UserCharacter_Previews: PreviewProvider {
    @State static var selectedChar = "red_user"
    @State static var isSheetOpen = false
    static var previews: some View {
        UserCharacter(imgName: "red_user", selectedChar: $selectedChar, isSheetOpen: $isSheetOpen)
    }
}
