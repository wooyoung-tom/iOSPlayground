//
//  ViewController.swift
//  Today
//
//  Created by 최우영 on 2023/03/27.
//

import UIKit

class ReminderListViewController: UICollectionViewController {
    var dataSource: DataSource!
    var reminders: [Reminder] = Reminder.sampleData
    var listStyle: ReminderListStyle = .today
    var filteredReminders: [Reminder] {
        return reminders
            .filter { reminder in
                listStyle.shouldInclude(date: reminder.dueDate)
            }
            .sorted { r1, r2 in
                r1.dueDate < r2.dueDate
            }
    }
    
    let listStyleSegmentedControl = UISegmentedControl(
        items: [ReminderListStyle.today.name, ReminderListStyle.future.name, ReminderListStyle.all.name]
    )
    
    var headerView: ProgressHeaderView?
    var progress: CGFloat {
        let chunkSize = 1.0 / CGFloat(filteredReminders.count)
        // reduce method returns the result of combining the elements of a sequence.
        let progress = filteredReminders.reduce(0.0) { result, reminder in
            let chunk = reminder.isComplete ? chunkSize : 0
            return result + chunk
        }
        return progress
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .todayGradientFutureBegin
        
        let listLayout = listLayout()
        collectionView.collectionViewLayout = listLayout
        
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        
        dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Reminder.ID) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration(
            elementKind: ProgressHeaderView.elementKind,
            handler: supplementaryRegistrationHandler
        )
        dataSource.supplementaryViewProvider = { supplementaryView, elementKind, indexPath in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didPressAddButton(_:)))
        addButton.accessibilityLabel = NSLocalizedString("Add reminder", comment: "Add button accessibility label")
        navigationItem.rightBarButtonItem = addButton
        
        listStyleSegmentedControl.selectedSegmentIndex = listStyle.rawValue
        listStyleSegmentedControl.addTarget(self, action: #selector(didChangeListStyle(_:)), for: .valueChanged)
        navigationItem.titleView = listStyleSegmentedControl
        
        if #available(iOS 16, *) {
            navigationItem.style = .navigator
        }
        
        updateSnapshot()
        
        // assign the data source to the collection view.
        collectionView.dataSource = dataSource
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let id = filteredReminders[indexPath.item].id
        pushDetailViewForReminder(withId: id)
        return false
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        willDisplaySupplementaryView view: UICollectionReusableView,
        forElementKind elementKind: String,
        at indexPath: IndexPath
    ) {
        guard elementKind == ProgressHeaderView.elementKind, let progressView = view as? ProgressHeaderView
        else {
            return
        }
        progressView.progress = progress
    }
    
    /**
     * This method adda a detail view controller to the navigation stack, causing a detail view to push onto the screen.
     * The detail view displays the reminder details for the provided identifier.
     * And a Back button appears automatically as the leading item in the navigation bar.
     */
    func pushDetailViewForReminder(withId id: Reminder.ID) {
        let reminder = reminder(withId: id)
        let viewController = ReminderViewController(reminder: reminder) { [weak self] reminder in
            self?.updateReminder(reminder)
            self?.updateSnapshot(reloading: [reminder.id])
        }
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.headerMode = .supplementary
        listConfiguration.showsSeparators = false
        listConfiguration.trailingSwipeActionsConfigurationProvider = makeSwipeActions
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
    private func makeSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        guard let indexPath = indexPath, let id = dataSource.itemIdentifier(for: indexPath) else {
            return nil
        }
        let deleteActionTitle = NSLocalizedString("Delete", comment: "Delete action title")
        let deleteAction = UIContextualAction(style: .destructive, title: deleteActionTitle) {
            [weak self] _, _, completion in
            self?.deleteReminder(withId: id)
            self?.updateSnapshot()
            completion(false)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    /// The registration handler specifies how to configure the content and appearance of the supplementary view.
    private func supplementaryRegistrationHandler(progressView: ProgressHeaderView, elementKind: String, indexPath: IndexPath) {
        headerView = progressView
    }
}
