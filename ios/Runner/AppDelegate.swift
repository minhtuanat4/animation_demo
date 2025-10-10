import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let textField = UITextField()
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
//      let controllerKeyBoard = CustomKeyboardController()
      CustomKeyboardPlugin.register(with: self.registrar(forPlugin: "CustomKeyboardPlugin")!)
//
//      let controller = window?.rootViewController as! FlutterViewController
//      let channel = FlutterMethodChannel(
//                        name: "custom_keyboard_channel",
//                        binaryMessenger: controller.binaryMessenger
//                    )
//
//
//      channel.setMethodCallHandler { [weak controller] call, result in
//          if call.method == "show" {
//              controllerKeyBoard.showKeyboard()
//              result(nil)
//          } else if call.method == "hide" {
//              controllerKeyBoard.hideKeyboard()
//              result(nil)
//          }
//      }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func initializeHideKeyboard(){
        //Declare a Tap Gesture Recognizer which will trigger our dismissMyKeyboard() function 
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        
        //Add this tap gesture recognizer to the parent view
        window.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        //endEditing causes the view (or one of its embedded text fields) to resign the first responder status.
        //In short- Dismiss the active keyboard.
        window.endEditing(true)
    }
}


//class CustomKeyboardInputView: UIView {
//    var onKeyTap: ((String) -> Void)?
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor = .systemGray5
//        
//        let button = UIButton(type: .system)
//        button.setTitle("😀", for: .normal)
//        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
//        button.frame = CGRect(x: 20, y: 20, width: 60, height: 40)
//        addSubview(button)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    @objc private func handleTap() {
//        onKeyTap?("😀")
//    }
//}

//class CustomKeyboardController: NSObject {
//    private let textField = UITextField()
//    private let customInput = CustomKeyboardInputView()
//
//    override init() {
//        super.init()
//        textField.isHidden = true
//        
//        // attach custom inputView
//        customInput.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 250)
//        textField.inputView = customInput
//        
//        // add hidden textField to window
//        UIApplication.shared.windows.first?.addSubview(textField)
//
//        // handle custom key taps
//        customInput.onKeyTap = { [weak self] value in
//            self?.textField.insertText(value)  // inject directly into iOS text input system
//        }
//    }
//
//    func showKeyboard() {
//        textField.becomeFirstResponder()
//    }
//
//    func hideKeyboard() {
//        textField.resignFirstResponder()
//    }
//}
//class CustomKeyboardFactory: NSObject, FlutterPlatformViewFactory {
//    func create(
//        withFrame frame: CGRect,
//        viewIdentifier viewId: Int64,
//        arguments args: Any?
//    ) -> FlutterPlatformView {
//        return CustomKeyboardView(frame: frame, viewId: viewId, args: args)
//    }
//}
//
//class CustomKeyboardView: NSObject, FlutterPlatformView {
//    let customInput: CustomKeyboardInputView
//    
//    init(frame: CGRect, viewId: Int64, args: Any?) {
//        self.customInput = CustomKeyboardInputView(frame: frame)
//        super.init()
//    }
//    
//    func view() -> UIView {
//        return customInput
//    }
//}
