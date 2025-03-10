import SwiftData
import SwiftUI

struct ClipboardListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var isDarkMode = false
    @Query(sort: \ClipboardItem.timestamp, order: .reverse) private var items:
        [ClipboardItem]
    @State private var showAlert = false
    @State private var itemsToShow: [ClipboardItem] = []

    var body: some View {
        VStack(spacing: 0) {
            if items.isEmpty {
                EmptyClipboardView()
            } else {
                SuccessClipboardView(items: items)
            }

            Divider()
            if showAlert {
                HStack(alignment: .center) {
                    Text(
                        "Tüm öğeleri silmek istediğinizden emin misiniz?"
                    ).font(.caption)
                    Spacer()
                    HStack {
                        Button(action: {
                            showAlert = false
                        }) {
                            Image(systemName: "xmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 14, height: 14)
                                .foregroundColor(.secondary)
                            
                        }.buttonStyle(.plain).foregroundColor(.secondary)
                        Button(action: {
                            deleteAllItems()
                            showAlert = false
                        }) {
                            Image(systemName: "checkmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 14, height: 14)
                                .foregroundColor(.red)
                        }.buttonStyle(.plain)
                            .foregroundColor(.red)
                    }
                }.padding(.all, 8)
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                HStack(alignment: .center) {
                    Image(.clipboardIcon)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(
                            isDarkMode
                                ? AppColors.backgroundLight
                                : AppColors.backgroundDark
                        )
                        .frame(width: 12, height: 12)
                    Text("by Ahmet OZBERK")
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button(action: {
                        NSApplication.shared.terminate(nil)
                    }) {
                        Image(systemName: "power")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 14, height: 14)
                            .foregroundColor(.red)
                    }
                    .buttonStyle(.plain)
                    if !items.isEmpty {
                        Button(action: {
                            showAlert = true
                        }) {
                            Image(systemName: "trash")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 14, height: 14)
                                .foregroundColor(.red)
                        }
                        .buttonStyle(.plain)
                    }
                }.padding(.all, 8)
            }
        }
        .frame(width: 300, height: 400)
        .dynamicBackground()
        .bindThemeState(to: $isDarkMode)
    }

    private func deleteAllItems() {
        withAnimation(.linear) {
            items.forEach { item in
                modelContext.delete(item)
            }
            try? modelContext.save()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation(.linear) {
            for index in offsets {
                modelContext.delete(items[index])
            }
            try? modelContext.save()
        }
    }
}
