import CoreLocation
import Foundation
import OpenJordyKit
import UIKit

typealias OpenJordyCameraSnapResult = (format: String, base64: String, width: Int, height: Int)
typealias OpenJordyCameraClipResult = (format: String, base64: String, durationMs: Int, hasAudio: Bool)

protocol CameraServicing: Sendable {
    func listDevices() async -> [CameraController.CameraDeviceInfo]
    func snap(params: OpenJordyCameraSnapParams) async throws -> OpenJordyCameraSnapResult
    func clip(params: OpenJordyCameraClipParams) async throws -> OpenJordyCameraClipResult
}

protocol ScreenRecordingServicing: Sendable {
    func record(
        screenIndex: Int?,
        durationMs: Int?,
        fps: Double?,
        includeAudio: Bool?,
        outPath: String?) async throws -> String
}

@MainActor
protocol LocationServicing: Sendable {
    func authorizationStatus() -> CLAuthorizationStatus
    func accuracyAuthorization() -> CLAccuracyAuthorization
    func ensureAuthorization(mode: OpenJordyLocationMode) async -> CLAuthorizationStatus
    func currentLocation(
        params: OpenJordyLocationGetParams,
        desiredAccuracy: OpenJordyLocationAccuracy,
        maxAgeMs: Int?,
        timeoutMs: Int?) async throws -> CLLocation
    func startLocationUpdates(
        desiredAccuracy: OpenJordyLocationAccuracy,
        significantChangesOnly: Bool) -> AsyncStream<CLLocation>
    func stopLocationUpdates()
    func startMonitoringSignificantLocationChanges(onUpdate: @escaping @Sendable (CLLocation) -> Void)
    func stopMonitoringSignificantLocationChanges()
}

@MainActor
protocol DeviceStatusServicing: Sendable {
    func status() async throws -> OpenJordyDeviceStatusPayload
    func info() -> OpenJordyDeviceInfoPayload
}

protocol PhotosServicing: Sendable {
    func latest(params: OpenJordyPhotosLatestParams) async throws -> OpenJordyPhotosLatestPayload
}

protocol ContactsServicing: Sendable {
    func search(params: OpenJordyContactsSearchParams) async throws -> OpenJordyContactsSearchPayload
    func add(params: OpenJordyContactsAddParams) async throws -> OpenJordyContactsAddPayload
}

protocol CalendarServicing: Sendable {
    func events(params: OpenJordyCalendarEventsParams) async throws -> OpenJordyCalendarEventsPayload
    func add(params: OpenJordyCalendarAddParams) async throws -> OpenJordyCalendarAddPayload
}

protocol RemindersServicing: Sendable {
    func list(params: OpenJordyRemindersListParams) async throws -> OpenJordyRemindersListPayload
    func add(params: OpenJordyRemindersAddParams) async throws -> OpenJordyRemindersAddPayload
}

protocol MotionServicing: Sendable {
    func activities(params: OpenJordyMotionActivityParams) async throws -> OpenJordyMotionActivityPayload
    func pedometer(params: OpenJordyPedometerParams) async throws -> OpenJordyPedometerPayload
}

struct WatchMessagingStatus: Sendable, Equatable {
    var supported: Bool
    var paired: Bool
    var appInstalled: Bool
    var reachable: Bool
    var activationState: String
}

struct WatchQuickReplyEvent: Sendable, Equatable {
    var replyId: String
    var promptId: String
    var actionId: String
    var actionLabel: String?
    var sessionKey: String?
    var note: String?
    var sentAtMs: Int?
    var transport: String
}

struct WatchNotificationSendResult: Sendable, Equatable {
    var deliveredImmediately: Bool
    var queuedForDelivery: Bool
    var transport: String
}

protocol WatchMessagingServicing: AnyObject, Sendable {
    func status() async -> WatchMessagingStatus
    func setReplyHandler(_ handler: (@Sendable (WatchQuickReplyEvent) -> Void)?)
    func sendNotification(
        id: String,
        params: OpenJordyWatchNotifyParams) async throws -> WatchNotificationSendResult
}

extension CameraController: CameraServicing {}
extension ScreenRecordService: ScreenRecordingServicing {}
extension LocationService: LocationServicing {}
