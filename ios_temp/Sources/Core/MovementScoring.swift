nonisolated enum MovementScoringError: Error, Equatable {
    case invalidPosition
    case invalidTime
    case observationsRequired
}

nonisolated struct ScreenPosition: Equatable, Sendable {
    let x: Double
    let y: Double

    init(x: Double, y: Double) throws {
        guard x.isFinite, y.isFinite else { throw MovementScoringError.invalidPosition }
        self.x = x
        self.y = y
    }
}

nonisolated enum MovementRegion: Int, Equatable, Sendable {
    case center = 0
    case slightDeparture = 1
    case largerDeparture = 2
    case nearEdge = 3
    case outside = 4

    static func containing(_ point: ScreenPosition) -> Self {
        if (0.25...0.75).contains(point.x) && (0.25...0.75).contains(point.y) { return .center }
        if (0.15...0.85).contains(point.x) && (0.15...0.85).contains(point.y) { return .slightDeparture }
        if (0.05...0.95).contains(point.x) && (0.05...0.95).contains(point.y) { return .largerDeparture }
        if (0...1).contains(point.x) && (0...1).contains(point.y) { return .nearEdge }
        return .outside
    }
}

nonisolated enum MovementExclusionReason: String, CaseIterable, Equatable, Hashable, Sendable {
    case settingDisabled
    case cameraUnavailable
    case trueDepthUnavailable
    case preparationTrackingUnavailable
    case interviewTrackingUnavailable
}

nonisolated enum MovementAssessment: Equatable, Sendable {
    case awaitingObservations
    case included(MovementCategoryScores)
    case excluded(Set<MovementExclusionReason>)
}

nonisolated struct MovementScoring: Sendable {
    private(set) var exclusions: Set<MovementExclusionReason>
    private var gazeTenths = 1000
    private var headTenths = 1000
    private var observedGaze = false
    private var observedHead = false
    private var gazeMissingSince: Duration?
    private var headMissingSince: Duration?
    private var lastTime: Duration = .zero

    init(exclusions: Set<MovementExclusionReason> = []) {
        self.exclusions = exclusions
    }

    static func initialExclusions(
        sharedSettingEnabled: Bool = true,
        frontCameraAvailable: Bool,
        hasTrueDepth: Bool,
        preparationTrackingAvailable: Bool
    ) -> Set<MovementExclusionReason> {
        var reasons = Set<MovementExclusionReason>()
        if !sharedSettingEnabled { reasons.insert(.settingDisabled) }
        if !frontCameraAvailable { reasons.insert(.cameraUnavailable) }
        if !hasTrueDepth { reasons.insert(.trueDepthUnavailable) }
        if !preparationTrackingAvailable { reasons.insert(.preparationTrackingUnavailable) }
        return reasons
    }

    var assessment: MovementAssessment {
        get throws {
            if !exclusions.isEmpty { return .excluded(exclusions) }
            guard observedGaze, observedHead else { return .awaitingObservations }
            return try .included(MovementCategoryScores(
                gaze: Score(numerator: gazeTenths, denominator: 10),
                head: Score(numerator: headTenths, denominator: 10)
            ))
        }
    }

    func scoresForOverall() throws -> MovementCategoryScores? {
        switch try assessment {
        case .included(let scores): return scores
        case .excluded: return nil
        case .awaitingObservations: throw MovementScoringError.observationsRequired
        }
    }

    // 호출자가 초당 확인 한 건씩 전달한다. nil은 화면 밖 위치와 구분한다.
    mutating func recordCheck(gaze: ScreenPosition?, head: ScreenPosition?) {
        guard exclusions.isEmpty else { return }
        if let gaze, gazeMissingSince == nil {
            observedGaze = true
            gazeTenths = max(0, gazeTenths - MovementRegion.containing(gaze).rawValue)
        }
        if let head, headMissingSince == nil {
            observedHead = true
            headTenths = max(0, headTenths - MovementRegion.containing(head).rawValue)
        }
    }

    // 정상 자료의 판별과 누락 시각 감지는 실제 추적 연결부의 별도 승인 사항이다.
    mutating func updateAvailability(gaze: Bool, head: Bool, at time: Duration) throws {
        try advanceTime(to: time)
        guard exclusions.isEmpty else { return }
        if gaze { gazeMissingSince = nil }
        else if gazeMissingSince == nil { gazeMissingSince = time }
        if head { headMissingSince = nil }
        else if headMissingSince == nil { headMissingSince = time }
    }

    mutating func advanceTime(to time: Duration) throws {
        guard time >= .zero, time >= lastTime else { throw MovementScoringError.invalidTime }
        lastTime = time
        guard exclusions.isEmpty else { return }
        let lost = [gazeMissingSince, headMissingSince].compactMap { $0 }
            .contains { time - $0 >= .seconds(3) }
        if lost { exclusions.insert(.interviewTrackingUnavailable) }
    }
}
