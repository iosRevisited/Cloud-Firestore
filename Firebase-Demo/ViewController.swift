//
//  ViewController.swift
//  Firebase-Demo
//
//  Created by Sai Sandeep on 25/09/17.
//  Copyright © 2017 iosRevisited. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var professionField: UITextField!
    
    var docRef : DocumentReference!
    
    var dataListener : FIRListenerRegistration!
    override func viewDidLoad() {
        super.viewDidLoad()
        docRef = Firestore.firestore().document("friends/profile")
        
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let name = nameField.text, !name.isEmpty else { return }
        guard let profession = professionField.text, !profession.isEmpty else { return }
        
        let dataToSave : [String: Any] = ["name": name, "profession": profession]
        docRef.setData(dataToSave) { (error) in
            if let error = error {
                print("Oh no! Some error \(error.localizedDescription)")
            }else {
                print("Data has been saved")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataListener =  docRef.addSnapshotListener { (docSnapshot, error) in
            guard let docSnapshot = docSnapshot, docSnapshot.exists else { return }
            let data = docSnapshot.data()
            let name = data["name"] as? String ?? ""
            let profession = data["profession"] as? String ?? ""
            self.titleLabel.text = "\(name) is a \(profession)"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dataListener.remove()
    }
    
    @IBAction func fetchButtonTapped(_ sender: Any) {
        docRef.getDocument { (docSnapshot, error) in
            guard let docSnapshot = docSnapshot, docSnapshot.exists else { return }
            let data = docSnapshot.data()
            let name = data["name"] as? String ?? ""
            let profession = data["profession"] as? String ?? ""
            self.titleLabel.text = "\(name) is a \(profession)"
        }
    }
    
}


