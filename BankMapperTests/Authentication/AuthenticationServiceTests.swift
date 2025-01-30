//
//  AuthenticationServiceTests.swift
//  BankMapperTests
//
//  Created by Alexander Jackson on 1/23/25.
//

import XCTest
@testable import BankMapper

final class AuthenticationServiceTests: XCTestCase {
    
    var sut: AuthenticationService!
    var username: String!
    var password: String!
    
    override func setUp() {
        sut = AuthenticationService.shared
        username = "test.user"
        password = "abc.123"
    }
    
    override func tearDown() {
        _ = sut.deleteCredentials(username: username)
        sut = nil
        username = nil
        password = nil
    }
    
    func testAddCredentials() {
        XCTAssertTrue(sut.addCredentials(username: username, password: password))
        XCTAssertEqual(sut.getCredentials(username: username), password)
    }
    
    func testSaveCredentials()  {
        XCTAssertTrue(sut.saveCredentials(username: username, password: password))
    }
    
    func testUpdateCredentials() {
        let newPassword = "new.456"
        _ = sut.addCredentials(username: username, password: password)
        XCTAssertTrue(sut.updateCredentials(username: username, password: newPassword))
        XCTAssertEqual(sut.getCredentials(username: username), newPassword)
    }
}
