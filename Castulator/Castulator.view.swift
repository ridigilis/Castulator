//
//  CastulatorView.swift
//  Castulator
//
//  Created by Ricky David Groner II on 12/8/23.
//

import SwiftUI

struct CastulatorView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var vm = ViewModel()

    var body: some View {
        NavigationStack {
                ZStack {
                    VStack {
                        if vm.running.lhs.result != nil && vm.running.value.count > 2 {
                            HStack{
                                Spacer()
                                if vm.running.total == Double.infinity || vm.running.total > Double(Int.max) || vm.running.total < Double(Int.min) {
                                    Text("\(vm.running.total < Double(Int.min) ? "-" : "")Infinity")
                                        .font(Font.custom("MedievalSharp", size: 36)).frame(minHeight:24, maxHeight: 64).padding(.vertical, -12)
                                } else {
                                    Text(String(Int(vm.running.total)))
                                        .font(Font.custom("MedievalSharp", size: 36)).frame(minHeight:24, maxHeight: 64).padding(.vertical, -12)
                                }
                            }
                            .padding(.bottom, 12)
                        } else {
                            if vm.running.value.count == 1 {
                                HStack {
                                    if vm.running.rhs.result != nil {
                                        Image(systemName: Operation.add.toString)
                                    }
                                    Spacer()
                                    ForEach(vm.running.rhs.terms) { term in
                                        Button {
                                            vm.handleRerollSingleButtonPress(term: term, side: vm.running.rhs)
                                        }
                                    label: {
                                        ZStack{
                                            DynamicImage(term.die.rawValue)
                                                .frame(minHeight: 24, maxHeight: 64)
                                                .padding(term.die.rawValue == "d12" ? -6 : -12)
                                                .opacity(term.roll != nil ? 0.3 : 1)
                                            if term.roll != nil {
                                                Text(String(Int(term.roll!)))
                                                    .font(Font.custom("MedievalSharp", size: 24))
                                            }
                                        }
                                    }
                                        if term != vm.running.rhs.terms.last {
                                            Image(systemName: Operation.add.toString).resizable().frame(width: 6, height: 6)
                                        }
                                    }
                                }
                                .padding(.bottom, 12)
                            } else {
                                HStack {
                                    Spacer()
                                    ForEach(vm.running.lhs.terms) { term in
                                        Button {
                                            vm.handleRerollSingleButtonPress(term: term, side: vm.running.lhs)
                                        }
                                    label: {
                                        ZStack{
                                            DynamicImage(term.die.rawValue)
                                                .frame(minHeight: 24, maxHeight: 64)
                                                .padding(term.die.rawValue == "d12" ? -6 : -12)
                                                .opacity(term.roll != nil ? 0.3 : 1)
                                            if term.roll != nil {
                                                Text(String(Int(term.roll!)))
                                                    .font(Font.custom("MedievalSharp", size: 24))
                                            }
                                        }
                                    }
                                        if term != vm.running.lhs.terms.last {
                                            Image(systemName: Operation.add.toString).resizable().frame(width: 6, height: 6)
                                        }
                                    }
                                }
                                .padding(.bottom, 12)
                            }
                        }


                        VStack {
                            if vm.running.value.count > 1 {
                                HStack {
                                    Image(systemName: vm.running.rhs.operation.toString)
                                    Spacer()
                                    ForEach(vm.running.rhs.terms) { term in
                                        Button {
                                            vm.handleRerollSingleButtonPress(term: term, side: vm.running.rhs)
                                        }
                                        label: {
                                            ZStack{
                                                DynamicImage(term.die.rawValue)
                                                    .frame(minHeight: 24, maxHeight: 64)
                                                    .padding(term.die.rawValue == "d12" ? -6 : -12)
                                                    .opacity(term.roll != nil ? 0.3 : 1)
                                                if term.roll != nil {
                                                    Text(String(Int(term.roll!)))
                                                        .font(Font.custom("MedievalSharp", size: 24))
                                                }
                                            }
                                        }
                                        if term != vm.running.rhs.terms.last {
                                            Image(systemName: Operation.add.toString).resizable().frame(width: 6, height: 6)
                                        }
                                    }

                                }.frame(minHeight: 24, maxHeight: 64).padding(.top, -6)
                            }
                        }

                        if vm.running.rhs.result != nil {
                            let runningTotal = Castulation.castulate(lhsTerm: vm.running.total, op: vm.running.rhs.operation, rhsTerm: Double(vm.running.rhs.result!))
                            Divider()
                            HStack {
                                Spacer()
                                if runningTotal == Double.infinity || runningTotal > Double(Int.max) || runningTotal < Double(Int.min) {
                                    Text("\(vm.running.total < Double(Int.min) ? "-" : "")Infinity").font(Font.custom("MedievalSharp", size: 42))
                                } else {
                                    Text(String(Int(runningTotal)))
                                        .font(Font.custom("MedievalSharp", size: 42))
                                }
                            }
                        }

                        Spacer()
                    }

                    VStack {
                        Spacer()

                        DicePadView(
                            onDiceButtonPress: vm.handleDiceButtonPress,
                            onOpButtonPress: vm.handleOpButtonPress,
                            onEqualsButtonPress: vm.handleEqualsButtonPress,
                            onClearButtonPress: vm.handleClearButtonPress,
                            onRerollLastButtonPress: vm.handleRerollLastButtonPress,
                            onRerollAllButtonPress: vm.handleRerollAllButtonPress
                        )
                    }
                }
                .padding()
                .background(Image(colorScheme == .dark ? "parchment-dark" : "parchment-light").resizable().scaledToFill().ignoresSafeArea(.all).opacity(0.6))
                .gesture(
                    DragGesture(minimumDistance: 20, coordinateSpace: .global)
                        .onEnded { value in
                            if value.translation.width < 0 || value.translation.width > 0 {
                                vm.removeLastTerm()
                            }
                        }
                )
        }
        .tabItem {
            Label("Castulator", systemImage: "scroll.fill")
        }
    }
}
