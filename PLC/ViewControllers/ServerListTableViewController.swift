//
//  ServerListTableTableViewController.swift
//  PLC
//
//  Created by Manuel Stampfl on 12.08.15.
//  Copyright (c) 2015 mani1337. All rights reserved.
//

import UIKit

class ServerListTableViewController: UITableViewController {
    var servers: [Server] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationController?.setToolbarHidden(false, animated: false)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.reload()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.servers.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ServerCell", forIndexPath: indexPath) as! UITableViewCell

        cell.textLabel?.text = self.servers[indexPath.row].name
        cell.detailTextLabel?.text = self.servers[indexPath.row].host

        return cell
    }
    

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            CoreData.coreData.servers.remove(self.servers[indexPath.row])
            self.servers = CoreData.coreData.servers.all()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        CoreData.coreData.servers.move(fromIndexPath.row, toIndex: toIndexPath.row)
        self.reload()
    }

    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditServer" || segue.identifier == "AddServer" {
            let server: Server
            if segue.identifier == "EditServer" {
                server = self.servers[self.tableView.indexPathForCell(sender as! UITableViewCell)!.row]
            } else {
                server = CoreData.coreData.servers.create(shouldSave: true)!
            }
            
            (segue.destinationViewController as! EditServerTableViewController).server = server
        }
    }
    
    func reload() {
        self.servers = CoreData.coreData.servers.all()
        self.tableView.reloadData()
    }
}
