//
//  AddCardViewController.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/05.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit
import RealmSwift
import CropViewController
import SVProgressHUD

extension UIImagePickerController{
    override open var supportedInterfaceOrientations:UIInterfaceOrientationMask {
        return .landscape
    }
}



// カード追加
class AddCardViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addTitleLabel: UILabel!
    @IBOutlet weak var attentionLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var toHomeButton: UIButton!
    
    @IBOutlet weak var deck1Button: UIButton!
    @IBOutlet weak var deck2Button: UIButton!
    @IBOutlet weak var deck3Button: UIButton!
    @IBOutlet weak var deck4Button: UIButton!
    @IBOutlet weak var deck5Button: UIButton!
    @IBOutlet weak var deck6Button: UIButton!
    @IBOutlet weak var deck7Button: UIButton!
    @IBOutlet weak var deck8Button: UIButton!
    @IBOutlet weak var deck9Button: UIButton!
    @IBOutlet weak var deck10Button: UIButton!
    var buttonArray:[UIButton] = []
    var boolArray:[Bool] = []
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pictureWordLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var TFView: UIView!
    
    @IBOutlet weak var cardView: UIView!
    var beforeOriginY:CGFloat = 0.0
    var scrollBool = false
    
    var newCardBool = true
    var card: Card!
    var editcard = EditCard()
    
    var SE: SoundEffect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.setMinimumDismissTimeInterval(0)
        textField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        buttonArray = [deck1Button,deck2Button,deck3Button,deck4Button,deck5Button,deck6Button,deck7Button,deck8Button,deck9Button,deck10Button]
        boolArray = [editcard.originalDeck1,editcard.originalDeck2,editcard.originalDeck3,editcard.originalDeck4,editcard.originalDeck5,editcard.originalDeck6,editcard.originalDeck7,editcard.originalDeck8,editcard.originalDeck9,editcard.originalDeck10]
        
        layoutSetting()
        SE = SoundEffect.sharedSoundEffect
        
        if newCardBool{
            editcard.newCard()
        }else{
            editcard.loadCard(card)
            textField.text = editcard.word
            imageView.image = UIImage(data:editcard.image! as Data)
            boolArray = [editcard.originalDeck1,editcard.originalDeck2,editcard.originalDeck3,editcard.originalDeck4,editcard.originalDeck5,editcard.originalDeck6,editcard.originalDeck7,editcard.originalDeck8,editcard.originalDeck9,editcard.originalDeck10]

            for i in 0 ..< buttonArray.count{
                buttonArray[i].isSelected = boolArray[i]
            }
            deleteButton.setTitle("削除", for: .normal)
            addButton.setTitle("修正", for: .normal)
            toHomeButton.isHidden = true
            pictureWordLabel.isHidden = true
        }
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(popUp)))
        
        // Do any additional setup after loading the view.
    }
    
    func layoutSetting(){
        let VS = VisualSetting()
        VS.backgraundView(self.view)
        addButton.backgroundColor = VS.importantOutletColor
        titleLabel.font = VS.fontAdjust(viewSize: .important)
        addTitleLabel.font = VS.fontAdjust(viewSize: .important)
        pictureWordLabel.font = VS.fontAdjust(viewSize: .verySmall)
        attentionLabel.font = VS.fontAdjust(viewSize: .sentence)
        toHomeButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        cancelButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        let deckButtonArray:[UIButton] = [deck1Button,deck2Button,deck3Button,deck4Button,deck5Button,deck6Button,deck7Button,deck8Button,deck9Button,deck10Button]
        for button in deckButtonArray{
            button.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        }
        deleteButton.titleLabel?.font = VS.fontAdjust(viewSize: .important)
        addButton.titleLabel?.font = VS.fontAdjust(viewSize: .important)
        
        textField.font = VS.fontAdjust(viewSize: .normal)
        textField.frame = TFView.frame
        
        cancelButton.buttonTapActionSetting(.circle)
        toHomeButton.buttonTapActionSetting(.circle)
        deleteButton.buttonTapActionSetting(.circle)
        addButton.buttonTapActionSetting(.circle)
        
        for button in buttonArray{
            button.setImage(UIImage(named: "CheckOn"), for: .selected)
            button.backgroundColor = UIColor.clear
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismissKeyboard()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
    @objc func popUp(){
        let alertController: UIAlertController = UIAlertController(title: "画像を取り込む", message: nil, preferredStyle: .alert)
        let camera = UIAlertAction(title: "カメラから取り込む", style: .default, handler: actionCamera)
        let library = UIAlertAction(title: "写真から取り込む", style: .default, handler: actionLibrary)
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        
        alertController.addAction(camera)
        alertController.addAction(library)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    
    func actionCamera(alert: UIAlertAction!){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    func actionLibrary(alert: UIAlertAction!){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if info[UIImagePickerControllerOriginalImage] != nil{
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            let editor = TOCropViewController(image: image)
            editor.delegate = self
            picker.pushViewController(editor, animated: true)
        }
    }
    func cropViewController(_ cropViewController: TOCropViewController, didCropToImage image: UIImage, rect cropRect: CGRect, angle: Int) {
        let resizeImage = image.resized(side: 300)
        imageView.image = resizeImage
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        cropViewController.dismiss(animated: true, completion: nil)
        pictureWordLabel.isHidden = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deckButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        switch sender.tag {
        case 1:editcard.originalDeck1 = sender.isSelected
        case 2:editcard.originalDeck2 = sender.isSelected
        case 3:editcard.originalDeck3 = sender.isSelected
        case 4:editcard.originalDeck4 = sender.isSelected
        case 5:editcard.originalDeck5 = sender.isSelected
        case 6:editcard.originalDeck6 = sender.isSelected
        case 7:editcard.originalDeck7 = sender.isSelected
        case 8:editcard.originalDeck8 = sender.isSelected
        case 9:editcard.originalDeck9 = sender.isSelected
        case 10:editcard.originalDeck10 = sender.isSelected
        default:break
        }
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        if newCardBool{
            textField.text = ""
            imageView.image = nil
            for button in buttonArray{
                button.isSelected = false
            }
            pictureWordLabel.isHidden = false
            soundPlay(deleteButton)
        }else{
            let alertController: UIAlertController = UIAlertController(title: "「\(card.word)」を削除しますか？", message: "カードリストからデータが削除され、使用できなくなります", preferredStyle: .alert)
            let yes = UIAlertAction(title: "はい", style: .default, handler: {
                (action: UIAlertAction!) -> Void in
                self.editcard.deleteCard(self.card)
                SVProgressHUD.setMinimumDismissTimeInterval(0)
                SVProgressHUD.showSuccess(withStatus: "カードを削除しました")
                self.soundPlay(self.deleteButton)
                self.dismiss(animated: true, completion: nil)
            })
            let no = UIAlertAction(title: "いいえ", style: .cancel)
            
            alertController.addAction(yes)
            alertController.addAction(no)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func addButton(_ sender: Any) {
        if !(textField.text?.isUsableString)!{
            SVProgressHUD.showError(withStatus: "使用できない文字が含まれています(空欄・漢字・アルファベット・特殊な拗音など)")
        }else if (textField.text?.isCountOver)!{
            SVProgressHUD.showError(withStatus: "文字数が多すぎます")
        }else if imageView.image == nil{
            SVProgressHUD.showError(withStatus: "画像が選択されていません")
        }else{
            let string = textField.text?.removeSpaceAndTyouon().katakanaToHiragana(true)
            editcard.word = string!
            editcard.image = UIImagePNGRepresentation(imageView.image!)! as NSData
            editcard.saveCard()
            soundPlay(addButton)
            if newCardBool{
                SVProgressHUD.showSuccess(withStatus: "カードを追加しました")
                editcard.newCard()
                textField.text = ""
                imageView.image = nil
                pictureWordLabel.isHidden = false
            }else{
                SVProgressHUD.showSuccess(withStatus: "カードを修正しました")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func keyboardWillBeShown(notification:NSNotification) {
        if !scrollBool{
            if let keyboardFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue {
                let keyboardFrameY = keyboardFrame.origin.y
                beforeOriginY = cardView.frame.origin.y
                let cardViewBottom = beforeOriginY + cardView.frame.height
                if cardViewBottom > keyboardFrameY {
                    let scrollRange = cardViewBottom - keyboardFrameY
                    UIView.animate(withDuration: 0.2, animations:{
                        self.cardView.frame.origin.y -= scrollRange
                    })
                }
            }
            scrollBool = true
        }
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
        if scrollBool{
            self.cardView.frame.origin.y = self.beforeOriginY
            scrollBool = false
        }
    }
    
    @IBAction func soundPlay(_ sender: UIButton) {
        switch sender.tag{
        case 1:SE.play(.tap)
        case 2:SE.play(.cancel)
        case 3:SE.play(.important)
        default:break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
