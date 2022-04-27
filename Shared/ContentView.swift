//
//  ContentView.swift
//  Shared
//
//  Created by 陈宝 on 2022/4/27.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            VStack {
                Text("Command 1")
                Text("Command 1")
                Text("Command 1")
                Text("Command 1")
                    .foregroundColor(.green)
            }
            .background(Color.red)

            CommandPalace()
        }
    }
}

struct CommandPalace: View {
    @State private
    var text = ""

    @FocusState
    var searchBarFocus: Bool

    @State private
    var items: [hehe] = (0 ... 1000).map {
        hehe(id: $0, str: "Command \($0)")
    }

    @State private
    var selecting: hehe? = nil

    var body: some View {
        HStack {
            VStack(spacing: 0) { // CommandPalace background
                VStack(alignment: .leading) { // CommandPalace
                    TextField("title", text: $text) // SearchBar
//                        .textFieldStyle(RoundedBorderTextFieldStyle()) // 设置了 textFieldStyle 后，TextField 的字体就没法调整大小了。。。
                        .font(.largeTitle)
                        .focused($searchBarFocus)

                        .task {
                            searchBarFocus = true
                        }

                    // Items
                    ScrollView(.vertical, showsIndicators: false) {
                        ItemsView
                            .lineLimit(1)
                            .truncationMode(Text.TruncationMode.tail)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    底部说明栏
                }
                .font(CommandPalaceFont)
                .padding()
            }
            .background(圆角毛玻璃)
            .frame(minWidth: 100, idealWidth: 400, maxWidth: 600, minHeight: 100, idealHeight: 200, maxHeight: 400)
            .padding(.top)
            .padding()
        }
        // 充满整个 View 并确保  .frame(alignment: .top)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(
            Color.black.opacity(0.1)
                .onTapGesture { }
        )
    }

    var CommandPalaceFont: Font? {
        #if os(macOS)
            return Font.title
        #else
            return nil
        #endif
    }

    var 底部说明栏: some View {
        // 在 TextFiel Focused 的时候，也能触发这些 Button 的快捷键。
        HStack {
            Spacer()
            Button("↑ 上一个") { debugPrint("↑ 上一个")
                self.searchBarFocus = false

                let i: Int = self.selecting == nil ? 0 : self.selecting!.id - 1

                if i < self.items.count && i >= 0 {
                    let sdfasf = self.items[i]

                    self.selecting = sdfasf
                }
            }
            .keyboardShortcut(.upArrow, modifiers: [])

            Button("↓ 下一个") { debugPrint("↓ 下一个")
                self.searchBarFocus = false

                let i: Int = self.selecting == nil ? 0 : self.selecting!.id + 1

                if i < self.items.count {
                    let sdfasf = self.items[i]

                    self.selecting = sdfasf
                }
            }
            .keyboardShortcut(.downArrow, modifiers: [])

            Button("⏎ 使用") { debugPrint("⏎ 使用") }
                .keyboardShortcut(.return, modifiers: [])

            Button("⎋ 退出") { debugPrint("⎋ 退出") }
                .keyboardShortcut(.escape, modifiers: [])
            Spacer()
        }
        .font(.footnote)
        .lineLimit(1)
    }

    var 圆角毛玻璃: some View {
        RoundedRectangle(cornerRadius: 10,
                         style: SwiftUI.RoundedCornerStyle.circular)
            .foregroundColor(
                Color.gray.opacity(0.2)
            )
            .background(
                Material.ultraThinMaterial
            )
            .shadow(radius: 10)
    }

    var ItemsView: some View {
        // 使用 LazyVGrid 能优化内存。
        LazyVGrid(columns: [GridItem()]) {
            ForEach(self.items, id: \.self) { s in
                HStack {
                    Text(s.str)
                    Spacer()
                }
                .background {
                    self.selecting?.id == s.id ? Color.blue : Color.white.opacity(0.01)
                }
                .onTapGesture {
                    self.selecting = s
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct hehe: Identifiable, Hashable {
    let id: Int
    let str: String
}
