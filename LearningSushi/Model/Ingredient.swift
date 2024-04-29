import Foundation

var ingredientType = [
    1: "sushi",
    2: "tuna",
    3: "rice",
    4: "plate",
    5: "salmon",
    6: "tamago"
]

struct Ingredient {
    var id: Int
    var name: String

    
    static func generate(id: Int) -> Ingredient {
        switch ingredientType[id] {
        case "sushi":
            return Ingredient(id: 1, name: "sushi")
        case "tuna":
            return Ingredient(id: 2, name: "tuna")
        case "rice":
            return Ingredient(id: 3, name: "rice")
        case "plate":
            return Ingredient(id: 4, name: "plate")
        case "salmon":
            return Ingredient(id: 5, name: "salmon")
        case "tamago":
            return Ingredient(id: 6, name: "tamago")
        default:
            return Ingredient(id: 1, name: "sushi")
        }
    }
}
