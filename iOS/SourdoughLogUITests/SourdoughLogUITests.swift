import XCTest

final class SourdoughLogUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testAddItemFlow() {
        app.buttons["button.add"].tap()
        let titleField = app.textFields["field.title"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 2))
        titleField.tap()
        titleField.typeText("UI Test Item")
        app.buttons["button.save"].tap()
        XCTAssertTrue(app.staticTexts["UI Test Item"].waitForExistence(timeout: 2))
    }

    func testFreeLimitTriggersPaywall() {
        for i in 0..<40 {
            app.buttons["button.add"].tap()
            let titleField = app.textFields["field.title"]
            if titleField.waitForExistence(timeout: 2) {
                titleField.tap()
                titleField.typeText("Item \(i)")
                app.buttons["button.save"].tap()
            }
        }
        XCTAssertTrue(app.buttons["button.purchase"].waitForExistence(timeout: 2))
    }

    func testKeyboardDismissOnTapOutside() {
        app.buttons["button.add"].tap()
        let titleField = app.textFields["field.title"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 2))
        titleField.tap()
        titleField.typeText("Dismiss Me")
        app.navigationBars.firstMatch.tap()
        XCTAssertFalse(titleField.hasKeyboardFocus)
    }

    func testSettingsOpens() {
        app.buttons["button.settings"].tap()
        XCTAssertTrue(app.navigationBars["Settings"].waitForExistence(timeout: 2))
    }
}
