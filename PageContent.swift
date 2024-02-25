//
//  ViewModel.swift
//  Pace
//
//  Created by Carter Schafer on 2/23/24.
//

import Foundation
import SwiftUI

struct EduItem: Hashable, Codable {
  let category: String
  let title: String
  let facts: [String]
}

class PageContent: ObservableObject {
  @Published var items: [EduItem] = []
  
  let pagesURL = "https://c-schafer.github.io/pace/pages.json"
  
  func fetch() {
    guard let url = URL(string: pagesURL) else {
      return
    }
    let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
      guard let data = data, error == nil else {
        return
      }
      // Convert to JSON
      do {
        let items = try JSONDecoder().decode([EduItem].self, from: data)
        DispatchQueue.main.async {
          self?.items = items
        }
      }
      catch {
        print(error)
      }
    }
    task.resume()
  }
}

