//
//  ObserverList.swift
//  ObserverList
//
//  Created by incetro on 6/2/21.
//

import Foundation

// MARK: - ObserverList

/// Base class for lists when we want to have "WeakCollection"
final public class ObserverList<T> {

    // MARK: - Aliases

    public typealias Observer = T

    // MARK: - Properties

    /// All currently stored observers
    private var observers = Set<ObserverBox<Observer>>()

    /// True if observers array is empty
    public var isEmpty: Bool {
        observers.isEmpty
    }

    /// Current observers count
    public var count: Int {
        observers.count
    }

    // MARK: - Initializers

    public init() {
    }

    // MARK: - Useful

    /// Add a new observer if it's not in the observers array
    /// - Parameters:
    ///   - disposable: a disposable instance
    ///   - observer: a new observer
    public func addObserverIfNotContains(disposable: AnyObject, observer: Observer) {
        let box = ObserverBox<Observer>(disposable: disposable)
        guard !observers.contains(box) else {
            return
        }
        addObserver(disposable: disposable, observer: observer)
    }

    /// Add a new observer even if the observer already in the observers array
    /// - Parameters:
    ///   - disposable: a disposable instance
    ///   - observer: a new observer
    public func addObserver(disposable: AnyObject, observer: Observer) {
        let box = ObserverBox<Observer>(disposable: disposable)
        let (_, memberAfterInsert) = observers.insert(box)
        if !memberAfterInsert.observers.contains(
            where: { ObjectIdentifier($0 as AnyObject) == ObjectIdentifier(observer as AnyObject) }
        ) {
            memberAfterInsert.observers.append(observer)
        }
    }

    /// Remove some observer
    /// - Parameter disposable: observer's disposable instance
    public func removeObserver(disposable: AnyObject) {
        observers.remove(ObserverBox<Observer>(disposable: disposable))
    }

    /// Remove certain observer
    /// - Parameter observer: some observer
    public func removeObserver(observer: Observer) {
        for obs in observers {
            if let index = obs.observers.firstIndex(
                where: { ObjectIdentifier($0 as AnyObject) == ObjectIdentifier(observer as AnyObject) }
            ) {
                obs.observers.remove(at: index)
            }
        }
    }

    /// Do something for each observer which is retained
    /// - Parameter closure: target ation block
    public func forEach(_ closure: (T) -> Void) {
        let newObservers = observers.filter { box in
            if box.disposable != nil {
                box.observers.forEach(closure)
                return true
            } else {
                return false
            }
        }
        if newObservers.count != observers.count {
            observers = Set(newObservers)
        }
    }

    /// Do something for each observer which is retained
    /// - Parameter closure: target ation block
    public func forEach(_ closure: (AnyObject, T) -> Void) {
        let newObservers = observers.filter { box in
            if let disposable = box.disposable {
                box.observers.forEach {
                    closure(disposable, $0)
                }
                return true
            } else {
                return false
            }
        }
        if newObservers.count != observers.count {
            observers = Set(newObservers)
        }
    }
}

// MARK: - ObserverBox

private class ObserverBox<T>: Hashable {

    // MARK: - Aliases

    typealias Observer = T

    // MARK: - Properties

    /// Disposable instance
    private(set) weak var disposable: AnyObject?

    /// Current object id
    private let objectIdentifier: ObjectIdentifier

    /// All currently stored observers
    var observers = [Observer]()

    // MARK: - Initializers

    /// Default initializer
    /// - Parameter disposable: disposable instance
    init(disposable: AnyObject) {
        self.disposable = disposable
        objectIdentifier = ObjectIdentifier(disposable)
    }

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(objectIdentifier.hashValue)
    }

    static func == (left: ObserverBox, right: ObserverBox) -> Bool {
        left.objectIdentifier == right.objectIdentifier
    }
}
