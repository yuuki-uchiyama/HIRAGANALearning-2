//
//  Layout.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/26.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework

class VisualSetting{
    
    enum size{
        case veryImportant
        case important
        case normal
        case small
        case verySmall
        case sentence
    }
    
    enum cornerType{
        case small
        case normal
        case circle
    }
    
    var baseColor: UIColor!
    var borderColor: UIColor!
    var normalOutletColor: UIColor!
    var importantOutletColor: UIColor!
    
    var viewScale = 0
    
    init() {
        switch UIScreen.main.bounds.width{
//            SE
        case 0.0 ..< 570.0: viewScale = 10
//            6,6S,7,8
        case 570.0 ..< 670.0:viewScale = 20
//            6+,6S+,7+,8+
        case 670.0 ..< 740.0:viewScale = 30
//            X,XS,XR
        case 740.0 ..< 900.0:viewScale = 40
//            iPad
        case 900.0 ..< 1200.0:viewScale = 50
        default:viewScale = 60
        }
        colorSetting()
    }

    func colorSetting(){
        if UserDefaults.standard.bool(forKey: Constants.HiraganaKey){
            baseColor = UIColor.flatSandDark
            borderColor = UIColor.flatOrange
            let outletColors = ColorSchemeOf(.triadic, color: baseColor, isFlatScheme: true)
            normalOutletColor = outletColors[1]
            importantOutletColor = UIColor.flatWatermelonDark
        }else{
            baseColor = UIColor.flatPowderBlueDark
            borderColor = UIColor.flatBlue
            let outletColors = ColorSchemeOf(.triadic, color: baseColor, isFlatScheme: true)
            normalOutletColor = outletColors[4]
            importantOutletColor = UIColor.flatWatermelon
        }
    }
    
    func backgraundView(_ view:UIView){
        let aspectRate = UIScreen.main.bounds.width / UIScreen.main.bounds.height
        if aspectRate > 2.0{
            view.layer.cornerRadius = 40.0
        }else{
            view.layer.cornerRadius = 2.0
        }
        view.layer.borderWidth = view.frame.height / 40
        view.backgroundColor = baseColor
        view.layer.borderColor = borderColor.cgColor
    }
    
    func sizeCalculate(_ size:size) -> Int{
        var sizeInt = viewScale
        switch size {
        case .sentence:sizeInt += 0
        case .verySmall:sizeInt += 1
        case .small:sizeInt += 2
        case .normal:sizeInt += 3
        case .important:sizeInt += 4
        case .veryImportant:sizeInt += 5
        }
        return sizeInt
    }
    
    func fontAdjust(viewSize:size) -> UIFont{
        let sizeInt = sizeCalculate(viewSize)
        
        switch sizeInt {
        case 10:return UIFont(name: "Hiragino Maru Gothic ProN", size: 10)!
        case 11:return UIFont(name: "Hiragino Maru Gothic ProN", size: 13)!
        case 12:return UIFont(name: "Hiragino Maru Gothic ProN", size: 15)!
        case 13:return UIFont(name: "Hiragino Maru Gothic ProN", size: 23)!
        case 14:return UIFont(name: "Hiragino Maru Gothic ProN", size: 28)!
        case 15:return UIFont(name: "Hiragino Maru Gothic ProN", size: 35)!
        case 20:return UIFont(name: "Hiragino Maru Gothic ProN", size: 11)!
        case 21:return UIFont(name: "Hiragino Maru Gothic ProN", size: 16)!
        case 22:return UIFont(name: "Hiragino Maru Gothic ProN", size: 18)!
        case 23:return UIFont(name: "Hiragino Maru Gothic ProN", size: 27)!
        case 24:return UIFont(name: "Hiragino Maru Gothic ProN", size: 33)!
        case 25:return UIFont(name: "Hiragino Maru Gothic ProN", size: 42)!
        case 30:return UIFont(name: "Hiragino Maru Gothic ProN", size: 12)!
        case 31:return UIFont(name: "Hiragino Maru Gothic ProN", size: 17)!
        case 32:return UIFont(name: "Hiragino Maru Gothic ProN", size: 20)!
        case 33:return UIFont(name: "Hiragino Maru Gothic ProN", size: 27)!
        case 34:return UIFont(name: "Hiragino Maru Gothic ProN", size: 35)!
        case 35:return UIFont(name: "Hiragino Maru Gothic ProN", size: 50)!
        case 40:return UIFont(name: "Hiragino Maru Gothic ProN", size: 14)!
        case 41:return UIFont(name: "Hiragino Maru Gothic ProN", size: 20)!
        case 42:return UIFont(name: "Hiragino Maru Gothic ProN", size: 22)!
        case 43:return UIFont(name: "Hiragino Maru Gothic ProN", size: 31)!
        case 44:return UIFont(name: "Hiragino Maru Gothic ProN", size: 33)!
        case 45:return UIFont(name: "Hiragino Maru Gothic ProN", size: 40)!
        case 50:return UIFont(name: "Hiragino Maru Gothic ProN", size: 18)!
        case 51:return UIFont(name: "Hiragino Maru Gothic ProN", size: 24)!
        case 52:return UIFont(name: "Hiragino Maru Gothic ProN", size: 30)!
        case 53:return UIFont(name: "Hiragino Maru Gothic ProN", size: 42)!
        case 54:return UIFont(name: "Hiragino Maru Gothic ProN", size: 56)!
        case 55:return UIFont(name: "Hiragino Maru Gothic ProN", size: 70)!
        case 60:return UIFont(name: "Hiragino Maru Gothic ProN", size: 18)!
        case 61:return UIFont(name: "Hiragino Maru Gothic ProN", size: 30)!
        case 62:return UIFont(name: "Hiragino Maru Gothic ProN", size: 34)!
        case 63:return UIFont(name: "Hiragino Maru Gothic ProN", size: 42)!
        case 64:return UIFont(name: "Hiragino Maru Gothic ProN", size: 65)!
        case 65:return UIFont(name: "Hiragino Maru Gothic ProN", size: 70)!
        default:return UIFont(name: "Hiragino Maru Gothic ProN", size: 15)!
        }
    }
    
    func fontAdjustOfSegmentedControl(_ SC:UISegmentedControl,_ viewSize:size){
        let font = fontAdjust(viewSize: viewSize)
        
        let stringAttributes: [NSAttributedStringKey : UIFont] = [.font:font]
        
        SC.setTitleTextAttributes(stringAttributes, for: .normal)
        SC.layer.cornerRadius = 5
        SC.clipsToBounds = true
        SC.tintColor = normalOutletColor
    }
    
    func cornerRadiusAdjust(_ size:CGSize,type:cornerType) -> CGFloat{
        switch type {
        case .small:
            return size.height / 6.0
        case .normal:
            return size.height / 4.0
        case .circle:
            return size.height / 2.0
        }
    }
    
    func borderMake(view:UIView,side:CGFloat,color:UIColor){
        view.layer.borderWidth = side / 100
        view.layer.borderColor = color.cgColor
    }
    
    func completionViewSetting(_ VC:UIViewController) -> CGSize{
        let aspectRate:CGFloat = 350 / 250
        var height = VC.view.frame.height * 2/3
        let deviceAspect = UIScreen.main.bounds.width / UIScreen.main.bounds.height
        if deviceAspect > 2.0{
            height = VC.view.frame.height * 4/5
        }
        
        let width = height * aspectRate
        
        return CGSize(width: width, height: height)
        
    }
}
