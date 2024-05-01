import Foundation
import AVFoundation
import SwiftUI

struct ItemView: View {
    @Binding var objective: Objective
    @EnvironmentObject var game: GameService
    @EnvironmentObject var connectionManager: MPConnectionManager
    @State var zidx: Double
    @Binding var ingredient: MyIngredient
    @Binding var isFinished: Bool
    @Binding var isDelete: Bool
    @Binding var isDelete2: Bool
    @Binding var isPlaying: Bool
    @State var audioPlayer: AVAudioPlayer?
    
    var body: some View {
        Image(ingredient.name)
            .resizable()
            .scaledToFit()
            .frame(width: 150, height: 150)
            .shadow(color: .shadow, radius: 0, x: 10, y: 10)
            .position(ingredient.loc)
            .zIndex(zidx)
            .onAppear {
                let screenHeight = UIScreen.main.bounds.size.height
                let yLoc: Double = screenHeight < 450 ? .random(in: 100 ... screenHeight - 70) : .random(in: 100 ... screenHeight - 300)
                withAnimation(Animation.spring(duration: 1)) {
                    ingredient.loc = CGPoint(x: ingredient.loc.x, y: yLoc)
                }
            }
            .transition(.scale)
            .animation(.spring())
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        if !isPlaying{
                            return
                        }
                        ingredient.loc = gesture.location
                        if zidx < game.highestIdx {
                            game.highestIdx += 1
                            zidx = game.highestIdx
                        }
                        if gesture.location.x < 200 {
                            isDelete = true
                        } else if gesture.location.x > UIScreen.main.bounds.width - 200 {
                            isDelete2 = true
                        } else {
                            isDelete = false
                            isDelete2 = false
                        }
                    }
                    .onEnded { _ in
                        if !isPlaying{
                            return
                        }
                        if checkCollisions() == false {
                            checkSide()
                        }
                        isDelete = false
                        isDelete2 = false
                    }
            )
    }
    
    func hasMoreThanTwoWords(_ string: String) -> Bool {
        let words = string.split(separator: " ")
        return words.count >= 2
    }
    
    func checkSide() {
        if !isPlaying{
            return
        }
        if ingredient.loc.y < 100 {
            sendItem()
        } else if ingredient.loc.y > UIScreen.main.bounds.height - 100 {
            checkObjective()
        } else if ingredient.loc.x < 100 || ingredient.loc.x > UIScreen.main.bounds.width - 100 {
            removeItem()
        }
    }
    
    func removeItem() {
        if !isPlaying{
            return
        }
        game.ingredients.removeAll(where: {
            $0.id == ingredient.id
        })
        isDelete = false
        isDelete2 = false
    }
    
    func checkObjective() {
        if !isPlaying{
            return
        }
        if let index = objective.menus.firstIndex(of: ingredient.name) {
            objective.menus[index] += " check"
            game.ingredients.removeAll(where: {
                $0.id == ingredient.id
            })
            Sound.playClick()
            if objective.menus.allSatisfy({
                $0.contains("check")
            }) {
                isFinished = true
//                objective.playerFinished.append(true)
                connectionManager.addPlayerFinished()
                connectionManager.send(ingredient: MyIngredient(name: "finished"))
            } else {
                print("Havent finished")
            }
            
            return
        } else {
            ingredient.loc.y = UIScreen.main.bounds.height / 2
        }
    }

    func sendItem() {
        withAnimation(Animation.spring(duration: 1)) {
            ingredient.loc.y = -150
        } completion: {
            self.connectionManager.send(ingredient: ingredient)
            self.game.ingredients.removeAll(where: {
                $0.id == ingredient.id
            })
        }
    }
    
    func checkCollisions() -> Bool {
        let thisRect = CGRect(origin: ingredient.loc, size: CGSize(width: 150, height: 150))
        
        for i in 0 ..< game.ingredients.count {
            if game.ingredients[i].id != ingredient.id {
                let otherRect = CGRect(origin: game.ingredients[i].loc, size: CGSize(width: 100, height: 100))
                if thisRect.intersects(otherRect) {
                    // Collision detected
                    // React to collision here
                    if (ingredient.name == "rice" && game.ingredients[i].name == "salmon") || (ingredient.name == "salmon" && game.ingredients[i].name == "rice") {
                        ingredient.name = "sushi salmon"
                        game.ingredients.removeAll(where: {
                            $0.id == self.game.ingredients[i].id
                        })
                        Sound.playClick()
                        return true
                    } else if (ingredient.name == "rice" && game.ingredients[i].name == "shrimp") || (ingredient.name == "shrimp" && game.ingredients[i].name == "rice") {
                        ingredient.name = "sushi shrimp"
                        game.ingredients.removeAll(where: {
                            $0.id == self.game.ingredients[i].id
                        })
                        Sound.playClick()
                        return true
                    } else if (ingredient.name == "rice" && game.ingredients[i].name == "tamago") || ingredient.name == "tamago" && game.ingredients[i].name == "rice" {
                        ingredient.name = "sushi tamago"
                        game.ingredients.removeAll(where: {
                            $0.id == self.game.ingredients[i].id
                        })
                        Sound.playClick()
                        return true
                    } else if (ingredient.name == "rice" && game.ingredients[i].name == "tuna") || ingredient.name == "tuna" && game.ingredients[i].name == "rice" {
                        ingredient.name = "sushi tuna"
                        game.ingredients.removeAll(where: {
                            $0.id == self.game.ingredients[i].id
                        })
                        Sound.playClick()
                        return true
                    } else if (ingredient.name == "nori" && game.ingredients[i].name == "wakame") || ingredient.name == "wakame" && game.ingredients[i].name == "nori" {
                        ingredient.name = "wakame nori"
                        game.ingredients.removeAll(where: {
                            $0.id == self.game.ingredients[i].id
                        })
                        Sound.playClick()
                        return true
                    } else if (ingredient.name == "nori" && game.ingredients[i].name == "tobiko") || ingredient.name == "tobiko" && game.ingredients[i].name == "nori" {
                        ingredient.name = "tobiko nori"
                        game.ingredients.removeAll(where: {
                            $0.id == self.game.ingredients[i].id
                        })
                        Sound.playClick()
                        return true
                    } else {
                        return false
                    }
                }
            }
        }
        return false
    }
}
