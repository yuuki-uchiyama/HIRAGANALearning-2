//
//  ProblemSetting1View.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/08.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit

class ProblemSetting1View: UIView{
    
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
    
    @IBOutlet weak var SCView: UIView!
    @IBOutlet weak var amountLevelSC: UISegmentedControl!
    
    var useSimilarBool = false
    var useDakuonBool = false
    var useYouonBool = false
    var amountLevel = 0
    
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
        
        amountLevel = UserDefaults.standard.integer(forKey: Constants.amountLevelKey)
        amountLevelSC.selectedSegmentIndex = amountLevel
        
    }
    
    func layoutSetting(){
        VS = VisualSetting()
        VS.borderMake(view: self, side: self.frame.height, color: VS.borderColor)
        self.cornerLayout(.collectionView)
        useSimilarButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        useDakuonButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        useYouonButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        sampleLabel.font = VS.fontAdjust(viewSize: .normal)
        similarLabel.font = VS.fontAdjust(viewSize: .normal)
        dakuonLabel.font = VS.fontAdjust(viewSize: .normal)
        youonLabel.font = VS.fontAdjust(viewSize: .small)
        choicesLabel.font = VS.fontAdjust(viewSize: .small)
        
        useSimilarButton.titleLabel?.adjustsFontSizeToFitWidth = true
        useDakuonButton.titleLabel?.adjustsFontSizeToFitWidth = true
        useYouonButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        useSimilarButton.buttonTapActionSetting(.circle)
        useDakuonButton.buttonTapActionSetting(.circle)
        useYouonButton.buttonTapActionSetting(.circle)
        displayView.cornerLayout(.small)
        SCView.cornerLayout(.verySmall)
        
        amountLevelSC.frame = SCView.frame
        VS.fontAdjustOfSegmentedControl(amountLevelSC, .verySmall)
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
    
    @IBAction func amountLevelChange(_ sender: UISegmentedControl) {
        amountLevel = sender.selectedSegmentIndex
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
