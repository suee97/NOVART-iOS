//
//  CatalogView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/16.
//

import SwiftUI

struct CatalogView: View {
    
    let pageCount: Int = 5
    @State private var currentIndex = 0
    @State private var timer: Timer?
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 4) {
                
                ScrollViewReader { scrollProxy in
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 0) {
                            ForEach(0..<pageCount) { item in
                                CatalogItem()
                                    .frame(width: geometry.size.width, height: 552)
                                    .id(item)
                            }
                        }
                    }
                    .allowsHitTesting(false)
                    .onAppear {
                        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
                            currentIndex = currentIndex < pageCount-1 ? currentIndex + 1 : 0
                            withAnimation {
                                scrollProxy.scrollTo(currentIndex)
                            }
                            
                            if currentIndex == 4 {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    currentIndex = 0
                                    scrollProxy.scrollTo(currentIndex)
                                }
                            }
                        }
                    }
                    
                    .onDisappear {
                        timer?.invalidate()
                                    timer = nil
                    }
                    
                    
                }
                
                
                HStack {
                    Text("1/6")
                        .font(.system(size: 14, weight: .regular))
                }
                .frame(height: 34)
                .padding(.leading, 24)
            }
        }
    }
}

struct CatalogView_Previews: PreviewProvider {
    static var previews: some View {
        CatalogView()
    }
}
