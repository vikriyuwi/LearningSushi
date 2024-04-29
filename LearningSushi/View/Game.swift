import SwiftUI

struct Game: View {
    @EnvironmentObject var connectionManager: MPConnectionManager
    @EnvironmentObject var game: GameService

    let ingredients = ["salmon", "shrimp", "tamago", "tuna", "rice", "rice", "rice", "rice", "wakame", "tobiko", "nori", "nori"]

    @State var objective = Objective()
    @State var isStart = false
    @State var isFinished = false
    
    @State var swing:Angle = Angle(degrees: -10)
    @State var swing2:Angle = Angle(degrees: -20)
    @State var swing3:Angle = Angle(degrees: -16)
    @State var floating:CGSize = CGSize(width: 0, height: -10)
    
    @State private var munculTimer:Bool = false
    @State var widthCountDown:CGFloat = 0
    @State var colorCountDown:Color = .green
    
    var body: some View {
        ZStack {
            Image("bg")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            if isStart {
                if connectionManager.playerFinished.count == 2 {
                    if connectionManager.playerFinished[0] == false || connectionManager.playerFinished[1] == false {
                        Image("bg fail")
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .ignoresSafeArea()
                        Image("sad_user")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .rotationEffect(swing3)
                            .onAppear {
                                let baseAnimation = Animation.easeInOut(duration: 1)
                                let repeated = baseAnimation.repeatForever(autoreverses: true)

                                withAnimation(repeated) {
                                    swing3 = Angle(degrees: 16)
                                }
                                
                                Task {
                                    munculTimer = false
                                }
                            }
                    } else {
                        Image("bg success")
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .ignoresSafeArea()
                        Image("happy_user")
                            .resizable()
                            .scaledToFit()
                            .offset(floating)
                            .rotationEffect(swing2)
                            .frame(width: 200, height: 200)
                            .onAppear {
                                let baseAnimation = Animation.easeInOut(duration: 0.5)
                                let repeated = baseAnimation.repeatForever(autoreverses: true)

                                withAnimation(repeated) {
                                    swing2 = Angle(degrees: 20)
                                }
                            }
                            .onAppear {
                                let baseAnimation2 = Animation.easeInOut(duration: 0.25)
                                let repeated2 = baseAnimation2.repeatForever(autoreverses: true)
                                
                                withAnimation(repeated2) {
                                    floating = CGSize(width: 0, height: 10)
                                }
                                Task {
                                    munculTimer = false
                                }
                            }
                    }
                } else {
                    Button {
                        let newIngredient = MyIngredient(name: ingredients.randomElement()!)
                        self.game.ingredients.append(newIngredient)
                        game.highestIdx += 1
                    } label: {
                        Image(systemName: "plus")
                    }

                    HStack(spacing: 20) {
                        ForEach(self.objective.menus, id: \.self) {
                            menu in
                            Image(menu)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                        }
                    }
                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 50)
                    if self.game.ingredients.count > 0 {
                        ForEach(self.$game.ingredients) { ingredient in
                            ItemView(objective: $objective, zidx: game.highestIdx, ingredient: ingredient, isFinished: $isFinished)
                        }
                    }
                }
            } else {
                Image("white_user")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .transition(.slide)
                    .offset(floating)
                    .rotationEffect(swing)
                    .onAppear {
                        let baseAnimation = Animation.easeInOut(duration: 2)
                        let repeated = baseAnimation.repeatForever(autoreverses: true)

                        withAnimation(repeated) {
                            swing = Angle(degrees: 10)
                        }
                    }
                    .onAppear {
                        let baseAnimation2 = Animation.easeInOut(duration: 1)
                        let repeated2 = baseAnimation2.repeatForever(autoreverses: true)

                        withAnimation(repeated2) {
                            floating = CGSize(width: 0, height: 5)
                        }
                    }
                    .onAppear {
                        Task {
                            try? await Task.sleep(for: .seconds(3))
                            isStart = true
                        }
                    }
                    .onAppear {
                        Task {
                            // start timer
                            munculTimer = true
                            // time is up
                            try? await Task.sleep(for: .seconds(90))
                            if connectionManager.playerFinished.count < 2 {
                                connectionManager.addPlayerFailed()
                                connectionManager.send(ingredient: MyIngredient(name: "failed"))
                            }
                        }
                    }
            }
            if munculTimer {
                VStack(alignment: .leading) {
                    Spacer()
                    HStack {
                        HStack {
                            
                        }
                        .frame(
                            maxWidth: widthCountDown,
                            maxHeight: 50
                        )
                        .background(colorCountDown)
                        .cornerRadius(20)
                        .ignoresSafeArea()
                        Spacer()
                    }
                    .frame(maxWidth: UIScreen.main.bounds.size.width, maxHeight: 20)
                    .background(.accent)
                    .cornerRadius(20)
                    .ignoresSafeArea()
                }
                .onAppear {
                    withAnimation(Animation.easeOut(duration: 90)) {
                        widthCountDown = UIScreen.main.bounds.size.width
                        colorCountDown = .red
                    }
                }
            }
        }
//        .fullScreenCover(item: $objective.playerFinished., content: <#T##(Identifiable) -> View#>)
        .ignoresSafeArea()
        .onAppear {
            connectionManager.setupObjective(objective: objective)
            for _ in 0 ..< 5 {
                let randIdx: Int = .random(in: 0 ... objective.ingredients.count - 1)

                let tempIngredient = MyIngredient(name: objective.ingredients[randIdx])

                connectionManager.send(ingredient: tempIngredient)
                objective.ingredients.remove(at: randIdx)
            }
        }
    }
}

//#Preview {
//    struct PreviewWrapper: View {
//        @StateObject var model: GameService = .init()
//        @State var isStart: Bool = false
//        var body: some View {
//            Game(isStart: isStart)
//                .environmentObject(model)
//        }
//    }
//    return PreviewWrapper()
//}

// struct Game_Previews: PreviewProvider {
//    static var previews: some View {
//        Game()
//            .environmentObject(GameService())
//    }
// }
