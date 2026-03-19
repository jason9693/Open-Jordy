import Foundation

// Stable identifier used for both the macOS LaunchAgent label and Nix-managed defaults suite.
// nix-openjordy writes app defaults into this suite to survive app bundle identifier churn.
let launchdLabel = "ai.openjordy.mac"
let gatewayLaunchdLabel = "ai.openjordy.gateway"
let onboardingVersionKey = "openjordy.onboardingVersion"
let onboardingSeenKey = "openjordy.onboardingSeen"
let currentOnboardingVersion = 7
let pauseDefaultsKey = "openjordy.pauseEnabled"
let iconAnimationsEnabledKey = "openjordy.iconAnimationsEnabled"
let swabbleEnabledKey = "openjordy.swabbleEnabled"
let swabbleTriggersKey = "openjordy.swabbleTriggers"
let voiceWakeTriggerChimeKey = "openjordy.voiceWakeTriggerChime"
let voiceWakeSendChimeKey = "openjordy.voiceWakeSendChime"
let showDockIconKey = "openjordy.showDockIcon"
let defaultVoiceWakeTriggers = ["openjordy"]
let voiceWakeMaxWords = 32
let voiceWakeMaxWordLength = 64
let voiceWakeMicKey = "openjordy.voiceWakeMicID"
let voiceWakeMicNameKey = "openjordy.voiceWakeMicName"
let voiceWakeLocaleKey = "openjordy.voiceWakeLocaleID"
let voiceWakeAdditionalLocalesKey = "openjordy.voiceWakeAdditionalLocaleIDs"
let voicePushToTalkEnabledKey = "openjordy.voicePushToTalkEnabled"
let talkEnabledKey = "openjordy.talkEnabled"
let iconOverrideKey = "openjordy.iconOverride"
let connectionModeKey = "openjordy.connectionMode"
let remoteTargetKey = "openjordy.remoteTarget"
let remoteIdentityKey = "openjordy.remoteIdentity"
let remoteProjectRootKey = "openjordy.remoteProjectRoot"
let remoteCliPathKey = "openjordy.remoteCliPath"
let canvasEnabledKey = "openjordy.canvasEnabled"
let cameraEnabledKey = "openjordy.cameraEnabled"
let systemRunPolicyKey = "openjordy.systemRunPolicy"
let systemRunAllowlistKey = "openjordy.systemRunAllowlist"
let systemRunEnabledKey = "openjordy.systemRunEnabled"
let locationModeKey = "openjordy.locationMode"
let locationPreciseKey = "openjordy.locationPreciseEnabled"
let peekabooBridgeEnabledKey = "openjordy.peekabooBridgeEnabled"
let deepLinkKeyKey = "openjordy.deepLinkKey"
let modelCatalogPathKey = "openjordy.modelCatalogPath"
let modelCatalogReloadKey = "openjordy.modelCatalogReload"
let cliInstallPromptedVersionKey = "openjordy.cliInstallPromptedVersion"
let heartbeatsEnabledKey = "openjordy.heartbeatsEnabled"
let debugPaneEnabledKey = "openjordy.debugPaneEnabled"
let debugFileLogEnabledKey = "openjordy.debug.fileLogEnabled"
let appLogLevelKey = "openjordy.debug.appLogLevel"
let voiceWakeSupported: Bool = ProcessInfo.processInfo.operatingSystemVersion.majorVersion >= 26
