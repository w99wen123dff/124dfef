//
//  OLEventDispatcher.swift
//  outlookTest
//
//  Created by 刘凡 on 2019/12/19.
//  Copyright © 2019 w99wen. All rights reserved.
//

import UIKit

class OLBaseEvent: NSObject {
    var name = ""
    var source = "";
    var data:[String: AnyObject];
    
    init(name:String, source:String, data:[String: AnyObject]) {
        self.name = name;
        self.source = source;
        self.data = data;
    }
}

protocol OLEventDispatcherProtocol {
    func eventFired(event: OLBaseEvent);
}

class OLEventDispatcher: NSObject {
    
    private var eventMap: [String: [OLEventDispatcherProtocol]] = [:]
    
    static let sharedInstance: OLEventDispatcher = {
        OLEventDispatcher();
    }()
    
    func dispatchEvent(_ event: OLBaseEvent) {
        if let listeners = eventMap[event.name] {
            listeners.forEach { (listener) in
                listener.eventFired(event: event);
            }
        }
    }
    
    func addEventListener(eventName forEvent:String, listener: OLEventDispatcherProtocol ) {
        if eventMap[forEvent] == nil {
            eventMap[forEvent] = [OLEventDispatcherProtocol]();
        }
        eventMap[forEvent]?.append(listener);
    }
}
