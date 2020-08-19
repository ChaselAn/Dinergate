import Foundation

public class RunLoopBlockEye: NSObject, CenterControl {

    public enum BlockType {
        case single // once, blocked for 250ms
        case continuous // five consecutive times, blocked for 50ms * 5
    }

    public static let shared = RunLoopBlockEye()
    public var blocked: ((BlockType) -> Void)?
    public var observable = EyeObservable<BlockType?>(value: nil)

    public func start() {
        handleCallStack()
        CFRunLoopAddObserver(CFRunLoopGetMain(), observer, CFRunLoopMode.commonModes)
        isStarted = true

        self.timeOutQueue.async { [weak self] in
            guard let self = self else { return }
            while self.isStarted {
                // 单次超过250ms的卡顿，算一次卡顿
                let res = self.singleSemaphore.wait(timeout: DispatchTime.now() + 0.25)
                switch res {
                case .success:
                    break
                case .timedOut:
                    self.observable.update(with: .single)
                    self.handleCallStack()
                    break
                }
            }
        }

        self.timeOutQueue.async { [weak self] in
            guard let self = self else { return }
            while self.isStarted {
                // 单5次超过50ms的卡顿，也算一次卡顿
                let res = self.fiveSemaphore.wait(timeout: DispatchTime.now() + 0.05)
                switch res {
                case .success:
                    break
                case .timedOut:
                    self.timeOutCount += 1
                    guard self.timeOutCount >= 5 else {
                        continue
                    }
                    self.observable.update(with: .continuous)
                    self.handleCallStack()
                }
                self.timeOutCount = 0
            }
        }
    }

    public func stop() {
        isStarted = false
        CFRunLoopRemoveObserver(CFRunLoopGetMain(), observer, CFRunLoopMode.commonModes)
    }

    private var observer: CFRunLoopObserver!

    private var timeOutCount = 0
    private let singleSemaphore = DispatchSemaphore(value: 0)
    private let fiveSemaphore = DispatchSemaphore(value: 0)
    private let timeOutQueue = DispatchQueue(label: "GodsEye_timeOutQueue", qos: .background, attributes: .concurrent)
    private var isStarted = false

    private override init() {
        super.init()

        observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, CFRunLoopActivity.beforeSources.rawValue | CFRunLoopActivity.afterWaiting.rawValue, true, 0) { [weak self] (observer, activity) in
            guard let self = self else { return }
            self.fiveSemaphore.signal()
            self.singleSemaphore.signal()
        }
    }

    private func handleCallStack() {
//        print(Thread.callStackSymbols)
        // TODO: handleCallStack
    }
}
