//
//  APIServiceTests.swift
//  EMToDo
//
//  Created by Maxim Makarenkov on 27.03.2025.
//

import XCTest
@testable import EMToDo

final class APIServiceTests: XCTestCase {
    var apiService: APIService!
    var urlSession: URLSession!
    
    override func setUp() {
        super.setUp()
        apiService = APIService.shared
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: config)
        
        apiService.urlSession = urlSession
    }
    
    override func tearDown() {
        apiService = nil
        urlSession = nil
        super.tearDown()
    }
    
    func testFetchTasksSuccess() {
        // Arrange
        let jsonData = """
        {
        "todos": [
            {
              "id": 1,
              "todo": "Do something nice for someone you care about",
              "completed": false,
              "userId": 152
            },
            {
              "id": 2,
              "todo": "Memorize a poem",
              "completed": true,
              "userId": 13
            }]
        }
        """.data(using: .utf8)
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, jsonData)
        }
        
        let expectation = self.expectation(description: "Fetch tasks succeeds")
        
        // Act
        apiService.fetchTasks { result in
            switch result {
            case .success(let tasks):
                XCTAssertEqual(tasks.count, 2, "Expected 2 tasks")
                XCTAssertEqual(tasks[0].description, "Do something nice for someone you care about")
                XCTAssertEqual(tasks[1].description, "Memorize a poem")
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testFetchTasksNetworkError() {
        // Arrange
        MockURLProtocol.requestHandler = { _ in
            throw URLError(.notConnectedToInternet)
        }
        
        let expectation = self.expectation(description: "Network error")
        
        // Act
        apiService.fetchTasks { result in
            if case .failure(let error) = result {
                XCTAssertEqual(error, .fetchError, "Expected fetchError")
            } else {
                XCTFail("Expected failure but got success")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testFetchTasksBadResponse() {
        // Arrange
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 500, httpVersion: nil, headerFields: nil)!
            return (response, nil)
        }
        
        let expectation = self.expectation(description: "Bad response error")
        
        // Act
        apiService.fetchTasks { result in
            if case .failure(let error) = result {
                XCTAssertEqual(error, .badResponse, "Expected badResponse error")
            } else {
                XCTFail("Expected failure but got success")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testFetchTasksDecodingError() {
        // Arrange
        let invalidJsonData = """
        {
            "tasks": [
                {"id": 1, "title": "Task 1", "completed": false}
            ]
        }
        """.data(using: .utf8)
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, invalidJsonData)
        }
        
        let expectation = self.expectation(description: "Decoding error")
        
        // Act
        apiService.fetchTasks { result in
            if case .failure(let error) = result {
                XCTAssertEqual(error, .badDecode, "Expected badDecode error")
            } else {
                XCTFail("Expected failure but got success")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
}

