package ai.openjordy.android.protocol

import org.junit.Assert.assertEquals
import org.junit.Test

class OpenJordyProtocolConstantsTest {
  @Test
  fun canvasCommandsUseStableStrings() {
    assertEquals("canvas.present", OpenJordyCanvasCommand.Present.rawValue)
    assertEquals("canvas.hide", OpenJordyCanvasCommand.Hide.rawValue)
    assertEquals("canvas.navigate", OpenJordyCanvasCommand.Navigate.rawValue)
    assertEquals("canvas.eval", OpenJordyCanvasCommand.Eval.rawValue)
    assertEquals("canvas.snapshot", OpenJordyCanvasCommand.Snapshot.rawValue)
  }

  @Test
  fun a2uiCommandsUseStableStrings() {
    assertEquals("canvas.a2ui.push", OpenJordyCanvasA2UICommand.Push.rawValue)
    assertEquals("canvas.a2ui.pushJSONL", OpenJordyCanvasA2UICommand.PushJSONL.rawValue)
    assertEquals("canvas.a2ui.reset", OpenJordyCanvasA2UICommand.Reset.rawValue)
  }

  @Test
  fun capabilitiesUseStableStrings() {
    assertEquals("canvas", OpenJordyCapability.Canvas.rawValue)
    assertEquals("camera", OpenJordyCapability.Camera.rawValue)
    assertEquals("screen", OpenJordyCapability.Screen.rawValue)
    assertEquals("voiceWake", OpenJordyCapability.VoiceWake.rawValue)
    assertEquals("location", OpenJordyCapability.Location.rawValue)
    assertEquals("sms", OpenJordyCapability.Sms.rawValue)
    assertEquals("device", OpenJordyCapability.Device.rawValue)
    assertEquals("notifications", OpenJordyCapability.Notifications.rawValue)
    assertEquals("system", OpenJordyCapability.System.rawValue)
    assertEquals("appUpdate", OpenJordyCapability.AppUpdate.rawValue)
    assertEquals("photos", OpenJordyCapability.Photos.rawValue)
    assertEquals("contacts", OpenJordyCapability.Contacts.rawValue)
    assertEquals("calendar", OpenJordyCapability.Calendar.rawValue)
    assertEquals("motion", OpenJordyCapability.Motion.rawValue)
  }

  @Test
  fun cameraCommandsUseStableStrings() {
    assertEquals("camera.list", OpenJordyCameraCommand.List.rawValue)
    assertEquals("camera.snap", OpenJordyCameraCommand.Snap.rawValue)
    assertEquals("camera.clip", OpenJordyCameraCommand.Clip.rawValue)
  }

  @Test
  fun screenCommandsUseStableStrings() {
    assertEquals("screen.record", OpenJordyScreenCommand.Record.rawValue)
  }

  @Test
  fun notificationsCommandsUseStableStrings() {
    assertEquals("notifications.list", OpenJordyNotificationsCommand.List.rawValue)
    assertEquals("notifications.actions", OpenJordyNotificationsCommand.Actions.rawValue)
  }

  @Test
  fun deviceCommandsUseStableStrings() {
    assertEquals("device.status", OpenJordyDeviceCommand.Status.rawValue)
    assertEquals("device.info", OpenJordyDeviceCommand.Info.rawValue)
    assertEquals("device.permissions", OpenJordyDeviceCommand.Permissions.rawValue)
    assertEquals("device.health", OpenJordyDeviceCommand.Health.rawValue)
  }

  @Test
  fun systemCommandsUseStableStrings() {
    assertEquals("system.notify", OpenJordySystemCommand.Notify.rawValue)
  }

  @Test
  fun photosCommandsUseStableStrings() {
    assertEquals("photos.latest", OpenJordyPhotosCommand.Latest.rawValue)
  }

  @Test
  fun contactsCommandsUseStableStrings() {
    assertEquals("contacts.search", OpenJordyContactsCommand.Search.rawValue)
    assertEquals("contacts.add", OpenJordyContactsCommand.Add.rawValue)
  }

  @Test
  fun calendarCommandsUseStableStrings() {
    assertEquals("calendar.events", OpenJordyCalendarCommand.Events.rawValue)
    assertEquals("calendar.add", OpenJordyCalendarCommand.Add.rawValue)
  }

  @Test
  fun motionCommandsUseStableStrings() {
    assertEquals("motion.activity", OpenJordyMotionCommand.Activity.rawValue)
    assertEquals("motion.pedometer", OpenJordyMotionCommand.Pedometer.rawValue)
  }
}
