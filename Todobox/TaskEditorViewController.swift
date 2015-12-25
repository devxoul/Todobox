//
//  TaskEditorViewController.swift
//  Todobox
//
//  Created by 전수열 on 12/26/15.
//  Copyright © 2015 Suyeol Jeon. All rights reserved.
//

import UIKit

class TaskEditorViewController: UIViewController {

    @IBOutlet var titleInput: UITextField!

    var didAddHandler: (Task -> Void)?

    @IBAction func cancelButtonDidTap() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func doneButtonDidTap() {
        guard let title = self.titleInput.text where !title.isEmpty else {
            return
        }
        let newTask = Task(title: title)
        let navigationController = self.presentingViewController as? UINavigationController
        let taskListViewController = navigationController?.viewControllers.first as? ViewController
        taskListViewController?.tasks.append(newTask)
        taskListViewController?.tableView.reloadData()
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
