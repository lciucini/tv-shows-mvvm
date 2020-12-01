//
//  SchedulerProvider.swift
//  tv-shows-app
//
//  Created by Lucas Ciucini on 23/11/2020.
//

import RxSwift

class SchedulerProvider {
    func io() -> SchedulerType {
        return SerialDispatchQueueScheduler(qos: .default)
    }
    
    func ui() -> SchedulerType {
        return MainScheduler.instance
    }
}
