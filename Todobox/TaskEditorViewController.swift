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
    @IBOutlet var textView: UITextView!

    var didAddHandler: (Task -> Void)?

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.titleInput.becomeFirstResponder()
    }

    @IBAction func cancelButtonDidTap() {
        self.titleInput.resignFirstResponder()

        if self.titleInput.text?.isEmpty == true {
            self.dismissViewControllerAnimated(true, completion: nil)
            return
        }

        let yes = UIAlertAction(title: "작성 취소", style: .Destructive) { _ in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        let no = UIAlertAction(title: "계속 작성", style: .Default) { _ in
            self.titleInput.becomeFirstResponder()
        }

        let alertController = UIAlertController(
            title: "앗!",
            message: "취소하면 작성중인 내용이 손실됩니다.\n취소하시겠어요?",
            preferredStyle: .Alert
        )
        alertController.addAction(yes)
        alertController.addAction(no)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    @IBAction func doneButtonDidTap() {
        guard let title = self.titleInput.text where !title.isEmpty else {
            self.shakeTitleInput()
            return
        }

        self.titleInput.resignFirstResponder()

        let newTask = Task(title: title)
        self.didAddHandler?(newTask)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func shakeTitleInput() {
        UIView.animateWithDuration(0.05, animations: { self.titleInput.frame.origin.x -= 5 }) { _ in
            UIView.animateWithDuration(0.05, animations: { self.titleInput.frame.origin.x += 10 }) { _ in
                UIView.animateWithDuration(0.05, animations: { self.titleInput.frame.origin.x -= 10 }) { _ in
                    UIView.animateWithDuration(0.05, animations: { self.titleInput.frame.origin.x += 10 }) { _ in
                        UIView.animateWithDuration(0.05) { self.titleInput.frame.origin.x -= 5 }
                    }
                }
            }
        }
    }

}
