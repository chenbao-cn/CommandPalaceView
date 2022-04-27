//
//  ContentView.swift
//  Shared
//
//  Created by 陈宝 on 2022/4/27.
//

import SwiftUI

struct ContentView: View {
    @State private
    var text = ""

    @State
    var items: [hehe] = (0 ... 10000).map {
        hehe(id: $0, str: "Command \($0)")
    }

    @State
    var isPresent: Bool = true

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

            if isPresent {
                CommandPalace(text: $text,
                              items: $items,
                              isPresent: $isPresent,
                              onEnter: { (h: hehe?) in
                                  debugPrint("onEnter, hehe.str is \(h?.str)")
                              }
                )
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct CommandPalace: View {
    @Binding
    var text: String

    @Binding
    var items: [hehe]

    @Binding
    var isPresent: Bool

    let onEnter: (hehe?) -> Void

    @FocusState private
    var searchBarFocus: Bool

    @State private
    var selecting: hehe? = nil

    @State private
    var proxy: ScrollViewProxy? = nil

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
                    ScrollViewReader.init { (p: ScrollViewProxy) in

                        ScrollView(.vertical, showsIndicators: false) {
                            ItemsView

                        }.onAppear {
                            self.proxy = p
                        }
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

                if self.searchBarFocus == true {
                    self.searchBarFocus = false
                }

                let sear = self.searching

                let i: Int = { () -> Int in
                    if self.selecting == nil {
                        return 0
                    } else if let index = sear.firstIndex(of: self.selecting!) {
                        return index - 1
                    }
                    return 0
                }()

                if i < self.items.count && i >= 0 {
                    self.selecting = sear[i]
                    proxy?.scrollTo(self.selecting?.str)
                }
            }
            .keyboardShortcut(.upArrow, modifiers: [])

            Button("↓ 下一个") {
                debugPrint("↓ 下一个")

                if self.searchBarFocus == true {
                    self.searchBarFocus = false
                }
                let sear = self.searching

                let i: Int = { () -> Int in
                    if self.selecting == nil {
                        return 0
                    } else if let index = sear.firstIndex(of: self.selecting!) {
                        return index + 1
                    }
                    return 0
                }()

                if i < sear.count {
                    self.selecting = sear[i]
                    proxy?.scrollTo(self.selecting?.str)
                }
            }
            .keyboardShortcut(.downArrow, modifiers: [])

            Button("⏎ 使用") { debugPrint("⏎ 使用")

                self.onEnter(self.selecting)
            }
            .keyboardShortcut(.return, modifiers: [])

            Button("⎋ 退出") {
                debugPrint("⎋ 退出")
                isPresent.toggle()
            }
            .keyboardShortcut(.escape, modifiers: [])
            Spacer()
        }
        .font(.footnote)
        .lineLimit(1)
        .buttonStyle(LinkButtonStyle()) // 使用 LinkButtonStyle 就会非常快。
//        .buttonStyle(DefaultButtonStyle()) // 在这里使用 DefaultButtonStyle 会有严重的性能问题。。。
//        .buttonStyle(PlainButtonStyle()) // 使用 PlainButtonStyle 则不会触发 快捷键。。。。
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

    var searching: [hehe] {
        if text == "" {
            return items
        }

        return items.filter({ (e: hehe) in

            let arr = self.text.split(separator: " ")

            for a in arr {
                if e.str.contains(a) {
                    return true
                }
            }

            return false
        }
        )
    }

    var ItemsView: some View {
        LazyVGrid(columns: [GridItem()]) {
            ForEach(searching) { s in
                HStack {
                    Text(s.str)
                    Spacer()
                }
                .lineLimit(1)
                .truncationMode(Text.TruncationMode.tail)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background {
                    self.selecting?.str == s.str ? Color.blue : Color.white.opacity(0.01)
                }
                .onTapGesture { self.selecting = s }
                .id(s.str)
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
