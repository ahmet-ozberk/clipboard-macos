//
//  EmptyClipboardView.swift
//  ClipBoard
//
//  Created by Ahmet OZBERK on 10.03.2025.
//

import SwiftUI

struct EmptyClipboardView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Text("Henüz hiçbir öğe kopyalanmadı.")
                .font(.headline)
            Text("Kopyalanan öğeler burada görünecek")
                .font(.subheadline)
        }.padding()
            .frame(
                maxWidth: .infinity, maxHeight: .infinity,
                alignment: .center)
    }
}

#Preview {
    EmptyClipboardView()
}
