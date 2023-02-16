//
//  VehiclesViewController.swift
//  Vehicles
//
//  Created by Aleksey Libin on 16.02.2023.
//

import UIKit

final class VehiclesViewController: UITableViewController {
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  var autos: [Auto] {
    get {
      do {
        return try context.fetch(Auto.fetchRequest())
      } catch {
        fatalError(error.localizedDescription)
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }
  
  @objc private func addAuto() {
    let alert = UIAlertController(title: "Add auto", message: "Enter a name", preferredStyle: .alert)
    alert.addTextField()
    let cancel = UIAlertAction(title: "Cancel", style: .cancel)
    let submit = UIAlertAction(title: "Submit", style: .default) { _ in
      guard
        let name = alert.textFields?.first?.text,
        name != ""
      else { return }
      self.create(with: name)
    }
    alert.addAction(cancel)
    alert.addAction(submit)
    present(alert, animated: true)
  }
}


// MARK: - CoreData methods
private extension VehiclesViewController {
  func create(with name: String) {
    let newObject = Auto(context: context)
    newObject.name = name
    do {
      try context.save()
    } catch {
      fatalError(error.localizedDescription)
    }
    tableView.reloadData()
  }
  
  func delete(_ object: Auto) {
    context.delete(object)
    do {
      try context.save()
    } catch {
      fatalError(error.localizedDescription)
    }
    tableView.reloadData()
  }
  
  func update(_ object: Auto) {
    let alert = UIAlertController(title: "Edit", message: nil, preferredStyle: .alert)
    alert.addTextField { textField in
      textField.text = object.name
    }
    let cancel = UIAlertAction(title: "Cancel", style: .cancel)
    let submit = UIAlertAction(title: "Submit", style: .default) { _ in
      guard
        let textField = alert.textFields?.first,
        textField.hasText
      else { return }
      object.name = textField.text
      
      do {
        try self.context.save()
      } catch {
        fatalError(error.localizedDescription)
      }
      self.tableView.reloadData()
      
    }
    alert.addAction(cancel)
    alert.addAction(submit)
    present(alert, animated: true)
  }
}


// MARK: - TableViewSetup
extension VehiclesViewController {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return autos.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Auto", for: indexPath)
    cell.textLabel?.text = autos[indexPath.row].name
    return cell
  }
  
  override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let action = UIContextualAction(style: .destructive, title: "remove") { _, _, _ in
      let auto = self.autos[indexPath.row]
      self.delete(auto)
    }
    return UISwipeActionsConfiguration(actions: [action])
  }
  
  override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let action = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in
      let auto = self.autos[indexPath.row]
      self.update(auto)
    }
    return UISwipeActionsConfiguration(actions: [action])
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let modelsVC = ModelsViewController(for: autos[indexPath.row])
    navigationController?.pushViewController(modelsVC, animated: true)
  }
  
  
}


// MARK: - SetupViews
private extension VehiclesViewController {
  func setupViews() {
    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Auto")
    let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAuto))
    navigationItem.rightBarButtonItem = plusButton
    
    let imageView = UIImageView(image: UIImage(named: "wallpaper"))
    view.addSubview(imageView)
    
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    NSLayoutConstraint.activate([
      imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100)
    ])
  }
}
