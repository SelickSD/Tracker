//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Сергей Денисенко on 13.03.2024.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    func testViewController() {
        let tracer = TrackersViewController()
        assertSnapshot(matching: tracer, as: .image)
    }

}
