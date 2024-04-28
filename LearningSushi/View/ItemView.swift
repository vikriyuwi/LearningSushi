import Foundation
import SwiftUI

struct ItemView: View {
    @EnvironmentObject var model: DeviceFinderViewModel
    
    @State var zidx: Double
    @Binding var ingredient: MyIngredient
    @Binding var highestIdx: Double
    @State private var isAnimating: Bool = false
    
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
                    ingredient.loc = CGPoint(x: UIScreen.main.bounds.size.width/2-60, y: UIScreen.main.bounds.size.height/2)
                }
            }
            .transition(.scale)
            .animation(.spring())
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        ingredient.loc = gesture.location
                        if(zidx < highestIdx-1){
                            zidx = highestIdx
                            highestIdx += 1
                            print("idx: \(zidx)")
                            print("highest:  \(highestIdx)")
                        }
                    }
                    .onEnded ({ value in
                        checkUpSide()
                        checkCollisions()
                    })
            )
    }
    
//    func isDraggingOverTrash(_ location: CGPoint) -> Bool {
//        let trashRect = CGRect(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height - 50, width: 20, height: 20)
//        let otherRect = CGRect(origin: location, size: CGSize(width: 10, height: 10))
//        return trashRect.intersects(otherRect)
//    }
    
    func hasMoreThanTwoWords(_ string: String) -> Bool {
        let words = string.split(separator: " ")
        return words.count >= 2
    }
    
    func checkUpSide() {
//        if hasMoreThanTwoWords(ingredient.name){
//            return
//        }

        
        if ingredient.loc.y < 100{
            sendItem()
        }
    }
    
    func sendItem() {
        withAnimation(Animation.spring(duration: 1)) {
            ingredient.loc.y = -150
        } completion: {
            self.model.send(string: ingredient.name)
            
            self.model.ingredients.removeAll(where: {
                $0.id == ingredient.id
            })
            print(self.model.ingredients)
        }
    }
    
    func checkCollisions() {
        let thisRect = CGRect(origin: ingredient.loc, size: CGSize(width: 150, height: 150))
        
        for i in 0..<self.model.ingredients.count {
            if self.model.ingredients[i].id != ingredient.id {
                let otherRect = CGRect(origin: self.model.ingredients[i].loc, size: CGSize(width: 100, height: 100))
                if thisRect.intersects(otherRect) {
                    // Collision detected
                    // print("combine \(ingredient.name) and \(ingredients[i].name)")
                    // React to collision here
                    if (ingredient.name == "rice" && self.model.ingredients[i].name == "salmon") || (ingredient.name == "salmon" && self.model.ingredients[i].name == "rice") {
                        ingredient.name = "sushi salmon"
                        self.model.ingredients.removeAll(where: {
                            $0.id == self.model.ingredients[i].id
                        })
                        return
                    } else if (ingredient.name == "rice" && self.model.ingredients[i].name == "shrimp") || (ingredient.name == "shrimp" && self.model.ingredients[i].name == "rice"){
                        ingredient.name = "sushi shrimp"
                        self.model.ingredients.removeAll(where: {
                            $0.id == self.model.ingredients[i].id
                        })
                        return
                    } else if (ingredient.name == "rice" && self.model.ingredients[i].name == "tamago") || ingredient.name == "tamago" && self.model.ingredients[i].name == "rice" {
                        ingredient.name = "sushi tamago"
                        self.model.ingredients.removeAll(where: {
                            $0.id == self.model.ingredients[i].id
                        })
                        return
                    } else if (ingredient.name == "rice" && self.model.ingredients[i].name == "tuna") || ingredient.name == "tuna" && self.model.ingredients[i].name == "rice" {
                        ingredient.name = "sushi tuna"
                        self.model.ingredients.removeAll(where: {
                            $0.id == self.model.ingredients[i].id
                        })
                        return
                    }
                }
            }
        }
    }
}
