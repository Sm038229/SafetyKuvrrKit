//
//  SKMapsTableViewController.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 25/07/24.
//

import UIKit

class SKMapsTableViewController: UITableViewController {
    var mapData: SKMapListResponse?
    private let steerpathMap = "Steerpath"
    private let hereMap = "Here"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackButton()
        //
        tableView.estimatedRowHeight = 50
        SKServiceManager.mapList { [weak self] response in
            self?.mapData = response
            self?.refreshData()
        } failure: { error in
            
        }
    }
    
    private func refreshData() {
        if let mapList = mapData?.mapList {
            var tempMapList: [SKMapInfoResponse] = []
            for mapInfo in mapList {
                if let mapType = mapInfo.mapType, mapType.lowercased() != steerpathMap.lowercased(), mapType.lowercased() != hereMap.lowercased() {
                    tempMapList.append(mapInfo)
                }
            }
            mapData?.mapList = tempMapList
        }
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    /*
     override func numberOfSections(in tableView: UITableView) -> Int {
     // #warning Incomplete implementation, return the number of sections
     return 0
     }
     */
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mapData?.mapList?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SKMapsTableViewCell.defaultIdentifier, for: indexPath) as! SKMapsTableViewCell
        
        if let mapInfo = mapData?.mapList?[indexPath.row] {
            cell.titleLabel.setupLabel(text: mapInfo.mapName)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let mapInfo = mapData?.mapList?[indexPath.row] {
            SKMapManager.presentMapsViewController(forMapData: mapInfo)
        } else {
            print("Map not found")
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
