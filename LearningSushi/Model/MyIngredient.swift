import Foundation
import SwiftUI

struct MyIngredient: Identifiable, Codable {
    var id: UUID = .init()
    var name: String
    var loc: CGPoint = .init(x: UIScreen.main.bounds.size.width / 2 - 60, y: -100)

    func data() -> Data? {
        try? JSONEncoder().encode(self)
    }
}
