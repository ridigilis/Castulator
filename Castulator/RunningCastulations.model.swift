struct RunningCastulations {
    let value: [Castulation]

    var rhs: Castulation {
        value.last ?? Castulation()
    }

    var lhs: Castulation {
        value.count <= 1
            ? Castulation()
            : value[value.count - 2]
    }

    var total: Double {
        value.reduce(0) { total, castulation in
            if castulation == value[value.count - 1] {
                return total
            }

            if castulation.result != nil {
                return Castulation.castulate(lhsTerm: total, op: castulation.operation, rhsTerm: Double(castulation.result!))
            }

            return total
        }
    }

    init(value: [Castulation] = [Castulation()]) {
        self.value = value
    }
}
