//
//  CoreDataManager.swift
//  RickAndMorty
//
//  Created by Igor Terletskyi on 01.05.2025.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()

    private init() { }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RickAndMorty")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Core Data loading error: \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveCharacters(_ characters: [Character]) {
        context.perform {
            let fetchRequest: NSFetchRequest<CDCharacter> = CDCharacter.fetchRequest()
            
            do {
                let existingCharacters = try self.context.fetch(fetchRequest)
                let existingIDs = Set(existingCharacters.map { Int($0.id) })

                for character in characters where !existingIDs.contains(character.id) {
                    let cdCharacter = CDCharacter(context: self.context)
                    cdCharacter.id = Int32(character.id)
                    cdCharacter.name = character.name
                    cdCharacter.status = character.status.rawValue
                    cdCharacter.species = character.species
                    cdCharacter.imageURL = character.imageURL
                }

                try self.context.save()

            } catch {
                print("❌ Failed to save characters: \(error)")
            }
        }
    }

    func fetchCharacters() -> [Character] {
        let request: NSFetchRequest<CDCharacter> = CDCharacter.fetchRequest()
        do {
            let cdCharacters = try context.fetch(request)
            return cdCharacters.map { Character(from: $0) }
        } catch {
            print("❌ Failed to fetch characters: \(error)")
            return []
        }
    }

    func deleteAllCharacters() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDCharacter.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(batchDeleteRequest)
            try context.save()
        } catch {
            print("❌ Failed to delete characters: \(error)")
        }
    }
}
