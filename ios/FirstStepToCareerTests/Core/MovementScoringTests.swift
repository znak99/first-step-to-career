import Testing
@testable import FirstStepToCareer

struct MovementScoringTests {
    @Test func boundariesAndCornersBelongToTheInnerRectangle() throws {
        let boundaries: [(Double, Double, MovementRegion, MovementRegion)] = [
            (0.25, 0.75, .center, .slightDeparture),
            (0.15, 0.85, .slightDeparture, .largerDeparture),
            (0.05, 0.95, .largerDeparture, .nearEdge),
            (0, 1, .nearEdge, .outside)
        ]
        for (lower, upper, inner, outer) in boundaries {
            for (x, y) in [(lower, 0.5), (upper, 0.5), (0.5, lower), (0.5, upper), (lower, lower), (lower, upper), (upper, lower), (upper, upper)] {
                #expect(try MovementRegion.containing(ScreenPosition(x: x, y: y)) == inner)
            }
            for value in [lower.nextDown, upper.nextUp] {
                #expect(try MovementRegion.containing(ScreenPosition(x: value, y: 0.5)) == outer)
                #expect(try MovementRegion.containing(ScreenPosition(x: 0.5, y: value)) == outer)
            }
        }
        #expect(throws: MovementScoringError.invalidPosition) { try ScreenPosition(x: .nan, y: 0) }
        #expect(throws: MovementScoringError.invalidPosition) { try ScreenPosition(x: 0, y: .infinity) }
    }

    @Test func consecutiveAndMixedDeductionsStayIndependent() throws {
        var movement = MovementScoring()
        let center = try ScreenPosition(x: 0.5, y: 0.5)
        for x in [0.2, 0.1, 0.01, -0.1] {
            for _ in 0..<10 { movement.recordCheck(gaze: try ScreenPosition(x: x, y: 0.5), head: center) }
        }
        var scores = try #require(try movement.scoresForOverall())
        #expect(scores.gaze.formatted == "90.0")
        #expect(scores.head.formatted == "100.0")
        for _ in 0..<1000 { movement.recordCheck(gaze: try ScreenPosition(x: -1, y: 0.5), head: nil) }
        scores = try #require(try movement.scoresForOverall())
        #expect(scores.gaze == .zero)
        #expect(scores.head == .hundred)
    }

    @Test func aMissingCheckIsSkippedAndDoesNotMeanCenterOrOutside() throws {
        var movement = MovementScoring()
        #expect(throws: MovementScoringError.observationsRequired) { try movement.scoresForOverall() }
        movement.recordCheck(gaze: nil, head: try ScreenPosition(x: 0.5, y: 0.5))
        #expect(try movement.assessment == .awaitingObservations)
        movement.recordCheck(gaze: try ScreenPosition(x: 0.5, y: 0.5), head: nil)
        movement.recordCheck(gaze: nil, head: try ScreenPosition(x: -0.1, y: 0.5))
        let scores = try #require(try movement.scoresForOverall())
        #expect(scores.gaze == .hundred)
        #expect(scores.head.formatted == "99.6")
    }

    @Test func shorterGapsRecoverWithoutCombiningSeparateIntervals() throws {
        var movement = MovementScoring()
        movement.recordCheck(gaze: try ScreenPosition(x: 0.5, y: 0.5), head: try ScreenPosition(x: 0.5, y: 0.5))
        try movement.updateAvailability(gaze: false, head: true, at: .zero)
        try movement.advanceTime(to: .milliseconds(2999))
        #expect(movement.exclusions.isEmpty)
        try movement.updateAvailability(gaze: true, head: true, at: .milliseconds(2999))
        try movement.updateAvailability(gaze: false, head: true, at: .seconds(5))
        try movement.updateAvailability(gaze: true, head: true, at: .milliseconds(6500))
        try movement.updateAvailability(gaze: true, head: false, at: .seconds(7))
        try movement.updateAvailability(gaze: true, head: true, at: .milliseconds(8500))
        #expect(movement.exclusions.isEmpty)
        #expect(try movement.scoresForOverall()?.gaze == .hundred)
    }

    @Test(arguments: [true, false])
    func eitherCategoryMissingForThreeSecondsExcludesBoth(gazeMissing: Bool) throws {
        var movement = MovementScoring()
        movement.recordCheck(gaze: try ScreenPosition(x: -1, y: 0.5), head: try ScreenPosition(x: -1, y: 0.5))
        try movement.updateAvailability(gaze: !gazeMissing, head: gazeMissing, at: .seconds(1))
        try movement.advanceTime(to: .milliseconds(3999))
        #expect(movement.exclusions.isEmpty)
        try movement.advanceTime(to: .seconds(4))
        #expect(try movement.assessment == .excluded([.interviewTrackingUnavailable]))
        #expect(try movement.scoresForOverall() == nil)
        try movement.updateAvailability(gaze: true, head: true, at: .seconds(5))
        #expect(try movement.scoresForOverall() == nil)
    }

    @Test func elapsedTimeRatherThanCheckCountDeterminesExclusion() throws {
        var movement = MovementScoring()
        try movement.updateAvailability(gaze: false, head: false, at: .zero)
        for _ in 0..<10 { movement.recordCheck(gaze: nil, head: nil) }
        #expect(movement.exclusions.isEmpty)
        try movement.advanceTime(to: .seconds(3))
        #expect(movement.exclusions == [.interviewTrackingUnavailable])
        #expect(throws: MovementScoringError.invalidTime) { try movement.advanceTime(to: .seconds(2)) }
    }

    @Test func existingReasonsExcludeBothWithoutChoosingDisplayPriority() throws {
        let reasons = MovementScoring.initialExclusions(sharedSettingEnabled: false, frontCameraAvailable: false, hasTrueDepth: false, preparationTrackingAvailable: false)
        #expect(reasons == [.settingDisabled, .cameraUnavailable, .trueDepthUnavailable, .preparationTrackingUnavailable])
        let movement = MovementScoring(exclusions: reasons)
        #expect(try movement.scoresForOverall() == nil)
        #expect(MovementScoring.initialExclusions(frontCameraAvailable: true, hasTrueDepth: true, preparationTrackingAvailable: true).isEmpty)
    }
}
