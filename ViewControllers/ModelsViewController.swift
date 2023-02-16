//
//  ModelsViewController.swift
//  Vehicles
//
//  Created by Aleksey Libin on 16.02.2023.
//

import UIKit

final class ModelsViewController: UITableViewController {
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  init(for auto: Auto) {
    self.auto = auto
    super.init(nibName: nil, bundle: nil)
  }
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  let auto: Auto
  
  var models: [Model] {
    get {
      do {
        let allModels = try context.fetch(Model.fetchRequest())
        var filtered: [Model] = []
        allModels.forEach { model in
          if model.brand == auto {
            filtered.append(model)
          }
        }
        return filtered
      } catch {
        fatalError(error.localizedDescription)
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }
  
  @objc private func addModel() {
    let alert = UIAlertController(title: "Add model", message: "Enter a name", preferredStyle: .alert)
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
private extension ModelsViewController {
  func create(with name: String) {
    let newModel = Model(context: context)
    newModel.name = name
    auto.addToModel(newModel)
    
    
    do {
      try context.save()
    } catch {
      fatalError(error.localizedDescription)
    }
    tableView.reloadData()
  }
  
  func delete(_ object: Model) {
    context.delete(object)
    do {
      try context.save()
    } catch {
      fatalError(error.localizedDescription)
    }
    tableView.reloadData()
  }
  
  func update(_ object: Model) {
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


// MARK: - SetupTableView
extension ModelsViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return models.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Model", for: indexPath)
    let model = models[indexPath.row].name
    cell.textLabel?.text = model
    return cell
  }
  
  override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let actoin = UIContextualAction(style: .destructive, title: "remove") { _, _, _ in
      let model = self.models[indexPath.row]
      self.delete(model)
    }
    return UISwipeActionsConfiguration(actions: [actoin])
  }
  
  override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let action = UIContextualAction(style: .normal, title: "edit") { _, _, _ in
      let model = self.models[indexPath.row]
      self.update(model)
    }
    return UISwipeActionsConfiguration(actions: [action])
  }
}


// MARK: - SetupViews
private extension ModelsViewController {
  func setupViews() {
    
    let plus = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addModel))
    navigationItem.rightBarButtonItem = plus
    navigationItem.title = auto.name
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Model")
    
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
