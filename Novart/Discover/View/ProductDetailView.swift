//
//  ProductDetailView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/05/20.
//

import SwiftUI
import Kingfisher

struct ProductDetailView: View {
    
    @Binding var isShowing: Bool
    @ObservedObject var viewModel: ProductDetailViewModel
    @State private var scrollOffset: CGFloat = 0
    @State private var previousScrollOffset: CGFloat = 0
    @State private var showBottomView: Bool = true
    
    let mock_picks = ["mock_table", "mock_chair_2"]
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)

    init(viewModel: ProductDetailViewModel, isShowing: Binding<Bool>) {
        self._isShowing = isShowing
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        ZStack(alignment: .top) {
            VStack {
                Spacer()
                    .frame(height: 63)
                mainView
            }
            
            VStack {
                productDetailNavigationBar
                Spacer()
            }
        }
    }
    
    var mainView: some View {
        GeometryReader { geometry in
            ZStack {
                ScrollView(showsIndicators: true) {
                    GeometryReader { proxy in
                                        Color.clear.preference(key: ScrollOffsetKey.self, value: proxy.frame(in: .named("scroll")).origin.y)
                                    }
                                    .frame(height: 0)
                    
                    VStack(spacing: 0) {
                        Group {
                            
                            if let imageUrl = viewModel.productDetail?.thumbnailImageUrl, let url = URL(string: imageUrl) {
                                KFImage(url)
                                    .placeholder {
                                        Image("mock_table")
                                    }
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: geometry.size.width, height: geometry.size.width)
                            } else {
                                Image("mock_table")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: geometry.size.width, height: geometry.size.width)
                            }
                            
                            Spacer()
                                .frame(height: 24)
                            
                            productInfoView
                            
                            Spacer()
                                .frame(height: 48)
                            
                            productIntroView
                            
                            Spacer()
                                .frame(height: 16)
                            
                            // 소개 사진
                            VStack(spacing: 14) {
                                ForEach(viewModel.productDetail?.detailedImageUrls ?? [], id: \.self) { image in
                                    if let url = URL(string: image) {
                                        KFImage(url)
                                            .placeholder {
                                                Image("mock_table")
                                            }
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: geometry.size.width - 48, height: geometry.size.width - 48)
                                    } else {
                                        Image("mock_table")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: geometry.size.width - 48, height: geometry.size.width - 48)
                                    }
                                }
                            }
                            
                            Spacer()
                                .frame(height: 48)
                        }
                        
                        Group {
                            // 다각도 이미지
                            HStack {
                                Text("다각도 이미지")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.Common.primaryDarkTextColor)
                                Spacer()
                            }
                            Spacer()
                                .frame(height: 16)
                            
                            LazyVGrid(columns: columns, spacing: 4) {
                                ForEach(viewModel.productDetail?.validationImageUrls ?? [], id: \.self) { image in
                                    if let url = URL(string: image) {
                                        KFImage(url)
                                            .placeholder {
                                                Image("mock_table")
                                            }
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: geometry.size.width / 2 - 26, height: geometry.size.width / 2 - 26)
                                    } else {
                                        Image("mock_table")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: geometry.size.width / 2 - 26, height: geometry.size.width / 2 - 26)
                                    }
                                }
                            }
                            Spacer()
                                .frame(height: 48)
                        }
                        .padding([.leading, .trailing], 24)
                        
                        // 상세정보
                        Group {
                            
                            HStack {
                                Text("상세정보")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.Common.primaryDarkTextColor)

                                Spacer()
                            }
                            
                            Spacer()
                                .frame(height: 16)
                            
                            VStack(spacing: 6) {
                                ZStack {
                                    HStack {
                                        Text("Material")
                                            .font(.system(size: 16, weight: .regular))
                                            .foregroundColor(.Common.subtextDarkColor)
                                        Spacer()
                                        Text((viewModel.productDetail?.materials ?? []).joined(separator: ", "))
                                            .font(.system(size: 16, weight: .regular))
                                            .foregroundColor(.Common.primaryDarkTextColor)
                                    }
                                    HStack(spacing: 0) {
                                        Spacer()
                                            .frame(width: 90)
                                        Rectangle()
                                            .foregroundColor(.Common.subtextColor)
                                            .frame(width: 1, height: 14)
                                        Spacer()
                                    }
                                }
                                
                                Rectangle()
                                    .foregroundColor(.Common.subtextColor)
                                    .frame(height: 1)
                            }
                            
                            Spacer()
                                .frame(height: 16)
                            
                            VStack(spacing: 6) {
                                ZStack {
                                    HStack {
                                        Text("Size")
                                            .font(.system(size: 16, weight: .regular))
                                            .foregroundColor(.Common.subtextDarkColor)
                                        Spacer()
                                        Text("\(viewModel.productDetail?.width ?? 0) * \(viewModel.productDetail?.height ?? 0) * \(viewModel.productDetail?.depth ?? 0)")
                                            .font(.system(size: 16, weight: .regular))
                                            .foregroundColor(.Common.primaryDarkTextColor)
                                    }
                                    HStack(spacing: 0) {
                                        Spacer()
                                            .frame(width: 90)
                                        Rectangle()
                                            .foregroundColor(.Common.subtextColor)
                                            .frame(width: 1, height: 14)
                                        Spacer()
                                    }
                                }
                                
                                Rectangle()
                                    .foregroundColor(.Common.subtextColor)
                                    .frame(height: 1)
                            }
                                                    
                            Spacer()
                                .frame(height: 16)

                            VStack(spacing: 6) {
                                ZStack {
                                    HStack {
                                        Text("Period")
                                            .font(.system(size: 16, weight: .regular))
                                            .foregroundColor(.Common.subtextDarkColor)
                                        Spacer()
                                        
                                        if let startDate = viewModel.productDetail?.productStartDate, let endDate = viewModel.productDetail?.productEndDate {
                                            Text("\(startDate) ~ \(endDate)")
                                                .font(.system(size: 16, weight: .regular))
                                                .foregroundColor(.Common.primaryDarkTextColor)
                                        }
                                    }
                                    HStack(spacing: 0) {
                                        Spacer()
                                            .frame(width: 90)
                                        Rectangle()
                                            .foregroundColor(.Common.subtextColor)
                                            .frame(width: 1, height: 14)
                                        Spacer()
                                    }
                                }
                                
                                Rectangle()
                                    .foregroundColor(.Common.subtextColor)
                                    .frame(height: 1)
                            }
                        }
                        .padding([.leading, .trailing], 24)
                        
                        Spacer()
                            .frame(height: 48)
                        
                        // 작가의 다른 작품
                        Group {
                            HStack {
                                Text("작가의 다른 작품")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.Common.primaryDarkTextColor)

                                Spacer()
                                
                                Button {
                                    print("전체보기")
                                } label: {
                                    HStack(spacing: 0) {
                                        Text("전체보기")
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundColor(.Common.subtextDarkColor)
                                        Image("icon_chevron_right")
                                    }
                                }

                            }
                            Spacer()
                                .frame(height: 16)
                        }
                        .padding([.leading, .trailing], 24)
                        
                        Spacer()
                            .frame(height: 80)
                    }
                }
                .onAppear {
                    viewModel.fetchProductDetail()
                }
                .navigationBarHidden(true)
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollOffsetKey.self) { offset in
                    scrollOffset = offset
                    if scrollOffset > previousScrollOffset && abs(scrollOffset - previousScrollOffset) > 10 {
                        // We scrolled up
                        withAnimation {
                            showBottomView = false
                        }
                    } else if scrollOffset < previousScrollOffset && abs(scrollOffset - previousScrollOffset) > 10 {
                        // We scrolled down
                        withAnimation {
                            showBottomView = true
                        }
                    }
                    
                    previousScrollOffset = scrollOffset
                }
                
                if showBottomView {
                    VStack {
                        Spacer()
                        
                        bottomDoneButtonView
                    }
                }
            }
        }
        
    }
}

extension ProductDetailView {
    
    var productDetailNavigationBar: some View {
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
                }
                .background(Color.white)
                .frame(height: 23)
                Text("제품상세")
                    .foregroundColor(Color.Common.primaryDarkTextColor)
                    .font(.system(size: 16, weight: .bold))
            }
            Spacer()
                .frame(height: 20)
        }
        .frame(height: 63) // Adjust the height of the custom navigation bar
        
    }
    
    var backButton: some View {
        Button {
            print("back")
        } label: {
            Image("icon_back")
        }
    }
    
    var productInfoView: some View {
        VStack(spacing: 0) {
            HStack {
                Text(viewModel.productDetail?.name ?? "")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.Common.primaryDarkTextColor)
                
                Spacer()
                
                if viewModel.like {
                    Button {
                        viewModel.postLike()
                    } label: {
                        Image("icon_heart_fill")
                    }

                } else {
                    Button {
                        viewModel.postLike()
                    } label: {
                        Image("icon_heart")
                    }

                }
            }
            
            Spacer()
                .frame(height: 11)
            
            HStack(spacing: 4) {
                ForEach(["힙한", "귀여운", "모던한"], id: \.self) { data in
                    Text(data)
                        .foregroundColor(Color.Common.subtextDarkColor)
                        .font(.system(size: 14, weight: .regular))
                        .padding([.leading, .trailing], 8)
                        .padding([.top, .bottom], 4)
                        .background(Color.Common.primaryTextColor)
                        .cornerRadius(4)
                }
                
                Spacer()
            }
            
            Spacer()
                .frame(height: 12)
            
            HStack {
                Spacer()
                
                Text("\(viewModel.productDetail?.price ?? 0)원")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.Common.primaryDarkTextColor)
            }
            
            Spacer()
                .frame(height: 16)
            
            Button {
                print("작가")
            } label: {
                HStack {
                    if let imageUrl = viewModel.productDetail?.seller.profileImageUrl, let url = URL(string: imageUrl) {
                        KFImage(url)
                            .placeholder {
                                Image("mock_artist_square")
                            }
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 36, height: 36)
                    } else {
                        Image("mock_artist_square")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 36, height: 36)
                    }
                    
                    Spacer()
                        .frame(width: 14)
                    
                    Text("작가ㅣ\(viewModel.productDetail?.seller.nickname ?? "")")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.Common.primaryDarkTextColor)
                    Spacer()
                    Image("icon_chevron_right")
                }
                .padding([.all], 10)
                .background(Color.Common.primaryTextColor)
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.Common.subtextColor, lineWidth: 1)
                )
                
            }

        }
        .padding([.leading, .trailing], 24)
    }
    
    var productIntroView: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 4) {
                Text("작품 소개")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.Common.primaryDarkTextColor)
                Image("tips_badge")
                Spacer()
            }
            .padding([.leading], 24)
            Spacer()
                .frame(height: 16)
            HStack {
                Rectangle()
                    .foregroundColor(.Common.primaryDarkTextColor)
                    .frame(width: 40, height: 2)
                Spacer()
            }
            .padding([.leading], 24)

            Spacer()
                .frame(height: 16)
            Text(viewModel.productDetail?.description ?? "작품 설명 미등록")
                .multilineTextAlignment(.leading)
                .padding([.leading, .trailing], 24)
        }
    }
    
    var bottomDoneButtonView: some View {
        VStack(spacing: 0) {
            
            Rectangle()
                .foregroundColor(Color.Common.gray01)
                .frame(height: 1)
            
            Spacer()
                .frame(height: 11)
            
            Button {
            } label: {
                Text("1:1 채팅")
                    .foregroundColor(Color.Common.white)
                    .font(.system(size: 16, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 46)
                    .background(Color.Common.primaryTintColor)
                    .cornerRadius(4)
                    .padding([.leading, .trailing], 24)
            }
            .buttonStyle(NoHighlightButtonStyle())
            Spacer()
                .frame(height: 12)
        }
        .background(Color.Common.primaryTextColor)
    }
}

struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}
