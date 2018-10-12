//
//  SyllabaryViewController.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/06.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit

class SyllabaryViewController: UIViewController, SideMenuDelegete, SwitchControlDelegate  {
    
    @IBOutlet weak var problemNumberLabel: UILabel!
    @IBOutlet weak var openMenuButton: UIButton!
    @IBOutlet weak var answerImageView: UIImageView!
    @IBOutlet weak var answerView: UIView!
    @IBOutlet weak var syllabaryView: UIView!
    
    @IBOutlet weak var seionButton: UIButton!
    @IBOutlet weak var dakuonButton: UIButton!
    @IBOutlet weak var handakuonButton: UIButton!
    @IBOutlet weak var youonButton: UIButton!
    @IBOutlet weak var specialYouonButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    
    
    var choiceLevel = 0
    var cardDataArray: [CardData]!
    var currentCDArray: [CardData]!
    
    var answerCD: CardData!
    var answerCharacterArray: [String]!
    var answerCharacter:String!
    var positionOfAnswerCharacters: [CGRect]!
    var answerImage: UIImage!
    var optionsArray: [String]!
    var choicesArray: [String]!
    var positionOfChoices: [CGRect]!
    
    var answerLabelArray: [UILabel] = []
    var answerFrame = UIView()
    var hintView: UIView!
    var useLineArray:[Int] = []
    var syllabaryArray: [UIButton] = []
    var specialButtonArray:[UIButton] = []
    var specialSyllableBool:[Bool] = [false,false,false,false]
    var answerCount = 0
    
    var userDefaults = UserDefaults.standard
    var HiraganaKatakanaBool:Bool!
    var characterShowUpBool:Bool!
    var useColorHintBool:Bool!
    
    var completionView: CompletionView!
    
    var problemNumber = 10
    
    var totalCharacterCount = 0
    var perfectAnswerCount = 0
    var currentPerfectCount = 0
    var perfectAnswerBool = true
    var newProblemBool = true
    
    let gameSystem = GameSystem().self
    let switchKey = UserDefaults.standard.integer(forKey: Constants.SwitchKey)
    var switchControl: SwitchControlSystem!
    var cursorLinesArray:[CGRect] = []
    var selectLineInt = 100
    
    
    var VS:VisualSetting!
    var SE:SoundEffect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetting()
        SE = SoundEffect.sharedSoundEffect
        
        HiraganaKatakanaBool = userDefaults.bool(forKey: Constants.HiraganaKey)
        characterShowUpBool = userDefaults.bool(forKey: Constants.characterShowUpKey)
        useColorHintBool = userDefaults.bool(forKey: Constants.useColorHintKey)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentCDArray = cardDataArray
        problemSetting()
        answerSetting()
        syllabarySetting()
        problemNumberLabel.text = "あと\(problemNumber)問"
        if switchKey > 0 && switchControl == nil{
            switchControl = SwitchControlSystem(switchKey, cursorLinesArray, self.view, self.view)
            switchControl.delegate = self
        }else{
            backButton.isHidden = true
        }
    }
    
    func layoutSetting(){
        VS = VisualSetting()
        VS.backgraundView(self.view)
        openMenuButton.backgroundColor = UIColor.clear
        problemNumberLabel.font = VS.fontAdjust(viewSize: .verySmall)
        answerView.layer.cornerRadius = VS.cornerRadiusAdjust(answerView.frame.size, type: .circle)
        specialButtonArray = [seionButton,dakuonButton,handakuonButton,youonButton,specialYouonButton]
        for button in specialButtonArray{
            button.titleLabel?.font = VS.fontAdjust(viewSize: .verySmall)
            button.titleLabel?.numberOfLines = 2
            button.titleLabel?.textAlignment = NSTextAlignment.center
            button.layer.borderWidth = 1.0
            button.layer.borderColor = VS.normalOutletColor.cgColor
            button.setBackgroundColor(UIColor.flatWhite, for: .normal)
            button.setTitleColor(VS.normalOutletColor, for: .normal)
            button.setBackgroundColor(VS.normalOutletColor, for: .selected)
            button.setTitleColor(UIColor.flatWhite, for: .selected)
        }
        backButton.titleLabel?.font = VS.fontAdjust(viewSize: .verySmall)
        
        openMenuButton.imageFit()
    }
        
    func problemSetting(){
        answerCD = gameSystem.selectTarget(currentCDArray)
        answerCharacterArray = answerCD.characterInWord
        answerImage = answerCD.image
        positionOfAnswerCharacters = gameSystem.calculateRectForAnswer(answerCD.characterInWord, answerView.frame)
        answerImageView.image = answerImage
        answerImageView.contentMode = UIViewContentMode.scaleAspectFit
        perfectAnswerBool = true
        answerCount = 0
    }
    
    func answerSetting(){
        answerCharacter = answerCharacterArray[0]
        
        let label = UILabel(frame: positionOfAnswerCharacters[0])
        let title = answerCharacter.katakanaToHiragana(HiraganaKatakanaBool)
        label.text = title
        label.font = VS.fontAdjust(viewSize: .veryImportant)
        label.textAlignment = NSTextAlignment.center
        label.adjustsFontSizeToFitWidth = true
        if useColorHintBool{
            label.textColor = gameSystem.colorChange(answerCharacter!)
        }else{
            label.textColor = UIColor.black
        }
        label.backgroundColor = UIColor.clear
        answerView.addSubview(label)
        
        answerFrame.frame.size = gameSystem.answerFrameSize(label.frame.size)
        answerFrame.center = label.center
        answerFrame.layer.cornerRadius = 5.0
        answerFrame.layer.borderWidth = 2.0
        answerFrame.layer.borderColor = UIColor.flatYellow.cgColor
        answerView.insertSubview(answerFrame, belowSubview: label)
        
        if !characterShowUpBool{
            hintView = UIView(frame: positionOfAnswerCharacters[0])
            hintView.backgroundColor = answerView.backgroundColor
            answerView.addSubview(hintView)
        }
    }
    
    func syllabarySetting(){
        if useLineArray.isEmpty{
            useLineArray = gameSystem.extractSyllabaryLines(answerCharacterArray)
            specialSyllableBool = [false,false,false,false]
            for button in specialButtonArray{
                if button == seionButton{
                    button.isSelected = true
                }else{
                    button.isSelected = false
                }
            }
        }
        
        syllabaryArray = gameSystem.syllabaryMake(syllabaryView, useColorHintBool, useLineArray, specialSyllableBool)
        for button in syllabaryArray{
            button.titleLabel?.font = VS.fontAdjust(viewSize: .normal)
            button.addTarget(self, action: #selector(buttonTaped(_:)), for: .touchUpInside)
            syllabaryView.addSubview(button)
            if button.titleLabel?.text == ""{
                syllabaryArray.remove(value: button)
            }
        }
        
        lineCursorMake()
    }
    
    //    SideMenuDelegete
    func changeProblem() {
        answerCharacterArray.remove(at: 0)
        positionOfAnswerCharacters.remove(at: 0)
        
        let syllabarySubviews = syllabaryView.subviews
        for subview in syllabarySubviews{
            subview.removeFromSuperview()
        }
        
        let answerSubviews = answerView.subviews
        for subview in answerSubviews{
            subview.removeFromSuperview()
        }
        problemSetting()
        useLineArray.removeAll()
        answerSetting()
        syllabarySetting()
    }
    
    @IBAction func syllabaryChange(_ sender: UIButton) {
        if sender == seionButton{
            for i in 0 ..< specialButtonArray.count - 1{
                let button = specialButtonArray[i + 1]
                button.isSelected = false
                specialSyllableBool[i] = false
            }
            sender.isSelected = true
        }else{
            seionButton.isSelected = false
            switch sender.tag {
            case 0:
                handakuonButton.isSelected = false
                specialSyllableBool[1] = false
                specialYouonButton.isSelected = false
                specialSyllableBool[3] = false
            case 1:
                dakuonButton.isSelected = false
                specialSyllableBool[0] = false
                specialYouonButton.isSelected = false
                specialSyllableBool[3] = false
            case 2:
                specialYouonButton.isSelected = false
                specialSyllableBool[3] = false
            case 3:
                dakuonButton.isSelected = false
                specialSyllableBool[0] = false
                handakuonButton.isSelected = false
                specialSyllableBool[1] = false
                youonButton.isSelected = false
                specialSyllableBool[2] = false
            default:break
            }
            
            sender.isSelected = !sender.isSelected
            specialSyllableBool[sender.tag] = sender.isSelected
            if specialSyllableBool == [false,false,false,false]{
                seionButton.isSelected = true
            }
        }
        let syllabarySubviews = syllabaryView.subviews
        for subview in syllabarySubviews{
            subview.removeFromSuperview()
        }
        syllabarySetting()
    }
    
    @objc func buttonTaped(_ sender:UIButton){
        judge((sender.titleLabel?.text)!)
    }
    func judge(_ selectChara:String){
        let answer = answerCharacter.katakanaToHiragana(HiraganaKatakanaBool)
        if gameSystem.judge(answer, selectChara){
            if perfectAnswerBool && newProblemBool{
                currentPerfectCount += 1
            }
            perfectAnswerBool = true
            
            if !characterShowUpBool{
                hintView.removeFromSuperview()
            }
            
            answerCharacterArray.remove(at: 0)
            positionOfAnswerCharacters.remove(at: 0)
            
            if answerCharacterArray.isEmpty{//単語完成
                SE.play(.fanfare)
                if newProblemBool{
                    totalCharacterCount += answerCD.characterInWord.count
                    perfectAnswerCount += currentPerfectCount
                    problemNumber -= 1
                }
                currentPerfectCount = 0
                print("問題文字数：\(totalCharacterCount)　正解文字数：\(perfectAnswerCount)")
                let syllabarySubviews = syllabaryView.subviews
                for subview in syllabarySubviews{
                    subview.removeFromSuperview()
                }
                
                let answerSubviews = answerView.subviews
                for subview in answerSubviews{
                    subview.removeFromSuperview()
                }
                
                completionView = CompletionView(frame: CGRect(x: 0.0, y: 0.0, width: 350, height: 250))
                completionView.frame.size = VS.completionViewSetting(self)
                completionView.center = self.view.center
                completionView.image.image = answerImage
                completionView.image.contentMode = UIViewContentMode.scaleAspectFit
                completionView.label.text = answerCD.word.katakanaToHiragana(HiraganaKatakanaBool)
                if problemNumber == 0{
                    completionView.nextProblemButton.setTitle("おしまい！", for: .normal)
                }
                completionView.sameProblemButton.addTarget(self, action: #selector(sameProblem), for: .touchUpInside)
                completionView.nextProblemButton.addTarget(self, action: #selector(nextProblem), for: .touchUpInside)
                self.view.addSubview(completionView)
                if switchControl != nil{
                    var cgRectArray:[CGRect] = []
                    cgRectArray.append(completionView.sameProblemButton.frame)
                    cgRectArray.append(completionView.nextProblemButton.frame)
                    switchControl.resetCursor(cgRectArray, completionView)
                }
            }else{//まだ文字が残ってる場合
                SE.play(.correct)
                answerSetting()
                if switchControl != nil{
                    lineCursorMake()
                }
            }
        }else{ //間違えた場合
            SE.play(.incorrect)
            perfectAnswerBool = false
            if !characterShowUpBool && hintView.frame.height >= 1.0{
                hintView.frame.size.height -= positionOfAnswerCharacters[0].height / 3
            }
            if switchControl != nil{
                lineCursorMake()
            }
        }
    }
    
    @objc func sameProblem(){
        SE.play(.same)
        newProblemBool = false
        answerCharacterArray = answerCD.characterInWord
        answerImage = answerCD.image
        positionOfAnswerCharacters = gameSystem.calculateRectForAnswer(answerCD.characterInWord, answerView.frame)
        answerImageView.image = answerImage
        
        answerSetting()
        syllabarySetting()
        completionView.removeFromSuperview()
    }
    
    @objc func nextProblem(){
        SE.play(.next)
        completionView.removeFromSuperview()
        useLineArray.removeAll()
        if problemNumber == 0{
            performSegue(withIdentifier: "toResult", sender: nil)
        }else{
            newProblemBool = true
            currentCDArray.remove(value: answerCD)
            problemNumberLabel.text = "あと\(problemNumber)問"
            problemSetting()
            answerSetting()
            syllabarySetting()
        }
    }
    
    @IBAction func openMenu(_ sender: Any) {
        openRight()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResult"{
            let resultVC = segue.destination as! ResultViewController
            resultVC.totalCharacterCount = self.totalCharacterCount
            resultVC.perfectAnswerCount = self.perfectAnswerCount
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToSyllabary(segue:UIStoryboardSegue){
    }
    
//    switchControl設定
    
    func decisionKeyPushed(_ cursorNumber: Int) {
        if answerCharacterArray.isEmpty{
            if cursorNumber == 0{
                sameProblem()
            }else{
                nextProblem()
            }
        }else if selectLineInt == 100{
            selectLineInt = cursorNumber
            characterCursorMake(cursorLinesArray[selectLineInt])
        }else{
            if cursorNumber == 5{
                lineCursorMake()
            }else{
                if selectLineInt == cursorLinesArray.count - 1{
                    syllabaryChange(specialButtonArray[cursorNumber])
                    lineCursorMake()
                }else{
                    let selectCharacter = characterChoice(cursorNumber)
                    if selectCharacter != ""{
                        judge(selectCharacter)
                    }
                }
            }
        }
    }
    
    func lineCursorMake(){
        selectLineInt = 100
        cursorLinesArray.removeAll()
        var cgRect = syllabaryView.frame
        cgRect.size.width = syllabaryView.frame.width / 11
        let startX = syllabaryView.frame.origin.x
        for lineInt in useLineArray{
            cgRect.origin.x = startX + cgRect.width * CGFloat(10 - lineInt)
            cursorLinesArray.append(cgRect)
        }
        cgRect.origin.x = startX
        cursorLinesArray.append(cgRect)
        if switchControl != nil{
            switchControl.resetCursor(cursorLinesArray, self.view)
        }
    }
    
    func characterCursorMake(_ rect:CGRect){
        var cgRectArray:[CGRect] = []
        var cgRect = rect
        cgRect.size.height = rect.height / 5
        for i in 0 ..< 5{
            cgRect.origin.y = syllabaryView.frame.origin.y + cgRect.height * CGFloat(i)
            cgRectArray.append(cgRect)
        }
        cgRectArray.append(backButton.frame)
        
        switchControl.resetCursor(cgRectArray, self.view)
    }
    
    func characterChoice(_ selectInt:Int) -> String{
        let syllabaryTypeDic = gameSystem.syllabaryTypeChange(specialSyllableBool)
        let lineInt = useLineArray[selectLineInt]
        let line = syllabaryTypeDic[lineInt]
        
        let str = line![selectInt]
        print(str)
        return str
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
