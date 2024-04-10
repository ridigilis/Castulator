struct Castulation: Identifiable, Equatable {
    let id = UUID()
    let operation: Operation
    let terms: [TermItem]

    var result: UInt? {
        let rolls = self.terms.compactMap { $0.roll }

        return rolls.count > 0
            ? rolls.reduce(0) { $0 + $1 }
            : nil
    }

    static func castulate(lhsTerm: Double, op: Operation, rhsTerm: Double) -> Double {
        switch op {
        case .add: floor(lhsTerm + rhsTerm)
        case .subtract: floor(lhsTerm - rhsTerm)
        case .multiply: floor(lhsTerm * rhsTerm)
        case .divide: floor(lhsTerm / (rhsTerm == 0 ? 1 : rhsTerm))
        }
    }

    init(operation: Operation = .add, terms: [TermItem] = []) {
        self.operation = operation
        self.terms = terms
    }

    static func == (lhs: Castulation, rhs: Castulation) -> Bool {
        lhs.id == rhs.id
    }
}
