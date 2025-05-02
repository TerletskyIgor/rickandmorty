//
//  Paginator.swift
//  RickAndMorty
//
//  Created by Igor Terletskyi on 30.04.2025.
//

import Foundation

final class Paginator {
    private(set) var currentPage = 1
    private var isLoading = false
    private var hasMorePages = true
    
    func reset() {
        currentPage = 1
        isLoading = false
        hasMorePages = true
    }
    
    /// Checks if the next page needs to be loaded and calls `load`
    /// - Parameters:
    /// - currentIndex: current index of the cell being displayed
    /// - totalCount: total number of elements in the list
    /// - threshold: how many elements before the end of the list to start loading the next page
    /// - load: closure that receives the current page and `done` callback
    
    func loadIfNeeded(
        currentIndex: Int,
        totalCount: Int,
        threshold: Int = 5,
        load: @escaping (_ page: Int, _ done: @escaping (_ hasMore: Bool) -> Void) -> Void
    ) {
        
        guard !isLoading, hasMorePages, currentIndex >= totalCount - threshold else { return }
        isLoading = true
        load(currentPage) { [weak self] hasMore in
            guard let self = self else { return }
            self.currentPage += 1
            self.hasMorePages = hasMore
            self.isLoading = false
        }
    }
}

