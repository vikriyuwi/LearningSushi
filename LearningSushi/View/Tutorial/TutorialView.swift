//
//  ContentView.swift
//  OnboardingSuhsi
//
//  Created by win win on 30/04/24.
//

import SwiftUI

struct TutorialView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var step:Int = 1
    var body: some View {
        ZStack{
            if step == 1 {
                TutorialSushiSalmon()
            } else if step == 2 {
                TutorialSend()
            } else if step == 3 {
                TutorialRemove()
            } else {
                TutorialSubmit()
            }
            VStack {
                HStack {
                    Button {
                        mode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    .controlSize(.extraLarge)
                    Spacer()
                }
                Spacer()
                if step < 4 {
                    Button {
                        withAnimation(.spring) {
                            step += 1
                        }
                    } label: {
                        Image(systemName: "chevron.right")
                    }
                    .controlSize(.extraLarge)
                    .buttonStyle(.bordered)
                } else {
                    Button {
                        mode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    .controlSize(.extraLarge)
                    .buttonStyle(.bordered)
                }
            }
            .padding(32)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
    }

}

#Preview {
    TutorialView()
}
