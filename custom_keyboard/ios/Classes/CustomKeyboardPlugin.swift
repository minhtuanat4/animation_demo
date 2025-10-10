import Flutter
import UIKit

public class CustomKeyboardPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "custom_keyboard", binaryMessenger: registrar.messenger())
    let instance = CustomKeyboardPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
    public func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        // Replace the default keyboard globally
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onTextInputAttached),
            name: NSNotification.Name("io.flutter.plugin.textinput.TextInputPlugin.TextInputAttached"),
            object: nil
        )
        return true
    }
    

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
   @objc private func onTextInputAttached(notification: Notification) {
        guard let textField = notification.object as? UITextInput else { return }
        
        if let view = textField as? UIView {
            let customKeyboard = CustomKeyboardInputView(
                frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 250)
            )
            if let tf = view as? UITextField {
                tf.inputView = customKeyboard
            } else if let tv = view as? UITextView {
                tv.inputView = customKeyboard
            }
        }
    }
}
class CustomKeyboardInputView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray6
        
        let button = UIButton(type: .system)
        button.setTitle("😀", for: .normal)
        button.frame = CGRect(x: 20, y: 20, width: 60, height: 40)
        button.addTarget(self, action: #selector(insertText), for: .touchUpInside)
        addSubview(button)
        
        let delete = UIButton(type: .system)
        delete.setTitle("⌫", for: .normal)
        delete.frame = CGRect(x: 100, y: 20, width: 60, height: 40)
        delete.addTarget(self, action: #selector(deleteBackward), for: .touchUpInside)
        addSubview(delete)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }
    
    @objc private func insertText() {
        UIApplication.shared.sendAction(#selector(UIKeyInput.insertText(_:)), to: nil, from: "😀", for: nil)
    }
    
    @objc private func deleteBackward() {
        UIApplication.shared.sendAction(#selector(UIKeyInput.deleteBackward), to: nil, from: nil, for: nil)
    }
}