//
//  DogViewController.swift
//  dogApiAsync
//
//  Created by user221908 on 7/13/22.
//

import UIKit
import CoreData

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

class DogViewController: UIViewController {
    
    var dog: DogApi?
    var persistentContainer: NSPersistentContainer!

    @IBOutlet weak var dogImg: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var idLbl: UILabel!
    
    @IBOutlet weak var favButton: UIButton!
    
    @IBAction func toggleFav(_ sender: UIButton) {
        if sender.tintColor == .yellow{
            sender.setImage(UIImage(systemName: "star"), for: .normal)
            
            sender.tintColor = .black
        }else{
            sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
            sender.tintColor = .yellow
            let moc = persistentContainer.viewContext
            
            moc.perform { [self] in
                let favDog = FavDog(context: moc)
                favDog.name = self.nameLbl!.text
                favDog.id = Int16(Int(self.idLbl.text!)!)
                do{
                    try moc.save()
                } catch{
                    moc.rollback()
                }
            }
        }
    }
    
    
       
       override func viewDidLoad() {
           super.viewDidLoad()

    
           nameLbl.text = dog?.localized_name
          // idLbl.text! = Int(exactly: dog!.id)!
           let imgUrl = "https://api.opendota.com" + (dog?.img)!
           print(imgUrl)
        dogImg.downloaded(from: imgUrl)
           
       }


}
