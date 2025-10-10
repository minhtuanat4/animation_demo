import Flutter
import UIKit

public class CustomKeyboardPlugin: NSObject, FlutterPlugin {
    var keyboardView: CustomKeyboardView?
    public static func register(with registrar: FlutterPluginRegistrar) {
        let factory = CustomKeyboardFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "CustomKeyboard")
        
    }
   
}
class CustomKeyboardFactory: NSObject, FlutterPlatformViewFactory {
    private let messenger: FlutterBinaryMessenger
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }
    
    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return CustomKeyboardView(frame: frame, viewId: viewId, messenger: messenger, args: args)
    }
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
            return FlutterStandardMessageCodec.sharedInstance()
        }
}

class CustomKeyboardView: NSObject, FlutterPlatformView, UITextFieldDelegate {
    private let textField: UITextField
    
    let textView = UITextView()
    
    private var channel: FlutterMethodChannel
    
    private let container: UIView
    
    let padding = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    
    private var isFocus: Bool = false
    
    var readOnly : Bool = false
    
    var colorBorder : String = ""
    var colorFocusedBorder : String = ""
    var colorErrorBorder : String = ""
    
    var borderSideBorder: CGFloat = 0
    var borderSideFocusedBorder: CGFloat = 0
    var borderSideErrorBorder: CGFloat = 0

    var cornerRadiusBorder: CGFloat = 0
    var cornerRadiusFocusedBorder: CGFloat = 0
    var cornerRadiusErrorBorder: CGFloat = 0
    
    var backgroundColor : String = ""
    
    var maxLength = 100

    var isFormatMoney = false
    
    @objc func dismissMyKeyboard() {
        view().endEditing(true) // hide the keyboard
    }
    
    func uiToolBar() -> UIToolbar {
        let bar = UIToolbar()
        //Create a done button with an action to trigger our function to dismiss the keyboard
        let doneBtn = UIBarButtonItem(title: "Hoàn tất", style: .plain, target: self, action: #selector(dismissMyKeyboard))
        //Create a felxible space item so that we can add it around in toolbar to position our done button
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        bar.items = [flexSpace, flexSpace, doneBtn]
        bar.sizeToFit()
        return bar
    }
    let formatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal  // adds grouping separators (e.g. 1,234)
        nf.maximumFractionDigits = 0
        return nf
    }()
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        // Build the new string
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
     

        guard (currentText.count) < maxLength else {
            if (string.isEmpty) {
                textField.text?.removeLast()
                channel.invokeMethod("onChanged", arguments: textField.text)
            }
            return false
        }
        guard  isFormatMoney else {
            textField.text = updatedText
            channel.invokeMethod("onChanged", arguments: textField.text)
            return false
        }
        // Remove separators before parsing
        let digits = updatedText.replacingOccurrences(of: formatter.groupingSeparator, with: "")

        // Only numbers
        guard let number = Int(digits) else {
            textField.text = ""
            return false
        }

        // Apply formatting
        textField.text = formatter.string(from: NSNumber(value: number))
        channel.invokeMethod("onChanged", arguments: textField.text)
        return false // prevent default behavior, since we set text manually
    }
    init(frame: CGRect, viewId: Int64, messenger: FlutterBinaryMessenger, args: Any?) {
     
        container = UIView(frame: frame)
        textField = UITextField()
        textField.borderStyle = .roundedRect
        
        let cornerRadiusBorderDefault : CGFloat = 8;
        print("cornerRadiusBorderDefault \(cornerRadiusBorderDefault)")
        channel = FlutterMethodChannel(name: "custom_keyboard_\(viewId)", binaryMessenger: messenger)
        
        super.init()
        
        print("args\(String(describing: args))")
        if let dict = args as? [String: Any]{
            
            if let readOnlyTemp = dict["readOnly"] as? Bool {
                readOnly = readOnlyTemp
            }
            if let maxLengthTemp = dict["maxLength"] as? Int {
                maxLength = maxLengthTemp
            }
            if let isFormatMoneyTemp = dict["isFormatMoney"] as? Bool {
                isFormatMoney = isFormatMoneyTemp
            }
            if let backgroundColorTemp = dict["backgroundColor"] as? String {
                backgroundColor = backgroundColorTemp
            }

            if let decoration = dict["decoration"] as? [String: Any] {
                if let border = decoration["border"] as? [String: Any] {
                    if let borderSide = border["borderSide"] as? [String: Any] {
                        colorBorder = borderSide["color"] as? String ?? ""
                        borderSideBorder = borderSide["width"] as? CGFloat ?? 1
                    }
                    let radius = border["borderRadius"] as? CGFloat ?? cornerRadiusBorderDefault
                    cornerRadiusBorder = radius
                }
                if let focusedBorder = decoration["focusedBorder"] as? [String: Any] {
                    if let borderSide = focusedBorder["borderSide"] as? [String: Any] {
                        colorFocusedBorder = borderSide["color"] as? String ?? ""
                        borderSideFocusedBorder = borderSide["width"] as? CGFloat ?? 1
                    }
                    let radius = focusedBorder["borderRadius"] as? CGFloat ?? cornerRadiusBorderDefault
                    cornerRadiusFocusedBorder = radius
                }
                
                if let errorBorder = decoration["errorBorder"] as? [String: Any] {
                    if let borderSide = errorBorder["borderSide"] as? [String: Any] {
                        colorErrorBorder = borderSide["color"] as? String ?? ""
                        borderSideErrorBorder = borderSide["width"] as? CGFloat ?? 1
                    }
                    let radius = errorBorder["borderRadius"] as? CGFloat ?? cornerRadiusBorderDefault
                    cornerRadiusErrorBorder = radius
                }
            }
        }
           
        self.container.layer.cornerRadius = cornerRadiusBorder
        self.container.layer.borderWidth = borderSideBorder
        self.container.layer.borderColor = CGColor.fromHex(colorBorder)
        self.container.translatesAutoresizingMaskIntoConstraints = true
        self.textField.inputAccessoryView = uiToolBar()
        self.textField.isUserInteractionEnabled = true
        self.textField.isEnabled = !readOnly
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.textField.borderStyle = .none
        self.textField.backgroundColor = .clear
        self.textField.keyboardType = .numberPad
        self.textField.returnKeyType = .done
        self.textField.bounds.inset(by: padding)
      
           // Placeholder styling
           self.textField.attributedPlaceholder = NSAttributedString(
               string: "Enter text...",
               attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
           )
        container.addSubview(textField)
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: view().leadingAnchor ),
            container.trailingAnchor.constraint(equalTo: view().trailingAnchor),
            container.topAnchor.constraint(equalTo: view().topAnchor),
            container.bottomAnchor.constraint(equalTo: view().bottomAnchor)
               ])
        NSLayoutConstraint.activate([
                textField.leadingAnchor.constraint(equalTo: container.leadingAnchor,  constant: 12),
                textField.trailingAnchor.constraint(equalTo: container.trailingAnchor,  constant: 12),
                textField.topAnchor.constraint(equalTo: container.topAnchor),
                textField.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            ])
 
        textField.delegate = self
        
        channel.setMethodCallHandler({
                 [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
                 let argument = call.arguments as? [String: Any]
                 switch call.method {
                 case "removeView":
                     print("removeView")
                     self?.removeView()
                     result(nil)
                 case "readOnly":
                     print("readOnly")
                     let readOnly = argument?["readOnly"] as? Bool ?? false
                     self?.textField.isEnabled = !readOnly
                     result(nil)
                 case "text":
                     print("text")
                     guard let value = argument?["text"] as? String else {
                         result(nil)
                         return
                     }
                    self?.textField.text = value
                    result(nil)
                 case "validate":
                     print("validate")
                     guard let value = argument?["errorText"] as? String else {
                         self?.setErrorBorder()
                         result(nil)
                         return
                     }
                     self?.setFocusBorder()
                    result(nil)
                 default:
                     result(FlutterMethodNotImplemented)
                 }
             })
    }
    
    func view() -> UIView {
        return container
    }
    
    func removeView() {
        DispatchQueue.main.async {
               // Ensure textField is not active anymore
               if self.textField.isFirstResponder {
                   self.textField.resignFirstResponder()
               }

               // Detach custom inputView to break UIKit references
               self.textField.inputView = nil

               // Remove delegate to avoid late callbacks
               self.textField.delegate = nil

               // Remove from view hierarchy safely
               if self.textField.superview != nil {
                   self.textField.removeFromSuperview()
               }
               if self.container.superview != nil {
                   self.container.removeFromSuperview()
               }
           }
      }
   func setBorder() {
    self.container.layer.cornerRadius = cornerRadiusBorder
    self.container.layer.borderWidth = borderSideBorder
    self.container.layer.borderColor = CGColor.fromHex(colorBorder)
    self.container.backgroundColor = UIColor(named:backgroundColor)
   }
    func setFocusBorder() {
        self.container.layer.cornerRadius = cornerRadiusFocusedBorder
        self.container.layer.borderWidth = borderSideFocusedBorder
        self.container.layer.borderColor = CGColor.fromHex(colorFocusedBorder)
        self.container.backgroundColor = UIColor(named:backgroundColor)
    }
    func setErrorBorder() {
        self.container.layer.cornerRadius = cornerRadiusErrorBorder
        self.container.layer.borderWidth = borderSideErrorBorder
        self.container.layer.borderColor = CGColor.fromHex(colorErrorBorder)
        self.container.backgroundColor = UIColor(named:backgroundColor)
     }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isFocus = true
        setFocusBorder()
        channel.invokeMethod("onTap", arguments: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        isFocus = false
        setBorder()
        channel.invokeMethod("onDone", arguments: textField.text)
    }
    func showKeyboard() {
        textField.becomeFirstResponder()
    }

    func hideKeyboard() {
        textField.resignFirstResponder()
    }
}

extension CGColor {
    static func fromHex(_ hex: String, alpha: CGFloat = 1.0) -> CGColor {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0

        return UIColor(red: r, green: g, blue: b, alpha: alpha).cgColor
    }
}
//
//  CustomKeyboardPlugin.swift
//  Runner
//
//  Created by Minh Tuan on 30/9/25.
//

