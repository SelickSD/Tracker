//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Сергей Денисенко on 13.03.2024.
//

import XCTest
import SnapshotTesting
import UIKit
@testable import Tracker

final class TrackerTests: XCTestCase {

    func testViewController() {
        let tracker = TrackersViewController()
        if tracker.traitCollection.userInterfaceStyle == .light {
            assertSnapshot(matching: tracker, as: .image(traits: .init(userInterfaceStyle: .light)))
        } else {
            assertSnapshot(matching: tracker, as: .image(traits: .init(userInterfaceStyle: .dark)))
        }
    }
}
