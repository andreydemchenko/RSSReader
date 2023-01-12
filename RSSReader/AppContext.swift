//
//  AppContext.swift
//  RSSReader
//
//  Created by zuzex-62 on 30.12.2022.
//

import Foundation
import CoreData

let appContext = AppContext()

class AppContext {
    
    lazy var historyCoreDataManager = HistoryCoreDataManager()
    lazy var sourcesCoreDataManager = SourceCoreDataManager()
    lazy var imageCache = ImageCache()
    
}
