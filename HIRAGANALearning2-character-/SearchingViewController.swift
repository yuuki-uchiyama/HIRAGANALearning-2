//
//  MatchingViewController.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/06.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit

class SearchingViewController: UIViewController, SideMenuDelegete, SwitchControlDelegate {
    
    @IBOutlet weak var openMenuButton: UIButton!
    @IBOutlet weak var answerImageView: UIImageView!
    @IBOutlet weak var answerView: UIView!
    @IBOutlet weak var choicesView: UIView!
    @IBOutlet weak var problemNumberLabel: UILabel!
    
    var cardDataArray: [CardData]!
    var currentCDArray: [CardData]!
    
    var startButton:UIButton!
    
    var answerCD: CardData!
    var answerCharacterArray: [String]!
    var answerCharacter:String!
    var answerFrame = UIView()
    var answerLabelArray:[UILabel] = []
    var positionOfAnswerCharacters: [CGRect]!
    var hintView: UIView!
    var answerImage: UIImage!
    
    
    var optionsArray: [String]!
    var choicesArray: [String]!
    var amountOfChoices:Int!
    var positionOfChoices: [CGRect]!
    
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
    var currentPerfectCount = 0
    var perfectAnswerBool = true
    var newProblemBool = true
    
    var gameSystem:GameSystem!
    let switchKey = UserDefaults.standard.integer(forKey: Constants.SwitchKey)
    var switchControl: SwitchControlSystem!
    
    
    var VS: VisualSetting!
    var SE: SoundEffect!
    
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
        amountOfChoices = gameSystem.amountCalcurate(amountLevel,gameLevel)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startUp()
    }
    
    func startUp(){
        startButton = UIButton()
        startButton.frame.size = CGSize(width: choicesView.frame.width * 0.7, height: choicesView.frame.height * 0.7)
        startButton.center = choicesView.center

        startButton.setTitle("スタート！", for: .normal)
        startButton.titleLabel?.font = VS.fontAdjust(viewSize: .important)
        startButton.setTitleColor(UIColor.flatWhite, for: .normal)
        
        startButton.addTarget(self, action: #selector(gameStart), for: .touchUpInside)
        self.view.addSubview(startButton)
        
        VS.borderMake(view: startButton, side: startButton.frame.height, color: UIColor.flatGray)
        startButton.backgroundColor = VS.importantOutletColor
        startButton.buttonTapActionSetting(.circle)
        
        if switchKey > 0 && switchControl == nil{
            switchControl = SwitchControlSystem(switchKey, [startButton.frame], self.view, self.view)
            switchControl.delegate = self
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
        startButton.layer.add(startAnimation, forKey: nil)

        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.startButton.alpha = 0.0
        }, completion: {(finished:Bool) in
            self.startButton.removeFromSuperview()
        })
    }
    
    func layoutSetting(){
        VS = VisualSetting()
        VS.backgraundView(self.view)
        VS.borderMake(view: choicesView, side: choicesView.frame.height, color:UIColor.red)
        choicesView.layer.borderColor = VS.borderColor.cgColor
        openMenuButton.backgroundColor = UIColor.clear
        problemNumberLabel.font = VS.fontAdjust(viewSize: .verySmall)
        answerView.layer.cornerRadius = VS.cornerRadiusAdjust(answerView.frame.size, type: .circle)
        choicesView.layer.cornerRadius = VS.cornerRadiusAdjust(choicesView.frame.size, type: .circle)
        
        openMenuButton.imageFit()
    }
    
//    正解単語のセッティング
    func problemSetting(){
        answerCD = gameSystem.selectTarget(currentCDArray)
        answerCharacterArray = answerCD.characterInWord
        answerImage = answerCD.image
        positionOfAnswerCharacters = gameSystem.calculateRectForAnswer(answerCD.characterInWord, answerView.frame)
        answerImageView.image = answerImage
        answerImageView.contentMode = UIViewContentMode.scaleAspectFit

        positionOfChoices = gameSystem.calculateRectForChoices(amountOfChoices + 1, choicesView.frame)
        
    }
    
//    正解の一文字のセッティング・選択肢のセッティング
    func answerSetting(){
        answerCharacter = answerCharacterArray[0]
        optionsArray = gameSystem.downselect([answerCharacter], useSimilarBool, useDakuonBool, useYouonBool)
        for chara in answerCD.characterInWord{
            if let index = optionsArray.index(of: chara){
                optionsArray.remove(at: index)
            }
        }
        choicesArray = gameSystem.extractCharacter(optionsArray, [answerCharacter], amountOfChoices)
        
        for i in 0 ..< choicesArray.count{
            let button = UIButton(frame: positionOfChoices[i])
            button.tag = i
            let title = choicesArray[i].katakanaToHiragana(HiraganaKatakanaBool)
            if title.count == 2{
                button.frame.size.width = button.frame.size.width * 1.3
            }
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = VS.fontAdjust(viewSize: .important)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            if useColorHintBool{
                button.setTitleColor(gameSystem.colorChange(choicesArray[i]), for: .normal)
            }else{
                button.setTitleColor(UIColor.flatBlack, for: .normal)
            }

            button.addTarget(self, action: #selector(buttonTaped(_:)), for: .touchUpInside)
            choicesView.addSubview(button)
            
            button.backgroundColor = UIColor.clear
            button.frame.origin = CGPoint(x: self.view.center.x, y: self.view.frame.height)
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                button.frame.origin = self.positionOfChoices[i].origin
            }, completion: {(finished:Bool) in
                button.backgroundColor = UIColor.groupTableViewBackground
                button.buttonTapActionSetting(.circle)
                
                if self.switchControl != nil{
                    self.switchControl.resetCursor(self.positionOfChoices, self.choicesView)
                    self.switchControl.cursor.alpha = 1.0
                    self.switchControl.resetTimer()
                }
            })
            
        }
        
        let label = UILabel(frame: positionOfAnswerCharacters[0])
        let title = answerCharacter.katakanaToHiragana(HiraganaKatakanaBool)
        label.text = title
        if title.count == 2{
            label.frame.size.width = label.frame.size.width * 1.4
        }
        label.font = VS.fontAdjust(viewSize: .veryImportant)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = NSTextAlignment.center
        if useColorHintBool{
            label.textColor = gameSystem.colorChange(answerCharacter!)
        }else{
            label.textColor = UIColor.black
        }
        label.backgroundColor = UIColor.clear
        answerView.addSubview(label)
        answerLabelArray.append(label)
        
        answerFrame.frame.size = gameSystem.answerFrameSize(label.frame.size)
        answerFrame.center = label.center
        answerFrame.layer.cornerRadius = 5.0
        answerFrame.layer.borderWidth = 2.0
        answerFrame.layer.borderColor = UIColor.flatYellow.cgColor
        answerView.insertSubview(answerFrame, belowSubview: label)
        
        if characterShowUpBool{
            label.alpha = 0.3
            label.font = VS.fontAdjust(viewSize: .important)
        }else{
            hintView = UIView(frame: label.frame)
            hintView.backgroundColor = answerView.backgroundColor
            answerView.addSubview(hintView)
        }
    }
    
    @objc func buttonTaped(_ sender:UIButton){
        judge(sender.tag)
    }
    
    func judge(_ choiceNumber:Int){
        if gameSystem.judge(answerCharacter, choicesArray[choiceNumber]){
            if perfectAnswerBool && newProblemBool{
                currentPerfectCount += 1
            }
            perfectAnswerBool = true
            
            if characterShowUpBool{
                answerLabelArray[0].alpha = 1.0
                answerLabelArray[0].font = VS.fontAdjust(viewSize: .veryImportant)
                answerLabelArray.remove(at: 0)
            }else{
                hintView.removeFromSuperview()
            }
            
            answerCharacterArray.remove(at: 0)
            positionOfAnswerCharacters.remove(at: 0)
            
            if answerCharacterArray.isEmpty{ //単語完成した場合
                SE.play(.fanfare)
                if newProblemBool{
                    totalCharacterCount += answerCD.characterInWord.count
                    perfectAnswerCount += currentPerfectCount
                    problemNumber -= 1
                }
                currentPerfectCount = 0
                print("問題文字数：\(totalCharacterCount)　正解文字数：\(perfectAnswerCount)")
                let answerSubviews = answerView.subviews
                for subview in answerSubviews{
                    subview.removeFromSuperview()
                }
                let choicesSubviews = self.choicesView.subviews
                for subview in choicesSubviews{
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
            }else{ //まだ文字が残ってる場合
                SE.play(.correct)
                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    let choicesSubviews = self.choicesView.subviews
                    for subview in choicesSubviews{
                        subview.alpha = 0.0
                    }
                }, completion: {(finished:Bool) in
                    self.deleteChoices()
                    self.answerSetting()
                })
            }
        }else{ //間違えた場合
            SE.play(.incorrect)
            perfectAnswerBool = false
            if !characterShowUpBool && hintView.frame.height >= 1.0{
                hintView.frame.size.height -= positionOfAnswerCharacters[0].height / 4
            }
        }
    }
    
    func deleteChoices(){
        let choicesSubviews = self.choicesView.subviews
        for subview in choicesSubviews{
            subview.removeFromSuperview()
        }
    }
    
    @objc func sameProblem(){
        SE.play(.same)
        newProblemBool = false
        answerCharacterArray = answerCD.characterInWord
        answerImage = answerCD.image
        positionOfChoices = gameSystem.calculateRectForChoices(amountOfChoices + 1, choicesView.frame)
        positionOfAnswerCharacters = gameSystem.calculateRectForAnswer(answerCD.characterInWord, answerView.frame)
        answerImageView.image = answerImage
        
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
        currentPerfectCount = 0
        newProblemBool = true
        answerCharacterArray.remove(at: 0)
        positionOfAnswerCharacters.remove(at: 0)
        
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
            helpImageView = UIImageView(image: UIImage(named: "Help6"))
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
    
    
    @IBAction func unwindToSearch(segue:UIStoryboardSegue){
    }
    
    //    switchControl設定

    
    func decisionKeyPushed(_ cursorNumber: Int) {
        if answerCD == nil{
            gameStart()
        }else if answerCharacterArray.isEmpty{
            if cursorNumber == 0{
                sameProblem()
            }else{
                nextProblem()
            }
        }else{
            judge(cursorNumber)
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
