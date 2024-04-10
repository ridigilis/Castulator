import Foundation

struct TermItem: Equatable, Hashable, Identifiable {
    let id = UUID()
    let die: Dice
    let roll: UInt?
}
