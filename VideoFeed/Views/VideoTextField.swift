//
//  VideoTextField.swift
//  VideoFeed
//
//  Created by Rola Kitaphanich on 2025-10-06.
//

import SwiftUI
import AVFoundation

struct VideoTextField: View {
    
    @State private var text: String = ""
    @FocusState private var isTextFieldFocused: Bool
    @State private var textHeight: CGFloat = 40
    @State private var isHeartFilledImage = false
    @State private var isPaperPlaneFilledImage = false
    @StateObject private var keyboard = KeyboardObserver()
    @State var player: AVPlayer
    
    let lineHeight: CGFloat = 24
    let font: UIFont = .systemFont(ofSize: 17)
    let minHeight: CGFloat = 40
    
    var body: some View {
        HStack {
            ZStack(alignment: .bottomTrailing) {
                if text.isEmpty {
                    Text("Send Message")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                TextEditor(text: $text)
                    .frame(height: textHeight)
                    .padding(12)
                    .scrollContentBackground(.hidden)
                    .background(Color(.black))
                    .background(GeometryReader { geometry in
                        Color.clear
                        .onChange(of: text) {
                            // when the user types something in the text editor pause the player and adjust the text editor height based on the text
                            player.pause()
                            calculateHeight(in: geometry.size.width)
                        }
                    })
                    .foregroundStyle(.white)
                    .padding(.trailing, 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray, lineWidth: 2))
                    .focused($isTextFieldFocused)
                // show paperplane image in the text editor at the bottom right if there is text
                if !text.isEmpty {
                    Button(action: {
                        text = ""
                    }) {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 15))
                            .foregroundColor(.black)
                            .padding(10)
                            .background(Color.white)
                            .clipShape(Circle())
                            .padding(10)
                            .transition(.opacity)
                            .animation(.easeIn(duration: 0.5), value: true)
                    }
                }
            }
            // add emotes next to the text field if it isnt in focus and change between filled emotes and non filled emotes
            if !isTextFieldFocused {
                HStack {
                    Button(action: {
                       isHeartFilledImage = !isHeartFilledImage
                    }) {
                        Image(systemName: isHeartFilledImage ? "heart.fill" : "heart")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    }
                    Button(action: {
                        isPaperPlaneFilledImage = !isPaperPlaneFilledImage
                    }) {
                        Image(systemName: isPaperPlaneFilledImage ? "paperplane.fill" : "paperplane")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    }
                }
            }
        }.padding(.bottom, keyboard.keyboardHeight)
        .animation(.easeOut(duration: 0.25), value: keyboard.keyboardHeight)
    }
        
    func calculateHeight(in width: CGFloat) {
        let lineHeight = font.lineHeight
        let maxHeight = lineHeight * 5  // limit to 5 lines
        let size = CGSize(width: UIScreen.main.bounds.width - 32, height: .infinity)
        let boundingBox = text.boundingRect(
            with: size,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )
        
        let newHeight = max(minHeight, min(boundingBox.height + 24, maxHeight))
        textHeight = newHeight
    }
}
