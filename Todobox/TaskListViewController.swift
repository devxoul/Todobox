//
//  TaskListViewController.swift
//  Todobox
//
//  Created by 전수열 on 12/26/15.
//  Copyright © 2015 Suyeol Jeon. All rights reserved.
//

import UIKit

let TodoboxTasksUserDefaultsKey = "TodoboxTasksUserDefaultsKey"

class TaskListViewController: UIViewController {

  @IBOutlet var tableView: UITableView!
  @IBOutlet var editButton: UIBarButtonItem!
  let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonDidTap))

  /// 할 일 목록
  var tasks = [Task]() {
    didSet {
      self.saveAll()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.loadAll()

    self.doneButton.target = self
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let navigationController = segue.destination as? UINavigationController,
      let taskEditorViewController = navigationController.viewControllers.first as? TaskEditorViewController {
      taskEditorViewController.didAddHandler = { task in
        self.tasks.append(task)
        self.tableView.reloadData()
      }
    }
  }

  /// `tasks`를 로컬에 저장합니다.
  func saveAll() {
    let data = self.tasks.map {
      [
        "title": $0.title,
        "done": $0.done,
        ]
    }

    let userDefaults = UserDefaults.standard
    userDefaults.set(data, forKey: TodoboxTasksUserDefaultsKey)
    userDefaults.synchronize()
  }

  func loadAll() {
    let userDefaults = UserDefaults.standard
    guard let data = userDefaults.object(forKey: TodoboxTasksUserDefaultsKey) as? [[String: AnyObject]] else {
      return
    }

    self.tasks = data.flatMap {
      guard let title = $0["title"] as? String else {
        return nil
      }
      let done = $0["done"]?.boolValue == true
      return Task(title: title, done: done)
    }
  }

  @IBAction func editButtonDidTap() {
    guard !self.tasks.isEmpty else {
      return
    }
    self.navigationItem.leftBarButtonItem = self.doneButton
    self.tableView.setEditing(true, animated: true)
  }

  dynamic func doneButtonDidTap() {
    self.navigationItem.leftBarButtonItem = self.editButton
    self.tableView.setEditing(false, animated: true)
  }

}


// MARK: - UITableViewDataSource

extension TaskListViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.tasks.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
    let task = self.tasks[indexPath.row]
    cell.textLabel?.text = task.title
    cell.detailTextLabel?.text = task.note
    if task.done {
      cell.accessoryType = .checkmark
    } else {
      cell.accessoryType = .none
    }
    return cell
  }

}


// MARK: - UITableViewDelegate

extension TaskListViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    var task = self.tasks[indexPath.row]
    task.done = !task.done
    self.tasks[indexPath.row] = task
    self.tableView.reloadRows(at: [indexPath], with: .automatic)
  }

  func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    var tasks = self.tasks
    let task = tasks[sourceIndexPath.row]
    tasks.remove(at: sourceIndexPath.row)
    tasks.insert(task, at: destinationIndexPath.row)
    self.tasks = tasks
  }

  func tableView(_ tableView: UITableView,
                 commit editingStyle: UITableViewCellEditingStyle,
                 forRowAt indexPath: IndexPath) {
    tableView.beginUpdates()
    self.tasks.remove(at: indexPath.row)
    tableView.deleteRows(at: [indexPath], with: .automatic)
    tableView.endUpdates()

    if self.tasks.isEmpty {
      self.doneButtonDidTap()
    }
  }

}
