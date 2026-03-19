package ai.openjordy.android.node

import ai.openjordy.android.protocol.OpenJordyCalendarCommand
import ai.openjordy.android.protocol.OpenJordyCanvasA2UICommand
import ai.openjordy.android.protocol.OpenJordyCanvasCommand
import ai.openjordy.android.protocol.OpenJordyCameraCommand
import ai.openjordy.android.protocol.OpenJordyCapability
import ai.openjordy.android.protocol.OpenJordyContactsCommand
import ai.openjordy.android.protocol.OpenJordyDeviceCommand
import ai.openjordy.android.protocol.OpenJordyLocationCommand
import ai.openjordy.android.protocol.OpenJordyMotionCommand
import ai.openjordy.android.protocol.OpenJordyNotificationsCommand
import ai.openjordy.android.protocol.OpenJordyPhotosCommand
import ai.openjordy.android.protocol.OpenJordyScreenCommand
import ai.openjordy.android.protocol.OpenJordySmsCommand
import ai.openjordy.android.protocol.OpenJordySystemCommand

data class NodeRuntimeFlags(
  val cameraEnabled: Boolean,
  val locationEnabled: Boolean,
  val smsAvailable: Boolean,
  val voiceWakeEnabled: Boolean,
  val motionActivityAvailable: Boolean,
  val motionPedometerAvailable: Boolean,
  val debugBuild: Boolean,
)

enum class InvokeCommandAvailability {
  Always,
  CameraEnabled,
  LocationEnabled,
  SmsAvailable,
  MotionActivityAvailable,
  MotionPedometerAvailable,
  DebugBuild,
}

enum class NodeCapabilityAvailability {
  Always,
  CameraEnabled,
  LocationEnabled,
  SmsAvailable,
  VoiceWakeEnabled,
  MotionAvailable,
}

data class NodeCapabilitySpec(
  val name: String,
  val availability: NodeCapabilityAvailability = NodeCapabilityAvailability.Always,
)

data class InvokeCommandSpec(
  val name: String,
  val requiresForeground: Boolean = false,
  val availability: InvokeCommandAvailability = InvokeCommandAvailability.Always,
)

object InvokeCommandRegistry {
  val capabilityManifest: List<NodeCapabilitySpec> =
    listOf(
      NodeCapabilitySpec(name = OpenJordyCapability.Canvas.rawValue),
      NodeCapabilitySpec(name = OpenJordyCapability.Screen.rawValue),
      NodeCapabilitySpec(name = OpenJordyCapability.Device.rawValue),
      NodeCapabilitySpec(name = OpenJordyCapability.Notifications.rawValue),
      NodeCapabilitySpec(name = OpenJordyCapability.System.rawValue),
      NodeCapabilitySpec(name = OpenJordyCapability.AppUpdate.rawValue),
      NodeCapabilitySpec(
        name = OpenJordyCapability.Camera.rawValue,
        availability = NodeCapabilityAvailability.CameraEnabled,
      ),
      NodeCapabilitySpec(
        name = OpenJordyCapability.Sms.rawValue,
        availability = NodeCapabilityAvailability.SmsAvailable,
      ),
      NodeCapabilitySpec(
        name = OpenJordyCapability.VoiceWake.rawValue,
        availability = NodeCapabilityAvailability.VoiceWakeEnabled,
      ),
      NodeCapabilitySpec(
        name = OpenJordyCapability.Location.rawValue,
        availability = NodeCapabilityAvailability.LocationEnabled,
      ),
      NodeCapabilitySpec(name = OpenJordyCapability.Photos.rawValue),
      NodeCapabilitySpec(name = OpenJordyCapability.Contacts.rawValue),
      NodeCapabilitySpec(name = OpenJordyCapability.Calendar.rawValue),
      NodeCapabilitySpec(
        name = OpenJordyCapability.Motion.rawValue,
        availability = NodeCapabilityAvailability.MotionAvailable,
      ),
    )

  val all: List<InvokeCommandSpec> =
    listOf(
      InvokeCommandSpec(
        name = OpenJordyCanvasCommand.Present.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = OpenJordyCanvasCommand.Hide.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = OpenJordyCanvasCommand.Navigate.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = OpenJordyCanvasCommand.Eval.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = OpenJordyCanvasCommand.Snapshot.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = OpenJordyCanvasA2UICommand.Push.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = OpenJordyCanvasA2UICommand.PushJSONL.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = OpenJordyCanvasA2UICommand.Reset.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = OpenJordyScreenCommand.Record.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = OpenJordySystemCommand.Notify.rawValue,
      ),
      InvokeCommandSpec(
        name = OpenJordyCameraCommand.List.rawValue,
        requiresForeground = true,
        availability = InvokeCommandAvailability.CameraEnabled,
      ),
      InvokeCommandSpec(
        name = OpenJordyCameraCommand.Snap.rawValue,
        requiresForeground = true,
        availability = InvokeCommandAvailability.CameraEnabled,
      ),
      InvokeCommandSpec(
        name = OpenJordyCameraCommand.Clip.rawValue,
        requiresForeground = true,
        availability = InvokeCommandAvailability.CameraEnabled,
      ),
      InvokeCommandSpec(
        name = OpenJordyLocationCommand.Get.rawValue,
        availability = InvokeCommandAvailability.LocationEnabled,
      ),
      InvokeCommandSpec(
        name = OpenJordyDeviceCommand.Status.rawValue,
      ),
      InvokeCommandSpec(
        name = OpenJordyDeviceCommand.Info.rawValue,
      ),
      InvokeCommandSpec(
        name = OpenJordyDeviceCommand.Permissions.rawValue,
      ),
      InvokeCommandSpec(
        name = OpenJordyDeviceCommand.Health.rawValue,
      ),
      InvokeCommandSpec(
        name = OpenJordyNotificationsCommand.List.rawValue,
      ),
      InvokeCommandSpec(
        name = OpenJordyNotificationsCommand.Actions.rawValue,
      ),
      InvokeCommandSpec(
        name = OpenJordyPhotosCommand.Latest.rawValue,
      ),
      InvokeCommandSpec(
        name = OpenJordyContactsCommand.Search.rawValue,
      ),
      InvokeCommandSpec(
        name = OpenJordyContactsCommand.Add.rawValue,
      ),
      InvokeCommandSpec(
        name = OpenJordyCalendarCommand.Events.rawValue,
      ),
      InvokeCommandSpec(
        name = OpenJordyCalendarCommand.Add.rawValue,
      ),
      InvokeCommandSpec(
        name = OpenJordyMotionCommand.Activity.rawValue,
        availability = InvokeCommandAvailability.MotionActivityAvailable,
      ),
      InvokeCommandSpec(
        name = OpenJordyMotionCommand.Pedometer.rawValue,
        availability = InvokeCommandAvailability.MotionPedometerAvailable,
      ),
      InvokeCommandSpec(
        name = OpenJordySmsCommand.Send.rawValue,
        availability = InvokeCommandAvailability.SmsAvailable,
      ),
      InvokeCommandSpec(
        name = "debug.logs",
        availability = InvokeCommandAvailability.DebugBuild,
      ),
      InvokeCommandSpec(
        name = "debug.ed25519",
        availability = InvokeCommandAvailability.DebugBuild,
      ),
      InvokeCommandSpec(name = "app.update"),
    )

  private val byNameInternal: Map<String, InvokeCommandSpec> = all.associateBy { it.name }

  fun find(command: String): InvokeCommandSpec? = byNameInternal[command]

  fun advertisedCapabilities(flags: NodeRuntimeFlags): List<String> {
    return capabilityManifest
      .filter { spec ->
        when (spec.availability) {
          NodeCapabilityAvailability.Always -> true
          NodeCapabilityAvailability.CameraEnabled -> flags.cameraEnabled
          NodeCapabilityAvailability.LocationEnabled -> flags.locationEnabled
          NodeCapabilityAvailability.SmsAvailable -> flags.smsAvailable
          NodeCapabilityAvailability.VoiceWakeEnabled -> flags.voiceWakeEnabled
          NodeCapabilityAvailability.MotionAvailable -> flags.motionActivityAvailable || flags.motionPedometerAvailable
        }
      }
      .map { it.name }
  }

  fun advertisedCommands(flags: NodeRuntimeFlags): List<String> {
    return all
      .filter { spec ->
        when (spec.availability) {
          InvokeCommandAvailability.Always -> true
          InvokeCommandAvailability.CameraEnabled -> flags.cameraEnabled
          InvokeCommandAvailability.LocationEnabled -> flags.locationEnabled
          InvokeCommandAvailability.SmsAvailable -> flags.smsAvailable
          InvokeCommandAvailability.MotionActivityAvailable -> flags.motionActivityAvailable
          InvokeCommandAvailability.MotionPedometerAvailable -> flags.motionPedometerAvailable
          InvokeCommandAvailability.DebugBuild -> flags.debugBuild
        }
      }
      .map { it.name }
  }
}
