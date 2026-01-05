import Flutter
import UIKit
class MyContainerView : UIView {
    
    
    var onActualFrame: ((CGRect) -> Void)?
    
    var didLayout = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !didLayout {
            didLayout = true
            onActualFrame?(self.frame)
           
        }
    }
}

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
    
    private var channel: FlutterMethodChannel
    
    private let container: MyContainerView
    
    private let underline: UIView
    
    let padding = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    
    private var isFocus: Bool = false
    
    var readOnly : Bool = false
    
    var initial : String = ""
    
    var textAlignment : String = "left"
    
    var colorBorder : String = ""
    var colorFocusedBorder : String = ""
    var colorErrorBorder : String = ""
    
    var borderSideBorder: CGFloat = 0
    var borderSideFocusedBorder: CGFloat = 0
    var borderSideErrorBorder: CGFloat = 0
    
    var underlineBorder: Bool = false
    var underlineFocusedBorder: Bool = false
    var underlineErrorBorder: Bool = false

    var cornerRadiusBorder: CGFloat = 0
    var cornerRadiusFocusedBorder: CGFloat = 0
    var cornerRadiusErrorBorder: CGFloat = 0
    
    var backgroundColor : String = ""
    
    var maxLength = 100
    
    var isFormatMoney : Bool = false
    
    var isError : Bool = false
    
    var hintText = ""
    var hintStyle = [String: Any] ()
    
    var contentPadding = [String: Any] ()
    
    var style = [String: Any] ()
    
    @objc func dismissMyKeyboard() {
        view().endEditing(true) // hide the keyboard
        channel.invokeMethod("onDone", arguments: textField.text)
    }
    
    func  getTextAlignment( textAlignment: String) -> NSTextAlignment {
        switch textAlignment {
        case "right":
            return .right
        case "center":
            return .center
        default:
            return .left
        }
    }
    

    init(frame: CGRect, viewId: Int64, messenger: FlutterBinaryMessenger, args: Any?)
    {
        container = MyContainerView(frame: frame)
        
        underline = UIView()
      
        textField = UITextField()
        
        textField.borderStyle = .roundedRect
        
        let cornerRadiusBorderDefault : CGFloat = 8;
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
            style = dict["style"] as? [String: Any] ?? [:]
            initial = dict["initial"] as? String ?? ""
            textAlignment = dict["textAlignment"] as? String ?? "left"
            
            if let decoration = dict["decoration"] as? [String: Any] {
                hintText = decoration["hintText"] as? String ?? ""
                hintStyle = decoration["hintStyle"] as? [String: Any] ?? [:]
                contentPadding = decoration["contentPadding"] as? [String: Any] ?? [:]
            
             
                if let border = decoration["border"] as? [String: Any] {
                    if let borderSide = border["borderSide"] as? [String: Any] {
                    
                        colorBorder = borderSide["color"] as? String ?? ""
                        borderSideBorder = borderSide["width"] as? CGFloat ?? 1
                        underlineBorder = borderSide["underline"] as? Bool ?? false
                    }
                    let radius = border["borderRadius"] as? CGFloat ?? cornerRadiusBorderDefault
                    cornerRadiusBorder = radius
                }
                if let focusedBorder = decoration["focusedBorder"] as? [String: Any] {
                    if let borderSide = focusedBorder["borderSide"] as? [String: Any] {
                        
                        colorFocusedBorder = borderSide["color"] as? String ?? ""
                        borderSideFocusedBorder = borderSide["width"] as? CGFloat ?? 1
                        underlineFocusedBorder = borderSide["underline"] as? Bool ?? false
                    }
                    let radius = focusedBorder["borderRadius"] as? CGFloat ?? cornerRadiusBorderDefault
                    cornerRadiusFocusedBorder = radius
                }
                
                if let errorBorder = decoration["errorBorder"] as? [String: Any] {
                    if let borderSide = errorBorder["borderSide"] as? [String: Any] {
            
                        colorErrorBorder = borderSide["color"] as? String ?? ""
                        borderSideErrorBorder = borderSide["width"] as? CGFloat ?? 1
                        underlineErrorBorder = borderSide["underline"] as? Bool ?? false
                    }
                    let radius = errorBorder["borderRadius"] as? CGFloat ?? cornerRadiusBorderDefault
                    cornerRadiusErrorBorder = radius
                }
            }
        }
           
//        self.container.layer.cornerRadius = cornerRadiusBorder
//        self.container.layer.borderWidth = borderSideBorder
//        self.container.layer.borderColor = CGColor.fromHex(colorBorder)
        
            self.container.clipsToBounds = true
            self.underline.backgroundColor = UIColor(hex:colorBorder)
            
            self.underline.isHidden = !underlineBorder
            self.textField.inputAccessoryView = uiToolBar()
            self.textField.isUserInteractionEnabled = true
            self.textField.textAlignment = getTextAlignment(textAlignment:  textAlignment)

            self.textField.isEnabled = !readOnly
            self.textField.borderStyle = .none
            self.textField.backgroundColor = .clear
            self.textField.keyboardType = .numberPad
            self.textField.returnKeyType = .done
            self.textField.adjustsFontSizeToFitWidth = false
            self.textField.contentVerticalAlignment = .center
            self.textField.minimumFontSize = 12
            self.textField.adjustsFontForContentSizeCategory = true
            self.textField.font = UIFont.preferredFont(forTextStyle: .body)
            //        self.textField.bounds.inset(by: padding)
            self.textField.tintColor = UIColor(named:colorFocusedBorder)  // cursor color
            
         
            
            
            // Placeholder styling
            let color = hintStyle["color"] as? String ?? ""
            let fontStyle = hintStyle["fontStyle"] as? String ?? "normal"
            let fontSize = hintStyle["fontSize"] as? CGFloat ?? 14
            self.textField.attributedPlaceholder = NSAttributedString(
                string: hintText,
                attributes: [
                    .foregroundColor: !color.isEmpty ? UIColor(named: color) ??  UIColor.gray : UIColor.gray ,
                    .font: fontStyle == "italic" ? UIFont.italicSystemFont(ofSize: fontSize ) : UIFont.systemFont(ofSize: fontSize) ,
                ]
            )
        self.underline.translatesAutoresizingMaskIntoConstraints = false
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(textField)
        container.addSubview(underline)
        
        
      
        
        let left = contentPadding["left"] as? CGFloat ?? 12
        let top = contentPadding["top"] as? CGFloat ?? 0
        let right = contentPadding["right"] as? CGFloat ?? -12
        let bottom = contentPadding["bottom"] as? CGFloat ?? 0
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: view().leadingAnchor ),
            container.trailingAnchor.constraint(equalTo: view().trailingAnchor, constant: 0),
            container.topAnchor.constraint(equalTo: view().topAnchor),
            container.bottomAnchor.constraint(equalTo: view().bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: container.leadingAnchor,  constant: left),
            textField.trailingAnchor.constraint(equalTo: container.trailingAnchor,  constant: -right),
            textField.topAnchor.constraint(equalTo: container.topAnchor, constant: top),
            textField.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -bottom),
               ])
    
        let colorPrimary = style["color"] as? String ?? ""
        let fontWeightPrimary = style["fontWeight"] as? String ?? "normal"
        var fontSizePrimary = style["fontSize"] as? CGFloat
        
        
        self.container.onActualFrame  = { [self] actualFrame in
            fontSizePrimary = fontSizePrimary != nil ? (fontSizePrimary! > actualFrame.size.height * 0.34 ? actualFrame.size.height * 0.34 : fontSizePrimary) : actualFrame.size.height * 0.34
            self.textField.font = UIFont.systemFont(ofSize: fontSizePrimary!, weight: fontWeightPrimary == "bold" ? .bold : .regular)
            let bottomAnchor = (actualFrame.size.height - fontSizePrimary! ) / 2 - 12
            NSLayoutConstraint.activate([
                
                underline.bottomAnchor.constraint(equalTo: textField.bottomAnchor, constant: -bottomAnchor),
                underline.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
                underline.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
                underline.heightAnchor.constraint(equalToConstant: 1),
                   ])
        }
        self.textField.textColor = UIColor(hex: colorPrimary)
        self.textField.text = initial
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
                     guard argument?["errorText"] is String else {
                         self?.isError = false
                         self?.setFocusBorder()
                         result(nil)
                         return
                     }
                     self?.setErrorBorder()
                    result(nil)
                 case "unFocus":
                     print("unFocus")
                     self?.view().endEditing(true)
                     result(nil)
                 case "requestFocus":
                     print("requestFocus")
                     self?.showKeyboard()
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
            self.textField.inputAccessoryView = nil

               // Remove delegate to avoid late callbacks
               self.textField.delegate = nil

               // Remove from view hierarchy safely
               if self.textField.superview != nil {
                   self.textField.removeFromSuperview()
               }
               if self.container.superview != nil {
                   self.container.removeFromSuperview()
               }
                if self.underline.superview != nil {
                        self.underline.removeFromSuperview()
                    }
           }
      }
    func uiToolBar() -> UIToolbar {
        let bar = UIToolbar(frame: CGRect(x: 0, y: -2, width: UIScreen.main.bounds.width, height: 40))

        //Create a done button with an action to trigger our function to dismiss the keyboard
        let doneBtn = UIBarButtonItem(title: "Hoàn tất", style: .plain, target: self, action: #selector(dismissMyKeyboard))
        //Create a felxible space item so that we can add it around in toolbar to position our done button
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        bar.items = [flexSpace, doneBtn]
    
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
   func setBorder() {
//    self.container.layer.cornerRadius = cornerRadiusBorder
//    self.container.layer.borderWidth = borderSideBorder
//    self.container.layer.borderColor = CGColor.fromHex(colorBorder)
//    self.container.backgroundColor = UIColor(named:backgroundColor)
    self.textField.tintColor = UIColor(hex:colorFocusedBorder)
       underline.backgroundColor = .gray
   }
    func setFocusBorder() {
//        self.container.layer.cornerRadius = cornerRadiusFocusedBorder
//        self.container.layer.borderWidth = borderSideFocusedBorder
//        self.container.layer.borderColor = CGColor.fromHex(colorFocusedBorder)
//        self.container.backgroundColor = UIColor(named:backgroundColor)
        self.textField.tintColor = UIColor(hex:colorFocusedBorder)
        if (underlineFocusedBorder) {
            underline.backgroundColor = UIColor(hex:colorFocusedBorder)
        }
        underline.isHidden = !underlineFocusedBorder
    }
    func setErrorBorder() {
        isError = true
//        self.container.layer.cornerRadius = cornerRadiusErrorBorder
//        self.container.layer.borderWidth = borderSideErrorBorder
//        self.container.layer.borderColor = CGColor.fromHex(colorErrorBorder)
//        self.container.backgroundColor = UIColor(named:backgroundColor)
        self.textField.tintColor = UIColor(hex:colorErrorBorder)
        if (underlineErrorBorder) {
            underline.backgroundColor = UIColor(hex:colorErrorBorder)
        }
        underline.isHidden = !underlineErrorBorder
     }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isFocus = true
        if (!isError) {
            setFocusBorder()
        }
        channel.invokeMethod("onTap", arguments: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        isFocus = false
        if (!isError) {
            setBorder()
        }
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

extension UIColor {
    /// Initialize from hex string.
    /// Supports:
    /// - "RRGGBB" (6 chars) -> alpha = 1
    /// - "AARRGGBB" (8 chars) -> alpha from first two chars
    convenience init?(hex: String) {
        var s = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if s.hasPrefix("#") { s.removeFirst() }

        var value: UInt64 = 0
        guard Scanner(string: s).scanHexInt64(&value) else { return nil }

        switch s.count {
        case 6: // RRGGBB
            let r = CGFloat((value & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((value & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(value & 0x0000FF) / 255.0
            self.init(red: r, green: g, blue: b, alpha: 1.0)
        case 8: // AARRGGBB (common on some platforms)
            let a = CGFloat((value & 0xFF000000) >> 24) / 255.0
            let r = CGFloat((value & 0x00FF0000) >> 16) / 255.0
            let g = CGFloat((value & 0x0000FF00) >> 8) / 255.0
            let b = CGFloat(value & 0x000000FF) / 255.0
            self.init(red: r, green: g, blue: b, alpha: a)
        default:
            return nil
        }
    }

    /// Alternate initializer for hex in RRGGBBAA format (if your source uses that).
    convenience init?(hexRRGGBBAA: String) {
        var s = hexRRGGBBAA.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if s.hasPrefix("#") { s.removeFirst() }

        var value: UInt64 = 0
        guard Scanner(string: s).scanHexInt64(&value) else { return nil }

        guard s.count == 8 else { return nil }

        // RRGGBBAA
        let r = CGFloat((value & 0xFF000000) >> 24) / 255.0
        let g = CGFloat((value & 0x00FF0000) >> 16) / 255.0
        let b = CGFloat((value & 0x0000FF00) >> 8) / 255.0
        let a = CGFloat(value & 0x000000FF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}

//
//  CustomKeyboardPlugin.swift
//  Runner
//
//  Created by Minh Tuan on 30/9/25.
//

class PlaceholderTextView: UITextView {

    private let placeholderLabel = UILabel()

    var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
        }
    }

    var placeholderAttributes: [NSAttributedString.Key: Any]? {
        didSet {
            if let placeholder = placeholder {
                placeholderLabel.attributedText = NSAttributedString(string: placeholder, attributes: placeholderAttributes)
            }
        }
    }

    override var text: String! {
        didSet {
            placeholderLabel.isHidden = !text.isEmpty
        }
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupPlaceholder()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPlaceholder()
    }

    private func setupPlaceholder() {
        placeholderLabel.numberOfLines = 0
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderLabel)

        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8)
        ])

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChange),
            name: UITextView.textDidChangeNotification,
            object: self
        )
    }

    @objc private func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
}
