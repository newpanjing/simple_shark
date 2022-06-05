import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController.init()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    if #available(macOS 10.13, *) {
      let customToolbar = NSToolbar()
      customToolbar.showsBaselineSeparator = false
      self.toolbar = customToolbar
    }
    self.titleVisibility = .hidden
    self.titlebarAppearsTransparent = true
    if #available(macOS 11.0, *) {
      // Use .expanded if the app will have a title bar, else use .unified
      self.toolbarStyle = .unified
    }

    self.isMovableByWindowBackground = true
    self.styleMask.insert(NSWindow.StyleMask.fullSizeContentView)

    self.isOpaque = false
//     self.backgroundColor = .clear

    self.setContentSize(NSSize(width: 900,height: 500))
    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }

  func window(_ window: NSWindow, willUseFullScreenPresentationOptions proposedOptions: NSApplication.PresentationOptions = []) -> NSApplication.PresentationOptions {
    return [.autoHideToolbar, .autoHideMenuBar, .fullScreen]
  }

  func windowWillEnterFullScreen(_ notification: Notification) {
      self.toolbar?.isVisible = false
  }

  func windowDidExitFullScreen(_ notification: Notification) {
      self.toolbar?.isVisible = true
  }
}
