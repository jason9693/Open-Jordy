import Foundation

public enum OpenJordyDeviceCommand: String, Codable, Sendable {
    case status = "device.status"
    case info = "device.info"
}

public enum OpenJordyBatteryState: String, Codable, Sendable {
    case unknown
    case unplugged
    case charging
    case full
}

public enum OpenJordyThermalState: String, Codable, Sendable {
    case nominal
    case fair
    case serious
    case critical
}

public enum OpenJordyNetworkPathStatus: String, Codable, Sendable {
    case satisfied
    case unsatisfied
    case requiresConnection
}

public enum OpenJordyNetworkInterfaceType: String, Codable, Sendable {
    case wifi
    case cellular
    case wired
    case other
}

public struct OpenJordyBatteryStatusPayload: Codable, Sendable, Equatable {
    public var level: Double?
    public var state: OpenJordyBatteryState
    public var lowPowerModeEnabled: Bool

    public init(level: Double?, state: OpenJordyBatteryState, lowPowerModeEnabled: Bool) {
        self.level = level
        self.state = state
        self.lowPowerModeEnabled = lowPowerModeEnabled
    }
}

public struct OpenJordyThermalStatusPayload: Codable, Sendable, Equatable {
    public var state: OpenJordyThermalState

    public init(state: OpenJordyThermalState) {
        self.state = state
    }
}

public struct OpenJordyStorageStatusPayload: Codable, Sendable, Equatable {
    public var totalBytes: Int64
    public var freeBytes: Int64
    public var usedBytes: Int64

    public init(totalBytes: Int64, freeBytes: Int64, usedBytes: Int64) {
        self.totalBytes = totalBytes
        self.freeBytes = freeBytes
        self.usedBytes = usedBytes
    }
}

public struct OpenJordyNetworkStatusPayload: Codable, Sendable, Equatable {
    public var status: OpenJordyNetworkPathStatus
    public var isExpensive: Bool
    public var isConstrained: Bool
    public var interfaces: [OpenJordyNetworkInterfaceType]

    public init(
        status: OpenJordyNetworkPathStatus,
        isExpensive: Bool,
        isConstrained: Bool,
        interfaces: [OpenJordyNetworkInterfaceType])
    {
        self.status = status
        self.isExpensive = isExpensive
        self.isConstrained = isConstrained
        self.interfaces = interfaces
    }
}

public struct OpenJordyDeviceStatusPayload: Codable, Sendable, Equatable {
    public var battery: OpenJordyBatteryStatusPayload
    public var thermal: OpenJordyThermalStatusPayload
    public var storage: OpenJordyStorageStatusPayload
    public var network: OpenJordyNetworkStatusPayload
    public var uptimeSeconds: Double

    public init(
        battery: OpenJordyBatteryStatusPayload,
        thermal: OpenJordyThermalStatusPayload,
        storage: OpenJordyStorageStatusPayload,
        network: OpenJordyNetworkStatusPayload,
        uptimeSeconds: Double)
    {
        self.battery = battery
        self.thermal = thermal
        self.storage = storage
        self.network = network
        self.uptimeSeconds = uptimeSeconds
    }
}

public struct OpenJordyDeviceInfoPayload: Codable, Sendable, Equatable {
    public var deviceName: String
    public var modelIdentifier: String
    public var systemName: String
    public var systemVersion: String
    public var appVersion: String
    public var appBuild: String
    public var locale: String

    public init(
        deviceName: String,
        modelIdentifier: String,
        systemName: String,
        systemVersion: String,
        appVersion: String,
        appBuild: String,
        locale: String)
    {
        self.deviceName = deviceName
        self.modelIdentifier = modelIdentifier
        self.systemName = systemName
        self.systemVersion = systemVersion
        self.appVersion = appVersion
        self.appBuild = appBuild
        self.locale = locale
    }
}
