//
//  ProblemSetting1View.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/08.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit

class ProblemSetting1View: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    

    @IBOutlet weak var displayView: UIView!
    @IBOutlet weak var useSimilarButton: UIButton!
    @IBOutlet weak var useDakuonButton: UIButton!
    @IBOutlet weak var useYouonButton: UIButton!
    
    @IBOutlet weak var similarBanImageView: UIImageView!
    @IBOutlet weak var dakuonBanImageView: UIImageView!
    @IBOutlet weak var youonBanImageView: UIImageView!
    
    @IBOutlet weak var sampleLabel: UILabel!
    @IBOutlet weak var similarLabel: UILabel!
    @IBOutlet weak var dakuonLabel: UILabel!
    @IBOutlet weak var youonLabel: UILabel!
    @IBOutlet weak var choicesLabel: UILabel!
    
    
    @IBOutlet weak var choicesPickerView: UIPickerView!
    let choicesPVArray = ["答えの数と同じ","+1","+2","+3","+4","+5"]
    
    var useSimilarBool = false
    var useDakuonBool = false
    var useYouonBool = false
    var amountOfChoices = 0
    
    var VS: VisualSetting!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        loadNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }
    
    func loadNib(){
        let view = Bundle.main.loadNibNamed("ProblemSetting1View", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        
        layoutSetting()
        
        choicesPickerView.dataSource = self
        choicesPickerView.delegate = self
        
        let buttonArray:[UIButton] = [useSimilarButton, useDakuonButton, useYouonButton]
        for button in buttonArray{
            button.setImage(UIImage(named: "CheckOn"), for: .selected)
        }
        
        useSimilarBool = UserDefaults.standard.bool(forKey:Constants.useSimilarKey)
        similarBanImageView.isHidden = useSimilarBool
        useSimilarButton.isSelected = useSimilarBool
        
        useDakuonBool = UserDefaults.standard.bool(forKey:Constants.useDakuonKey)
        dakuonBanImageView.isHidden = useDakuonBool
        useDakuonButton.isSelected = useDakuonBool
        
        useYouonBool = UserDefaults.standard.bool(forKey:Constants.useYouonKey)
        youonBanImageView.isHidden = useYouonBool
        useYouonButton.isSelected = useYouonBool
        
        amountOfChoices = UserDefaults.standard.integer(forKey: Constants.amountOfChoicesKey)
        choicesPickerView.selectRow(amountOfChoices, inComponent: 0, animated: false)
        
        
    }
    
    func layoutSetting(){
        VS = VisualSetting()
        useSimilarButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        useDakuonButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        useYouonButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        sampleLabel.font = VS.fontAdjust(viewSize: .normal)
        similarLabel.font = VS.fontAdjust(viewSize: .normal)
        dakuonLabel.font = VS.fontAdjust(viewSize: .normal)
        youonLabel.font = VS.fontAdjust(viewSize: .small)
        choicesLabel.font = VS.fontAdjust(viewSize: .normal)
        
        useSimilarButton.titleLabel?.adjustsFontSizeToFitWidth = true
        useDakuonButton.titleLabel?.adjustsFontSizeToFitWidth = true
        useYouonButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        useSimilarButton.layer.cornerRadius = VS.cornerRadiusAdjust(useSimilarButton.frame.size, type: .small)
        useDakuonButton.layer.cornerRadius = VS.cornerRadiusAdjust(useDakuonButton.frame.size, type: .small)
        useYouonButton.layer.cornerRadius = VS.cornerRadiusAdjust(useYouonButton.frame.size, type: .small)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choicesPVArray.count
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return pickerView.frame.height / 3
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.size.width, height: pickerView.frame.size.height / 2))
        label.textAlignment = .center
        label.text = choicesPVArray[row]
        label.font = VS.fontAdjust(viewSize: .verySmall)
        label.adjustsFontSizeToFitWidth = true
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        amountOfChoices = row
    }
    
    @IBAction func useSimilar(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        useSimilarBool = sender.isSelected
        similarBanImageView.isHidden = useSimilarBool
    }
    
    @IBAction func useDakuon(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        useDakuonBool = sender.isSelected
        dakuonBanImageView.isHidden = useDakuonBool
    }
    
    @IBAction func useYouon(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        useYouonBool = sender.isSelected
        youonBanImageView.isHidden = useYouonBool
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
