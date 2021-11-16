//
//  ContentTableView.swift
//  PasswordScreenAutoLayout
//
//  Created by Paul Solt on 4/3/20.
//  Copyright © 2020 BloomTech. All rights reserved.
//

import UIKit

class ContentTableView: UITableViewController {
    
    lazy var mockData: [Int] = {
        var array = [Int]()
        for i in 0...100 {
            array.append(i)
        }
        return array
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let element = mockData[indexPath.row]
        cell.textLabel?.text = "Fake content row: \(element)"
        return cell
    }
    
}
