import Foundation

public enum OpenJordyCameraCommand: String, Codable, Sendable {
    case list = "camera.list"
    case snap = "camera.snap"
    case clip = "camera.clip"
}

public enum OpenJordyCameraFacing: String, Codable, Sendable {
    case back
    case front
}

public enum OpenJordyCameraImageFormat: String, Codable, Sendable {
    case jpg
    case jpeg
}

public enum OpenJordyCameraVideoFormat: String, Codable, Sendable {
    case mp4
}

public struct OpenJordyCameraSnapParams: Codable, Sendable, Equatable {
    public var facing: OpenJordyCameraFacing?
    public var maxWidth: Int?
    public var quality: Double?
    public var format: OpenJordyCameraImageFormat?
    public var deviceId: String?
    public var delayMs: Int?

    public init(
        facing: OpenJordyCameraFacing? = nil,
        maxWidth: Int? = nil,
        quality: Double? = nil,
        format: OpenJordyCameraImageFormat? = nil,
        deviceId: String? = nil,
        delayMs: Int? = nil)
    {
        self.facing = facing
        self.maxWidth = maxWidth
        self.quality = quality
        self.format = format
        self.deviceId = deviceId
        self.delayMs = delayMs
    }
}

public struct OpenJordyCameraClipParams: Codable, Sendable, Equatable {
    public var facing: OpenJordyCameraFacing?
    public var durationMs: Int?
    public var includeAudio: Bool?
    public var format: OpenJordyCameraVideoFormat?
    public var deviceId: String?

    public init(
        facing: OpenJordyCameraFacing? = nil,
        durationMs: Int? = nil,
        includeAudio: Bool? = nil,
        format: OpenJordyCameraVideoFormat? = nil,
        deviceId: String? = nil)
    {
        self.facing = facing
        self.durationMs = durationMs
        self.includeAudio = includeAudio
        self.format = format
        self.deviceId = deviceId
    }
}
