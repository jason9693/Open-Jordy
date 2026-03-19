import Foundation

public enum OpenJordyChatTransportEvent: Sendable {
    case health(ok: Bool)
    case tick
    case chat(OpenJordyChatEventPayload)
    case agent(OpenJordyAgentEventPayload)
    case seqGap
}

public protocol OpenJordyChatTransport: Sendable {
    func requestHistory(sessionKey: String) async throws -> OpenJordyChatHistoryPayload
    func sendMessage(
        sessionKey: String,
        message: String,
        thinking: String,
        idempotencyKey: String,
        attachments: [OpenJordyChatAttachmentPayload]) async throws -> OpenJordyChatSendResponse

    func abortRun(sessionKey: String, runId: String) async throws
    func listSessions(limit: Int?) async throws -> OpenJordyChatSessionsListResponse

    func requestHealth(timeoutMs: Int) async throws -> Bool
    func events() -> AsyncStream<OpenJordyChatTransportEvent>

    func setActiveSessionKey(_ sessionKey: String) async throws
}

extension OpenJordyChatTransport {
    public func setActiveSessionKey(_: String) async throws {}

    public func abortRun(sessionKey _: String, runId _: String) async throws {
        throw NSError(
            domain: "OpenJordyChatTransport",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "chat.abort not supported by this transport"])
    }

    public func listSessions(limit _: Int?) async throws -> OpenJordyChatSessionsListResponse {
        throw NSError(
            domain: "OpenJordyChatTransport",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "sessions.list not supported by this transport"])
    }
}
