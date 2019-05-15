//
//  PostListTableViewController.swift
//  Post
//
//  Created by Kaden Hendrickson on 5/13/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController {

    
    let postController = PostController()
    
    
    var refreshedControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshedControl.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)

        postController.fetchPosts {
            self.reloadTableView()
        }
        tableView.estimatedRowHeight = 45
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.refreshControl = refreshedControl
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        presentNewPostAlert()
    }
    
    func presentNewPostAlert(){
        let alertController = UIAlertController(title: "Create a new Message", message: "Write your new post here!", preferredStyle: .alert)
        alertController.addTextField { (usernameTextField) in
            usernameTextField.placeholder = "username"
        }
        alertController.addTextField { (messsageTextField) in
            messsageTextField.placeholder = "message"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addPostAction = UIAlertAction(title: "Post", style: .default) { (_) in
            guard let username = alertController.textFields?[0].text,
                let post = alertController.textFields?[1].text else {return}
            self.postController.addNewPostWith(username: username, text: post, completion: {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
        alertController.addAction(cancelAction)
        alertController.addAction(addPostAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.refreshedControl.endRefreshing()

        }
    }
    
    @objc func refreshControlPulled() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.refreshedControl.beginRefreshing()
        postController.fetchPosts {
            self.reloadTableView()
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postController.posts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        let post = postController.posts[indexPath.row]
        cell.textLabel?.text = post.text
        cell.detailTextLabel?.text = "\(post.timestamp)"

        return cell
    }
    


    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

}


