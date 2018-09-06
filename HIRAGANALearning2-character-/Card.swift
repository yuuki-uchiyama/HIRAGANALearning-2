

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

