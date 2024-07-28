//
//  DataManager.swift
//  KickBoardApp
//
//  Created by 김윤홍 on 7/24/24.
//

import UIKit
import CoreData

protocol ReadCoreData {
  func readCoreData<T: NSManagedObject>(entityType: T.Type) -> [T]
  func readUserDefault(key: String) -> String?
  func deleteUserDefault(key: String)
}

class DataManager: ReadCoreData {
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  // CoreData에서 데이터 읽기
  func readCoreData<T: NSManagedObject>(entityType: T.Type) -> [T] {
    let fetchRequest = NSFetchRequest<T>(entityName: String(describing: entityType))
    
    do {
      let results = try context.fetch(fetchRequest)
      return results
    } catch {
      print("Failed to fetch data: \(error)")
      return []
    }
  }
  
  // UserDefaults에서 데이터 읽기
  func readUserDefault(key: String) -> String? {
    return UserDefaults.standard.object(forKey: key) as? String
  }
  
  // UserDefaults에서 데이터 삭제
  func deleteUserDefault(key: String) {
    UserDefaults.standard.removeObject(forKey: key)
  }
}


