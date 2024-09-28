//
//  Models.swift
//  Murdle
//
//  Created by Dinith Meegahapola on 27/9/2024.
//

import Foundation
import SwiftUI

struct Murdle {
    let id = UUID()
    let title: String
    let date: Date
    
    let gridSize: Int
    
    let body: [String] // need to change
    let clues: [Clue]
    // special clue (guilty always lie, innocent always truth)
    
    let suspects: [Card]
    let weapons: [Card]
    let locations: [Card]
    let motives: [Card]
    
    var guess = Guess()
    let solution: Guess
}

struct Card: Equatable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color? // String?
    let description: String
    let tags: [String]
    
    enum CardType {
        case suspect, weapon, location, motive
    }
}

struct Clue {
    let id = UUID()
    let type: ClueType
    let description: String
    // fingerprints, decoder, birthday, etc.
    
    enum ClueType {
        case normal, important
    }
}

struct Guess {
    let id = UUID()
    var suspect: Card?
    var weapon: Card?
    var location: Card?
    var motive: Card?
}

struct WorkingGrid {
    let id = UUID()
    var murdle: Murdle
    
    var cells: [Cell]
    
    mutating func checkCells() {
        for cell in cells.filter({ $0.clickable == true }) {
            if cell.type == .check {
                var filteredCells = cells.filter({ ($0.gridSection == cell.gridSection) && ($0.XIndex == cell.XIndex || $0.YIndex == cell.YIndex) })
                filteredCells.remove(at: filteredCells.firstIndex(of: cell)!)
                for filteredCell in filteredCells {
                    cells[cells.firstIndex(of: filteredCell)!].clickable = false
                }
            }
        }
        for cell in cells.filter({ $0.clickable == false }) {
            let filteredCells = cells.filter({ ($0.gridSection == cell.gridSection) && ($0.XIndex == cell.XIndex || $0.YIndex == cell.YIndex) && ($0.type == .check) })
            if filteredCells.count == 0 {
                cells[cells.firstIndex(of: cell)!].clickable = true
            }
        }
    }

    struct Cell: Equatable, Identifiable {
        let id = UUID()
        let gridSection: Int
        let XIndex: Int
        let YIndex: Int
        
        var type: CellType = .empty
        var icon: String {
            if clickable || type == .cross {
                switch type {
                case .cross:
                    return "❌"
                case .check:
                    return "✅"
                case .question:
                    return "❓"
                default:
                    return ""
                }
            } else {
                return "✖️"
            }
        }
        
        var clickable: Bool = true
        
        mutating func click() {
            if clickable {
                var index = CellType.allCases.firstIndex(of: type)!
                if index == CellType.allCases.count - 1 {
                    index = -1
                }
                type = CellType.allCases[index + 1]
            }
        }
        
        enum CellType: CaseIterable {
            case empty, cross, check, question
        }
    }
}

func generateRandomCards(_ type: Card.CardType, _ count: Int) -> [Card] {
    func randomCard() -> Card {
        let suspects: [String: String] = ["Admiral Navy": "👨‍✈️", "Agent Fuchsia": "🕵️‍♀️", "Babyface Blue": "👶", "Baron Maroon": "🧔", "Bishop Azure": "👨‍⚖️", "Brother Brownstone": "👨‍👦", "Captain Slate": "👨‍✈️", "Chancellor Tuscany": "👨‍🎓", "Chef Aubergine": "👨‍🍳", "Coach Raspberry": "🏋️‍♂️", "Comrade Champagne": "🤵", "Dame Obsidian": "👩‍⚖️", "Deacon Verdigris": "👨‍⚕️", "Dean Glaucous": "👨‍🏫", "Dr. Crimson": "👨‍⚕️", "Earl Grey": "🧔", "Father Mango": "👨‍👧", "General Coffee": "👨‍✈️", "Grandmaster Rose": "👩‍🎤", "Judge Pine": "👨‍⚖️", "Lady Violet": "👩‍🎨", "Lord Lavender": "🧔", "Major Red": "👨‍✈️", "Mayor Honey": "👨‍💼", "Miss Ruby": "👩‍🎤", "Miss Saffron": "👩‍🍳", "Mx. Tangerine": "🧑‍🎤", "Officer Copper": "👮‍♂️", "Principal Applegreen": "👩‍🏫", "Président Amaranth": "👨‍💼", "Secretary Celadon": "👩‍💼", "Signor Emerald": "🕵️‍♂️", "Silverton the Legend": "👤", "Sir Rulean": "🧔", "Sister Lapis": "👩‍⚕️", "The Amazing Aureolin": "🌟", "The Duchess of Vermillion": "👸", "Uncle Midnight": "👴", "Vice President Mauve": "👨‍💼", "Viscount Eminence": "🧔"]
        let weapons: [String: String] = ["Dagger": "🗡️", "Gun": "🔫", "Sword": "⚔️", "Bow": "🏹", "Axe": "🪓", "Hammer": "🔨", "Poison": "☠️", "Fire": "🔥", "Spear": "⛏️", "Bomb": "💣"]
        let locations: [String: String] = ["Kitchen": "🍽️", "Library": "📚", "Living Room": "🛋️", "Bedroom": "🛏️", "Bathroom": "🚽", "Garage": "🛠️", "Garden": "🌳", "Cellar": "🍷", "Attic": "🏠", "Dining Room": "🍴"]
        let motives: [String: String] = ["Revenge": "🔪", "Greed": "💰", "Jealousy": "💔", "Passion": "❤️", "Power": "👑", "Fear": "😱", "Love": "😍", "Betrayal": "🖤", "Desperation": "😔", "Hatred": "😡"]
        let colors: [Color] = [.red, .green, .blue, .purple, .pink, .orange, .yellow, .black, .brown, .gray, .cyan, .indigo, .mint, .teal, .white]
        
        switch type {
        case .suspect:
            return Card(name: suspects.keys.randomElement()!, icon: suspects.values.randomElement()!, color: colors.randomElement(), description: "Generate me a description.", tags: [])
        case .weapon:
            return Card(name: weapons.keys.randomElement()!, icon: weapons.values.randomElement()!, color: colors.randomElement(), description: "Generate me a description.", tags: [])
        case .location:
            return Card(name: locations.keys.randomElement()!, icon: locations.values.randomElement()!, color: colors.randomElement(), description: "Generate me a description.", tags: [])
        case .motive:
            return Card(name: motives.keys.randomElement()!, icon: motives.values.randomElement()!, color: colors.randomElement(), description: "Generate me a description.", tags: [])
        }
    }
    
    var list: [Card] = []
    for _ in 0..<count {
        list.append(randomCard())
    }
    print(list)
    return list
}

func generateRandomMurdle(_ size: Int? = nil) -> Murdle {
    let titles: [String] = ["A Fatal Family Feast", "Murder at Midnight", "Secrets in the Library", "The Stolen Crown", "A Ghostly Encounter", "Poison in the Punch", "The Jealous Lover", "The Gardener's Revenge", "A Betrayal Unveiled", "The Hidden Agenda"]
    var gridSize: Int = 0
    if (size != nil) {
        gridSize = size!
    } else {
        let gridSizes: [Int] = [3,4,5,6]
        gridSize = gridSizes.randomElement()!
    }
    let suspects = generateRandomCards(.suspect, gridSize)
    let weapons = generateRandomCards(.weapon, gridSize)
    let locations = generateRandomCards(.location, gridSize)
    let hasMotives = [true, false]
    let motives = hasMotives.randomElement()! ? generateRandomCards(.motive, gridSize) : []
    let solution = Guess(suspect: suspects.randomElement(), weapon: weapons.randomElement(), location: locations.randomElement(), motive: motives.randomElement())
    
    return Murdle(title: titles.randomElement()!, date: Date.now, gridSize: gridSize, body: ["Body Description"], clues: [], suspects: suspects, weapons: weapons, locations: locations, motives: motives, solution: solution)
}

func generateWorkingGrid(_ murdle: Murdle = generateRandomMurdle()) -> WorkingGrid {
    func generateCells(_ gridSize: Int, hasMotives: Bool) -> [WorkingGrid.Cell] {
        var list: [WorkingGrid.Cell] = []
        let size = gridSize - 1
        let gridSections = hasMotives ? 5 : 3
        for i in 0...gridSections {
            for j in 0...size {
                for k in 0...size {
                    list.append(WorkingGrid.Cell(gridSection: i, XIndex: j, YIndex: k))
                }
            }
        }
        return list
    }
    let workingGrid = WorkingGrid(murdle: murdle, cells: generateCells(murdle.gridSize, hasMotives: murdle.motives == [] ? false : true))
    print(workingGrid)
    print(workingGrid.murdle)
    print(workingGrid.murdle.gridSize)
    return workingGrid
}
