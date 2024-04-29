//
//  Objective.swift
//  LearningSushi
//
//  Created by Nadhif Rahman Alfan on 29/04/24.
//

import Foundation

let menu = ["sushi salmon", "sushi shrimp", "sushi tamago", "sushi tuna", "wakame nori", "tobiko nori"]

struct Objective {
    var menus: [String] = []
    var ingredients: [String] = []
    var playerFinished: [Bool] = []
    
    init() {
        let temp = generateMenu()
        self.menus = temp
        self.ingredients = generateIngredient(objectiveMenu: temp)
    }
    
    func generateMenu() -> [String] {
        var objectiveTemp: [String] = []
        
        for _ in 0 ..< 5 {
            objectiveTemp.append(menu.randomElement()!)
        }
        return objectiveTemp
    }
    
    func generateIngredient(objectiveMenu: [String]) -> [String] {
        var objectiveIngredient: [String] = []
        
        for i in 0 ..< objectiveMenu.count {
            let stringSpliced = objectiveMenu[i].split(separator: " ")
            for i in 0 ..< 2 {
                let ingredient = stringSpliced[i] == "sushi" ? "rice" : stringSpliced[i]
                objectiveIngredient.append(String(ingredient))
            }
        }
        
//        print("\(objectiveIngredient) ini objective")

        return objectiveIngredient
    }
}
