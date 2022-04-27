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

    var body: some View {
        HStack {
            VStack(spacing: 0) { // CommandPalace background
                VStack(alignment: .leading) { // CommandPalace
                    TextField("title", text: $text) // SearchBar
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    // Items
                    ScrollView(.vertical, showsIndicators: false) {
                        Items
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
    }

    var CommandPalaceFont: Font? {
        #if os(macOS)
            return Font.title
        #else
            return nil
        #endif
    }

    var 底部说明栏: some View {
        HStack {
            Spacer()
            Text("↑ ↓ 导航") +
                Text("⏎ 使用") +
                Text("⎋ 退出")
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

    var Items: some View {
        Group {
            Group {
                Text("Command 1")

                Text("Command 1")
                Text("Command 1")
                Text("Command 1")
            }

            Group {
                Text("Command 1")
                Text("Command 1")
                Text("Command 1")
                Text("Command 1")
            }
            Group {
                Text("Command 1")
                Text("Command 1")
                Text("Command 1")
                Text("Command 1")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
