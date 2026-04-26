//
//  BackgroundGrass.swift
//  Lawnmower
//
//  Created by Oliver Gorst on 4/25/26.
//

import SwiftUI

struct BackgroundGrass: View {
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        Canvas { context, size in
            struct Blade {
                let x: CGFloat
                let bladeHeight: CGFloat
                let curve: CGFloat
                let bladeWidth: CGFloat
                let opacity: Double
            }

            let blades: [Blade] = [
                Blade(x: width * 0.00, bladeHeight: 140, curve: -14, bladeWidth: 10, opacity: 0.12),
                Blade(x: width * 0.04, bladeHeight: 160, curve: 12, bladeWidth: 11, opacity: 0.10),
                Blade(x: width * 0.08, bladeHeight: 130, curve: -10, bladeWidth: 9,  opacity: 0.13),
                Blade(x: width * 0.12, bladeHeight: 150, curve: 15, bladeWidth: 10, opacity: 0.11),
                Blade(x: width * 0.16, bladeHeight: 145, curve: -12, bladeWidth: 11, opacity: 0.12),
                Blade(x: width * 0.20, bladeHeight: 155, curve: 10, bladeWidth: 9,  opacity: 0.10),
                Blade(x: width * 0.24, bladeHeight: 135, curve: -15, bladeWidth: 10, opacity: 0.13),
                Blade(x: width * 0.28, bladeHeight: 160, curve: 12, bladeWidth: 11, opacity: 0.11),
                Blade(x: width * 0.32, bladeHeight: 140, curve: -10, bladeWidth: 9,  opacity: 0.12),
                Blade(x: width * 0.36, bladeHeight: 150, curve: 14, bladeWidth: 10, opacity: 0.10),
                Blade(x: width * 0.40, bladeHeight: 145, curve: -12, bladeWidth: 11, opacity: 0.13),
                Blade(x: width * 0.44, bladeHeight: 155, curve: 11, bladeWidth: 9,  opacity: 0.11),
                Blade(x: width * 0.48, bladeHeight: 135, curve: -14, bladeWidth: 10, opacity: 0.12),
                Blade(x: width * 0.52, bladeHeight: 160, curve: 12, bladeWidth: 11, opacity: 0.10),
                Blade(x: width * 0.56, bladeHeight: 140, curve: -10, bladeWidth: 9,  opacity: 0.13),
                Blade(x: width * 0.60, bladeHeight: 150, curve: 15, bladeWidth: 10, opacity: 0.11),
                Blade(x: width * 0.64, bladeHeight: 145, curve: -12, bladeWidth: 11, opacity: 0.12),
                Blade(x: width * 0.68, bladeHeight: 155, curve: 10, bladeWidth: 9,  opacity: 0.10),
                Blade(x: width * 0.72, bladeHeight: 135, curve: -15, bladeWidth: 10, opacity: 0.13),
                Blade(x: width * 0.76, bladeHeight: 160, curve: 12, bladeWidth: 11, opacity: 0.11),
                Blade(x: width * 0.80, bladeHeight: 140, curve: -10, bladeWidth: 9,  opacity: 0.12),
                Blade(x: width * 0.84, bladeHeight: 150, curve: 14, bladeWidth: 10, opacity: 0.10),
                Blade(x: width * 0.88, bladeHeight: 145, curve: -12, bladeWidth: 11, opacity: 0.13),
                Blade(x: width * 0.92, bladeHeight: 155, curve: 11, bladeWidth: 9,  opacity: 0.11),
                Blade(x: width * 0.96, bladeHeight: 135, curve: -14, bladeWidth: 10, opacity: 0.12),
                Blade(x: width * 0.02, bladeHeight: 100, curve: 10, bladeWidth: 12, opacity: 0.18),
                Blade(x: width * 0.07, bladeHeight: 115, curve: -13, bladeWidth: 13, opacity: 0.20),
                Blade(x: width * 0.13, bladeHeight: 105, curve: 11, bladeWidth: 12, opacity: 0.18),
                Blade(x: width * 0.19, bladeHeight: 120, curve: -10, bladeWidth: 13, opacity: 0.20),
                Blade(x: width * 0.25, bladeHeight: 100, curve: 14, bladeWidth: 12, opacity: 0.18),
                Blade(x: width * 0.31, bladeHeight: 110, curve: -12, bladeWidth: 13, opacity: 0.20),
                Blade(x: width * 0.37, bladeHeight: 105, curve: 10, bladeWidth: 12, opacity: 0.18),
                Blade(x: width * 0.43, bladeHeight: 120, curve: -13, bladeWidth: 13, opacity: 0.20),
                Blade(x: width * 0.49, bladeHeight: 100, curve: 11, bladeWidth: 12, opacity: 0.18),
                Blade(x: width * 0.55, bladeHeight: 115, curve: -10, bladeWidth: 13, opacity: 0.20),
                Blade(x: width * 0.61, bladeHeight: 105, curve: 14, bladeWidth: 12, opacity: 0.18),
                Blade(x: width * 0.67, bladeHeight: 120, curve: -12, bladeWidth: 13, opacity: 0.20),
                Blade(x: width * 0.73, bladeHeight: 100, curve: 10, bladeWidth: 12, opacity: 0.18),
                Blade(x: width * 0.79, bladeHeight: 110, curve: -13, bladeWidth: 13, opacity: 0.20),
                Blade(x: width * 0.85, bladeHeight: 105, curve: 11, bladeWidth: 12, opacity: 0.18),
                Blade(x: width * 0.91, bladeHeight: 120, curve: -10, bladeWidth: 13, opacity: 0.20),
                Blade(x: width * 0.97, bladeHeight: 100, curve: 14, bladeWidth: 12, opacity: 0.18),
                Blade(x: width * 0.01, bladeHeight: 70, curve: -8,  bladeWidth: 14, opacity: 0.28),
                Blade(x: width * 0.06, bladeHeight: 80, curve: 11,  bladeWidth: 15, opacity: 0.30),
                Blade(x: width * 0.12, bladeHeight: 72, curve: -10, bladeWidth: 14, opacity: 0.28),
                Blade(x: width * 0.18, bladeHeight: 85, curve: 8,   bladeWidth: 15, opacity: 0.30),
                Blade(x: width * 0.24, bladeHeight: 70, curve: -12, bladeWidth: 14, opacity: 0.28),
                Blade(x: width * 0.30, bladeHeight: 78, curve: 10,  bladeWidth: 15, opacity: 0.30),
                Blade(x: width * 0.36, bladeHeight: 72, curve: -8,  bladeWidth: 14, opacity: 0.28),
                Blade(x: width * 0.42, bladeHeight: 85, curve: 11,  bladeWidth: 15, opacity: 0.30),
                Blade(x: width * 0.48, bladeHeight: 70, curve: -10, bladeWidth: 14, opacity: 0.28),
                Blade(x: width * 0.54, bladeHeight: 80, curve: 8,   bladeWidth: 15, opacity: 0.30),
                Blade(x: width * 0.60, bladeHeight: 72, curve: -12, bladeWidth: 14, opacity: 0.28),
                Blade(x: width * 0.66, bladeHeight: 85, curve: 10,  bladeWidth: 15, opacity: 0.30),
                Blade(x: width * 0.72, bladeHeight: 70, curve: -8,  bladeWidth: 14, opacity: 0.28),
                Blade(x: width * 0.78, bladeHeight: 78, curve: 11,  bladeWidth: 15, opacity: 0.30),
                Blade(x: width * 0.84, bladeHeight: 72, curve: -10, bladeWidth: 14, opacity: 0.28),
                Blade(x: width * 0.90, bladeHeight: 85, curve: 8,   bladeWidth: 15, opacity: 0.30),
                Blade(x: width * 0.96, bladeHeight: 70, curve: -12, bladeWidth: 14, opacity: 0.28),
            ]

            for blade in blades {
                var path = Path()
                let baseY = size.height
                let tipX = blade.x + blade.curve
                let tipY = size.height - blade.bladeHeight
                let ctrlX = blade.x + blade.curve * 0.7
                let ctrlY = size.height - blade.bladeHeight * 0.5
                let rightBaseX = blade.x + blade.bladeWidth
                let rightTipX = tipX + blade.bladeWidth * 0.4
                let rightCtrlX = ctrlX + blade.bladeWidth * 0.4

                path.move(to: CGPoint(x: blade.x, y: baseY))
                path.addQuadCurve(
                    to: CGPoint(x: tipX, y: tipY),
                    control: CGPoint(x: ctrlX, y: ctrlY)
                )
                path.addLine(to: CGPoint(x: rightTipX, y: tipY))
                path.addQuadCurve(
                    to: CGPoint(x: rightBaseX, y: baseY),
                    control: CGPoint(x: rightCtrlX, y: ctrlY)
                )
                path.closeSubpath()

                context.fill(path, with: .color(.white.opacity(blade.opacity)))
            }
        }
    }
}
