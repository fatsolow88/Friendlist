//
//  FriendsTableViewController.swift
//  Friendlist
//
//  Created by Low Wai Hong on 11/06/2019.
//  Copyright © 2019 Low Wai Hong. All rights reserved.
//

import UIKit
import PKHUD

class FriendsTableViewController: UITableViewController {

    let viewModel: FriendsTableViewViewModel = FriendsTableViewViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        bindViewModel()
    }

    // MARK: - Table view data source

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func bindViewModel(){
        viewModel.friendCells.bindAndFire { [weak self] _ in
            self?.tableView?.reloadData()
        }
        
        viewModel.showLoadingHud.bind { (visible) in
            PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
            visible ? PKHUD.sharedHUD.show() : PKHUD.sharedHUD.hide()
        }
        
        viewModel.onShowError = { [weak self] alert in
            let alertController = UIAlertController(title: alert.title,
                                                    message: alert.message,
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: alert.action.buttonTitle,
                                                    style: .default,
                                                    handler: { _ in alert.action.handler?() }))
            self?.present(alertController, animated: true, completion: nil)
        }
        
        //closure format
//        { (parameters) -> return type in
//            statements
//        }

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "friendsToAddFriend",
            let destinationViewController = segue.destination as? FriendViewController {
            destinationViewController.viewModel = AddFriendViewModel()
            destinationViewController.updateFriends = { [weak self] in
                self?.viewModel.getFriends()
            }
        }
        else if segue.identifier == "friendToUpdateFriend",
            let destinationViewController = segue.destination as? FriendViewController,
            let indexPath = tableView.indexPathForSelectedRow {
            
            switch viewModel.friendCells.value[indexPath.row] {
            case .normal(let viewModel):
                destinationViewController.viewModel = UpdateFriendViewModel(friend:viewModel.friendItem)
                destinationViewController.updateFriends = { [weak self] in
                    self?.viewModel.getFriends()
                }
            case .empty, .error:
                // nop
                break
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension FriendsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.friendCells.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.friendCells.value[indexPath.row] {
        case .normal(let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTableViewCell") as? FriendTableViewCell else {
                return UITableViewCell()
            }
            cell.viewModel = viewModel
            return cell
        case .error(let message):
            let cell = UITableViewCell()
            cell.textLabel?.text = message
            return cell
        case .empty:
            let cell = UITableViewCell()
            cell.textLabel?.text = "No data available"
            return cell
        }
    }
    
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
        return true
     }
 
    
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            viewModel.deleteFriend(at: indexPath.row)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}
