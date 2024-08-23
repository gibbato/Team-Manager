//
//  playerTests.swift
//  playerTests
//
//  Created by Michael Gibson on 8/22/24.
//

import XCTest
@testable import Team_Manager

final class playerTests: XCTestCase {

    var teamController: TeamController!

    override func setUpWithError() throws {
        // Initialize the TeamController before each test
        teamController = TeamController()
    }

    override func tearDownWithError() throws {
        // Clean up the TeamController after each test
        teamController = nil
    }

    // Example functional test for loading team members
    func testLoadTeamMembers() throws {
        // Use an expectation for asynchronous code
        let expectation = self.expectation(description: "Load team members")

        teamController.loadTeamMembers()

        // Wait for the asynchronous call to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertFalse(self.teamController.teamMembers.isEmpty, "Team members should not be empty after loading")
            expectation.fulfill()
        }

        // Wait for expectations to be met
        waitForExpectations(timeout: 5, handler: nil)
    }

    // Example performance test for adding a team member
    func testPerformanceAddTeamMember() throws {
        let newMember = TeamMember(id: "test_id", name: "Test User", email: "testuser@example.com", role: "Player", profilePictureURL: URL(string: "https://example.com/image.jpg"))

        measure {
            // Measure the time it takes to add a team member
            teamController.addTeamMember(newMember)
        }
    }
}
