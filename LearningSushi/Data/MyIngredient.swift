//
//  MyIngredient.swift
//  LearningSushi
//
//  Created by win win on 24/04/24.
//

import Foundation
import SwiftUI

struct MyIngredient: Identifiable {
    var id: UUID = UUID()
    var name : String
    var loc: CGPoint = CGPoint(x: UIScreen.main.bounds.size.width/2-60, y: -100)
}
