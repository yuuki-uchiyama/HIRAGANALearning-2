//
//  Extension.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/10/11.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit

extension UIImage{
    func resized(side:CGFloat) ->UIImage{
        if self.size.width < side && self.size.height < side{
            return self
        }
        var resizedSize: CGSize!
        let aspectRate: CGFloat = self.size.height / self.size.width
        if self.size.width >= self.size.height{
            let height = side * aspectRate
            resizedSize = CGSize(width: side, height: height)
        }else{
            let width = side / aspectRate
            resizedSize = CGSize(width: width, height: side)
        }
        UIGraphicsBeginImageContext(resizedSize)
        self.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
}

extension Array where Element: Equatable {
    mutating func remove(value: Element) {
        if let i = self.index(of: value) {
            self.remove(at: i)
        }
    }
}

extension UIView{
    func shadowSetting(){
        let screenHeight = UIScreen.main.bounds.height
        var shadowSize = screenHeight / 100
        if UIDevice.current.userInterfaceIdiom == .phone{
            shadowSize = screenHeight / 75
        }
        
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: shadowSize, height: shadowSize)
    }
    
    func shadowDisappear(){
        self.layer.shadowOpacity = 0
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    func viewTapActionSetting(){
        shadowSetting()
        let touchDown = UILongPressGestureRecognizer(target: self, action: #selector(viewTap(_:)))
        touchDown.minimumPressDuration = 0
        self.addGestureRecognizer(touchDown)
    }
    
    @objc func viewTap(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            print("tapBegan")
            let shadowSize = sender.view!.layer.shadowOffset.height
            sender.view!.frame.origin.x += shadowSize / 2
            sender.view!.frame.origin.y += shadowSize / 2
            shadowDisappear()
        }
        if  sender.state == .ended {
            print("tapEnded")
            let shadowSize = sender.view!.layer.shadowOffset.height
            sender.view!.frame.origin.x -= shadowSize * 2
            sender.view!.frame.origin.y -= shadowSize * 2
            shadowSetting()
        }
    }
    
    enum cornerType{
        case collectionView
        case verySmall
        case small
        case normal
        case circle
    }
    
    func cornerLayout(_ type:cornerType){
        let rate = self.frame.height / self.frame.width
        var side: CGFloat!
        if rate == 1{
            if UIDevice.current.userInterfaceIdiom == .pad{
                side = self.frame.width
            }else{
                side = self.frame.height
            }
        }else if rate > 1{
            side = self.frame.width
        }else{
            side = self.frame.height
        }
        switch type {
        case .collectionView:
            self.layer.cornerRadius = side / 16.0
        case .verySmall:
            self.layer.cornerRadius = side / 8.0
        case .small:
            self.layer.cornerRadius = side / 6.0
        case .normal:
            self.layer.cornerRadius = side / 4.0
        case .circle:
            self.layer.cornerRadius = side / 2.0
        }
    }
}

extension UIButton{
    func imageFit(){
        self.imageView?.contentMode = .scaleAspectFit
        self.contentHorizontalAlignment = .fill
        self.contentVerticalAlignment = .fill
    }
    
    func setBackgroundColor(_ color: UIColor, for state: UIControlState) {
        let image = color.image
        setBackgroundImage(image, for: state)
    }
    
    func helpButtonAction(){
        self.backgroundColor = UIColor.clear
        self.setImage(UIImage(named: "Help"), for: .normal)
        self.setImage(UIImage(named: "Close"), for: .selected)
        self.imageFit()
    }
    func viewAdd(_ addView:UIView,_ backgroundView:UIView,_ superView:UIView){
        self.isSelected = !self.isSelected
        if self.isSelected{
            backgroundView.frame = superView.frame
            backgroundView.backgroundColor = UIColor.flatGray
            backgroundView.alpha = 0.8
            superView.insertSubview(backgroundView, belowSubview: self)
            addView.frame = superView.frame
            addView.contentMode = UIViewContentMode.scaleAspectFit
            superView.insertSubview(addView, belowSubview: self)
        }else{
            backgroundView.removeFromSuperview()
            addView.removeFromSuperview()
        }
    }
    
    func buttonTapActionSetting(_ type:cornerType){
        self.cornerLayout(type)
        let screenHeight = UIScreen.main.bounds.height
        var shadowSize = screenHeight / 100
        if UIDevice.current.userInterfaceIdiom == .phone{
            shadowSize = screenHeight / 75
        }
        
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: shadowSize, height: shadowSize)
        self.addTarget(self, action: #selector(buttonTap(_:)), for: .touchDown)
        
        self.addTarget(self, action: #selector(buttonRelease(_:)), for: .touchUpInside)
        self.addTarget(self, action: #selector(buttonRelease(_:)), for: .touchUpOutside)
        
    }
    
    @objc func buttonTap(_ sender: UIButton) {
        let shadowSize = sender.layer.shadowOffset.height
        sender.frame.origin.x += shadowSize / 2
        sender.frame.origin.y += shadowSize / 2
        sender.layer.shadowOffset = CGSize(width:
            shadowSize / 4, height: shadowSize / 4)
    }
    
    @objc func buttonRelease(_ sender: UIButton) {
        let shadowSize = sender.layer.shadowOffset.height
        sender.frame.origin.x -= shadowSize * 2
        sender.frame.origin.y -= shadowSize * 2
        sender.layer.shadowOffset = CGSize(width: shadowSize * 4, height: shadowSize * 4)
    }
    
    func buttonSelect(){
        if self.isSelected{
            buttonTap(self)
        }else{
            let shadowSize = self.layer.shadowOffset.height
            if shadowSize < UIScreen.main.bounds.height / 100{
                buttonRelease(self)
            }
        }
    }
}

extension UIColor {
    var image: UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        context.setFillColor(self.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension String{
    var isTone: Bool {
        let range = "^[ぁぃぅぇぉゃゅょ]+$"
        return NSPredicate(format: "SELF MATCHES %@", range).evaluate(with: self)
    }
    var isDakuten: Bool{
        let range = "^[ゔがぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽ]+$"
        return NSPredicate(format: "SELF MATCHES %@", range).evaluate(with: self)
    }
    
    var isHiragana: Bool {
        let range = "^[ぁ-ゞ]+$"
        return NSPredicate(format: "SELF MATCHES %@", range).evaluate(with: self)
    }
    
    var isKatakana: Bool {
        let range = "^[ァ-ヾ]+$"
        return NSPredicate(format: "SELF MATCHES %@", range).evaluate(with: self)
    }
    
    var isLineA: Bool {
        let range = "^[あいうえおぁぃぅぇぉゔ]+$"
        return NSPredicate(format: "SELF MATCHES %@", range).evaluate(with: self)
    }
    var isLineK: Bool {
        let range = "^[か-ご]+$"
        return NSPredicate(format: "SELF MATCHES %@", range).evaluate(with: self)
    }
    var isLineS: Bool {
        let range = "^[さ-ぞ]+$"
        return NSPredicate(format: "SELF MATCHES %@", range).evaluate(with: self)
    }
    var isLineT: Bool {
        let range = "^[たちつてとだぢづでど]+$"
        return NSPredicate(format: "SELF MATCHES %@", range).evaluate(with: self)
    }
    var isLineN: Bool {
        let range = "^[な-の]+$"
        return NSPredicate(format: "SELF MATCHES %@", range).evaluate(with: self)
    }
    var isLineH: Bool {
        let range = "^[は-ぽ]+$"
        return NSPredicate(format: "SELF MATCHES %@", range).evaluate(with: self)
    }
    var isLineM: Bool {
        let range = "^[ま-も]+$"
        return NSPredicate(format: "SELF MATCHES %@", range).evaluate(with: self)
    }
    var isLineY: Bool {
        let range = "^[ゃ-よ]+$"
        return NSPredicate(format: "SELF MATCHES %@", range).evaluate(with: self)
    }
    var isLineR: Bool {
        let range = "^[ら-ろ]+$"
        return NSPredicate(format: "SELF MATCHES %@", range).evaluate(with: self)
    }
    var isLineW: Bool {
        let range = "^[ゎわをんっー]+$"
        return NSPredicate(format: "SELF MATCHES %@", range).evaluate(with: self)
    }
    
    func makeYouon() -> [String]{
        var stringArray: [String] = []
        for i in 0 ..< self.count{
            let string = String(self[self.index(self.startIndex, offsetBy: i) ..< self.index(self.startIndex, offsetBy: i+1)])
            var s = ""
            
            if !string.isTone{
                if i == self.count - 1{
                    s = string
                }else{
                    let nextString = String(self[self.index(self.startIndex, offsetBy: i+1) ..< self.index(self.startIndex, offsetBy: i+2)])
                    if nextString.isTone{
                        s = string + nextString
                    }else{
                        s = string
                    }
                }
                stringArray.append(s)
            }
        }
        return stringArray
    }
    
    //    カード編集・追加用
    var isUsableString: Bool {
        let usableStringArray = ["あ","い","う","え","お","か","き","く","け","こ","さ","し","す","せ","そ","た","ち","つ","て","と","な","に","ぬ","ね","の","は","ひ","ふ","へ","ほ","ま","み","む","め","も","や","ゆ","よ","ら","り","る","れ","ろ","わ","を","ん","ゔ","が","ぎ","ぐ","げ","ご","ざ","じ","ず","ぜ","ぞ","だ","ぢ","づ","で","ど","ば","び","ぶ","べ","ぼ","ぱ","ぴ","ぷ","ぺ","ぽ","ふぁ","ゔぁ","すぃ","ずぃ","てぃ","でぃ","ふぃ","うぃ","ゔぃ","とぅ","どぅ","しぇ","じぇ","ちぇ","ぢぇ","ふぇ","うぇ","ゔぇ","ふぉ","うぉ","ゔぉ","きゃ","ぎゃ","しゃ","じゃ","ちゃ","ぢゃ","にゃ","ひゃ","びゃ","ぴゃ","みゃ","りゃ","きゅ","ぎゅ","しゅ","じゅ","ちゅ","ぢゅ","にゅ","ひゅ","びゅ","ぴゅ","みゅ","りゅ","きょ","ぎょ","しょ","じょ","ちょ","ぢょ","にょ","ひょ","びょ","ぴょ","みょ","りょ","っ","ー"]
        
        if self == ""{
            return false
        }
        let characterArray = self.makeYouon()
        for chara in characterArray{
            if !usableStringArray.contains(chara){
                return false
            }
        }
        return true
    }
    
    var isCountOver: Bool {
        if self.count > 10{
            return true
        }else{
            return false
        }
    }
    
    func removeSpaceAndTyouon() -> String{
        let string = self.replacingOccurrences(of: " ", with: "")
        return string.replacingOccurrences(of: "-", with: "ー")
    }
    
    func katakanaToHiragana(_ bool:Bool) -> String {
        return self.transform(transform: .hiraganaToKatakana, reverse: bool)
    }
    
    func toneToSingle() -> String{
        var toneToSingleDic:[String:String] =
            ["ぁ":"あ","ぃ":"い","ぅ":"う","ぇ":"え","ぉ":"お","ゃ":"や","ゅ":"ゆ","ょ":"よ","っ":"つ"]
        if self.isTone || self == "っ"{
            return toneToSingleDic[self]!
        }else{
            return self
        }
    }
    
    private func transform(transform: StringTransform, reverse: Bool) -> String {
        if let string = self.applyingTransform(transform, reverse: reverse) {
            return string
        } else {
            return ""
        }
    }
    
    func containsString(_ str:String) -> Bool {
        return NSPredicate(format: "SELF CONTAINS %@", str).evaluate(with: self)
    }
    
}
