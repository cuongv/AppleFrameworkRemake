//
//  CVNotificationCenter.swift
//  AppleFrameworkRemake
//
//  Created by Cuong Vuong on 12/6/19.
//  Copyright © 2019 Cuong Vuong. All rights reserved.
//

import Foundation

fileprivate struct CVDictionaryKey: Hashable {
    let observer: NSObject
    let name: Notification.Name
}

fileprivate extension Dictionary where Key == CVDictionaryKey, Value ==  Selector {
    func getObserversAndSelectors(for name: Notification.Name) -> [(NSObject, Selector)] {
        return keys.filter { $0.name == name }.map { ($0.observer, self[$0]!) }
    }
    
    mutating func removeAllSelectors(for observer: NSObject) {
        keys.filter { $0.observer == observer }.forEach { self[$0] = nil }
    }
    
    mutating func removeSelector(for observer: NSObject, and name: Notification.Name) {
        if let key = keys.first(where: { $0.observer == observer && $0.name == name }) {
            self[key] = nil
        }
    }
}

public final class CVNotificationCenter {
    static let `default` = CVNotificationCenter()
    
    private let queue = DispatchQueue(label: "CVNotificationQueue", attributes: .concurrent)
    private var observersDictionary = [CVDictionaryKey: Selector]()
    
    func addObserver(_ observer: NSObject, selector: Selector, name: Notification.Name) {
        queue.async(flags: .barrier) { [weak self] in
            let key = CVDictionaryKey(observer: observer, name: name)
            self?.observersDictionary[key] = selector
        }
    }
    
    func post(_ notification: Notification) {
        queue.async { [weak self] in
            guard let obsAndSels = self?.observersDictionary.getObserversAndSelectors(for: notification.name) else { return }
            
            obsAndSels.forEach { (observer, selector) in
                if observer.responds(to: selector) {
                    observer.perform(selector, with: notification)
                }
            }
        }
    }
    
    func removeObserver(_ observer: NSObject) {
        queue.async(flags: .barrier) { [weak self] in
            self?.observersDictionary.removeAllSelectors(for: observer)
        }
    }
    
    func removeObserver(_ observer: NSObject, for name: Notification.Name) {
        queue.async(flags: .barrier) { [weak self] in
            self?.observersDictionary.removeSelector(for: observer, and: name)
        }
    }
}
