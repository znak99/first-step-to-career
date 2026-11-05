import XCTest

@MainActor
final class AppNavigationUITests: XCTestCase {
    func testOnboardingTabsAndEveryChildScreen() {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()

        let start = app.buttons["onboarding.start"]
        XCTAssertTrue(start.waitForExistence(timeout: 10))
        capture(app, name: "Onboarding")
        start.tap()

        XCTAssertTrue(app.navigationBars["模擬面接"].exists)
        XCTAssertEqual(app.tabBars.buttons.count, 4)
        capture(app, name: "MockInterview")

        app.buttons["setup.prepare"].tap()
        XCTAssertTrue(app.navigationBars["面接の準備"].exists)
        capture(app, name: "Preparation")

        app.buttons["preparation.openInterview"].tap()
        XCTAssertTrue(app.navigationBars["面接"].exists)
        capture(app, name: "Interview")

        app.buttons["interview.openResult"].tap()
        XCTAssertTrue(app.navigationBars["面接結果"].exists)
        XCTAssertTrue(app.staticTexts["まだ面接結果がありません"].exists)
        capture(app, name: "InterviewResult")

        for _ in 0..<3 {
            app.navigationBars.buttons.element(boundBy: 0).tap()
        }
        XCTAssertTrue(app.navigationBars["模擬面接"].exists)

        app.tabBars.buttons["面接管理"].tap()
        XCTAssertTrue(app.navigationBars["面接管理"].exists)
        capture(app, name: "Management")

        app.buttons["management.history"].tap()
        XCTAssertTrue(app.navigationBars["過去の面接結果"].exists)
        XCTAssertTrue(app.staticTexts["まだ面接の記録がありません"].exists)
        capture(app, name: "PastResults")
        app.navigationBars.buttons.element(boundBy: 0).tap()

        app.buttons["management.schedule"].tap()
        XCTAssertTrue(app.navigationBars["面接スケジュール"].exists)
        XCTAssertTrue(app.staticTexts["面接の予定はありません"].exists)
        capture(app, name: "Schedule")

        app.tabBars.buttons["面接分析"].tap()
        XCTAssertTrue(app.navigationBars["面接分析"].exists)
        capture(app, name: "Analysis")

        app.tabBars.buttons["メニュー"].tap()
        XCTAssertTrue(app.navigationBars["メニュー"].exists)
        capture(app, name: "Menu")
    }

    func testQuestionCountBoundsAndSharedTabState() {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
        let start = app.buttons["onboarding.start"]
        XCTAssertTrue(start.waitForExistence(timeout: 10))
        start.tap()

        app.tabBars.buttons["メニュー"].tap()
        let stepper = app.steppers["settings.questionCount"]
        XCTAssertTrue(stepper.exists)
        let decrement = stepper.buttons.element(boundBy: 0)
        let increment = stepper.buttons.element(boundBy: 1)
        decrement.tap()
        decrement.tap()
        XCTAssertFalse(decrement.isEnabled)

        for _ in 0..<4 { increment.tap() }
        XCTAssertFalse(increment.isEnabled)

        let movement = app.switches["settings.movementScoring"]
        XCTAssertEqual(movement.value as? String, "1")
        movement.coordinate(withNormalizedOffset: CGVector(dx: 0.92, dy: 0.5)).tap()
        let switchedOff = expectation(for: NSPredicate(format: "value == '0'"), evaluatedWith: movement)
        wait(for: [switchedOff], timeout: 3)

        app.tabBars.buttons["模擬面接"].tap()
        let questionCount = app.descendants(matching: .any).matching(identifier: "setup.questionCount").firstMatch
        XCTAssertEqual(questionCount.value as? String, "7問")
        app.buttons["setup.prepare"].tap()
        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertEqual(questionCount.value as? String, "7問")

        app.tabBars.buttons["メニュー"].tap()
        XCTAssertEqual(movement.value as? String, "0")
    }

    private func capture(_ app: XCUIApplication, name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
