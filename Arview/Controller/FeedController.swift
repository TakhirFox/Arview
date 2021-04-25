//
//  FeedController.swift
//  Arview
//
//  Created by Zakirov Tahir on 25.04.2021.
//

import UIKit
import CoreData
import SDWebImage

// ВНЕДРИТЬ КОРДАТУ
// ПРОВЕРКА СЕТИ
// ФОРМУ ЗАХВАТА, ПОКА НЕЗНАЮ КУДА БУДут УХОДИТЬ данные

class FeedController: UITableViewController {
    
    let cellId = "cellId"
    let pageSize = 1
    var pages = 1
    var isPaginating = false
    var isDonePaginating = false
    let networkService = NetworkService()
    var topGames = [Top]()
    var cacheTopGames = [Entity]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let context = getContext()
        let fetchRequest: NSFetchRequest<Entity> = Entity.fetchRequest()
        
        if Reachability.isConnected() {
            
            let results = try! context.fetch(fetchRequest)
            for item in results {
                context.delete(item)
            }
            
            do {
                try context.save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        } else {
            noInternet(title: "Отсутствует интернет", message: "Но мы сохранили для вас кое-какие данные")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        tableView.register(GamesCell.self, forCellReuseIdentifier: cellId)
        
        if Reachability.isConnected() {
            getData()
        }
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let context = getContext()
        let fetchRequest: NSFetchRequest<Entity> = Entity.fetchRequest()
        let results = try! context.fetch(fetchRequest)
        
        if Reachability.isConnected() {
            return topGames.count
        } else {
            return results.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! GamesCell
        
        
        
        if Reachability.isConnected() {
            
            let games = topGames[indexPath.item]
            
            cell.nameLabel.text = games.game?.name
            cell.countChannelsLabel.text = String("Каналов: \(games.channels ?? 0)")
            cell.countViewsLabel.text = String("Зрителей: \(games.viewers ?? 0)")
            
            cell.imageViews.sd_setImage(with: URL(string: games.game?.box?.medium ?? ""), completed: nil)
            
            DispatchQueue.global().async {
                
                
                
                guard let imageUrl = URL(string: games.game?.box?.medium ?? "") else { return }
                
                guard let imageData = try? Data(contentsOf: imageUrl) else { return }
                
                DispatchQueue.main.async {
                    self.saveData(with: games.game?.name ?? "",
                                  channels: games.channels ?? 0,
                                  viewers: games.viewers ?? 0,
                                  medium: imageData)
                }
                    
            }
            
        } else {
            
            let context = getContext()
            let fetchRequest: NSFetchRequest<Entity> = Entity.fetchRequest()
            
            do {
                
                cacheTopGames = try context.fetch(fetchRequest)
                cell.nameLabel.text = cacheTopGames[indexPath.row].name
                cell.countChannelsLabel.text = String("\(cacheTopGames[indexPath.row].channels)")
                cell.countViewsLabel.text = String("\(cacheTopGames[indexPath.row].viewers)")
                cell.imageViews.image = UIImage(data: cacheTopGames[indexPath.row].medium!)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        
        if indexPath.row == topGames.count - 1 && !isPaginating  {
 
            isPaginating = true
            
            getData()
        }
        
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func getData() {
        
        let baseUrl = "https://api.twitch.tv/kraken/games/top?offset=\(pages)&limit=\(pageSize)"
        
        networkService.getTopGames(urlString: baseUrl)  { (topGames: Articles?, error) in
            
            if error != nil {
                DispatchQueue.main.async {
                    // Сюда кинуть алерт
                    print("Ошибка")
                }
                return
            }
            
            self.pages += 1
            
            if topGames?.top?.count == 0 {
                self.isDonePaginating = true
            }
            
            self.topGames += topGames?.top ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            self.isPaginating = false
            
        }
    }
    
    func noInternet(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: "Повторить", style: .default) { (_) in
            self.getData()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(retryAction)
        alertController.addAction(cancelAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func saveData(with name: String, channels: Int, viewers: Int, medium: Data ) {
        
        let context = getContext()
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Entity", in: context) else { return }
        
        let object = Entity(entity: entity, insertInto: context)
        object.name = name
        object.channels = Int64(channels)
        object.viewers = Int64(viewers)
        object.medium = medium
        
        do {
            try context.save()
            cacheTopGames.append(object)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
}
