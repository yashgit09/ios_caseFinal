//
//  ViewController.swift
//  dogApiAsync
//
//  Created by user221908 on 7/13/22.
//

import UIKit
import CoreData


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
        
    
    var dogs = [DogApi]()
    var persistentContainer: NSPersistentContainer!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
            
            downloadJSON {
                self.tableView.reloadData()
                print("success")
            }
            
            tableView.delegate = self
            tableView.dataSource = self
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return dogs.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
           let dog = dogs[indexPath.row]
           cell.textLabel?.text = dog.localized_name.capitalized
           

           return cell
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           performSegue(withIdentifier: "showDetails", sender: self)
       }
       
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if let destination = segue.destination as? DogViewController {
               destination.dog = dogs[tableView.indexPathForSelectedRow!.row]
               destination.persistentContainer = persistentContainer
               
           }
       }
    
    
    func downloadJSON(completed: @escaping () -> ()) {
        let url = URL(string: "https://api.opendota.com/api/heroStats")
        
        URLSession.shared.dataTask(with: url!) { data, response, err in
            
            if err == nil {
                do{
                    self.dogs = try JSONDecoder().decode([DogApi].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
            }
                catch{
                    print("error")
                }
                
                
            }
        }.resume()
    }


}

