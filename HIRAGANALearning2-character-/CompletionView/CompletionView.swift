//
//  completionView.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/08.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit

class CompletionView: UIView {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var sameProblemButton: UIButton!
    @IBOutlet weak var nextProblemButton: UIButton!
    
    @IBOutlet weak var SEIKAILabel: UILabel!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        loadNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }
    
    func loadNib(){
        let view = Bundle.main.loadNibNamed("CompletionView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        
        layoutSetting()
    }
    
    func layoutSetting(){
        let VS = VisualSetting()
        VS.borderMake(view: self, side: self.frame.height, color: VS.borderColor)
        self.cornerLayout(.small)
        self.clipsToBounds = true
        nextProblemButton.backgroundColor = VS.importantOutletColor
        
        label.font = VS.fontAdjust(viewSize: .normal)
        label.adjustsFontSizeToFitWidth = true
        SEIKAILabel.font = VS.fontAdjust(viewSize: .normal)
        sameProblemButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        nextProblemButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        
        sameProblemButton.buttonTapActionSetting(.circle)
        nextProblemButton.buttonTapActionSetting(.circle)
        
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
