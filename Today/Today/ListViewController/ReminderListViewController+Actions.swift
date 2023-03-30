//
//  ReminderListViewController+Actions.swift
//  Today
//
//  Created by 최우영 on 2023/03/27.
//

import UIKit

// create another method that calls completeReminder
// when a user taps the done button in a cell.

extension ReminderListViewController {
    
    @objc func eventStoreChanged(_ notification: NSNotification) {
        reminderStoreChanged()
    }
    
    @objc func didPressDoneButton(_ sender: ReminderDoneButton) {
        // unwrap the sender's optional id into a constant named id.
        guard let id = sender.id else {
            return
        }
        
        completeReminder(withId: id)
    }
    
    @objc func didPressAddButton(_ sender: UIBarButtonItem) {
        let reminder = Reminder(title: "", dueDate: Date.now)
        let viewController = ReminderViewController(reminder: reminder) { [weak self] reminder in
            self?.addReminder(reminder)
            self?.updateSnapshot()
            self?.dismiss(animated: true)
        }
        viewController.isAddingNewReminder = true
        viewController.setEditing(true, animated: false)
        viewController.navigationItem.leftBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didCancelAdd))
        viewController.navigationItem.title =
            NSLocalizedString("Add Reminder", comment: "Add Reminder view controller title")
        
        // Modality is a useful design technique you can use to help a user focus on a self-contained task
        // that interrupts their current task, such as when they create a new reminder.
        // You'll present the navigation controller that you just created as a modal view over the list view.
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }
    
    @objc func didCancelAdd(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @objc func didChangeListStyle(_ sender: UISegmentedControl) {
        listStyle = ReminderListStyle(rawValue: sender.selectedSegmentIndex) ?? .today
        updateSnapshot()
        refreshBackground()
    }
}
