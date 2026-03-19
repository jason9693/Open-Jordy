package ai.openjordy.android.node

import ai.openjordy.android.protocol.OpenJordyCalendarCommand
import ai.openjordy.android.protocol.OpenJordyCameraCommand
import ai.openjordy.android.protocol.OpenJordyCapability
import ai.openjordy.android.protocol.OpenJordyContactsCommand
import ai.openjordy.android.protocol.OpenJordyDeviceCommand
import ai.openjordy.android.protocol.OpenJordyLocationCommand
import ai.openjordy.android.protocol.OpenJordyMotionCommand
import ai.openjordy.android.protocol.OpenJordyNotificationsCommand
import ai.openjordy.android.protocol.OpenJordyPhotosCommand
import ai.openjordy.android.protocol.OpenJordySmsCommand
import ai.openjordy.android.protocol.OpenJordySystemCommand
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class InvokeCommandRegistryTest {
  private val coreCapabilities =
    setOf(
      OpenJordyCapability.Canvas.rawValue,
      OpenJordyCapability.Screen.rawValue,
      OpenJordyCapability.Device.rawValue,
      OpenJordyCapability.Notifications.rawValue,
      OpenJordyCapability.System.rawValue,
      OpenJordyCapability.AppUpdate.rawValue,
      OpenJordyCapability.Photos.rawValue,
      OpenJordyCapability.Contacts.rawValue,
      OpenJordyCapability.Calendar.rawValue,
    )

  private val optionalCapabilities =
    setOf(
      OpenJordyCapability.Camera.rawValue,
      OpenJordyCapability.Location.rawValue,
      OpenJordyCapability.Sms.rawValue,
      OpenJordyCapability.VoiceWake.rawValue,
      OpenJordyCapability.Motion.rawValue,
    )

  private val coreCommands =
    setOf(
      OpenJordyDeviceCommand.Status.rawValue,
      OpenJordyDeviceCommand.Info.rawValue,
      OpenJordyDeviceCommand.Permissions.rawValue,
      OpenJordyDeviceCommand.Health.rawValue,
      OpenJordyNotificationsCommand.List.rawValue,
      OpenJordyNotificationsCommand.Actions.rawValue,
      OpenJordySystemCommand.Notify.rawValue,
      OpenJordyPhotosCommand.Latest.rawValue,
      OpenJordyContactsCommand.Search.rawValue,
      OpenJordyContactsCommand.Add.rawValue,
      OpenJordyCalendarCommand.Events.rawValue,
      OpenJordyCalendarCommand.Add.rawValue,
      "app.update",
    )

  private val optionalCommands =
    setOf(
      OpenJordyCameraCommand.Snap.rawValue,
      OpenJordyCameraCommand.Clip.rawValue,
      OpenJordyCameraCommand.List.rawValue,
      OpenJordyLocationCommand.Get.rawValue,
      OpenJordyMotionCommand.Activity.rawValue,
      OpenJordyMotionCommand.Pedometer.rawValue,
      OpenJordySmsCommand.Send.rawValue,
    )

  private val debugCommands = setOf("debug.logs", "debug.ed25519")

  @Test
  fun advertisedCapabilities_respectsFeatureAvailability() {
    val capabilities = InvokeCommandRegistry.advertisedCapabilities(defaultFlags())

    assertContainsAll(capabilities, coreCapabilities)
    assertMissingAll(capabilities, optionalCapabilities)
  }

  @Test
  fun advertisedCapabilities_includesFeatureCapabilitiesWhenEnabled() {
    val capabilities =
      InvokeCommandRegistry.advertisedCapabilities(
        defaultFlags(
          cameraEnabled = true,
          locationEnabled = true,
          smsAvailable = true,
          voiceWakeEnabled = true,
          motionActivityAvailable = true,
          motionPedometerAvailable = true,
        ),
      )

    assertContainsAll(capabilities, coreCapabilities + optionalCapabilities)
  }

  @Test
  fun advertisedCommands_respectsFeatureAvailability() {
    val commands = InvokeCommandRegistry.advertisedCommands(defaultFlags())

    assertContainsAll(commands, coreCommands)
    assertMissingAll(commands, optionalCommands + debugCommands)
  }

  @Test
  fun advertisedCommands_includesFeatureCommandsWhenEnabled() {
    val commands =
      InvokeCommandRegistry.advertisedCommands(
        defaultFlags(
          cameraEnabled = true,
          locationEnabled = true,
          smsAvailable = true,
          motionActivityAvailable = true,
          motionPedometerAvailable = true,
          debugBuild = true,
        ),
      )

    assertContainsAll(commands, coreCommands + optionalCommands + debugCommands)
  }

  @Test
  fun advertisedCommands_onlyIncludesSupportedMotionCommands() {
    val commands =
      InvokeCommandRegistry.advertisedCommands(
        NodeRuntimeFlags(
          cameraEnabled = false,
          locationEnabled = false,
          smsAvailable = false,
          voiceWakeEnabled = false,
          motionActivityAvailable = true,
          motionPedometerAvailable = false,
          debugBuild = false,
        ),
      )

    assertTrue(commands.contains(OpenJordyMotionCommand.Activity.rawValue))
    assertFalse(commands.contains(OpenJordyMotionCommand.Pedometer.rawValue))
  }

  private fun defaultFlags(
    cameraEnabled: Boolean = false,
    locationEnabled: Boolean = false,
    smsAvailable: Boolean = false,
    voiceWakeEnabled: Boolean = false,
    motionActivityAvailable: Boolean = false,
    motionPedometerAvailable: Boolean = false,
    debugBuild: Boolean = false,
  ): NodeRuntimeFlags =
    NodeRuntimeFlags(
      cameraEnabled = cameraEnabled,
      locationEnabled = locationEnabled,
      smsAvailable = smsAvailable,
      voiceWakeEnabled = voiceWakeEnabled,
      motionActivityAvailable = motionActivityAvailable,
      motionPedometerAvailable = motionPedometerAvailable,
      debugBuild = debugBuild,
    )

  private fun assertContainsAll(actual: List<String>, expected: Set<String>) {
    expected.forEach { value -> assertTrue(actual.contains(value)) }
  }

  private fun assertMissingAll(actual: List<String>, forbidden: Set<String>) {
    forbidden.forEach { value -> assertFalse(actual.contains(value)) }
  }
}
