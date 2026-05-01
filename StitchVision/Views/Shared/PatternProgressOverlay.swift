import SwiftUI

/// Overlay showing progress on pattern thumbnail
struct PatternProgressOverlay: View {
    let pattern: KnittingPattern
    let currentRowCount: Int

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                // Pattern thumbnail
                if let uiImage = UIImage(data: pattern.imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .cornerRadius(8)
                        .overlay(
                            // Dim completed rows
                            CompletedRowsOverlay(
                                pattern: pattern,
                                currentRow: currentRowCount
                            )
                        )
                }

                // Progress badge
                VStack {
                    HStack {
                        Spacer()
                        progressBadge
                    }
                    Spacer()
                }
                .padding(8)
            }
        }
    }

    private var progressBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: "chart.bar.fill")
                .font(.system(size: 10))
            Text("\(currentRowCount)/\(pattern.totalRows)")
                .font(.system(size: 11, weight: .semibold))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.black.opacity(0.7))
        .cornerRadius(12)
    }
}

/// Overlay that dims completed rows
struct CompletedRowsOverlay: View {
    let pattern: KnittingPattern
    let currentRow: Int

    var body: some View {
        GeometryReader { geometry in
            let imageHeight = geometry.size.height

            ForEach(0..<min(currentRow, pattern.detectedRows.count), id: \.self) { index in
                let row = pattern.detectedRows[index]
                let normalizedY = row.yPosition
                let normalizedHeight = row.height

                Rectangle()
                    .fill(Color.black.opacity(0.5))
                    .frame(
                        width: geometry.size.width,
                        height: imageHeight * normalizedHeight
                    )
                    .position(
                        x: geometry.size.width / 2,
                        y: imageHeight * normalizedY
                    )
            }

            // Highlight current row
            if currentRow < pattern.detectedRows.count {
                let currentRowData = pattern.detectedRows[currentRow]
                let normalizedY = currentRowData.yPosition
                let normalizedHeight = currentRowData.height

                Rectangle()
                    .fill(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.3))
                    .frame(
                        width: geometry.size.width,
                        height: imageHeight * normalizedHeight
                    )
                    .position(
                        x: geometry.size.width / 2,
                        y: imageHeight * normalizedY
                    )
                    .overlay(
                        Rectangle()
                            .stroke(Color(red: 0.561, green: 0.659, blue: 0.533), lineWidth: 2)
                            .frame(
                                width: geometry.size.width,
                                height: imageHeight * normalizedHeight
                            )
                            .position(
                                x: geometry.size.width / 2,
                                y: imageHeight * normalizedY
                            )
                    )
            }
        }
    }
}

#Preview {
    PatternProgressOverlay(
        pattern: KnittingPattern(
            name: "Test Pattern",
            imageData: Data(),
            detectedRows: [],
            totalRows: 20,
            currentRow: 10,
            completedRows: []
        ),
        currentRowCount: 10
    )
}
