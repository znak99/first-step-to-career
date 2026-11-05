nonisolated enum ScoreError: Error, Equatable {
    case invalidFraction
    case outOfRange
    case arithmeticOverflow
}

nonisolated struct Score: Equatable, Sendable {
    fileprivate let value: ScoreFraction

    static let zero = Score(validated: .zero)
    static let hundred = Score(validated: ScoreFraction(integer: 100))

    init(numerator: Int, denominator: Int = 1) throws {
        try self.init(fraction: ScoreFraction(numerator, denominator))
    }

    init(fraction: ScoreFraction) throws {
        let whole = fraction.numerator / fraction.denominator
        guard whole < 100 || (whole == 100 && fraction.numerator % fraction.denominator == 0) else {
            throw ScoreError.outOfRange
        }
        self.value = fraction
    }

    private init(validated value: ScoreFraction) {
        self.value = value
    }

    var formatted: String {
        let whole = value.numerator / value.denominator
        let remainder = value.numerator % value.denominator
        let digit = value.denominator.dividingFullWidth(remainder.multipliedFullWidth(by: 10))
        let roundUp = digit.remainder >= value.denominator / 2 + value.denominator % 2
        let tenths = whole * 10 + digit.quotient + (roundUp ? 1 : 0)
        return "\(tenths / 10).\(tenths % 10)"
    }

    static func weightedMean(_ entries: [(score: Score, weight: Int)]) throws -> Score {
        var sum = ScoreFraction.zero
        var totalWeight = 0
        for entry in entries {
            guard entry.weight > 0 else { throw ScoreError.invalidFraction }
            sum = try sum.adding(entry.score.value.multiplied(by: entry.weight))
            totalWeight = try ScoreFraction.checkedAdd(totalWeight, entry.weight)
        }
        return try Score(fraction: sum.divided(by: totalWeight))
    }

    func scaled(by numerator: Int, over denominator: Int) throws -> Score {
        try Score(fraction: value.multiplied(by: numerator).divided(by: denominator))
    }

    func subtractingWithFloor(_ amount: Int) throws -> Score {
        guard amount >= 0 else { throw ScoreError.invalidFraction }
        if value.numerator / value.denominator < amount { return .zero }
        let deduction = try ScoreFraction.checkedMultiply(amount, value.denominator)
        return try Score(numerator: value.numerator - deduction, denominator: value.denominator)
    }
}

// 승인된 평균·가중치 계산에서 중간 반올림 없이 분자와 분모를 유지한다.
nonisolated struct ScoreFraction: Equatable, Sendable {
    let numerator: Int
    let denominator: Int

    static let zero = ScoreFraction(integer: 0)

    init(integer: Int) {
        precondition(integer >= 0)
        numerator = integer
        denominator = 1
    }

    init(_ numerator: Int, _ denominator: Int) throws {
        guard numerator >= 0, denominator > 0 else { throw ScoreError.invalidFraction }
        let divisor = Self.gcd(numerator, denominator)
        self.numerator = numerator / divisor
        self.denominator = denominator / divisor
    }

    func adding(_ other: Self) throws -> Self {
        let common = Self.gcd(denominator, other.denominator)
        let left = try Self.checkedMultiply(numerator, other.denominator / common)
        let right = try Self.checkedMultiply(other.numerator, denominator / common)
        return try Self(Self.checkedAdd(left, right), Self.checkedMultiply(denominator, other.denominator / common))
    }

    func multiplied(by multiplier: Int) throws -> Self {
        guard multiplier >= 0 else { throw ScoreError.invalidFraction }
        let common = Self.gcd(multiplier, denominator)
        return try Self(Self.checkedMultiply(numerator, multiplier / common), denominator / common)
    }

    func divided(by divisor: Int) throws -> Self {
        guard divisor > 0 else { throw ScoreError.invalidFraction }
        let common = Self.gcd(numerator, divisor)
        return try Self(numerator / common, Self.checkedMultiply(denominator, divisor / common))
    }

    static func checkedAdd(_ lhs: Int, _ rhs: Int) throws -> Int {
        let result = lhs.addingReportingOverflow(rhs)
        guard !result.overflow else { throw ScoreError.arithmeticOverflow }
        return result.partialValue
    }

    static func checkedMultiply(_ lhs: Int, _ rhs: Int) throws -> Int {
        let result = lhs.multipliedReportingOverflow(by: rhs)
        guard !result.overflow else { throw ScoreError.arithmeticOverflow }
        return result.partialValue
    }

    private static func gcd(_ lhs: Int, _ rhs: Int) -> Int {
        var a = lhs
        var b = rhs
        while b != 0 { (a, b) = (b, a % b) }
        return a
    }
}
