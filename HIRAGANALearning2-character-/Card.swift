
import UIKit
import RealmSwift

class Card: Object {
    
    @objc dynamic var id = 0
    
    @objc dynamic var word = ""
    
    @objc dynamic var originalDeck1 = false
    @objc dynamic var originalDeck2 = false
    @objc dynamic var originalDeck3 = false
    @objc dynamic var originalDeck4 = false
    @objc dynamic var originalDeck5 = false
    @objc dynamic var originalDeck6 = false
    @objc dynamic var originalDeck7 = false
    @objc dynamic var originalDeck8 = false
    @objc dynamic var originalDeck9 = false
    @objc dynamic var originalDeck10 = false
    
    @objc dynamic var image: NSData?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

// カードデータの操作用クラス
class CardData: Equatable{
    var card:Card!
    var id:Int!
    var word: String!
    var image: UIImage!
    var boolArray:[Bool]!
    
    var characterInWord:[String] = []
    
    init(_ cardData:Card) {
        card = cardData
        id = cardData.id
        word = cardData.word
        image = UIImage(data: cardData.image! as Data)
        boolArray = [cardData.originalDeck1,cardData.originalDeck2,cardData.originalDeck3,cardData.originalDeck4,cardData.originalDeck5,cardData.originalDeck6,cardData.originalDeck7,cardData.originalDeck8,cardData.originalDeck9,cardData.originalDeck10]
        
        characterInWord = word.makeYouon()
    }
    
    static func == (l: CardData, r: CardData) -> Bool {    // 評価関数
        return l.id == r.id
    }
}

class CollectionCardData{
    var totalCardDataArray:[CardData] = []
    
    var deckArray:[[CardData]] = []
    
    var resultCardDataArray:[CardData] = []
    var restCardDataArray:[CardData] = []
    
    init(_ results:Results<Card>){
        for card in results{
            let CD = CardData(card)
            totalCardDataArray.append(CD)
        }
    }
    
    //    editCardCV用
    func search(_ deckInt:Int,_ searchString:String){
        
        var CDArray:[CardData] = []
        
        if deckInt < 0{
            CDArray = totalCardDataArray
        }else{
            for CD in totalCardDataArray{
                if CD.boolArray[deckInt]{
                    CDArray.append(CD)
                }
            }
        }
        
        if searchString != ""{
            let array:[CardData] = CDArray
            CDArray.removeAll()
            for CD in array{
                if CD.word.containsString(searchString){
                    CDArray.append(CD)
                }
            }
        }
        resultCardDataArray = CDArray
    }
    
    func deckSort(){
        var deck1CardDataArray:[CardData] = []
        var deck2CardDataArray:[CardData] = []
        var deck3CardDataArray:[CardData] = []
        var deck4CardDataArray:[CardData] = []
        var deck5CardDataArray:[CardData] = []
        var deck6CardDataArray:[CardData] = []
        var deck7CardDataArray:[CardData] = []
        var deck8CardDataArray:[CardData] = []
        var deck9CardDataArray:[CardData] = []
        var deck10CardDataArray:[CardData] = []
        
        for CD in totalCardDataArray{
            if CD.boolArray[0]{deck1CardDataArray.append(CD)}
            if CD.boolArray[1]{deck2CardDataArray.append(CD)}
            if CD.boolArray[2]{deck3CardDataArray.append(CD)}
            if CD.boolArray[3]{deck4CardDataArray.append(CD)}
            if CD.boolArray[4]{deck5CardDataArray.append(CD)}
            if CD.boolArray[5]{deck6CardDataArray.append(CD)}
            if CD.boolArray[6]{deck7CardDataArray.append(CD)}
            if CD.boolArray[7]{deck8CardDataArray.append(CD)}
            if CD.boolArray[8]{deck9CardDataArray.append(CD)}
            if CD.boolArray[9]{deck10CardDataArray.append(CD)}
        }
        deckArray = [deck1CardDataArray,deck2CardDataArray,deck3CardDataArray,deck4CardDataArray,deck5CardDataArray,deck6CardDataArray,deck7CardDataArray,deck8CardDataArray,deck9CardDataArray,deck10CardDataArray]
    }
    
    //    editDeckVC用
    func deckSieve(_ deckInt:Int){
        let inDeckArray:[CardData] = deckArray[deckInt]
        var outOfDeckArray:[CardData] = []
        for CD in totalCardDataArray{
            if !inDeckArray.contains(CD){
                outOfDeckArray.append(CD)
            }
        }
        resultCardDataArray = inDeckArray
        restCardDataArray = outOfDeckArray
    }
    
    func putInDeck(_ CD:CardData,_ deckInt:Int){
        deckArray[deckInt].append(CD)
        restCardDataArray.remove(value: CD)
        resultCardDataArray.append(CD)
    }
    func putOutDeck(_ CD:CardData,_ deckInt:Int){
        deckArray[deckInt].remove(value: CD)
        restCardDataArray.append(CD)
        resultCardDataArray.remove(value: CD)
    }
    
    func editDeck(){
        let realm = try! Realm()
        try! realm.write {
            for CD in totalCardDataArray{
                if deckArray[0].contains(CD){CD.card.originalDeck1 = true}else{CD.card.originalDeck1 = false}
                if deckArray[1].contains(CD){CD.card.originalDeck2 = true}else{CD.card.originalDeck2 = false}
                if deckArray[2].contains(CD){CD.card.originalDeck3 = true}else{CD.card.originalDeck3 = false}
                if deckArray[3].contains(CD){CD.card.originalDeck4 = true}else{CD.card.originalDeck4 = false}
                if deckArray[4].contains(CD){CD.card.originalDeck5 = true}else{CD.card.originalDeck5 = false}
                if deckArray[5].contains(CD){CD.card.originalDeck6 = true}else{CD.card.originalDeck6 = false}
                if deckArray[6].contains(CD){CD.card.originalDeck7 = true}else{CD.card.originalDeck7 = false}
                if deckArray[7].contains(CD){CD.card.originalDeck8 = true}else{CD.card.originalDeck8 = false}
                if deckArray[8].contains(CD){CD.card.originalDeck9 = true}else{CD.card.originalDeck9 = false}
                if deckArray[9].contains(CD){CD.card.originalDeck10 = true}else{CD.card.originalDeck10 = false}
                
                realm.add(CD.card, update: true)
            }
        }
    }
}

//カードデータ作成・編集用
class EditCard:Equatable{
    var id = 0
    
    var word = ""
    
    var image: NSData?
    
    var originalDeck1 = false
    var originalDeck2 = false
    var originalDeck3 = false
    var originalDeck4 = false
    var originalDeck5 = false
    var originalDeck6 = false
    var originalDeck7 = false
    var originalDeck8 = false
    var originalDeck9 = false
    var originalDeck10 = false
    
    let realm = try! Realm()
    
    func loadCard(_ card:Card){
        id = card.id
        word = card.word
        image = card.image
        originalDeck1 = card.originalDeck1
        originalDeck2 = card.originalDeck2
        originalDeck3 = card.originalDeck3
        originalDeck4 = card.originalDeck4
        originalDeck5 = card.originalDeck5
        originalDeck6 = card.originalDeck6
        originalDeck7 = card.originalDeck7
        originalDeck8 = card.originalDeck8
        originalDeck9 = card.originalDeck9
        originalDeck10 = card.originalDeck10
    }
    func newCard(){
        let cardResults = realm.objects(Card.self)
        id = cardResults.max(ofProperty: "id")! + 1
        word = ""
        image = nil
        originalDeck1 = false
        originalDeck2 = false
        originalDeck3 = false
        originalDeck4 = false
        originalDeck5 = false
        originalDeck6 = false
        originalDeck7 = false
        originalDeck8 = false
        originalDeck9 = false
        originalDeck10 = false
    }
    
    func importCard(_ w:String,_ i:NSData){
        word = w
        image = i
    }
    
    func saveCard(){
        try! realm.write {
            let card = Card()
            card.id = id
            card.word = word
            card.image = image
            card.originalDeck1 = originalDeck1
            card.originalDeck2 = originalDeck2
            card.originalDeck3 = originalDeck3
            card.originalDeck4 = originalDeck4
            card.originalDeck5 = originalDeck5
            card.originalDeck6 = originalDeck6
            card.originalDeck7 = originalDeck7
            card.originalDeck8 = originalDeck8
            card.originalDeck9 = originalDeck9
            card.originalDeck10 = originalDeck10
            
            realm.add(card, update: true)
        }
    }
    
    func deleteCard(_ card:Card){
        try! realm.write {
            realm.delete(card)
        }
    }
    
    static func == (l: EditCard, r: EditCard) -> Bool {    // 評価関数
        return l.word == r.word
    }
}

extension UIImage{
    func resized(side:CGFloat) ->UIImage{
        if self.size.width < side && self.size.height < side{
            return self
        }
        var resizedSize: CGSize!
        let aspectRate: CGFloat = self.size.height / self.size.width
        if self.size.width >= self.size.height{
            let height = side * aspectRate
            resizedSize = CGSize(width: side, height: height)
        }else{
             let width = side / aspectRate
            resizedSize = CGSize(width: width, height: side)
        }
        UIGraphicsBeginImageContext(resizedSize)
        self.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
}
