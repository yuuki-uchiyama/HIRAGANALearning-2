
//
//  GameSystem.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/06.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

extension Array where Element: Equatable {
    mutating func remove(value: Element) {
        if let i = self.index(of: value) {
            self.remove(at: i)
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




class GameSystem{
//    清音一覧
    var simpleCharacters:[String] = ["あ","い","う","え","お","か","き","く","け","こ","さ","し","す","せ","そ","た","ち","つ","て","と","な","に","ぬ","ね","の","は","ひ","ふ","へ","ほ","ま","み","む","め","も","や","ゆ","よ","ら","り","る","れ","ろ","わ","を","ん"]
    
//    濁音・半濁音一覧
    var dakuonCharacters:[String] = ["ゔ","が","ぎ","ぐ","げ","ご","ざ","じ","ず","ぜ","ぞ","だ","ぢ","づ","で","ど","ば","び","ぶ","べ","ぼ","ぱ","ぴ","ぷ","ぺ","ぽ"]
    
//    使用できる拗音一覧
    var usableYouonCharacters:[String] = ["ふぁ","ゔぁ","すぃ","ずぃ","てぃ","でぃ","ふぃ","うぃ","ゔぃ","とぅ","どぅ","しぇ","じぇ","ちぇ","ぢぇ","ふぇ","うぇ","ゔぇ","ふぉ","うぉ","ゔぉ","きゃ","ぎゃ","しゃ","じゃ","ちゃ","ぢゃ","にゃ","ひゃ","びゃ","ぴゃ","みゃ","りゃ","きゅ","ぎゅ","しゅ","じゅ","ちゅ","ぢゅ","にゅ","ひゅ","びゅ","ぴゅ","みゅ","りゅ","きょ","ぎょ","しょ","じょ","ちょ","ぢょ","にょ","ひょ","びょ","ぴょ","みょ","りょ"]
    
//    似た文字のDic
    var similarCharactersDic:[String:[String]] =
        ["あ":["お", "ぬ", "の", "め"],
         "い":["け","げ","こ","ぎ","し","じ","に", "り"],
         "う":["ゔ","ち","ぢ","つ","づ","ふ","ぶ","ぷ", "ら", "る", "ろ"],
         "ゔ":["う","ち","ぢ","つ","づ","ふ","ぶ","ぷ", "ら", "る", "ろ"],

         "え":["ひ","び","ぴ", "る", "れ", "ろ", "わ", "ん"],
         "お":["あ", "す","ず", "ち","ぢ", "ぬ", "ね", "の", "ま", "み", "む", "め", "わ"],
         
         "か":["が","な", "ふ","ぶ","ぷ", "や", "ゆ", "ら", "り", "わ"],
         "き":["ぎ","さ","ざ", "ま", "も"],
         "く":["ぐ","し","じ", "つ","づ", "て","で", "と","ど", "へ","べ","ぺ"],
         "け":["げ","い", "さ","ざ", "た","だ", "に", "は","ば","ぱ", "ほ","ぼ","ぽ", "り"],
         "こ":["ご","い","つ","づ","て","で","に","り"],
         "が":["か","な", "ふ","ぶ","ぷ", "や", "ゆ", "ら", "り", "わ"],
         "ぎ":["き","さ","ざ", "ま", "も"],
         "ぐ":["く","し","じ", "つ","づ", "て","で", "と","ど", "へ","べ","ぺ"],
         "げ":["け","い", "さ","ざ", "た","だ", "に", "は","ば","ぱ", "ほ","ぼ","ぽ", "り"],
         "ご":["こ","い","つ","づ","て","で","に","り"],
         
         "さ":["ざ","き","ぎ","け","げ","ち","ぢ"],
         "し":["じ","い","く","ぐ","つ","づ","と","ど","ひ","び","ぴ","も","ん"],
         "す":["ず","お","ま"],
         "せ":["ぜ","む"],
         "そ":["ぞ","て","で","る","ろ","を"],
         "ざ":["さ","き","ぎ","け","げ","ち","ぢ"],
         "じ":["し","い","く","ぐ","つ","づ","と","ど","ひ","び","ぴ","も","ん"],
         "ず":["す","お","ま"],
         "ぜ":["せ","む"],
         "ぞ":["そ","て","で","る","ろ","を"],
         
         "た":["だ","け","げ","な","に"],
         "ち":["ぢ","う","ゔ","お","さ","ざ","つ","づ","ろ","を"],
         "つ":["づ","う","ゔ","く","ぐ","こ","ご","し","じ","ち","ぢ","の","ら","ろ","わ"],
         "て":["で","く","ぐ","こ","ご","そ","ぞ","ひ","び","ぴ","へ","べ","ぺ"],
         "と":["ど","く","ぐ","し","じ","を"],
         "だ":["た","け","げ","な","に"],
         "ぢ":["ち","う","ゔ","お","さ","ざ","つ","づ","ろ","を"],
         "づ":["つ","う","ゔ","く","ぐ","こ","ご","し","じ","ち","ぢ","の","ら","ろ","わ"],
         "で":["て","く","ぐ","こ","ご","そ","ぞ","ひ","び","ぴ","へ","べ","ぺ"],
         "ど":["と","く","ぐ","し","じ","を"],
         
         "な":["か","が","た","だ","は","ば","ぱ","ほ","ぼ","ぽ","む"],
         "に":["い","け","げ","こ","ご","た","だ","は","ば","ぱ"],
         "ぬ":["あ","お","の","め","る"],
         "ね":["お","ぬ","る","れ","わ"],
         "の":["あ","お","つ","づ","ぬ","め"],
         
         "は":["ば","ぱ","け","げ","な","に","ほ","ぼ","ぽ","ま"],
         "ひ":["び","ぴ","え","し","じ","て","で"],
         "ふ":["ぶ","ぷ","う","ゔ","か","が","て","で"],
         "へ":["べ","ぺ","く","ぐ"],
         "ほ":["ぼ","ぽ","け","げ","な","は","ば","ぱ","ま"],
         "ば":["は","ぱ","け","げ","な","に","ほ","ぼ","ぽ","ま"],
         "び":["ひ","ぴ","え","し","じ","て","で"],
         "ぶ":["ふ","ぷ","う","ゔ","か","が","て","で"],
         "べ":["へ","ぺ","く","ぐ"],
         "ぼ":["ほ","ぽ","け","げ","な","は","ば","ぱ","ま"],
         "ぱ":["ば","は","け","げ","な","に","ほ","ぼ","ぽ","ま"],
         "ぴ":["び","ひ","え","し","じ","て","で"],
         "ぷ":["ぶ","ふ","う","ゔ","か","が","て","で"],
         "ぺ":["べ","へ","く","ぐ"],
         "ぽ":["ぼ","ほ","け","げ","な","は","ば","ぱ","ま"],
         
         "ま":["お","き","ぎ","す","ず","は","ば","ぱ","ほ","ぼ","ぽ","も","よ"],
         "み":["お"],
         "む":["お","せ","ぜ","な"],
         "め":["あ","お","ぬ","の","ゆ","わ"],
         "も":["き","ぎ","し","じ","ま"],
         
         "や":["か","が","わ"],
         "ゆ":["か","が","め","わ"],
         "よ":["ま"],
         
         "ら":["う","ゔ","か","が","つ","づ","ろ","わ"],
         "り":["い","か","が","け","げ","こ","ご"],
         "る":["う","ゔ","え","そ","ぞ","ぬ","ね","ろ","わ"],
         "れ":["え","ね","わ","ん"],
         "ろ":["う","ゔ","え","そ","ぞ","ち","ぢ","つ","づ","ら","る","わ","を"],
         
         "わ":["え","お","か","が","つ","す","ね","め","や","ゆ","ら","る","れ","ろ"],
         "を":["そ","ぞ","ち","ぢ","と","ど","ろ"],
         "ん":["え","し","じ","れ"],
         "ー":[]]
    
    //        清音
    let lineWArray = ["わ","を","ん","っ","ー"]
    let lineRArray = ["ら","り","る","れ","ろ"]
    let lineYArray = ["や","","ゆ","","よ"]
    let lineMArray = ["ま","み","む","め","も"]
    let lineHArray = ["は","ひ","ふ","へ","ほ"]
    let lineNArray = ["な","に","ぬ","ね","の"]
    let lineTArray = ["た","ち","つ","て","と"]
    let lineSArray = ["さ","し","す","せ","そ"]
    let lineKArray = ["か","き","く","け","こ"]
    let lineAArray = ["あ","い","う","え","お"]
    //        濁音・半濁音
    let linePArray = ["ぱ","ぴ","ぷ","ぺ","ぽ"]
    let lineBArray = ["ば","び","ぶ","べ","ぼ"]
    let lineDArray = ["だ","ぢ","づ","で","ど"]
    let lineZArray = ["ざ","じ","ず","ぜ","ぞ"]
    let lineGArray = ["が","ぎ","ぐ","げ","ご"]
    let lineVArray = ["","","ゔ","",""]
    
    
    //        拗音
    let lineRYouonArray = ["りゃ","","りゅ","","りょ"]
    let lineMYouonArray = ["みゃ","","みゅ","","みょ"]
    let lineHYouonArray = ["ひゃ","","ひゅ","","ひょ"]
    let lineNYouonArray = ["にゃ","","にゅ","","にょ"]
    let lineTYouonArray = ["ちゃ","","ちゅ","","ちょ"]
    let lineSYouonArray = ["しゃ","","しゅ","","しょ"]
    let lineKYouonArray = ["きゃ","","きゅ","","きょ"]
    let lineUYouonArray = ["うぁ","うぃ","","うぇ","うぉ"]
    
    let linePYouonArray = ["ぴゃ","","ぴゅ","","ぴょ"]
    let lineBYouonArray = ["びゃ","","びゅ","","びょ"]
    let lineDYouonArray = ["ぢゃ","","ぢゅ","","ぢょ"]
    let lineZYouonArray = ["じゃ","","じゅ","","じょ"]
    let lineGYouonArray = ["ぎゃ","","ぎゅ","","ぎょ"]
    let lineVYouonArray = ["ゔぁ","ゔぃ","","ゔぇ","ゔぉ"]
    
    //        特殊拗音
    let lineHHYouonArray = ["ふぁ","ふぃ","","ふぇ","ふぉ"]
    let lineDDYouonArray = ["","でぃ","どぅ","ぢぇ",""]
    let lineTTYouonArray = ["","てぃ","とぅ","ちぇ","",]
    let lineZZYouonArray = ["","ずぃ","","じぇ",""]
    let lineSSYouonArray = ["","すぃ","","しぇ",""]
    
    var characterColorArray: [UIColor] = [UIColor.flatRed,UIColor.flatSkyBlue,UIColor.flatLime,UIColor.flatYellow,UIColor.flatMagenta,UIColor.flatRedDark,UIColor.flatSkyBlueDark,UIColor.flatLimeDark,UIColor.flatYellowDark,UIColor.flatMagentaDark]
    
    
    func lineDiscrimination(_ chara:String) -> Int{
        var character = ""
        
        if chara.count > 1{
            character = String(chara[chara.index(chara.startIndex, offsetBy: 0) ..< chara.index(chara.startIndex, offsetBy: 1)])
        }else{
            character = chara
        }
        
        if character.isLineA{
            return 0
        }else if character.isLineK{
            return 1
        }else if character.isLineS{
            return 2
        }else if character.isLineT{
            return 3
        }else if character.isLineN{
            return 4
        }else if character.isLineH{
            return 5
        }else if character.isLineM{
            return 6
        }else if character.isLineY{
            return 7
        }else if character.isLineR{
            return 8
        }else if character.isLineW{
            return 9
        }else{
            return 10
        }
    }
//    色分けメソッド
    func colorChange(_ chara:String) -> UIColor{
        
        let line = lineDiscrimination(chara)
        
        switch line {
        case 0:return UIColor.flatRed
        case 1:return UIColor.flatSkyBlue
        case 2:return UIColor.flatLime
        case 3:return UIColor.flatYellow
        case 4:return UIColor.flatMagenta
        case 5:return UIColor.flatRedDark
        case 6:return UIColor.flatSkyBlueDark
        case 7:return UIColor.flatLimeDark
        case 8:return UIColor.flatYellowDark
        case 9:return UIColor.flatMagentaDark
        default:return UIColor.flatBlack
        }
    }
    
//    似た文字を探すメソッド
    func searchSimilarCharacter(_ str:String) -> [String]{
        var strArray:[String] = []
        if str.count > 1{
            let s1 = String(str[str.index(str.startIndex, offsetBy: 0) ..< str.index(str.startIndex, offsetBy: 1)])
            let s2 = String(str[str.index(str.startIndex, offsetBy: 0) ..< str.index(str.startIndex, offsetBy: 1)])
            
            strArray = similarCharactersDic[s1]!
            let s2Array = similarCharactersDic[s2]!
            for str in s2Array{
                strArray.append(str)
            }
        }else{
            strArray = similarCharactersDic[str]!
        }
        
        return strArray
    }
//    選択肢候補を投げると、使用できる拗音が帰ってくる
    func usableYouonCheck(_ strArray:[String]) -> [String]{
        var returnArray:[String] =  []
        
        let youonArray:[String] = ["あ","い","う","え","お","や","ゆ","よ"]
        let youonDic:[String:[String]] =
            ["あ":["ふぁ","ゔぁ"],
             "い":["すぃ","ずぃ","てぃ","でぃ","ふぃ","うぃ","ゔぃ"],
             "う":["とぅ","どぅ"],
             "え":["しぇ","じぇ","ちぇ","ぢぇ","ふぇ","うぇ","ゔぇ"],
             "お":["ふぉ","うぉ","ゔぉ"],
             "や":["きゃ","ぎゃ","しゃ","じゃ","ちゃ","ぢゃ","にゃ","ひゃ","びゃ","ぴゃ","みゃ","りゃ"],
             "ゆ":["きゅ","ぎゅ","しゅ","じゅ","ちゅ","ぢゅ","にゅ","ひゅ","びゅ","ぴゅ","みゅ","りゅ"],
             "よ":["きょ","ぎょ","しょ","じょ","ちょ","ぢょ","にょ","ひょ","びょ","ぴょ","みょ","りょ"]]
        
//        選択肢候補の中に拗音Arrayの文字があるかチェック
        for youon in youonArray{
            if !strArray.filter({ $0 == youon}).isEmpty{
//                あれば、その小文字を使う拗音の最初の一文字は入っているかチェック
                for character in youonDic[youon]!{
                    let c1 = String(character[character.index(character.startIndex, offsetBy: 0) ..< character.index(character.startIndex, offsetBy: 1)])
//                    あれば入れる
                    if !strArray.filter({ $0 == c1}).isEmpty{
                        returnArray.append(character)
                    }
                }
            }
        }
        return returnArray
    }
    
//    ターゲット単語をランダムに選ぶ
    func selectTarget(_ cardDataArray:[CardData]) -> CardData{
        let randomNumber = Int(arc4random_uniform(UInt32(cardDataArray.count)))
        let targetCD = cardDataArray[randomNumber]
        
        return targetCD
    }

//    選択肢候補を絞るメソッド
    func downselect(_ answerArray:[String], _ useSimilarBool:Bool,_ useDakuonBool:Bool,_ useYouonBool:Bool) -> [String]{
        var returnArray:[String] = simpleCharacters
        
        //        濁音を使う場合は、濁音を追加
        if useDakuonBool{
            for d in dakuonCharacters{
                returnArray.append(d)
            }
        }
        //        似た文字を使わない場合は、選択肢候補から外す
        if !useSimilarBool{
            for answer in answerArray{
                let similarArray:[String] = searchSimilarCharacter(answer)
                if !similarArray.isEmpty{
                    for similarC in similarArray{
                        if let removeIndex = returnArray.index(of: similarC){
                            returnArray.remove(at: removeIndex)
                        }
                    }
                }
            }
        }
        //        拗音を使う場合は選択肢候補に追加
        if useYouonBool{
            let usableYouonArray = usableYouonCheck(returnArray)
            for youonC in usableYouonArray{
                returnArray.append(youonC)
            }
        }
        //        answerは選択肢の中に必ず入れるため、選択肢候補からははずす
        for character in answerArray{
            if let removeCharacterIndex = returnArray.index(of: character){
                returnArray.remove(at: removeCharacterIndex)
            }
        }
        //        選択肢候補が何もなくなった場合は、清音を全て渡す
        if returnArray.isEmpty{
            returnArray = simpleCharacters
        }
        
        return returnArray
    }
    
//    選択肢の抽出メソッド
    func extractCharacter(_ choicesArray:[String],_ answer:[String],_ amountOfChoices:Int) -> [String]{
        var returnArray:[String] = []
        var array: [String] = answer
        
        var strArray = choicesArray
        
        for _ in 0 ..< amountOfChoices{
            let i = Int(arc4random_uniform(UInt32(strArray.count)))
            array.append(strArray[i])
            strArray.remove(at: i)
            if array.count == 10{
                break
            }
        }
        //        ランダム配列
        for _ in 0 ..< array.count{
            let i = Int(arc4random_uniform(UInt32(array.count)))
            returnArray.append(array[i])
            array.remove(at: i)
        }
        return returnArray
    }
    
//    位置の計算メソッド
    func calculateRectForChoices(_ choices:Int,_ space:CGRect) -> [CGRect]{
        var returnArray: [CGRect] = []
        if choices < 6{
            for i in 0 ..< choices{
                let interval = space.width / CGFloat(choices + 1)
                
                let width = space.height * 2/3
                let height = space.height * 2/3
                let x = interval - (width / 2) + (interval * CGFloat(i))
                let y = (space.height / 2) - (height / 2)
                let rect = CGRect(x: x, y: y, width: width, height: height)
                returnArray.append(rect)
            }
        }else{
            for i in 0 ..< choices{
                let lines = Int(ceil(CGFloat(choices) / 2.0))
                let interval = space.width / CGFloat(lines + 1)
                
                let width = space.height * 1/2
                let height = space.height * 1/2
                var x:CGFloat = 0.0
                var y:CGFloat = 0.0
                if i < lines{
                    x = interval - (width / 2) - (interval / 4) + interval * CGFloat(i)
                    y = 0.0
                }else{
                    x = interval - (width / 2) + (interval / 4) + interval * CGFloat(i - lines)
                    y = space.height * 1/2
                }
                let rect = CGRect(x: x, y: y, width: width, height: height)
                returnArray.append(rect)
            }
        }
        return returnArray
    }
    
//    正解文字の出現位置の計算メソッド
    func calculateRectForAnswer(_ answerCharacterArray:[String],_ space:CGRect) -> [CGRect]{
        var returnArray: [CGRect] = []
        
        let width = space.height * 2/3
        let height = space.height * 2/3
        for i in 0 ..< answerCharacterArray.count{
                let interval = space.width / CGFloat(answerCharacterArray.count + 1)
                
                let x = interval - (width / 2) + (interval * CGFloat(i))
                let y = (space.height / 2) - (height / 2)
                let rect = CGRect(x: x, y: y, width: width, height: height)
                returnArray.append(rect)
            }

        return returnArray
    }
    
//    外枠のサイズ計算
    func answerFrameSize(_ answerSize:CGSize) -> CGSize{
        let side = answerSize.width * 1.2
        
        let size = CGSize(width: side, height: side)
        return size
    }
    
//    正誤判定
    func judge(_ answer:String,_ choice:String) -> Bool{
        if answer == choice{
            return true
        }else{
            return false
        }
    }
    
    func StringSize(_ view:UIView) -> UIFont{
        let returnFont: UIFont!
        
        switch view.frame.width {
        case 0 ... 568:
            returnFont = UIFont(name: "Hiragino Maru Gothic ProN", size: 23)
        default:
            returnFont = UIFont(name: "Hiragino Maru Gothic ProN", size: 30)
        }
        
        return returnFont
    }
    
    func extractSyllabaryLines(_ answerCharacterArray:[String]) -> [Int]{
        var intArray:[Int] = []

        //        使用する行指定のためのプロパティ
        var useCharacterArray:[String] = []
        let syllabaryLevel = UserDefaults.standard.integer(forKey: Constants.syllabaryLevelKey)
        
        //        拗音を清音に変換
        for chara in answerCharacterArray{
            if chara.count > 1{
                let chara1 = String(chara[chara.index(chara.startIndex, offsetBy: 0) ..< chara.index(chara.startIndex, offsetBy: 1)])
                useCharacterArray.append(chara1)
            }else{
                useCharacterArray.append(chara)
            }
        }
        
        switch syllabaryLevel {
        case 0:
            for chara in answerCharacterArray{
                let lineInt = lineDiscrimination(chara)
                intArray.append(lineInt)
            }
        case 1:
            let syllabaryLines = UserDefaults.standard.integer(forKey: Constants.syllabaryLinesKey)
            var array = [0,1,2,3,4,5,6,7,8,9]
            for chara in answerCharacterArray{
                let lineInt = lineDiscrimination(chara)
                intArray.append(lineInt)
                array.remove(value: lineInt)
            }
            for _ in 0 ... syllabaryLines{
                if array.isEmpty{break}
                let randomInt = Int(arc4random_uniform(UInt32(array.count)))
                let lineInt = array[randomInt]
                intArray.append(lineInt)
                array.remove(value: lineInt)
                print(array)
            }
        case 2:
            for lineInt in 0 ... 9{
                intArray.append(lineInt)
            }
        default:break
        }
        let orderedSet:NSOrderedSet = NSOrderedSet(array: intArray)
        intArray = orderedSet.array as! [Int]
        intArray.sort(by: {$0 < $1})
        
        return intArray
    }
    
    func syllabaryTypeChange(_ boolArray:[Bool]) -> [Int:[String]]{
        let lineSeionDic:[Int:[String]] = [0:lineAArray,1:lineKArray,2:lineSArray,3:lineTArray,4:lineNArray,5:lineHArray,6:lineMArray,7:lineYArray,8:lineRArray,9:lineWArray]
        
        let lineDakuonDic:[Int:[String]] = [0:lineVArray,1:lineGArray,2:lineZArray,3:lineDArray,4:[],5:lineBArray,6:[],7:[],8:[],9:[]]
        
        let lineHandakuonDic:[Int:[String]] = [0:[],1:[],2:[],3:[],4:[],5:linePArray,6:[],7:[],8:[],9:[]]
        
        let lineYouonDic:[Int:[String]] = [0:lineUYouonArray,1:lineKYouonArray,2:lineSYouonArray,3:lineTYouonArray,4:lineNYouonArray,5:lineHYouonArray,6:lineMYouonArray,7:[],8:lineRYouonArray,9:[]]
        
        let lineYouonDakuonDic:[Int:[String]] = [0:lineVYouonArray,1:lineGYouonArray,2:lineZYouonArray,3:lineDYouonArray,4:[],5:lineBYouonArray,6:[],7:[],8:[],9:[]]
        
        let lineYouonHandakuonDic:[Int:[String]] = [0:[],1:[],2:[],3:[],4:[],5:linePYouonArray,6:[],7:[],8:[],9:[]]
        
        let lineSpecialYouonDic:[Int:[String]] = [0:[],1:lineSSYouonArray,2:lineZZYouonArray,3:lineTTYouonArray,4:lineDDYouonArray,5:lineHHYouonArray,6:[],7:[],8:[],9:[]]
        
        //        使用するDicを指定
        var useDic:[Int:[String]] = [:]
        switch boolArray{
        //[濁音、半濁音、拗音、特殊音節]
        case [false,false,false,false]:useDic = lineSeionDic
        case [true,false,false,false]:useDic = lineDakuonDic
        case [false,true,false,false]:useDic = lineHandakuonDic
        case [false,false,true,false]:useDic = lineYouonDic
        case [false,false,false,true]:useDic = lineSpecialYouonDic
        case [true,false,true,false]:useDic = lineYouonDakuonDic
        case [false,true,true,false]:useDic = lineYouonHandakuonDic
        default:break
        }
        
        return useDic
    }
    
    func syllabaryMake(_ view:UIView,_ useColorHintBool:Bool,_ useLineArray:[Int],_ boolArray:[Bool]) -> [UIButton]{

        let width = view.frame.width / 11
        let height = view.frame.height / 5
        
        let useDic = syllabaryTypeChange(boolArray)
        let lineSpecialYouonDic:[Int:[String]] = [0:[],1:lineSSYouonArray,2:lineZZYouonArray,3:lineTTYouonArray,4:lineDDYouonArray,5:lineHHYouonArray,6:[],7:[],8:[],9:[]]
        
        var array:[Int] = []
        
        if useDic == lineSpecialYouonDic{
            if useLineArray.contains(2){
                array.append(1)
                array.append(2)
            }else if useLineArray.contains(3){
                array.append(3)
                array.append(4)
            }else if useLineArray.contains(5){
                array.append(5)
            }
        }else{array = useLineArray}
            
        var buttonArray:[UIButton] = []
//        使用する行のArrayからbuttonを作成
        for lineInt in array{
            let syllabaryLineArray = useDic[lineInt]!
            for i in 0 ..< syllabaryLineArray.count{
                let x = width * CGFloat(10 - lineInt)
                let y = height * CGFloat(i)
                let button = UIButton(frame: CGRect(x: x, y: y, width: width, height: height))
                button.backgroundColor = UIColor.groupTableViewBackground
                button.setBackgroundColor(UIColor.flatGray, for: .highlighted)
                let bool = UserDefaults.standard.bool(forKey: Constants.HiraganaKey)
                let title = syllabaryLineArray[i].katakanaToHiragana(bool)
                button.setTitle(title, for: .normal)
                if useColorHintBool{
                    button.setTitleColor(colorChange(syllabaryLineArray[i]), for: .normal)
                }else{
                    button .setTitleColor(UIColor.flatBlack, for: .normal)
                }
                buttonArray.append(button)
            }
        }
        return buttonArray
    }
}

