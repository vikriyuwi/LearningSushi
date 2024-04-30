import SwiftUI

struct Game: View {
    @EnvironmentObject var connectionManager: MPConnectionManager
    @EnvironmentObject var game: GameService

    let ingredients = ["salmon", "shrimp", "tamago", "tuna", "rice", "rice", "rice", "rice", "wakame", "tobiko", "nori", "nori"]

    @State var objective = Objective()
    @State var isStart = false
    @State var isFinished = false

    @State var swing: Angle = .init(degrees: -10)
    @State var swing2: Angle = .init(degrees: -20)
    @State var swing3: Angle = .init(degrees: -16)
    @State var floating: CGSize = .init(width: 0, height: -10)

    @State private var munculTimer: Bool = false
    @State var widthCountDown: CGFloat = 0
    @State var colorCountDown: Color = .green
    @State var isButtonEnabled = true
    var screenHeight = UIScreen.main.bounds.height
    var dismissed: () -> Void

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
                        VStack {
                            Spacer()
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
                                .onTapGesture {
                                    connectionManager.send(ingredient: MyIngredient(name: "end"))
                                    connectionManager.isPlayAgain = true
                                }
//                            Button(action: {
//                                connectionManager.send(ingredient: MyIngredient(name: "end"))
//                                connectionManager.isPlayAgain = true
//                            }) {
//                                Image(systemName: "repeat")
//                                    .buttonStyle(.bordered)
//                                    .padding(.top, 20)
//                                    .position(CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 80))
//                            }
                            // reset button
                            Spacer()
                        }
                    } else {
                        Image("bg success")
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .ignoresSafeArea()
                        VStack {
                            Spacer()
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
                                .onTapGesture {
                                    connectionManager.send(ingredient: MyIngredient(name: "end"))
                                    connectionManager.isPlayAgain = true
                                }
                            // reset button
//                            Button(action: {
//                                connectionManager.send(ingredient: MyIngredient(name: "end"))
//                                connectionManager.isPlayAgain = true
//                            }) {
//                                Image(systemName: "repeat")
//                                    .buttonStyle(.bordered)
//                                    .padding(.top, 20)
//                                    .position(CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 80))
//                            }
                            Spacer()
                        }
                    }

                } else {
                    Button {
                        guard isButtonEnabled else { return }
                        isButtonEnabled = false

                        let newIngredient = MyIngredient(name: ingredients.randomElement()!)
                        self.game.ingredients.append(newIngredient)
                        game.highestIdx += 1

                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isButtonEnabled = true
                        }

                    } label: {
                        Image(systemName: "plus")
                            .opacity(isButtonEnabled ? 1 : 0.2)
                    }
                    .controlSize(.large)
                    .buttonStyle(.bordered)

                    HStack(spacing: 20) {
                        ForEach(self.objective.menus, id: \.self) {
                            menu in
                            Image(menu)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                        }
                    }
                    .position(x: UIScreen.main.bounds.width / 2, y: screenHeight < 450 ? screenHeight : (screenHeight - 80))
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

                            // timer
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
                        HStack {}
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
                .position(CGPoint(x: UIScreen.main.bounds.width / 2, y: screenHeight / 2 - (screenHeight < 450 ? 24 : 0)))
                .onAppear {
                    // timer
                    withAnimation(Animation.easeIn(duration: 90)) {
                        widthCountDown = UIScreen.main.bounds.size.width
                        colorCountDown = .red
                    }
                }
            }
        }
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
