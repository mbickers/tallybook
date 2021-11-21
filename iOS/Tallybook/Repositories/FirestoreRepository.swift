//
//  FirestoreRepository.swift
//  Tallybook
//
//  Created by Max Bickers on 11/20/21.
//  Copyright © 2021 Max Bickers. All rights reserved.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

class FirestoreRepository: Repository {
  var publisher: AnyPublisher<[Tally], Never> {
    return tallies.eraseToAnyPublisher()
  }

  private var db = Firestore.firestore()
  private var tallies = CurrentValueSubject<[Tally], Never>([Tally]())

  init() {
    db.collection("tallies")
      .order(by: "listPriority")
      .addSnapshotListener { snapshot, error in
        guard let snapshot = snapshot else {
          print("Snapshot is nil")
          return
        }

        let tallies = snapshot.documents.compactMap { document -> Tally? in
          guard let tally = try? document.data(as: Tally.self) else {
            print("Unable to decode tally")
            return nil
          }

          return tally
        }

        self.tallies.value = tallies
      }
  }

  func addTally(_ tally: Tally) {
    do {
      let _ = try db.collection("tallies").addDocument(from: tally)
    } catch {
      print("Unable to add tally \(error)")
    }
  }

  func removeTally(_ tally: Tally) {
    if let id = tally.id {
      db.collection("tallies")
        .document(id)
        .delete { error in
          if let error = error {
            print("Error removing document: \(error)")
          }
        }
    }
  }

  func updateTally(_ tally: Tally) {
    if let id = tally.id {
      do {
        try db.collection("tallies")
          .document(id)
          .setData(from: tally)
      } catch {
        print("Error updating tally \(error)")
      }
    } else {
      print("Tally id is nil")
    }
  }
}
