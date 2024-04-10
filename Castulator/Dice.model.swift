enum Dice: String, Codable {
    case d2, d4, d6, d8, d10, d12, d20, d100

		static func castDie(_ die: Self) -> UInt {
				switch die {
				case .d2: return UInt.random(in: 0...1)
				case .d4: return UInt.random(in: 1...4)
				case .d6: return UInt.random(in: 1...6)
				case .d8: return UInt.random(in: 1...8)
				case .d10: return UInt.random(in: 0...9)
				case .d12: return UInt.random(in: 1...12)
				case .d20: return UInt.random(in: 1...20)
				case .d100: return UInt.random(in: 0...99)
				}
		}
}
