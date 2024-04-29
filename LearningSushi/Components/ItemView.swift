import Foundation
import SwiftUI

struct ItemView: View {
    @EnvironmentObject var game: GameService
    @EnvironmentObject var connectionManager: MPConnectionManager
    @State var zidx: Double
    @Binding var ingredient: MyIngredient
    
    var body: some View {
        Image(ingredient.name)
            .resizable()
            .scaledToFit()
            .frame(width: 150, height: 150)
            .shadow(color: .shadow, radius: 0, x: 10, y: 10)
            .position(ingredient.loc)
            .zIndex(zidx)
            .onAppear {
                withAnimation(Animation.spring(duration: 1)) {
                    ingredient.loc = CGPoint(x: UIScreen.main.bounds.size.width/2 - 60, y: UIScreen.main.bounds.size.height/2)
                }
            }
            .transition(.scale)
            .animation(.spring())
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        ingredient.loc = gesture.location
                        if zidx < game.highestIdx {
                            game.highestIdx += 1
                            zidx = game.highestIdx
                            print("idx: \(zidx)")
                            print("highest:  \(game.highestIdx)")
                        }
                    }
                    .onEnded { _ in
                        checkUpSide()
                        checkCollisions()
                    }
            )
    }
    
    func hasMoreThanTwoWords(_ string: String) -> Bool {
        let words = string.split(separator: " ")
        return words.count >= 2
    }
    
    func checkUpSide() {
        if ingredient.loc.y < 100 {
            sendItem()
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
            print(self.game.ingredients)
        }
    }
    
    func checkCollisions() {
        let thisRect = CGRect(origin: ingredient.loc, size: CGSize(width: 150, height: 150))
        
        for i in 0 ..< game.ingredients.count {
            if game.ingredients[i].id != ingredient.id {
                let otherRect = CGRect(origin: game.ingredients[i].loc, size: CGSize(width: 100, height: 100))
                if thisRect.intersects(otherRect) {
                    // Collision detected
                    // print("combine \(ingredient.name) and \(ingredients[i].name)")
                    // React to collision here
                    if (ingredient.name == "rice" && game.ingredients[i].name == "salmon") || (ingredient.name == "salmon" && game.ingredients[i].name == "rice") {
                        ingredient.name = "sushi salmon"
                        game.ingredients.removeAll(where: {
                            $0.id == self.game.ingredients[i].id
                        })
                        return
                    } else if (ingredient.name == "rice" && game.ingredients[i].name == "shrimp") || (ingredient.name == "shrimp" && game.ingredients[i].name == "rice") {
                        ingredient.name = "sushi shrimp"
                        game.ingredients.removeAll(where: {
                            $0.id == self.game.ingredients[i].id
                        })
                        return
                    } else if (ingredient.name == "rice" && game.ingredients[i].name == "tamago") || ingredient.name == "tamago" && game.ingredients[i].name == "rice" {
                        ingredient.name = "sushi tamago"
                        game.ingredients.removeAll(where: {
                            $0.id == self.game.ingredients[i].id
                        })
                        return
                    } else if (ingredient.name == "rice" && game.ingredients[i].name == "tuna") || ingredient.name == "tuna" && game.ingredients[i].name == "rice" {
                        ingredient.name = "sushi tuna"
                        game.ingredients.removeAll(where: {
                            $0.id == self.game.ingredients[i].id
                        })
                        return
                    } else if (ingredient.name == "nori" && game.ingredients[i].name == "wakame") || ingredient.name == "wakame" && game.ingredients[i].name == "nori" {
                        ingredient.name = "wakame gunkan"
                        game.ingredients.removeAll(where: {
                            $0.id == self.game.ingredients[i].id
                        })
                        return
                    } else if (ingredient.name == "nori" && game.ingredients[i].name == "tobiko") || ingredient.name == "tobiko" && game.ingredients[i].name == "nori" {
                        ingredient.name = "tobiko gunkan"
                        game.ingredients.removeAll(where: {
                            $0.id == self.game.ingredients[i].id
                        })
                        return
                    }
                }
            }
        }
    }
}
