//
//  ReminderListViewController+DataSource.swift
//  Today
//
//  Created by 최우영 on 2023/03/27.
//

import UIKit

extension ReminderListViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Reminder.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Reminder.ID>
    
    var reminderCompletedValue: String {
        NSLocalizedString("Completed", comment: "Reminder completed value")
    }
    
    var reminderNotCompletedValue: String {
        NSLocalizedString("Not completed", comment: "Reminder not completed value")
    }
    
    private var reminderStore: ReminderStore { ReminderStore.shared }
    
    /// Specifying an empty array as the default value for the parameter lets you call the method from `viewDidLoad` without providing identifiers.
    ///
    /// - Parameters:
    ///   - idsThatChanged: include only identifiers that correspond to reminders in the `filteredReminders` array
    func updateSnapshot(reloading idsThatChanged: [Reminder.ID] = []) {
        let ids = idsThatChanged.filter { id in
            filteredReminders.contains(where: { reminder in
                reminder.id == id
            })
        }
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(filteredReminders.map { reminder in reminder.id })
        
        if !ids.isEmpty {
            snapshot.reloadItems(ids)
        }
        
        dataSource.apply(snapshot)
        headerView?.progress = progress
    }
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, id: Reminder.ID) {
        let reminder = reminder(withId: id)
        
        // creates a content configuration with the predefines system style.
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = reminder.title
        contentConfiguration.secondaryText = reminder.dueDate.dayAndTimeText
        
        // change the secondary text's font to .caption1
        contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .caption1)
        
        // assign the content configuration to the celdl.
        cell.contentConfiguration = contentConfiguration
        
        var doneButtonConfiguration = doneButtonConfiguration(for: reminder)
        doneButtonConfiguration.tintColor = .todayListCellDoneButtonTint
        
        cell.accessibilityCustomActions = [doneButtonAccessibilityAction(for: reminder)]
        cell.accessibilityValue = reminder.isComplete ? reminderCompletedValue : reminderNotCompletedValue
        
        // create an array of cell accessories, and assign it to the cell's accessories property.
        
        // the array contains a custom view configured using the done button configuration
        // and an always-on disclosure indicator.
        cell.accessories = [
            .customView(configuration: doneButtonConfiguration),
            .disclosureIndicator(displayed: .always)
        ]
        
        var backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfiguration.backgroundColor = .todayListCellBackground
        cell.backgroundConfiguration = backgroundConfiguration
    }
    
    // accepts a reminder identifier and returns the corresponding reminder from the reminders array.
    func reminder(withId id: Reminder.ID) -> Reminder {
        let index = reminders.indexOfReminder(withId: id)
        return reminders[index]
    }
    
    func updateReminder(_ reminder: Reminder) {
        do {
            try reminderStore.save(reminder)
            let index = reminders.indexOfReminder(withId: reminder.id)
            reminders[index] = reminder
        } catch TodayError.accessDenied {
            // Try adding the error handling yourself. Use the steps below to help if you get stuck.
        } catch {
            showError(error)
        }
    }
    
    // this method will be called when the button is pressed.
    func completeReminder(withId id: Reminder.ID) {
        // fetch the reminder
        var reminder = reminder(withId: id)
        // toggle the reminder's isComplete property.
        reminder.isComplete.toggle()
        // update the reminder in the model.
        updateReminder(reminder)
        updateSnapshot(reloading: [id])
    }
    
    func addReminder(_ reminder: Reminder) {
        var reminder = reminder
        do {
            let idFromStore = try reminderStore.save(reminder)
            reminder.id = idFromStore
            reminders.append(reminder)
        } catch TodayError.accessDenied {
            // if the user chose to disallow access to their reminders. In this case, you'll ignore the error.
        } catch {
            showError(error)
        }
    }
    
    func deleteReminder(withId id: Reminder.ID) {
        do {
            try reminderStore.remove(with: id)
            let index = reminders.indexOfReminder(withId: id)
            reminders.remove(at: index)
        } catch TodayError.accessDenied {
            // do nothing.
        } catch {
            showError(error)
        }
    }
    
    func prepareReminderStore() {
        // create a new unit of work that executes asynchronously.
        Task {
            do {
                try await reminderStore.requestAccess()
                reminders = try await reminderStore.readAll()
                NotificationCenter.default.addObserver(self, selector: #selector(eventStoreChanged(_:)), name: .EKEventStoreChanged, object: nil)
            } catch TodayError.accessDenied, TodayError.accessRestricted {
                // Providing sample data allows your app to function in a demonstration mode when EventKit data is unavailable.
                #if DEBUG
                reminders = Reminder.sampleData
                #endif
            } catch {
                showError(error)
            }
            
            updateSnapshot()
        }
    }
    
    func reminderStoreChanged() {
        Task {
            reminders = try await reminderStore.readAll()
            updateSnapshot()
        }
    }
    
    /// call this method in the cell registration handler to create a custom action for each cell.
    private func doneButtonAccessibilityAction(for reminder: Reminder) -> UIAccessibilityCustomAction {
        let name = NSLocalizedString("Toggle completion", comment: "Reminder done button accessibility label")
        let action = UIAccessibilityCustomAction(name: name) { [weak self] action in
            self?.completeReminder(withId: reminder.id)
            return true
        }
        
        return action
    }
    
    private func doneButtonConfiguration(for reminder: Reminder) -> UICellAccessory.CustomViewConfiguration {
        // user the ternary conditional operator to assign either
        // "circle.fill" or "circle" to a constant.
        let symbolName = reminder.isComplete ? "circle.fill" : "circle"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        
        // create a new image using the symbol configuration,
        // and assign the result to a constant named image.
        let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        
        // create a new button, and assign the result to a constant named button.
        let button = ReminderDoneButton()
        
        // during compilation, the system checks that the target,
        // ReminderListViewController, has a didPressDoneButton(_:) method.
        button.addTarget(self, action: #selector(didPressDoneButton(_:)), for: .touchUpInside)
        button.id = reminder.id
        button.setImage(image, for: .normal)
        
        // this configuration initializer lets you define whether the cell accessory
        // appears on the leading or the trailing edge of a cell, outside of the cell's content view.
        return UICellAccessory.CustomViewConfiguration(customView: button, placement: .leading(displayed: .always))
    }
}
