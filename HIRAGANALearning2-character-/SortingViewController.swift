//
//  SortingViewController.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/06.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit

class SortingViewController: UIViewController, SideMenuDelegete, SwitchControlDelegate  {

    
    
    @IBOutlet weak var problemNumberLabel: UILabel!
    @IBOutlet weak var openMenuButton: UIButton!
    @IBOutlet weak var answerImageView: UIImageView!
    @IBOutlet weak var answerView: UIView!
    @IBOutlet weak var choicesView: UIView!
    
    var cardDataArray: [CardData]!
    var currentCDArray: [CardData]!
    
    var startChoiceLabel:UILabel!
    var startAnswerLabel:UILabel!
    var startTapImageView:UIImageView!
    
    var answerCD: CardData!
    var answerCharacterArray: [String]!
    var positionOfAnswerCharacters: [CGRect]!
    var hintView: UIView!
    var answerImage: UIImage!
    
    var optionsArray: [String]!
    var choicesArray: [String]!
    var amountOfChoices:Int!
    var positionOfChoices: [CGRect]!
    var selectViewRect = CGRect()
    
    var answerLabelArray: [UILabel] = []
    var answerFrameArray: [UIView] = []
    var hintViewArray: [UIView] = []
    var choicesLabelArray: [UILabel] = []
    var answerCount = 0
    
    var userDefaults = UserDefaults.standard
    var HiraganaKatakanaBool:Bool!
    var characterShowUpBool:Bool!
    var useSimilarBool:Bool!
    var useDakuonBool:Bool!
    var useYouonBool:Bool!
    var useColorHintBool:Bool!
    var amountLevel:Int!
    var gameLevel:Int!
    
    var completionView: CompletionView!
    
    var problemNumber = 10
    
    var totalCharacterCount = 0
    var perfectAnswerCount = 0
    var perfectAnswerBool = true
    var newProblemBool = true
    
    var gameSystem:GameSystem!
    let switchKey = UserDefaults.standard.integer(forKey: Constants.SwitchKey)
    var switchControl: SwitchControlSystem!
    var answerCursorArray:[CGRect] = []
    var choicesCursorArray:[CGRect] = []
    var selectCursorView = UIView()
    var selectLabel: UILabel!
    var selectLabelIndex = 100
    
    
    var VS:VisualSetting!
    var SE:SoundEffect!
    
    var coverView:UIView!
    var helpImageView:UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetting()
        SE = SoundEffect.sharedSoundEffect
        
        HiraganaKatakanaBool = userDefaults.bool(forKey: Constants.HiraganaKey)
        characterShowUpBool = userDefaults.bool(forKey: Constants.characterShowUpKey)
        useSimilarBool = userDefaults.bool(forKey: Constants.useSimilarKey)
        useDakuonBool = userDefaults.bool(forKey: Constants.useDakuonKey)
        useYouonBool = userDefaults.bool(forKey: Constants.useYouonKey)
        useColorHintBool = userDefaults.bool(forKey: Constants.useColorHintKey)
        amountLevel = userDefaults.integer(forKey: Constants.amountLevelKey)
        gameLevel = userDefaults.integer(forKey: Constants.gameLevelKey)
        
        gameSystem = GameSystem()
        amountOfChoices = gameSystem.amountCalcurate(amountLevel, gameLevel)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startUp()
    }
    
    func layoutSetting(){
        VS = VisualSetting()
        VS.backgraundView(self.view)
        openMenuButton.backgroundColor = UIColor.clear
        problemNumberLabel.font = VS.fontAdjust(viewSize: .verySmall)
        answerView.layer.cornerRadius = VS.cornerRadiusAdjust(answerView.frame.size, type: .circle)
        choicesView.layer.cornerRadius = VS.cornerRadiusAdjust(choicesView.frame.size, type: .circle)
        
        openMenuButton.imageFit()
    }
    
    func startUp(){
        startChoiceLabel = UILabel()
        startAnswerLabel = UILabel()
        startTapImageView = UIImageView(image: UIImage(named: "TapImage"))
        
        let side = choicesView.frame.height * 0.6
        
        for label in [startChoiceLabel,startAnswerLabel]{
            label!.frame.size = CGSize(width: side * 2.5, height: side)
            label!.text = "スタート!"
            label!.font = VS.fontAdjust(viewSize: .important)
            label!.textAlignment = NSTextAlignment.center
            label!.cornerLayout(.circle)
            label!.clipsToBounds = true
        }
        startChoiceLabel.center = choicesView.center
        startChoiceLabel.textColor = UIColor.flatWhite
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(startButtonMove(_:)))
        startChoiceLabel.addGestureRecognizer(panGesture)
        startChoiceLabel.isUserInteractionEnabled = true
        startChoiceLabel.isExclusiveTouch = true
        VS.borderMake(view: startChoiceLabel, side: startChoiceLabel.frame.height, color: UIColor.flatGray)
        startChoiceLabel.backgroundColor = VS.importantOutletColor

        self.view.addSubview(startChoiceLabel)
        
        startAnswerLabel.center = answerView.center
        startAnswerLabel.textColor = VS.importantOutletColor
        if !characterShowUpBool{
            startAnswerLabel.textColor = UIColor.clear
        }else if !useColorHintBool{
            startAnswerLabel.textColor = UIColor.black
        }
        VS.borderMake(view: startAnswerLabel, side: startAnswerLabel.frame.height, color: UIColor.flatYellow)
        startAnswerLabel.backgroundColor = UIColor.clear
        self.view.addSubview(startAnswerLabel)
        
        startTapImageView.frame.size = CGSize(width: side/1.5, height: side/1.5)
        startTapImageView.contentMode = UIViewContentMode.scaleAspectFit
        startTapImageView.frame.origin = startChoiceLabel.center
        self.view.addSubview(startTapImageView)
        
        UIView.animateKeyframes(withDuration: 3.0, delay: 0.0, options: .repeat, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.333, animations: {
                self.startTapImageView.frame.origin = self.startAnswerLabel.center
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.333, relativeDuration: 0.333, animations: {
                self.startTapImageView.alpha = 0.0
            })
            
        }, completion: {(finished:Bool) in
            self.startTapImageView.alpha = 1.0
        })
        
        if switchKey > 0 && switchControl == nil{
            switchControl = SwitchControlSystem(switchKey, [startChoiceLabel.frame], self.view, self.view)
            switchControl.delegate = self
        }
    }
    
    
    @objc func startButtonMove(_ sender:UIPanGestureRecognizer){
        let label = sender.view as! UILabel
        
        if sender.state == .began{
            startTapImageView.isHidden = true
            SE.play(.dragBegan)
            selectViewRect = label.frame
        }
        
        let move:CGPoint = sender.translation(in: view)
        label.center.x += move.x
        label.center.y += move.y
        
        sender.setTranslation(CGPoint.zero, in: view)
        
        if sender.state == .ended{
            let endPoint = sender.location(in: self.view)
            if startAnswerLabel.frame.contains(endPoint){
                gameStart()
            }else{
                label.frame = selectViewRect
                SE.play(.dragEnded)
                startTapImageView.isHidden = false
            }
        }
    }
    
    @objc func gameStart(){
        SE.play(.start)
        currentCDArray = cardDataArray
        problemSetting()
        answerSetting()
        problemNumberLabel.text = "あと\(problemNumber)問"
        let startAnimation = CABasicAnimation(keyPath: "transform.scale")
        startAnimation.duration = 0.5
        startAnimation.fromValue = 1.2
        startAnimation.toValue = 0.0
        startAnimation.isRemovedOnCompletion = false
        startAnimation.fillMode = kCAFillModeForwards
        startChoiceLabel.layer.add(startAnimation, forKey: nil)
        startAnswerLabel.layer.add(startAnimation, forKey: nil)
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.startChoiceLabel.alpha = 0.0
            self.startAnswerLabel.alpha = 0.0

        }, completion: {(finished:Bool) in
            self.startChoiceLabel.removeFromSuperview()
            self.startAnswerLabel.removeFromSuperview()
            self.startTapImageView.removeFromSuperview()
        })
    }
    
    //    正解単語のセッティング
    func problemSetting(){
        answerCD = gameSystem.selectTarget(currentCDArray)
        answerCharacterArray = answerCD.characterInWord
        answerImage = answerCD.image
        positionOfAnswerCharacters = gameSystem.calculateRectForAnswer(answerCD.characterInWord, answerView.frame)
        answerImageView.image = answerImage
        answerImageView.contentMode = UIViewContentMode.scaleAspectFit
        perfectAnswerBool = true
        answerCount = 0
        answerCursorArray = positionOfAnswerCharacters
        print(answerCD.word)
    }
    
    //    正解の一文字のセッティング・選択肢のセッティング
    func answerSetting(){
        optionsArray = gameSystem.downselect(answerCharacterArray, useSimilarBool, useDakuonBool, useYouonBool)
        choicesArray = gameSystem.extractCharacter(optionsArray, answerCharacterArray, amountOfChoices)
        positionOfChoices = gameSystem.calculateRectForChoices(choicesArray.count, choicesView.frame)
        choicesLabelArray.removeAll()
        choicesCursorArray = positionOfChoices
        for i in 0 ..< choicesArray.count{
            let label = UILabel(frame: positionOfChoices[i])
            let title = choicesArray[i].katakanaToHiragana(HiraganaKatakanaBool)
            label.text = title
            label.font = VS.fontAdjust(viewSize: .important)
            label.adjustsFontSizeToFitWidth = true
            label.textAlignment = NSTextAlignment.center
            if useColorHintBool{
                label.textColor = gameSystem.colorChange(choicesArray[i])
            }
            label.backgroundColor = UIColor.clear
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(choicesMoved(sender:)))
            label.addGestureRecognizer(panGesture)
            label.isUserInteractionEnabled = true
            label.isExclusiveTouch = true
            choicesView.addSubview(label)
            choicesLabelArray.append(label)
            
            label.frame.origin = CGPoint(x: self.view.center.x, y: self.view.frame.height)
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                label.frame.origin = self.positionOfChoices[i].origin
            }, completion: {(finished:Bool) in
                if self.switchControl != nil{
                    self.switchControl.resetCursor(self.positionOfChoices, self.choicesView)
                }
            })
        }
        
        answerLabelArray.removeAll()
        answerFrameArray.removeAll()
        if !characterShowUpBool{
            hintViewArray.removeAll()
        }
        
        for i in 0 ..< answerCharacterArray.count{
            let label = UILabel(frame: positionOfAnswerCharacters[i])
            let title = answerCharacterArray[i].katakanaToHiragana(HiraganaKatakanaBool)
            if title.count == 2{
                label.frame.size.width = label.frame.size.width * 1.2
            }
            label.text = title
            label.font = VS.fontAdjust(viewSize: .veryImportant)
            label.textAlignment = NSTextAlignment.center
            label.adjustsFontSizeToFitWidth = true
            if useColorHintBool{
                label.textColor = gameSystem.colorChange(answerCharacterArray[i])
            }
            label.backgroundColor = UIColor.clear
            answerView.addSubview(label)
            answerLabelArray.append(label)
            
            let frameView = UIView()
            frameView.frame.size = gameSystem.answerFrameSize(label.frame.size)
            frameView.center = label.center
            frameView.layer.cornerRadius = 5.0
            frameView.layer.borderWidth = 2.0
            frameView.layer.borderColor = UIColor.flatYellow.cgColor
            answerView.insertSubview(frameView, belowSubview: label)
            answerFrameArray.append(frameView)
            
            if characterShowUpBool{
                label.alpha = 0.3
                label.font = VS.fontAdjust(viewSize: .important)
            }else{
                hintView = UIView(frame: label.frame)
                hintView.backgroundColor = answerView.backgroundColor
                answerView.addSubview(hintView)
                hintViewArray.append(hintView)
            }

        }
        if switchControl != nil{
            switchControl.resetCursor(positionOfChoices, choicesView)
        }
    }
    
    @objc func choicesMoved(sender: UIPanGestureRecognizer) {
        let label = sender.view as! UILabel
        
        if sender.state == .began{
            SE.play(.dragBegan)
            selectViewRect = label.frame
            selectLabelIndex = choicesLabelArray.index(of: label)!
        }
        
        let move:CGPoint = sender.translation(in: view)
        label.center.x += move.x
        label.center.y += move.y
        
        sender.setTranslation(CGPoint.zero, in: view)
        
        if sender.state == .ended{
            let endPoint = sender.location(in: self.view)
            dropPointVerification(endPoint)
            label.frame = selectViewRect
        }
    }
    
    func dropPointVerification(_ endPoint:CGPoint){
        var judgeBool = false
        for i in 0 ..< answerFrameArray.count{
            let rect = answerFrameArray[i].frame
            let frameOrigin = CGPoint(x: rect.origin.x + answerView.frame.origin.x, y: rect.origin.y + answerView.frame.origin.y)
            let frame = CGRect(origin: frameOrigin, size: rect.size)
            if frame.contains(endPoint){
                judgment(i)
                judgeBool = true
                break
            }
        }
        if !judgeBool{
            SE.play(.dragEnded)
        }
    }
    
    func judgment(_ number:Int){
        if gameSystem.judge(answerLabelArray[number].text!, choicesLabelArray[selectLabelIndex].text!){
            if characterShowUpBool{
                answerLabelArray[number].alpha = 1.0
                answerLabelArray[number].font = VS.fontAdjust(viewSize: .veryImportant)
            }else{
                hintViewArray[number].removeFromSuperview()
                hintViewArray.remove(at: number)
            }
            choicesLabelArray[selectLabelIndex].removeFromSuperview()
            choicesLabelArray.remove(at: selectLabelIndex)
            choicesCursorArray.remove(at: selectLabelIndex)
            answerFrameArray[number].removeFromSuperview()
            answerLabelArray.remove(at: number)
            answerFrameArray.remove(at: number)
            answerCursorArray.remove(at: number)
            
            answerCount += 1
            if answerCount == answerCharacterArray.count{// 単語完成
                SE.play(.fanfare)
                if newProblemBool{
                    totalCharacterCount += 1
                    if perfectAnswerBool{perfectAnswerCount += 1}
                    problemNumber -= 1
                }
                print("問題文字数：\(totalCharacterCount)　正解文字数：\(perfectAnswerCount)")
                
                let answerSubviews = answerView.subviews
                for answer in answerSubviews{
                    answer.removeFromSuperview()
                }
                let choicesSubViews = choicesView.subviews
                for choices in choicesSubViews{
                    choices.removeFromSuperview()
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
            }else{ //文字がまだ残ってる場合
                SE.play(.correct)
            }
        }else{//間違えた場合
            SE.play(.incorrect)
            perfectAnswerBool = false
            if !characterShowUpBool && hintViewArray[number].frame.height >= 1.0{
                hintViewArray[number].frame.size.height -= positionOfAnswerCharacters[0].height / 3
            }
        }
        if switchControl != nil && answerCount < answerCharacterArray.count{
            switchControl.resetCursor(choicesCursorArray, choicesView)
        }
        selectLabelIndex = 100
    }
    
    @objc func sameProblem(){
        SE.play(.same)
        newProblemBool = false
        answerCount = 0
        answerCursorArray = positionOfAnswerCharacters
        answerSetting()
        completionView.removeFromSuperview()
    }
    
    @objc func nextProblem(){
        SE.play(.next)
        completionView.removeFromSuperview()
        if problemNumber == 0{
            performSegue(withIdentifier: "toResult", sender: nil)
        }else{
            newProblemBool = true
            currentCDArray.remove(value: answerCD)
            problemNumberLabel.text = "あと\(problemNumber)問"
            problemSetting()
            answerSetting()
        }
    }
    
    @IBAction func openMenu(_ sender: Any) {
        coverView = UIView(frame: self.view.frame)
        coverView.backgroundColor = UIColor.flatBlack
        coverView.alpha = 0.4
        self.view.addSubview(coverView)
        openRight()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResult"{
            let resultVC = segue.destination as! ResultViewController
            resultVC.totalCharacterCount = self.totalCharacterCount
            resultVC.perfectAnswerCount = self.perfectAnswerCount
        }
    }
    
    //    SideMenuDelegete
    func changeProblem() {
        let choicesSubviews = choicesView.subviews
        for subview in choicesSubviews{
            subview.removeFromSuperview()
        }
        
        let answerSubviews = answerView.subviews
        for subview in answerSubviews{
            subview.removeFromSuperview()
        }
        
        problemSetting()
        answerSetting()
    }
    
    func changeHelpView(_ bool: Bool) {
        if bool{
            helpImageView = UIImageView(image: UIImage(named: "Help7"))
            helpImageView.frame.size.width = self.view.frame.width * 3/4
            helpImageView.frame.size.height = self.view.frame.height * 3/4
            helpImageView.contentMode = UIViewContentMode.scaleAspectFit
            helpImageView.center.y = self.view.center.y
            helpImageView.frame.origin.x = self.view.frame.origin.x
            self.view.addSubview(helpImageView)
        }else{
            helpImageView.removeFromSuperview()
        }
    }
    
    func toHome(){
        closeRight()
        performSegue(withIdentifier: "toHome", sender: nil)
    }
    
    func toLevelChoice() {
        closeRight()
        performSegue(withIdentifier: "toLevelChoice", sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToSort(segue:UIStoryboardSegue){
    }
    
    //    switchControl設定
    
    func decisionKeyPushed(_ cursorNumber: Int) {
        if answerCD == nil{
            if switchControl.cursor.frame == startChoiceLabel.frame{
                switchControl.resetCursor([startAnswerLabel.frame], self.view)
            }else{
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    self.startChoiceLabel.center = self.startAnswerLabel.center
                }, completion: {(finished:Bool) in
                    self.gameStart()
                    self.switchControl.resetTimer()
                })
            }
        }else if answerCount == answerCharacterArray.count{
            if cursorNumber == 0{
                sameProblem()
            }else{
                nextProblem()
            }
        }else if selectLabelIndex == 100{
            selectCursorView.frame = choicesCursorArray[cursorNumber]
            choicesView.insertSubview(selectCursorView, aboveSubview: choicesView)
            selectLabelIndex = cursorNumber
            switchControl.resetCursor(answerCursorArray, answerView)
        }else{
            let label = choicesLabelArray[selectLabelIndex]
            let frame = label.frame
            let x = (answerView.frame.origin.x + answerFrameArray[cursorNumber].center.x) - choicesView.frame.origin.x
            let y = (answerView.frame.origin.y + answerFrameArray[cursorNumber].center.y) - choicesView.frame.origin.y
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                label.center = CGPoint(x: x, y: y)
            }, completion: {(finished:Bool) in
                self.judgment(cursorNumber)
                label.frame = frame
                self.switchControl.resetTimer()
            })
        }
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
