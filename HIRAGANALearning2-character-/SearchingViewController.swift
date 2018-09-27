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
    
    var answerCD: CardData!
    var answerCharacterArray: [String]!
    var answerCharacter:String!
    var answerFrame = UIView()
    var positionOfAnswerCharacters: [CGRect]!
    var hintView: UIView!
    var answerImage: UIImage!
    var optionsArray: [String]!
    var choicesArray: [String]!
    var positionOfChoices: [CGRect]!
    
    let characterShowUpBool = UserDefaults.standard.bool(forKey: Constants.characterShouUpKey)
    let useSimilarBool = UserDefaults.standard.bool(forKey:Constants.useSimilarKey)
    let useDakuonBool = UserDefaults.standard.bool(forKey:Constants.useDakuonKey)
    let useYouonBool = UserDefaults.standard.bool(forKey:Constants.useYouonKey)
    let useColorHintBool = UserDefaults.standard.bool(forKey:Constants.useColorHintKey)
    let amountOfChoices = UserDefaults.standard.integer(forKey: Constants.amountOfChoicesKey)
    
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
    
    var alertBool = false
    
    var VS: VisualSetting!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetting()
        
        
        if cardDataArray.count < 10{
            alertBool = true
        }else{
            alertBool = false
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if alertBool{
            popUp()
        }else{
            currentCDArray = cardDataArray
            print(currentCDArray.count)
            problemSetting()
            answerSetting()
            problemNumberLabel.text = "あと\(problemNumber)問"
            if switchKey > 0 && switchControl == nil{
                switchControl = SwitchControlSystem(switchKey, positionOfChoices, self.view, choicesView)
                switchControl.delegate = self
            }
        }
    }
    
    func layoutSetting(){
        VS = VisualSetting()
        VS.backgraundView(self)
        problemNumberLabel.font = VS.fontAdjust(viewSize: .normal)
        answerView.layer.cornerRadius = VS.cornerRadiusAdjust(answerView.frame.size, type: .circle)
        choicesView.layer.cornerRadius = VS.cornerRadiusAdjust(choicesView.frame.size, type: .circle)
    }
    
    func popUp(){
        print("popup")
        let alertController: UIAlertController = UIAlertController(title: "カードの枚数が足りません", message: "カードが10枚以上必要です", preferredStyle: .alert)
        let card = UIAlertAction(title: "カード編集へ", style: .default, handler:{(action: UIAlertAction!) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.performSegue(withIdentifier: "toCard", sender: nil)
            }
        })
        let level = UIAlertAction(title: "難易度設定へ", style: .default, handler:{(action: UIAlertAction!) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.performSegue(withIdentifier: "unwindToLevelChoice", sender: nil)
            }
        })
        alertController.addAction(card)
        alertController.addAction(level)
        present(alertController, animated: true, completion: nil)
        alertBool = false
    }
    
//    正解単語のセッティング
    func problemSetting(){
        answerCD = gameSystem.selectTarget(currentCDArray)
        answerCharacterArray = answerCD.characterInWord
        answerImage = answerCD.image
        positionOfAnswerCharacters = gameSystem.calculateRectForAnswer(answerCD.characterInWord, answerView.frame)
        answerImageView.image = answerImage
        positionOfChoices = gameSystem.calculateRectForChoices(amountOfChoices + 1, choicesView.frame)

    }
    
//    正解の一文字のセッティング・選択肢のセッティング
    func answerSetting(){
        answerCharacter = answerCharacterArray[0]
        optionsArray = gameSystem.downselect([answerCharacter], useSimilarBool, useDakuonBool, useYouonBool)
        choicesArray = gameSystem.extractCharacter(optionsArray, [answerCharacter], amountOfChoices)
        
        for i in 0 ..< choicesArray.count{
            let button = UIButton(frame: positionOfChoices[i])
            button.tag = i
            button.setTitle(choicesArray[i], for: .normal)
            button.titleLabel?.font = VS.fontAdjust(viewSize: .important)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            if useColorHintBool{
                button.setTitleColor(gameSystem.colorChange(choicesArray[i]), for: .normal)
            }else{
                button.setTitleColor(UIColor.flatBlack, for: .normal)
            }
            button.backgroundColor = UIColor.clear
            button.addTarget(self, action: #selector(buttonTaped(_:)), for: .touchUpInside)
            choicesView.addSubview(button)
        }
        
        let label = UILabel(frame: positionOfAnswerCharacters[0])
        label.text = answerCharacter!
        label.font = VS.fontAdjust(viewSize: .important)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = NSTextAlignment.center
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
        if switchControl != nil{
            switchControl.resetCursor(positionOfChoices, choicesView)
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
            
            if !characterShowUpBool{
                hintView.removeFromSuperview()
            }
            
            answerCharacterArray.remove(at: 0)
            positionOfAnswerCharacters.remove(at: 0)
            
            let choicesSubviews = choicesView.subviews
            for subview in choicesSubviews{
                subview.removeFromSuperview()
            }
            if answerCharacterArray.isEmpty{
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
                
                completionView = CompletionView(frame: CGRect(x: 0.0, y: 0.0, width: 350, height: 250))
                completionView.center = self.view.center
                completionView.image.image = answerImage
                completionView.label.text = answerCD.word
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
                
            }else{
                answerSetting()
            }
        }else{
            perfectAnswerBool = false
            if !characterShowUpBool && hintView.frame.height >= 1.0{
                hintView.frame.size.height -= positionOfAnswerCharacters[0].height / 3
            }
        }
    }
    
    @objc func sameProblem(){
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func unwindToSearch(segue:UIStoryboardSegue){
    }
    
    //    switchControl設定

    
    func decisionKeyPushed(_ cursorNumber: Int) {
        if answerCharacterArray.isEmpty{
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
