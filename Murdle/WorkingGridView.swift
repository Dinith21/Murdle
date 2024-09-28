//
//  WorkingGridView.swift
//  Murdle
//
//  Created by Dinith Meegahapola on 27/9/2024.
//

import SwiftUI

struct WorkingGridView: View {
    @State var workingGrid: WorkingGrid
    
    var gridRowCount: Int { workingGrid.murdle.motives == [] ? 2 : 3 }
    
    var body: some View {
        ScrollView([.horizontal, .vertical]){
            Grid(horizontalSpacing: -2, verticalSpacing: -2) {
                GridRow {
                    Text("")
                    ForEach(0..<gridRowCount) { i in
                        Grid(horizontalSpacing: 7) {
                            GridRow {
                                ForEach(0..<workingGrid.murdle.gridSize) { j in
                                    if i == 0 {
                                        Text(workingGrid.murdle.suspects[j].icon)
                                            .padding(2)
                                    } else if gridRowCount == 3 && i == 1 {
                                        Text(workingGrid.murdle.motives[j].icon)
                                            .padding(2)
                                    } else {
                                        Text(workingGrid.murdle.locations[j].icon)
                                            .padding(2)
                                    }
                                }
                            }
                        }
                    }
                }
                GridRow {
                    Grid {
                        ForEach(0..<workingGrid.murdle.gridSize) { i in
                            Text(workingGrid.murdle.weapons[i].icon)
                                .padding(2)
                        }
                    }
                    ForEach(0..<gridRowCount) { i in
                        GridSectionView(workingGrid: $workingGrid, gridSection: i)
                    }
                }
                GridRow {
                    Grid {
                        ForEach(0..<workingGrid.murdle.gridSize) { i in
                            Text(workingGrid.murdle.locations[i].icon)
                                .padding(2)
                        }
                    }
                    if gridRowCount == 3 {
                        GridSectionView(workingGrid: $workingGrid, gridSection: 3)
                        GridSectionView(workingGrid: $workingGrid, gridSection: 4)
                    } else {
                        GridSectionView(workingGrid: $workingGrid, gridSection: 2)
                    }
                }
                if gridRowCount == 3 {
                    GridRow {
                        Grid {
                            ForEach(0..<workingGrid.murdle.gridSize) { i in
                                Text(workingGrid.murdle.motives[i].icon)
                                    .padding(2)
                            }
                        }
                        GridSectionView(workingGrid: $workingGrid, gridSection: 5)
                    }
                }
            }
            .scaledToFit()
        }
    }
}

struct GridSectionView: View {
    @Binding var workingGrid: WorkingGrid
    
    var gridSection: Int
    
    var body: some View {
        Grid(horizontalSpacing: 5, verticalSpacing: 5) {
            ForEach(0..<workingGrid.murdle.gridSize) { i in
                GridRow {
                    ForEach(workingGrid.cells.filter({ $0.gridSection == gridSection && $0.XIndex == i })) { cell in
                        CellView(workingGrid: $workingGrid, cell: cell)
                    }
                }
            }
        }
        .frame(width: 35*CGFloat(workingGrid.murdle.gridSize), height: 35*CGFloat(workingGrid.murdle.gridSize))
        .border(.black, width: 3)
        .onChange(of: workingGrid.cells) {
            workingGrid.checkCells()
        }
    }
}

struct CellView: View {
    @Binding var workingGrid: WorkingGrid
    
    var cell: WorkingGrid.Cell
    
    var cellIndex: Int {
        workingGrid.cells.firstIndex(where: { $0.gridSection == cell.gridSection && $0.XIndex == cell.XIndex && $0.YIndex == cell.YIndex })!
    }
    
    var body: some View {
        Button {
            workingGrid.cells[cellIndex].click()
        } label: {
            Text(cell.icon)
                .background {
                    Rectangle()
                        .frame(width: 35, height: 35)
                        .foregroundColor(.white)
                        .border(.black)
                }
                .frame(width: 30, height: 30)
        }
    }
}

#Preview {
    WorkingGridView(workingGrid: generateWorkingGrid())
}
