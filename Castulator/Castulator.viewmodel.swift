//
//  CastulatorViewModel.swift
//  Castulator
//
//  Created by Ricky David Groner II on 3/21/24.
//

import Foundation

extension CastulatorView {
    @Observable
    class ViewModel {
        var running: RunningCastulations = RunningCastulations()
        
        func handleDiceButtonPress(_ die: Dice) {
            // if we have a castulation result already, begin a new castulation
            if running.rhs.result != nil {
                running = RunningCastulations(value: running.value + [Castulation()])
                return
            }
            
            // otherwise, append the indicated die to the current castulation
            // but only if there are less than 6
            if running.rhs.terms.count < 6 {
                let castulation = Castulation(
                    operation: running.rhs.operation,
                    terms: running.rhs.terms + [TermItem(die: die, roll: nil)]
                )
                
                running = RunningCastulations(value: running.value.map { $0 == running.rhs ? castulation : $0 })
            }
        }
        
        func handleOpButtonPress(_ op: Operation) {
            
            // ignore repeat press
            if running.rhs.operation == op && running.rhs.result == nil { return }
            
            // ignore if only one castulation and zero dice
            if running.rhs.operation != op && running.rhs.terms.isEmpty && running.value.count == 1 { return }
            
            // switch op of current castulation if no result yet and zero dice
            if running.rhs.operation != op && running.rhs.terms.isEmpty && running.value.count > 1 {
                let castulation = Castulation(
                    operation: op
                )
                
                running = RunningCastulations(value: running.value.map { $0 == running.rhs ? castulation : $0 })
                return
            }
            
            // append a new castulation if we have a result for the current castulation
            if !running.rhs.terms.isEmpty && running.rhs.result != nil {
                running = RunningCastulations(value: running.value + [Castulation(operation: op)])
                return
            }
            
            // otherwise, get result for current castulation and then append new castulation
            let castulation = Castulation(
                operation: running.rhs.operation,
                terms: running.rhs.terms.map { item in
                    TermItem(die: item.die, roll: castDie(item.die))
                }
            )
            
            running = RunningCastulations(value: running.value.map { $0 == running.rhs ? castulation : $0 } + [Castulation(operation: op)])
        }
        
        func handleEqualsButtonPress() {
            // ignore if nothing to work with
            if running.value.count == 1 && running.rhs.terms.isEmpty { return }
            
            // if there are some dice to work with in a single present castulation,
            // roll them if they haven't been rolled yet
            let castulation = Castulation(
                operation: running.rhs.operation,
                terms: running.rhs.terms.map { item in
                    TermItem(die: item.die, roll: castDie(item.die))
                }
            )
            
            if running.rhs.result != nil {
                running = RunningCastulations(value: running.value + [castulation])
                return
            }
            
            running = RunningCastulations(value: running.value.map { $0 == running.rhs ? castulation : $0 })
        }
        
        func handleClearButtonPress() {
            running = RunningCastulations()
        }
        
        func handleRerollSingleButtonPress(term: TermItem, side: Castulation) {
            // ignore if nothing to reroll
            
            let castulation = Castulation(
                operation: side.operation,
                terms: side.terms.map { item in
                    if term == item {
                        return TermItem(die: item.die, roll: castDie(item.die))
                    }
                    return item
                }
            )
            
            running = RunningCastulations(value: running.value.map { $0 == side ? castulation : $0 } )
        }
        
        func handleRerollLastButtonPress() {
            // ignore if nothing to reroll
            if running.value.count == 1 && running.rhs.result == nil {
                return
            }
            
            let castulation = Castulation(
                operation: running.rhs.operation,
                terms: running.rhs.terms.map { item in
                    TermItem(die: item.die, roll: castDie(item.die))
                }
            )
            
            running = RunningCastulations(value: running.value.map { $0 == running.rhs ? castulation : $0 } )
        }
        
        func handleRerollAllButtonPress() {
            running = RunningCastulations(value: running.value.map { castulation in
                Castulation(operation: castulation.operation, terms: castulation.terms.map { item in
                    TermItem(die: item.die, roll: castDie(item.die))
                })
            })
        }
        
        func removeLastTerm() {
            let side = running.rhs.terms.count == 0 && running.value.count <= 2 ? running.lhs : running.rhs
            running = RunningCastulations(value: running.value.map { $0 == side ? Castulation(operation: $0.operation, terms: $0.terms.dropLast()) : $0} )
        }
    }
}
