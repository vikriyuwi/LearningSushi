import Foundation
import SwiftUI

struct MyIngredient: Identifiable, Codable {
    var id: UUID = .init()
    var name: String
    var loc: CGPoint = .init(x: .random(in : 100...UIScreen.main.bounds.size.width - 100), y: -100)

    func data() -> Data? {
        try? JSONEncoder().encode(self)
    }
}
