//
//  CatalogDetailView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/06/11.
//

import SwiftUI
import Kingfisher

struct CatalogDetailView: View {
    
    @Binding var isShowing: Bool
    
    init(isShowing: Binding<Bool>) {
        self._isShowing = isShowing
    }
    
    var body: some View {
        
        ZStack(alignment: .top) {
            VStack {
                Spacer()
                    .frame(height: 63)
                mainView
            }
            
            VStack {
                catalogDetailNavigationBar
                Spacer()
            }
        }
    }
}

extension CatalogDetailView {
    var mainView: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: true) {
                VStack( alignment: .leading, spacing: 0) {
                    
                Image("mock_home_poster")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: 552)
                
                // info view
                Image("mock_info_image")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.width)
                }
                
                // about
                
                VStack(alignment: .leading, spacing: 0) {
                    Spacer()
                        .frame(height: 32)
                    Text("ABOUT.")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color.Common.primaryDarkTextColor)
                    Spacer()
                        .frame(height: 15)
                    
                    Rectangle()
                        .foregroundColor(Color.Common.yellow)
                        .frame(width: 32, height: 2)
                    
                    Spacer()
                        .frame(height: 15)
                    
                    Text("해당 전시는 스페인의 초현실주의 거장 '살바도르 달리(Salvador Dali)'의 국내 최초 대규모 회고전이다. 스페인 피게레스에 위치한 달리 극장 미술관을 중심으로 레이나 소피아 국립미술관, 미국 플로리다의 살바도르 달리 미술관의 소장품으로 구성된다.")
                        .font(.system(size: 14, weight: .regular))
                        .lineSpacing(10)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                        .frame(height: 58)
                    
                    Button {
                        print("더 알아보기")
                    } label: {
                        Text("더 알아보기")
                            .foregroundColor(Color.Common.white)
                            .font(.system(size: 16, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 46)
                            .background(Color.Common.primaryDarkTextColor)
                            .cornerRadius(4)
                    }
                    .buttonStyle(NoHighlightButtonStyle())

                }
                .padding([.leading, .trailing], 24)
            }
        }
        .navigationBarHidden(true)
    }
    
    var catalogDetailNavigationBar: some View {
        VStack(spacing: 0) {
            Spacer()
            ZStack {
                HStack(spacing: 0) {
                    Spacer()
                        .frame(width: 24)
                    Button {
                        isShowing = false
                    } label: {
                        Image("icon_back")
                    }
                    .buttonStyle(NoHighlightButtonStyle())

                    Spacer()
                    
                    Button {
                    } label: {
                        Image("icon_search")
                    }
                    .buttonStyle(NoHighlightButtonStyle())
                    Spacer()
                        .frame(width: 24)
                }
                .background(Color.white)
                .frame(height: 23)
                Text("예술전시")
                    .foregroundColor(Color.Common.primaryDarkTextColor)
                    .font(.system(size: 16, weight: .bold))
            }
            Spacer()
                .frame(height: 20)
        }
        .frame(height: 63)
    }
}
