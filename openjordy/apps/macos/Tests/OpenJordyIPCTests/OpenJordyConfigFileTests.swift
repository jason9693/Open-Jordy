import Foundation
import Testing
@testable import OpenJordy

@Suite(.serialized)
struct OpenJordyConfigFileTests {
    private func makeConfigOverridePath() -> String {
        FileManager().temporaryDirectory
            .appendingPathComponent("openjordy-config-\(UUID().uuidString)")
            .appendingPathComponent("openjordy.json")
            .path
    }

    @Test
    func configPathRespectsEnvOverride() async {
        let override = makeConfigOverridePath()

        await TestIsolation.withEnvValues(["OPENJORDY_CONFIG_PATH": override]) {
            #expect(OpenJordyConfigFile.url().path == override)
        }
    }

    @MainActor
    @Test
    func remoteGatewayPortParsesAndMatchesHost() async {
        let override = makeConfigOverridePath()

        await TestIsolation.withEnvValues(["OPENJORDY_CONFIG_PATH": override]) {
            OpenJordyConfigFile.saveDict([
                "gateway": [
                    "remote": [
                        "url": "ws://gateway.ts.net:19999",
                    ],
                ],
            ])
            #expect(OpenJordyConfigFile.remoteGatewayPort() == 19999)
            #expect(OpenJordyConfigFile.remoteGatewayPort(matchingHost: "gateway.ts.net") == 19999)
            #expect(OpenJordyConfigFile.remoteGatewayPort(matchingHost: "gateway") == 19999)
            #expect(OpenJordyConfigFile.remoteGatewayPort(matchingHost: "other.ts.net") == nil)
        }
    }

    @MainActor
    @Test
    func setRemoteGatewayUrlPreservesScheme() async {
        let override = makeConfigOverridePath()

        await TestIsolation.withEnvValues(["OPENJORDY_CONFIG_PATH": override]) {
            OpenJordyConfigFile.saveDict([
                "gateway": [
                    "remote": [
                        "url": "wss://old-host:111",
                    ],
                ],
            ])
            OpenJordyConfigFile.setRemoteGatewayUrl(host: "new-host", port: 2222)
            let root = OpenJordyConfigFile.loadDict()
            let url = ((root["gateway"] as? [String: Any])?["remote"] as? [String: Any])?["url"] as? String
            #expect(url == "wss://new-host:2222")
        }
    }

    @MainActor
    @Test
    func clearRemoteGatewayUrlRemovesOnlyUrlField() async {
        let override = makeConfigOverridePath()

        await TestIsolation.withEnvValues(["OPENJORDY_CONFIG_PATH": override]) {
            OpenJordyConfigFile.saveDict([
                "gateway": [
                    "remote": [
                        "url": "wss://old-host:111",
                        "token": "tok",
                    ],
                ],
            ])
            OpenJordyConfigFile.clearRemoteGatewayUrl()
            let root = OpenJordyConfigFile.loadDict()
            let remote = ((root["gateway"] as? [String: Any])?["remote"] as? [String: Any]) ?? [:]
            #expect((remote["url"] as? String) == nil)
            #expect((remote["token"] as? String) == "tok")
        }
    }

    @Test
    func stateDirOverrideSetsConfigPath() async {
        let dir = FileManager().temporaryDirectory
            .appendingPathComponent("openjordy-state-\(UUID().uuidString)", isDirectory: true)
            .path

        await TestIsolation.withEnvValues([
            "OPENJORDY_CONFIG_PATH": nil,
            "OPENJORDY_STATE_DIR": dir,
        ]) {
            #expect(OpenJordyConfigFile.stateDirURL().path == dir)
            #expect(OpenJordyConfigFile.url().path == "\(dir)/openjordy.json")
        }
    }

    @MainActor
    @Test
    func saveDictAppendsConfigAuditLog() async throws {
        let stateDir = FileManager().temporaryDirectory
            .appendingPathComponent("openjordy-state-\(UUID().uuidString)", isDirectory: true)
        let configPath = stateDir.appendingPathComponent("openjordy.json")
        let auditPath = stateDir.appendingPathComponent("logs/config-audit.jsonl")

        defer { try? FileManager().removeItem(at: stateDir) }

        try await TestIsolation.withEnvValues([
            "OPENJORDY_STATE_DIR": stateDir.path,
            "OPENJORDY_CONFIG_PATH": configPath.path,
        ]) {
            OpenJordyConfigFile.saveDict([
                "gateway": ["mode": "local"],
            ])

            let configData = try Data(contentsOf: configPath)
            let configRoot = try JSONSerialization.jsonObject(with: configData) as? [String: Any]
            #expect((configRoot?["meta"] as? [String: Any]) != nil)

            let rawAudit = try String(contentsOf: auditPath, encoding: .utf8)
            let lines = rawAudit
                .split(whereSeparator: \.isNewline)
                .map(String.init)
            #expect(!lines.isEmpty)
            guard let last = lines.last else {
                Issue.record("Missing config audit line")
                return
            }
            let auditRoot = try JSONSerialization.jsonObject(with: Data(last.utf8)) as? [String: Any]
            #expect(auditRoot?["source"] as? String == "macos-openjordy-config-file")
            #expect(auditRoot?["event"] as? String == "config.write")
            #expect(auditRoot?["result"] as? String == "success")
            #expect(auditRoot?["configPath"] as? String == configPath.path)
        }
    }
}
