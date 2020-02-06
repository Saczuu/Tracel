//
//  VisualEffectView.swift
//  Tracel
//
//  Created by Maciej Sączewski on 1/29/20.
//  Copyright © 2020 Maciej Sączewski. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}
