//
//  CatalogView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/16.
//

import SwiftUI

struct CatalogView: View {
    
    var items: [CatalogItemModel]
    @State private var currentIndex = 0
    @State private var timer: Timer?
    
    init(items: [CatalogItemModel]) {
        self.items = items
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 4) {
                
                ScrollViewReader { scrollProxy in
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 0) {
                            
                            ForEach(items, id: \.id) { item in
                                CatalogItem(item: item)
                                    .frame(width: geometry.size.width, height: 552)
                                    .id(item.id)
                            }
                        }
                        .onChange(of: items, perform: { newValue in
                            let pageCount = newValue.count
                            if timer != nil {
                                timer?.invalidate()
                                timer = nil
                            }
                            timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
                                currentIndex = currentIndex < pageCount-1 ? currentIndex + 1 : 0
                                
                                withAnimation {

                                    scrollProxy.scrollTo(newValue[currentIndex].id)
                                }
                                if currentIndex == pageCount - 1 {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        currentIndex = 0
                                        scrollProxy.scrollTo(currentIndex)
                                    }
                                }
                            }
  
                        })

                    }
                    .allowsHitTesting(false)
                    
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

