//
//  ChangeAvaView.swift
//  LearningSushi
//
//  Created by win win on 27/04/24.
//

import SwiftUI

struct ChangeAvaView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var currentAva:String?
    @State var scale:Double = 0.9
    
    var ava:[String] = [
        "AvaDefault",
        "AvaOrange",
        "AvaYellow",
        "AvaRed",
        "AvaGreen"
    ]
    
    let column = Array(repeating: GridItem(.fixed(145)), count: 2)
    
    var body: some View {
        VStack {
            Image(currentAva ?? "AvaDefault")
                .resizable()
                .frame(width: 150, height: 150)
                .scaledToFit()
                .padding(10)
                .padding()
                .background(.accent)
                .cornerRadius(60)
                .scaleEffect(scale)
                .onAppear {
                    let baseAnimation = Animation.spring(duration: 2)
                    let repeated = baseAnimation.repeatForever(autoreverses: true)

                    withAnimation(repeated) {
                        scale = 1
                    }
                }
            LazyVGrid(columns:column) {
                ForEach(0..<ava.count) {index in
                    if currentAva != ava[index] {
                        Button {
                            changeAva(ava[index])
                        } label: {
                            Image(ava[index])
                                .resizable()
                                .frame(width: 100, height: 100)
                                .scaledToFit()
                                .padding(10)
                        }
                        .buttonStyle(.bordered)
                        .cornerRadius(40)
                    }
                }
            }
            .padding(.vertical, 32)
        }
    }
    
    func changeAva(_ pickedAva:String) {
        UserDefaults.standard.set(pickedAva, forKey: "SUSHI_AVA")
        currentAva = pickedAva
        dismiss()
    }
}

#Preview {
    struct PreviewWrapper:View {
        @State var avaUser = UserDefaults.standard.string(forKey: "SUSHI_AVA")
        
        var body: some View {
            ChangeAvaView(currentAva: $avaUser)
        }
    }
    return PreviewWrapper()
}
