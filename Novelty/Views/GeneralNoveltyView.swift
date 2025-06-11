//
//  Untitled.swift
//  Novelty
//
//  Created by Fabio on 21/05/25.
//

import SwiftUI
import UIKit
import CoreMotion
import AVFoundation

struct GeneralNoveltyProposalView: View {
    @EnvironmentObject var manager: NoveltyManager
    @EnvironmentObject var noveltyTimerManager: NoveltyTimerManager
    @State private var noveltytime: Double = Double.infinity
    
    @AppStorage("onboarding") var onboarding: Bool = false
    @AppStorage("NextNoveltyId") var NextNoveltyId: String = ""
    @AppStorage("NextNoveltyTime") var NextNoveltyTime: Double = Double.infinity
    
    var body: some View {
        NavigationStack {
            ZStack{
                VStack(alignment: .leading) {
                    Text("\(manager.todayNovelty?.title ?? "No Novelty")")
                        .font(.extrabold(size: 40))
                        .frame(alignment: .leading)
                        .foregroundStyle(.white)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 15)
                    Text("\(manager.todayNovelty?.description ?? "No Novelty")")
                        .font(.italic(size: 25))
                        .frame(alignment: .leading)
                        .foregroundStyle(.white)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 30)
                .padding(.trailing, 40)
                UIKitInteractionView(
                    onAccept: {noveltyTimerManager.currentNovelty = manager.todayNovelty
                        noveltyTimerManager.startLiveActivity()
                        manager.acceptTodayNovelty()
                        noveltyTimerManager.totalDuration = manager.todayNovelty?.duration ?? 240
                        print("Novelty accepted and done", NextNoveltyTime, NextNoveltyId)
                    },
                    onRefresh: {
                        manager.refreshNovelty(duration: manager.todayNovelty?.duration ?? 240)
                        print("Notification Delayed", NextNoveltyTime, NextNoveltyId)
                    },
                    onDiscard: {
                        manager.discardTodayNovelty()
                        print("Novelty Discarded", NextNoveltyTime, NextNoveltyId)
                    }
                )
            }
        }.onAppear {
            noveltytime = NextNoveltyTime
        }
        .onChange(of: NextNoveltyTime) { newValue in
            noveltytime = newValue
        }
    }
}

struct UIKitInteractionView: UIViewControllerRepresentable {
    let onAccept: () -> Void
    let onRefresh: () -> Void
    let onDiscard: () -> Void
    
    func makeUIViewController(context: Context) -> InteractionViewController {
        let viewController = InteractionViewController()
        viewController.onAccept = onAccept
        viewController.onRefresh = onRefresh
        viewController.onDiscard = onDiscard
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: InteractionViewController, context: Context) {}
}

class InteractionViewController: UIViewController {
    var onAccept: (() -> Void)?
    var onRefresh: (() -> Void)?
    var onDiscard: (() -> Void)?
    
    private let drawingView = DrawingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        drawingView.frame = view.bounds
        drawingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        drawingView.delegate = self
        view.addSubview(drawingView)
        
        becomeFirstResponder()
        UIDevice.current.isProximityMonitoringEnabled = true
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(proximityChanged),
                                               name: UIDevice.proximityStateDidChangeNotification,
                                               object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            UIDevice.current.isProximityMonitoringEnabled = true
            becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            // When the view goes away, turn it off so it can “reset.”
            UIDevice.current.isProximityMonitoringEnabled = false
        }

    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            onRefresh?()
        }
    }
    
    @objc private func proximityChanged(notification: Notification) {
            // If the device is “near” (i.e. user covered it), call discard:
            if UIDevice.current.proximityState {
                UIDevice.current.isProximityMonitoringEnabled = false
                onDiscard?()
                
                // Immediately disable monitoring so the next time you re-enable
                // it (in viewDidAppear), you’ll get a fresh “far→near” cycle.
                UIDevice.current.isProximityMonitoringEnabled = false
            }
        }

    
    private func checkIfCanvasIsAllBlack() {
        // 1) Grab the size of the drawing area
        let rect = drawingView.bounds
        let width = Int(rect.width)
        let height = Int(rect.height)
        guard width > 0 && height > 0 else { return }
        
        // 2) Set up our own RGBA bitmap context (premultipliedLast → RGBA order).
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        
        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo
        ) else {
            return
        }
        
        context.setFillColor(UIColor.black.cgColor)
        context.fill(rect)
        
        drawingView.layer.render(in: context)
        
        // 5) Extract a CGImage from that context
        guard
            let cgImage = context.makeImage(),
            let provider = cgImage.dataProvider,
            let data = provider.data,
            let ptr = CFDataGetBytePtr(data)
        else {
            return
        }
        
        let tolerance: UInt8 = 20
        for y in 0 ..< height {
            let rowStart = y * bytesPerRow
            for x in 0 ..< width {
                let idx = rowStart + x * bytesPerPixel
                let r = ptr[idx]       // Red
                let g = ptr[idx + 1]   // Green
                let b = ptr[idx + 2]   // Blue
                let a = ptr[idx + 3]   // Alpha

                if a == 255 && (r < 255 - tolerance || g < 255 - tolerance || b < 255 - tolerance) {
                    return
                }
            }
        }
        onAccept?()
    }
    
    deinit {
            NotificationCenter.default.removeObserver(
                self,
                name: UIDevice.proximityStateDidChangeNotification,
                object: nil
            )
            UIDevice.current.isProximityMonitoringEnabled = false
        }
}

extension InteractionViewController: DrawingViewDelegate {
    func drawingViewDidFinishStroke(_ drawingView: DrawingView) {
        print("stroke finished")
        checkIfCanvasIsAllBlack()
    }
}

protocol DrawingViewDelegate: AnyObject {
    /// Chiamato quando l'utente solleva il dito (finisce uno stroke).
    func drawingViewDidFinishStroke(_ drawingView: DrawingView)
}

class DrawingView: UIView {
    
    // MARK: – Public
    
    weak var delegate: DrawingViewDelegate?
    
    /// Pulisce tutta la tinta nera (quando carico una nuova card o quando devo mostrare “ciao”).
    func clearCanvas() {
        path.removeAllPoints()
        shapeLayer.path = path.cgPath
    }
    
    // MARK: – Private
    
    private var path = UIBezierPath()
    private let shapeLayer = CAShapeLayer()
    private let lineWidth: CGFloat = 200
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        // Configuro il layer che disegnerà i tratti neri
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = nil
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
        layer.addSublayer(shapeLayer)
        
        isMultipleTouchEnabled = false
        backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.frame = bounds
    }
    
    // MARK: – Touch Handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let pt = touches.first?.location(in: self) else { return }
        path.move(to: pt)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let pt = touches.first?.location(in: self) else { return }
        path.addLine(to: pt)
        shapeLayer.path = path.cgPath
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Segnalo al delegate che uno stroke è terminato
        delegate?.drawingViewDidFinishStroke(self)
        clearCanvas()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.drawingViewDidFinishStroke(self)
        clearCanvas()
    }
}
