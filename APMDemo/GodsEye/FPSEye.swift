import UIKit

public class FPSEye: NSObject {

    private var link: CADisplayLink!
    private var lastTimestamp: TimeInterval?

    public override init() {
        super.init()
        link = CADisplayLink(target: EyeWeakTarget<FPSEye>(target: self), selector: #selector(tick))
        link.add(to: RunLoop.main, forMode: .common)
    }

    deinit {
        link.invalidate()
        link = nil
    }

    func getFPS() {

    }

    @objc private func tick() {
        guard let lastTimestamp = lastTimestamp else {
            self.lastTimestamp = link.timestamp
            return
        }
        let dif = link.timestamp - lastTimestamp
        self.lastTimestamp = link.timestamp
        let fps = 1 / dif

    }
}
