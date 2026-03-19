import Darwin
import Foundation
import Testing
@testable import OpenJordy

@Suite struct LogLocatorTests {
    @Test func launchdGatewayLogPathEnsuresTmpDirExists() {
        let fm = FileManager()
        let baseDir = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let logDir = baseDir.appendingPathComponent("openjordy-tests-\(UUID().uuidString)")

        setenv("OPENJORDY_LOG_DIR", logDir.path, 1)
        defer {
            unsetenv("OPENJORDY_LOG_DIR")
            try? fm.removeItem(at: logDir)
        }

        _ = LogLocator.launchdGatewayLogPath

        var isDir: ObjCBool = false
        #expect(fm.fileExists(atPath: logDir.path, isDirectory: &isDir))
        #expect(isDir.boolValue == true)
    }
}
