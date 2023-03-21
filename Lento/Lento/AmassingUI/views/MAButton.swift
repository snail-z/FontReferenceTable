//
//  MAButton.swift
//  AmassingUI
//
//  Created by zhanghao on 2022/10/1.
//

import UIKit

/**
*  提供以下功能：
*  1. 支持设置图片相对于 titleLabel 的位置 (imagePlacement)
*  2. 支持设置图片和 titleLabel 之间的间距 (imageAndTitleSpacing)
*  3. 支持自定义图片尺寸大小 (imageFixedSize)
*  4. 支持图片和 titleLabel 居中对齐或边缘对齐 (Content...Alignment)
*  5. 支持图片和 titleLabel 各自对齐到两端 (.spaceBetween)
*  6. 支持调整内容内边距 (contentEdgeInsets)
*  7. 支持子视图排列样式 (arrangedAlignment)
*  8. 支持调整 cornerRadius 始终保持为高度的 1/2 (adjustsRoundedCornersAutomatically)
*  9. 支持 Auto Layout 自撑开 (以上设置可根据内容自适应)
* 10. 支持扩增手势事件的响应区域 (touchResponseInsets)
*/
@objc open class MAButton: UIView {
    
    /// 图片与文字布局位置
    @objc public enum ImagePlacement: Int {
        /// 图片在上，文字在下
        case top
        /// 图片在左，文字在右
        case left
        /// 图片在下，文字在上
        case bottom
        /// 图片在右，文字在左
        case right
    }
    
    /// 设置按图标和文字的相对位置，默认为ImagePlacement.left
    @objc public var imagePlacement: ImagePlacement = .left {
        didSet {
            guard imagePlacement != oldValue else { return }
            imagePlacementUpdates()
        }
    }
    
    /// 设置图标和文字之间的间隔，默认为10 (与对齐到两端样式冲突时优先布局.spaceBetween样式)
    @objc public var imageAndTitleSpacing: CGFloat = 10 {
        didSet {
            stackView.spacing = imageAndTitleSpacing
        }
    }
    
    /// 设置图标固定尺寸，默认为zero图标尺寸自适应
    @objc public var imageFixedSize: CGSize = .zero {
        didSet {
            guard !imageFixedSize.equalTo(oldValue) else { return }
            imageFixedSizeUpdates()
        }
    }
    
    /// 设置四周内边距，默认.zero
    @objc public var contentEdgeInsets: UIEdgeInsets = .zero {
        didSet {
            guard contentEdgeInsets != oldValue else { return }
            layoutUpdates()
        }
    }
    
    /// 竖直方向对齐样式
    @objc public enum ContentVerticalAlignment: Int {
        /// nature常用于视图自适应内容大小时 // center, left, right, spaceBetween常用于高度已被约束时
        case nature, center, top, bottom, spaceBetween
    }
    
    /// 水平方向对齐样式
    @objc public enum ContentHorizontalAlignment: Int {
        /// nature常用于视图自适应内容大小时 // center, left, right, spaceBetween常用于宽度已被约束时
        case nature, center, left, right, spaceBetween
    }
        
    /// 竖直方向对齐样式，默认顶部对齐
    @objc public var contentVerticalAlignment: ContentVerticalAlignment = .nature {
        didSet {
            guard contentVerticalAlignment != oldValue else { return }
            layoutUpdates()
        }
    }
    
    /// 水平方向对齐样式，默认居左对齐
    @objc public var contentHorizontalAlignment: ContentHorizontalAlignment = .nature {
        didSet {
            guard contentHorizontalAlignment != oldValue else { return }
            layoutUpdates()
        }
    }
    
    /// 子视图排列对齐样式
    public var arrangedAlignment: UIStackView.Alignment = .center {
        didSet {
            stackView.alignment = arrangedAlignment
        }
    }
    
    /// 是否自动调整 `cornerRadius` 使其始终保持为高度的 1/2
    @objc public var adjustsRoundedCornersAutomatically: Bool = false {
        didSet {
            guard adjustsRoundedCornersAutomatically else { return }
            layer.masksToBounds = true
            setNeedsLayout()
        }
    }
    
    /// 设置扩增手势事件的响应区域，默认UIEdgeInsetsZero
    @objc public var touchResponseInsets:UIEdgeInsets = .zero
    
    @objc public private(set) var imageView: UIImageView!
    @objc public private(set) var titleLabel: UILabel!
    private var stackView: UIStackView!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        privateInitialization()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        privateInitialization()
    }
    
    private func privateInitialization() {
        stackView = UIStackView()
        stackView.alignment = arrangedAlignment
        stackView.spacing = imageAndTitleSpacing
        addSubview(stackView)
        
        imageView = UIImageView()
        stackView.addArrangedSubview(imageView)
        
        titleLabel = UILabel()
        titleLabel.lineBreakMode = .byTruncatingTail
        stackView.addArrangedSubview(titleLabel)
        
        layoutUpdates()
    }
    
    private func imagePlacementUpdates() {
        imageView.removeFromSuperview()
        switch imagePlacement {
        case .left, .top:
            stackView.insertArrangedSubview(imageView, at: 0)
        case .right, .bottom:
            stackView.addArrangedSubview(imageView)
        }
        
        layoutUpdates()
    }
    
    private func layoutUpdates() {
        switch imagePlacement {
        case .top, .bottom:
            stackView.axis = .vertical
            stackView.distribution = contentVerticalAlignment == .spaceBetween ? .equalCentering : .fill
            imageView.setContentHuggingPriority(.required, for: .vertical)
            imageView.setContentCompressionResistancePriority(.required, for: .vertical)
            contentVerticalLayoutUpdates()
        case .left, .right:
            stackView.axis = .horizontal
            stackView.distribution = contentHorizontalAlignment == .spaceBetween ? .equalCentering : .fill
            imageView.setContentHuggingPriority(.required, for: .horizontal)
            imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
            contentHorizontalLayoutUpdates()
        }
    }
    
    private func contentHorizontalLayoutUpdates() {
        let inset = contentEdgeInsets
        switch contentHorizontalAlignment {
        case .nature, .spaceBetween:
            stackView.snp.remakeConstraints { make in
                make.top.equalTo(inset.top)
                make.bottom.equalToSuperview().inset(inset.bottom)
                make.left.equalTo(inset.left)
                make.right.equalToSuperview().inset(inset.right)
            }
        case .center:
            stackView.snp.remakeConstraints { make in
                make.top.equalTo(inset.top)
                make.bottom.equalToSuperview().inset(inset.bottom)
                make.centerX.equalToSuperview()
                make.left.greaterThanOrEqualToSuperview().offset(inset.left)
                make.right.lessThanOrEqualToSuperview().inset(inset.right)
            }
        case .left:
            stackView.snp.remakeConstraints { make in
                make.top.equalTo(inset.top)
                make.bottom.equalToSuperview().inset(inset.bottom)
                make.left.equalTo(inset.left)
                make.right.lessThanOrEqualToSuperview().inset(inset.right)
            }
        case .right:
            stackView.snp.remakeConstraints { make in
                make.top.equalTo(inset.top)
                make.bottom.equalToSuperview().inset(inset.bottom)
                make.left.greaterThanOrEqualToSuperview().offset(inset.left)
                make.right.equalToSuperview().inset(inset.right)
            }
        }
    }
    
    private func contentVerticalLayoutUpdates() {
        let inset = contentEdgeInsets
        switch contentVerticalAlignment {
        case .nature, .spaceBetween:
            stackView.snp.remakeConstraints { make in
                make.left.equalTo(inset.left)
                make.right.equalToSuperview().inset(inset.right)
                make.top.equalTo(inset.top)
                make.bottom.equalToSuperview().inset(inset.bottom)
            }
        case .center:
            stackView.snp.remakeConstraints { make in
                make.left.equalTo(inset.left)
                make.right.equalToSuperview().inset(inset.right)
                make.centerY.equalToSuperview()
                make.top.greaterThanOrEqualToSuperview().offset(inset.top)
                make.bottom.lessThanOrEqualToSuperview().inset(inset.bottom)
            }
        case .top:
            stackView.snp.remakeConstraints { make in
                make.left.equalTo(inset.left)
                make.right.equalToSuperview().inset(inset.right)
                make.top.equalTo(inset.top)
                make.bottom.lessThanOrEqualToSuperview().inset(inset.bottom)
            }
        case .bottom:
            stackView.snp.remakeConstraints { make in
                make.left.equalTo(inset.left)
                make.right.equalToSuperview().inset(inset.right)
                make.top.greaterThanOrEqualToSuperview().offset(inset.top)
                make.bottom.equalToSuperview().inset(inset.bottom)
            }
        }
    }
    
    private func imageFixedSizeUpdates() {
        imageView.snp.updateConstraints { make in
            make.size.equalTo(imageFixedSize)
        }
    }
    
    open override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        guard adjustsRoundedCornersAutomatically else { return }
        layer.cornerRadius = bounds.height / 2
    }
    
    private func increscent(rect: CGRect, by inset: UIEdgeInsets) -> CGRect {
        guard inset != UIEdgeInsets.zero else { return rect }
        return CGRect(x: rect.minX - inset.left,
                      y: rect.minY - inset.top,
                      width: rect.width + inset.left + inset.right,
                      height: rect.height + inset.top + inset.bottom)
    }
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect = increscent(rect: bounds, by: touchResponseInsets)
        guard rect.equalTo(bounds) else {
            return rect.contains(point)
        }
        return super.point(inside: point, with: event)
    }
}



@objc open class MAStateButton: UIView {
    
    /// 图片与文字布局位置
    @objc public enum ImagePlacement: Int {
        /// 图片在上，文字在下
        case top
        /// 图片在左，文字在右
        case left
        /// 图片在下，文字在上
        case bottom
        /// 图片在右，文字在左
        case right
    }
    
    /// 设置按图标和文字的相对位置，默认为ImagePlacement.left
    @objc public var imagePlacement: ImagePlacement = .left {
        didSet {
            guard imagePlacement != oldValue else { return }
            imagePlacementUpdates()
        }
    }
    
    /// 设置图标和文字之间的间隔，默认为10 (与对齐到两端样式冲突时优先布局.spaceBetween样式)
    @objc public var imageAndTitleSpacing: CGFloat = 10 {
        didSet {
            stackView.spacing = imageAndTitleSpacing
        }
    }
    
    /// 设置图标固定尺寸，默认为zero图标尺寸自适应
    @objc public var imageFixedSize: CGSize = .zero {
        didSet {
            guard !imageFixedSize.equalTo(oldValue) else { return }
            imageFixedSizeUpdates()
        }
    }
    
    /// 设置四周内边距，默认.zero
    @objc public var contentEdgeInsets: UIEdgeInsets = .zero {
        didSet {
            guard contentEdgeInsets != oldValue else { return }
            layoutUpdates()
        }
    }
    
    /// 竖直方向对齐样式
    @objc public enum ContentVerticalAlignment: Int {
        /// nature常用于视图自适应内容大小时 // center, left, right, spaceBetween常用于高度已被约束时
        case nature, center, top, bottom, spaceBetween
    }
    
    /// 水平方向对齐样式
    @objc public enum ContentHorizontalAlignment: Int {
        /// nature常用于视图自适应内容大小时 // center, left, right, spaceBetween常用于宽度已被约束时
        case nature, center, left, right, spaceBetween
    }
        
    /// 竖直方向对齐样式，默认顶部对齐
    @objc public var contentVerticalAlignment: ContentVerticalAlignment = .nature {
        didSet {
            guard contentVerticalAlignment != oldValue else { return }
            layoutUpdates()
        }
    }
    
    /// 水平方向对齐样式，默认居左对齐
    @objc public var contentHorizontalAlignment: ContentHorizontalAlignment = .nature {
        didSet {
            guard contentHorizontalAlignment != oldValue else { return }
            layoutUpdates()
        }
    }
    
    /// 子视图排列对齐样式
    public var arrangedAlignment: UIStackView.Alignment = .center {
        didSet {
            stackView.alignment = arrangedAlignment
        }
    }
    
    /// 是否自动调整 `cornerRadius` 使其始终保持为高度的 1/2
    @objc public var adjustsRoundedCornersAutomatically: Bool = false {
        didSet {
            guard adjustsRoundedCornersAutomatically else { return }
            layer.masksToBounds = true
            setNeedsLayout()
        }
    }
    
    /// 设置扩增手势事件的响应区域，默认UIEdgeInsetsZero
    @objc public var touchResponseInsets:UIEdgeInsets = .zero
    
    @objc public private(set) var imageView: UIImageView!
    @objc public private(set) var titleLabel: UILabel!
    private var stackView: UIStackView!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        privateInitialization()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        privateInitialization()
    }
    
    private func privateInitialization() {
        stackView = UIStackView()
        stackView.alignment = arrangedAlignment
        stackView.spacing = imageAndTitleSpacing
        addSubview(stackView)
        
        imageView = UIImageView()
        stackView.addArrangedSubview(imageView)
        
        titleLabel = UILabel()
        titleLabel.lineBreakMode = .byTruncatingTail
        stackView.addArrangedSubview(titleLabel)
        
        layoutUpdates()
    }
    
    private func imagePlacementUpdates() {
        imageView.removeFromSuperview()
        switch imagePlacement {
        case .left, .top:
            stackView.insertArrangedSubview(imageView, at: 0)
        case .right, .bottom:
            stackView.addArrangedSubview(imageView)
        }
        
        layoutUpdates()
    }
    
    private func layoutUpdates() {
        switch imagePlacement {
        case .top, .bottom:
            stackView.axis = .vertical
            stackView.distribution = contentVerticalAlignment == .spaceBetween ? .equalCentering : .fill
            imageView.setContentHuggingPriority(.required, for: .vertical)
            imageView.setContentCompressionResistancePriority(.required, for: .vertical)
            contentVerticalLayoutUpdates()
        case .left, .right:
            stackView.axis = .horizontal
            stackView.distribution = contentHorizontalAlignment == .spaceBetween ? .equalCentering : .fill
            imageView.setContentHuggingPriority(.required, for: .horizontal)
            imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
            contentHorizontalLayoutUpdates()
        }
    }
    
    private func contentHorizontalLayoutUpdates() {
        let inset = contentEdgeInsets
        switch contentHorizontalAlignment {
        case .nature, .spaceBetween:
            stackView.snp.remakeConstraints { make in
                make.top.equalTo(inset.top)
                make.bottom.equalToSuperview().inset(inset.bottom)
                make.left.equalTo(inset.left)
                make.right.equalToSuperview().inset(inset.right)
            }
        case .center:
            stackView.snp.remakeConstraints { make in
                make.top.equalTo(inset.top)
                make.bottom.equalToSuperview().inset(inset.bottom)
                make.centerX.equalToSuperview()
                make.left.greaterThanOrEqualToSuperview().offset(inset.left)
                make.right.lessThanOrEqualToSuperview().inset(inset.right)
            }
        case .left:
            stackView.snp.remakeConstraints { make in
                make.top.equalTo(inset.top)
                make.bottom.equalToSuperview().inset(inset.bottom)
                make.left.equalTo(inset.left)
                make.right.lessThanOrEqualToSuperview().inset(inset.right)
            }
        case .right:
            stackView.snp.remakeConstraints { make in
                make.top.equalTo(inset.top)
                make.bottom.equalToSuperview().inset(inset.bottom)
                make.left.greaterThanOrEqualToSuperview().offset(inset.left)
                make.right.equalToSuperview().inset(inset.right)
            }
        }
    }
    
    private func contentVerticalLayoutUpdates() {
        let inset = contentEdgeInsets
        switch contentVerticalAlignment {
        case .nature, .spaceBetween:
            stackView.snp.remakeConstraints { make in
                make.left.equalTo(inset.left)
                make.right.equalToSuperview().inset(inset.right)
                make.top.equalTo(inset.top)
                make.bottom.equalToSuperview().inset(inset.bottom)
            }
        case .center:
            stackView.snp.remakeConstraints { make in
                make.left.equalTo(inset.left)
                make.right.equalToSuperview().inset(inset.right)
                make.centerY.equalToSuperview()
                make.top.greaterThanOrEqualToSuperview().offset(inset.top)
                make.bottom.lessThanOrEqualToSuperview().inset(inset.bottom)
            }
        case .top:
            stackView.snp.remakeConstraints { make in
                make.left.equalTo(inset.left)
                make.right.equalToSuperview().inset(inset.right)
                make.top.equalTo(inset.top)
                make.bottom.lessThanOrEqualToSuperview().inset(inset.bottom)
            }
        case .bottom:
            stackView.snp.remakeConstraints { make in
                make.left.equalTo(inset.left)
                make.right.equalToSuperview().inset(inset.right)
                make.top.greaterThanOrEqualToSuperview().offset(inset.top)
                make.bottom.equalToSuperview().inset(inset.bottom)
            }
        }
    }
    
    private func imageFixedSizeUpdates() {
        imageView.snp.updateConstraints { make in
            make.size.equalTo(imageFixedSize)
        }
    }
    
    open override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        guard adjustsRoundedCornersAutomatically else { return }
        layer.cornerRadius = bounds.height / 2
    }
    
    private func increscent(rect: CGRect, by inset: UIEdgeInsets) -> CGRect {
        guard inset != UIEdgeInsets.zero else { return rect }
        return CGRect(x: rect.minX - inset.left,
                      y: rect.minY - inset.top,
                      width: rect.width + inset.left + inset.right,
                      height: rect.height + inset.top + inset.bottom)
    }
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect = increscent(rect: bounds, by: touchResponseInsets)
        guard rect.equalTo(bounds) else {
            return rect.contains(point)
        }
        return super.point(inside: point, with: event)
    }


    
    /// 按钮状态
    @objc public enum State: Int {
        /// 普通状态，高亮状态，禁用状态，选中状态
        case normal, highlighted, disabled, selected
    }
    
    /// 当前按钮状态
    @objc open private(set) var state: State = .normal
    
    /// 状态改变回调 (可通过监听此状态更新时做相应逻辑处理)
    @objc open var stateUpdateClosure: ((_ sender: MAStateButton) -> Void)?
    
    /// 设置是否为高亮状态
    @objc open private(set) var isHighlighted: Bool = false {
        didSet {
            guard oldValue != isHighlighted else { return }
            state = isHighlighted ? .highlighted : .normal
            setStateUpdates()
            stateUpdateClosure?(self)
        }
    }
    
    /// 设置是否为禁用状态
    @objc open var isDisabled: Bool = false {
        didSet {
            guard oldValue != isDisabled else { return }
            state = isDisabled ? .disabled : .normal
            setStateUpdates()
            stateUpdateClosure?(self)
        }
    }
    
    /// 设置是否为选中状态
    @objc open var isSelected: Bool = false {
        didSet {
            guard oldValue != isSelected else { return }
            state = isSelected ? .selected : .normal
            setStateUpdates()
            stateUpdateClosure?(self)
        }
    }
    
    
    
    
        
    private func setStateUpdates() {
        let methodValues = takeMethodValues(state)
        for rawValue in Method.allMethods() {
            let aKey = "\(rawValue)"
            let value = methodValues[aKey]
            send(method: Method.build(rawValue), value)
        }
    }
    
    private func update(_ method: Method, value: Any?, for state: State) {
        var values = takeMethodValues(state)
        let aKey = "\(method.rawValue)"
        guard let obj = value else {
//            send(method: method, nil)
            return
        }
        values.updateValue(obj, forKey: aKey)
        stateValues.updateValue(values, forKey: "\(state.rawValue)")
        print("stateValues is: \(stateValues)")
//        send(method: method, obj)
    }
    
    private func getValue(_ method: Method, for state: State) -> Any? {
        let val = takeMethodValues(state)
        let aKey = "\(method.rawValue)"
       return val[aKey]
    }

    

    
    /// 设置不同状态下的标题
    @objc open func setTitle(_ title: String?, for state: State) {
        update(.title, value: title, for: state)
    }
    
    /// 设置不同状态下的图标
    @objc open func setImage(_ image: UIImage?, for state: State) {
        update(.image, value: image, for: state)
    }
    
    /// 设置不同状态下的标题颜色
    @objc open func setTitleColor(_ color: UIColor?, for state: State) {
        update(.titleColor, value: color, for: state)
    }
    
    /// 设置不同状态下的标题字体
    @objc open func setTitleFont(_ font: UIFont?, for state: State) {
        update(.titleFont, value: font, for: state)
    }
    
    /// 设置不同状态下的背景色
    @objc open func setBackgroundColor(_ color: UIColor?, for state: State) {
        update(.backgroundColor, value: color, for: state)
    }
    
    /// 设置不同状态下的属性字符串
    @objc open func setAttributedTitle(_ title: NSAttributedString?, for state: State) {
        update(.attributedTitle, value: title, for: state)
    }
    
    /// 设置不同状态下的边框色
    @objc open func setBorderColor(_ color: UIColor?, for state: State) {
        update(.borderColor, value: color, for: state)
    }
    
    /// 设置不同状态下的边框宽度
    @objc open func setBorderWidth(_ width: CGFloat, for state: State) {
        update(.borderWidth, value: width, for: state)
    }
    
    /// 设置不同状态下的轮廓色
    @objc open func setImageTintColor(_ color: UIColor?, for state: State) {
        update(.imageTintColor, value: color, for: state)
    }
    
    /// 获取不同状态下的标题
    @objc open func title(for state: State) -> String? {
        return getValue(.title, for: state) as? String
    }
    
    /// 获取不同状态下的图片
    @objc open func image(for state: State) -> UIImage? {
        return getValue(.image, for: state) as? UIImage
    }
    
    /// 获取不同状态下的标题颜色
    @objc open func titleColor(for state: State) -> UIColor? {
        return getValue(.titleColor, for: state) as? UIColor
    }
    
    /// 获取不同状态下的标题字体
    @objc open func titleFont(for state: State) -> UIFont? {
        return getValue(.titleFont, for: state) as? UIFont
    }
    
    /// 获取不同状态下的背景色
    @objc open func backgroundColor(for state: State) -> UIColor? {
        return getValue(.backgroundColor, for: state) as? UIColor
    }
    
    /// 获取不同状态下的属性文本
    @objc open func attributedTitle(for state: State) -> NSAttributedString? {
        return getValue(.attributedTitle, for: state) as? NSAttributedString
    }
    
    /// 获取不同状态下的边框色
    @objc open func borderColor(for state: State) -> UIColor? {
        return getValue(.borderColor, for: state) as? UIColor
    }
    
    /// 获取不同状态下的边框宽度
    @objc open func borderWidth(for state: State) -> CGFloat {
        return getValue(.borderWidth, for: state) as? CGFloat ?? 0
    }
    
    /// 获取不同状态下的轮廓色
    @objc open func imageTintColor(for state: State) -> UIColor? {
        return getValue(.imageTintColor, for: state) as? UIColor
    }
    
    

    

    
    // MARK: - private -
    
    private enum Method: Int {
        case none
        case title
        case image
        case titleColor
        case titleFont
        case backgroundColor
        case attributedTitle
        case borderWidth
        case borderColor
        case imageTintColor
        
        static func allMethods() -> ClosedRange<Int> {
            return title.rawValue...imageTintColor.rawValue
        }
        
        static func build(_ rawValue: Int) -> Method {
            return Method.init(rawValue: rawValue) ?? .none
        }
    }
    
    private typealias MethodValues = [String: Any] // [Method: Any]
    
    private var stateValues = [String: MethodValues]()
    
    private func takeMethodValues(_ state: State) -> MethodValues {
        let aKey =  "\(state.rawValue)"
        if let values = stateValues[aKey] {
            return values
        } else {
            return MethodValues()
        }
    }
    
    private func send(method: Method, _ value: Any?) {
        switch method {
        case .none: break
        case .title:
            titleLabel.text = value as? String ?? "空的"
            titleLabel.textColor = .black
        case .image:
            
            if let _ = imageTintColor(for: state) {
                var image = value as? UIImage
                image = image?.withRenderingMode(.alwaysTemplate)
                imageView.image =  image
            } else {
                imageView.image =  value as? UIImage
            }

        case .titleColor:
            titleLabel.textColor = value as? UIColor ?? .black
        case .titleFont:
            titleLabel.font = value as? UIFont ?? .systemFont(ofSize: UIFont.systemFontSize)
        case .backgroundColor:
            self.backgroundColor = value as? UIColor ?? .white
        case .attributedTitle:
            if let _ = title(for: state) {
//                titleLabel.attributedText = value as? NSAttributedString
            } else {
                titleLabel.attributedText = value as? NSAttributedString
            }
            
            break
        case .borderWidth:
            layer.borderWidth = value as? CGFloat ?? 0
        case .borderColor:
            layer.borderColor = (value as? UIColor)?.cgColor
        case .imageTintColor:
            if imageView.image?.renderingMode == .alwaysTemplate {
                imageView.tintColor = value as? UIColor
            } else {
                let img = imageView.image?.withRenderingMode(.alwaysTemplate)
                imageView.image = img
                imageView.tintColor = value as? UIColor
            }
        }
    }
    
    
    
//    private var actionClosure: ((_ target: AnyObject?, _ action: Selector) -> Void)?
    
    weak var tempTarget:AnyObject?
    var tempAction: Selector?
    
    @objc open func addTarget(_ target: AnyObject?, action: Selector) {
        tempTarget = target
        tempAction = action
    }
    
    func send(action: Selector?, target: AnyObject?) {
        guard let sel = action, let anyObj = target else { return }
        guard anyObj.responds(to: sel) else { return }
        if sel.description.hasSuffix(":") {
            anyObj.performSelector(onMainThread: sel, with: self, waitUntilDone: true)
        } else {
            anyObj.performSelector(onMainThread: sel, with: nil, waitUntilDone: true)
        }
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("touchesBegan")
//        isHighlighted = true
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesEnded")
        super.touchesEnded(touches, with: event)
//        isHighlighted = false
        send(action: tempAction, target: tempTarget)
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesCancelled")
        super.touchesCancelled(touches, with: event)
//        isHighlighted = false
    }

    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        let tp = UITapGestureRecognizer.init(target: self, action: nil)
        
        print("touchesMoved")
        guard let p = touches.first?.location(in: self) else { return }
        let boundsIncrescent = increscent(rect: bounds, by: touchResponseInsets)
//        isHighlighted = boundsIncrescent.contains(p)
//        if boundsIncrescent.contains(p) {
//            print("试图内")
//
//            isHighlighted = true
//        } else {
//            print("出去了")
//            isHighlighted = false
//        }
    }
    
    func didtapped(_ g: UITapGestureRecognizer) {
        switch g.state {
        case .began:
            break
        case .changed:
            break
        case .cancelled:
            break
        case .ended:break
        case .failed:break
        default: break
        }
    }
}
