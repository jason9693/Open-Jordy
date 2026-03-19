import Foundation

public enum OpenJordyRemindersCommand: String, Codable, Sendable {
    case list = "reminders.list"
    case add = "reminders.add"
}

public enum OpenJordyReminderStatusFilter: String, Codable, Sendable {
    case incomplete
    case completed
    case all
}

public struct OpenJordyRemindersListParams: Codable, Sendable, Equatable {
    public var status: OpenJordyReminderStatusFilter?
    public var limit: Int?

    public init(status: OpenJordyReminderStatusFilter? = nil, limit: Int? = nil) {
        self.status = status
        self.limit = limit
    }
}

public struct OpenJordyRemindersAddParams: Codable, Sendable, Equatable {
    public var title: String
    public var dueISO: String?
    public var notes: String?
    public var listId: String?
    public var listName: String?

    public init(
        title: String,
        dueISO: String? = nil,
        notes: String? = nil,
        listId: String? = nil,
        listName: String? = nil)
    {
        self.title = title
        self.dueISO = dueISO
        self.notes = notes
        self.listId = listId
        self.listName = listName
    }
}

public struct OpenJordyReminderPayload: Codable, Sendable, Equatable {
    public var identifier: String
    public var title: String
    public var dueISO: String?
    public var completed: Bool
    public var listName: String?

    public init(
        identifier: String,
        title: String,
        dueISO: String? = nil,
        completed: Bool,
        listName: String? = nil)
    {
        self.identifier = identifier
        self.title = title
        self.dueISO = dueISO
        self.completed = completed
        self.listName = listName
    }
}

public struct OpenJordyRemindersListPayload: Codable, Sendable, Equatable {
    public var reminders: [OpenJordyReminderPayload]

    public init(reminders: [OpenJordyReminderPayload]) {
        self.reminders = reminders
    }
}

public struct OpenJordyRemindersAddPayload: Codable, Sendable, Equatable {
    public var reminder: OpenJordyReminderPayload

    public init(reminder: OpenJordyReminderPayload) {
        self.reminder = reminder
    }
}
