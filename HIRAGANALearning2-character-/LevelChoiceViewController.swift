//
//  LevelChoiceViewController.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/05.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit

// 出題形式を選ぶ
class LevelChoiceViewController: UIViewController {
    
    @IBOutlet weak var levelChoiceSC: UISegmentedControl!
    var gameLevel = 0
    
    @IBOutlet weak var characterHintButton: UIButton!
    var characterShowUpBool = false
    
    @IBOutlet weak var level1: UIImageView!
    @IBOutlet weak var level2: UIImageView!
    @IBOutlet weak var level3: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    
    var imageViewArray:[UIImageView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetting()
        
        gameLevel = UserDefaults.standard.integer(forKey: Constants.gameLevelKey)
        levelChoiceSC.selectedSegmentIndex = gameLevel
        imageViewArray = [level1,level2,level3]
        imageViewArray[gameLevel].alpha = 1.0
        for image in imageViewArray{
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTaped(_:)))
            image.addGestureRecognizer(tapGesture)
            image.isUserInteractionEnabled = true
        }
        
        characterHintButton.setImage(UIImage(named: "CheckOn"), for: .selected)
        characterShowUpBool = UserDefaults.standard.bool(forKey: Constants.characterShouUpKey)
        characterHintButton.isSelected = characterShowUpBool
        
        // Do any additional setup after loading the view.
    }
    
    func layoutSetting(){
        let VS = VisualSetting()
        VS.backgraundView(self)
        titleLabel.font = VS.fontAdjust(viewSize: .important)
        characterHintButton.titleLabel?.font = VS.fontAdjust(viewSize: .normal)
        nextButton.titleLabel?.font = VS.fontAdjust(viewSize: .normal)
        cancelButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        
        characterHintButton.layer.cornerRadius = VS.cornerRadiusAdjust(characterHintButton.frame.size, type: .normal)
        nextButton.layer.cornerRadius = VS.cornerRadiusAdjust(characterHintButton.frame.size, type: .normal)
        cancelButton.layer.cornerRadius = VS.cornerRadiusAdjust(cancelButton.frame.size, type: .small)
        
        levelChoiceSC.frame.size.height = cancelButton.frame.height
    }
    
    @IBAction func levelChanged(_ sender: UISegmentedControl) {
        gameLevel = sender.selectedSegmentIndex
        for i in 0 ..< imageViewArray.count{
            if i == sender.selectedSegmentIndex{
                imageViewArray[i].alpha = 1.0
            }else{
                imageViewArray[i].alpha = 0.5
            }
        }
    }
    
    @objc func imageTaped(_ sender:UITapGestureRecognizer){
        let tapImage = sender.view as! UIImageView
        levelChoiceSC.selectedSegmentIndex = tapImage.tag
        levelChanged(levelChoiceSC)
    }
    
    
    @IBAction func changeCharacterHint(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        characterShowUpBool = sender.isSelected
    }
    
    @IBAction func nextButton(_ sender: Any) {
        UserDefaults.standard.set(gameLevel, forKey: Constants.gameLevelKey)
        UserDefaults.standard.set(characterShowUpBool, forKey: Constants.characterShouUpKey)
        self.performSegue(withIdentifier: "problemChoice", sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToLevelChoice(segue:UIStoryboardSegue){
        
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
