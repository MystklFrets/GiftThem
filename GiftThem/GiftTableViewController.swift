//
//  GiftTableViewController.swift
//  GiftThem
//
//  Created by Raul Fernando Gutierrez on 2/26/17.
//  Copyright © 2017 Raul Fernando Gutierrez. All rights reserved.
//

import UIKit
import CoreData

class GiftTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

//    var gifts = [["name": "Homie","image": "1", "item": "Camera"], ["name": "Mom","image": "2", "item": "a new iPhone"],
//                 ["name": "Wife","image": "3", "item": "a dress"], ["name": "Brother","image": "4", "item": "4k TV"]]
//    

    var gifts = [Gift]()
    
    var managedObjectContext:NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let iconImageView = UIImageView(image: UIImage(named: "trending"))
        self.navigationItem.titleView = iconImageView
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        loadData()
    }
    func loadData(){
        let giftRequest:NSFetchRequest<Gift> = Gift.fetchRequest()
        
        do{
            
            gifts = try managedObjectContext.fetch(giftRequest)
            self.tableView.reloadData()
        }catch{
            
            print("could not load data from core data \(error.localizedDescription)")
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gifts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GIftTableViewCell

     //   let gift = gifts[indexPath.row]
        
        let giftItem = gifts[indexPath.row]
        
        if let giftImage = UIImage(data: giftItem.image as! Data) {
        cell.backgroundImageView.image = giftImage
            
        }
        
//        cell.nameLabel.text = gift["name"]
//        cell.itemLabel.text = gift["item"]
        
        cell.nameLabel.text = giftItem.personName
        cell.itemLabel.text = giftItem.itemName
        return cell
    }

 
    @IBAction func addGift(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
           picker.dismiss(animated: true, completion: {
            
            self.createGiftItem(with: image)
           })
            
        }
        
        
    }
    
    func createGiftItem(with image: UIImage) {
        
        let giftItem = Gift(context: managedObjectContext)
        giftItem.image = NSData(data: UIImageJPEGRepresentation(image, 0.3)!)
        
        let inputAlert = UIAlertController(title: "New Gift", message: "Enter recipient name and gift name", preferredStyle: .alert)
        inputAlert.addTextField { (textField:UITextField) in
            textField.placeholder = "Person"
        }
        inputAlert.addTextField { (textField:UITextField) in
            textField.placeholder = "Gift Item"
        }
        
        inputAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action:UIAlertAction) in
            let personTextField = inputAlert.textFields?.first
            let giftTextField = inputAlert.textFields?.last
            
            if personTextField?.text != "" && giftTextField?.text != "" {
               giftItem.personName = personTextField?.text
               giftItem.itemName = giftTextField?.text
                
                do {
                    
                    try self.managedObjectContext.save()
                    self.loadData()
                }catch{
                    print("could not save data! \(error.localizedDescription)")
                    
                }
                
            }
        }))
   
        inputAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(inputAlert, animated: true, completion: nil)
        
    }
}
