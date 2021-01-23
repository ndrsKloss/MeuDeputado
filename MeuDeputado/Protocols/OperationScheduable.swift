import RxSwift

protocol OperationScheduable {
  var scheduler: OperationQueueScheduler { get }
}
