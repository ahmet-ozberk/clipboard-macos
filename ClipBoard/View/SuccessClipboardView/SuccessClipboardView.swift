//
//  SuccessClipboardView.swift
//  ClipBoard
//
//  Created by Ahmet OZBERK on 10.03.2025.
//

import SwiftData
import SwiftUI


struct SuccessClipboardView: View {
    let items: [ClipboardItem]

    @FocusState private var focusState: Bool
    @State private var searchText: String = ""
    @State private var filteredItems: [ClipboardItem] = []

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                TextField(
                    "Kopyalanan içerik ara...",
                    text: $searchText
                )
                .onChange(of: searchText) { oldValue, newValue in
                    performSearch(query: newValue)
                }
                .focused($focusState)
                .lineLimit(1)
                .textFieldStyle(.roundedBorder)
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.all, 8)

            if filteredItems.isEmpty && !searchText.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                    Text("Sonuç bulunamadı")
                        .font(.headline)
                    Text("\"\(searchText)\" ile eşleşen içerik bulunamadı")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(searchText.isEmpty ? items : filteredItems) { item in
                            Button(action: {
                                copyToClipboard(item.content)
                            }) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.content)
                                        .lineLimit(2)
                                    Text(item.timestamp.formatted())
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding([.top, .trailing], 8)
                                .padding(.bottom, 4)
                                .padding(.leading, 12)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .buttonStyle(.plain)
                            if item.id != (searchText.isEmpty ? items.last?.id : filteredItems.last?.id) {
                                Divider()
                                    .frame(height: 0.6)
                                    .padding(.leading, 12)
                            }
                        }
                    }
                }
            }
        }.onDisappear {
            if focusState {
                focusState = false
            }
        }
    }

    func performSearch(query: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            let results = items.filter { $0.content.localizedCaseInsensitiveContains(query) }
            DispatchQueue.main.async {
                filteredItems = results
            }
        }
    }

    private func copyToClipboard(_ content: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(content, forType: .string)
        NSApplication.shared.hide(nil)
    }
}
