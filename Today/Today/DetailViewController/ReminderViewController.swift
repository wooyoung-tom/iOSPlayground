//
//  ReminderViewController.swift
//  Today
//
//  Created by 최우영 on 2023/03/27.
//

import UIKit

class ReminderViewController: UICollectionViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Row>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    
    var reminder: Reminder {
        didSet {
            onChange(reminder)
        }
    }
    var workingReminder: Reminder
    var isAddingNewReminder: Bool = false
    var onChange: (Reminder) -> Void
    private var dataSource: DataSource!
    
    // In Swift, classes and structures must assign an initial value to all stored properties by the time an instance is created.
    init(reminder: Reminder, onChange: @escaping (Reminder) -> Void) {
        self.reminder = reminder
        self.workingReminder = reminder
        self.onChange = onChange
        
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfiguration.showsSeparators = false
        listConfiguration.headerMode = .firstItemInSection
        
        // create a compositional list layout using the list configuration,
        // and assign the result to a constant named listLayout.
        let listLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        
        // call the superclass's init, passing the new list layout.
        // Swift subclass must call one of its superclass's designated initializers durin initialization.
        super.init(collectionViewLayout: listLayout)
    }
    
    // create the failable initializer that NSCoding requires.
    required init?(coder: NSCoder) {
        fatalError("Always initialize ReminderViewController using init(reminder:)")
    }
    
    // You'll intervene in the view controller's life cycle to register the cell with the
    // collection view and create the data source after the view loads.
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        
        // to avoid unnecessary cell creation,
        // the system maintains a queue of collection cells to recycle after they go offscreen.
        dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Row) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        // iOS 16 supports navigation styles that allow you to customize the behavior
        // and content density of your navigation bar.
        if #available(iOS 16, *) {
            navigationItem.style = .navigator
        }
        
        // change the navigation title to "Reminder".
        navigationItem.title = NSLocalizedString("Reminder", comment: "Reminder view controller title")
        navigationItem.rightBarButtonItem = editButtonItem
        
        updateSnapshotForViewing()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        // if the view is transitioning into its editing mode, call updatingSnapshotForEditing().
        // Otherwise, call updateSnapshotForViewing().
        if editing {
            prepareForEditing()
        } else {
            if isAddingNewReminder {
                onChange(workingReminder)
            } else {
                prepareForViewing()
            }
        }
    }
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: Row) {
        let section = section(for: indexPath)
        switch (section, row) {
        case (_, .header(let title)):
            cell.contentConfiguration = headerConfiguration(for: cell, with: title)
        case (.view, _):
            cell.contentConfiguration = defaultConfiguration(for: cell, at: row)
        case (.title, .editableText(let title)):
            cell.contentConfiguration = titleConfiguration(for: cell, with: title)
        case (.date, .editableDate(let date)):
            cell.contentConfiguration = dateConfiguration(for: cell, with: date)
        case (.notes, .editableText(let notes)):
            cell.contentConfiguration = notesConfiguration(for: cell, with: notes)
        default: fatalError("Unexpected combination of section and row.")
        }
        cell.tintColor = .todayPrimaryTint
    }
    
    @objc func didCancelEdit() {
        workingReminder = reminder
        setEditing(false, animated: true)
    }
    
    private func prepareForEditing() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didCancelEdit))
        updateSnapshotForEditing()
    }
    
    private func updateSnapshotForEditing() {
        // the snapshot represents the current state of the data.
        var snapshot = Snapshot()
        snapshot.appendSections([.title, .date, .notes])
        
        snapshot.appendItems([.header(Section.title.name), .editableText(reminder.title)], toSection: .title)
        snapshot.appendItems([.header(Section.date.name), .editableDate(reminder.dueDate)], toSection: .date)
        snapshot.appendItems([.header(Section.notes.name), .editableText(reminder.notes)], toSection: .notes)
        
        dataSource.apply(snapshot)
    }
    
    private func prepareForViewing() {
        navigationItem.leftBarButtonItem = nil
        if workingReminder != reminder {
            reminder = workingReminder
        }
        updateSnapshotForViewing()
    }
    
    // You'll start developing the collection view snapshot
    // with a mutable snapshot instance that uses default values.
    private func updateSnapshotForViewing() {
        var snapshot = Snapshot()
        snapshot.appendSections([.view])
        
        // Because view mode has a single section, it doesn't need a header.
        snapshot.appendItems([Row.header(""), Row.title, Row.date, Row.time, Row.notes], toSection: .view)
        
        // recall that applying a snapshot updates the user interface
        // to reflect the snapshot's data and styling.
        dataSource.apply(snapshot)
    }
    
    // returns the section for a row that you pass to it.
    private func section(for indexPath: IndexPath) -> Section {
        // use the index path to generate a section number.
        // In view mode, all items are displayed in section 0.
        // In editing mode, the title, date, and notes are separated into section 1, 2, and 3, respectively.
        let sectionNumber = isEditing ? indexPath.section + 1 : indexPath.section
        
        // Use the section number to create an instance of Section.
        
        guard let section = Section(rawValue: sectionNumber) else {
            fatalError("Unable to find matching section")
        }
        return section
    }
}
