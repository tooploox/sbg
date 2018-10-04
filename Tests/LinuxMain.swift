import XCTest

import sbgTests

var tests = [XCTestCaseEntry]()
tests += sbgTests.allTests()
XCTMain(tests)