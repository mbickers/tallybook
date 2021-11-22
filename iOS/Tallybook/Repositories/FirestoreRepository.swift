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

// Referenced https://peterfriese.dev/replicating-reminder-swiftui-firebase-part2/

class FirestoreRepository: Repository {
  var publisher: AnyPublisher<[Tally], Never> {
    return tallies.eraseToAnyPublisher()
  }

  private var db = Firestore.firestore()
  private var tallies = CurrentValueSubject<[Tally], Never>([Tally]())

  init() {
    db.collection("tallies")
      .order(by: "listPriority")
      .addSnapshotListener(snapshotListener)
  }

  func snapshotListener(_ snapshot: QuerySnapshot?, _ error: Error?) {
    if let error = error {
      print("Error in snapshot listener: \(error)")
    }

    guard let snapshot = snapshot else {
      print("Snapshot is nil")
      return
    }

    tallies.value = snapshot.documents.compactMap { document -> Tally? in
      do {
        return try document.data(as: Tally.self)
      } catch {
        print("Error decoding tally document: \(error)")
      }

      return nil
    }
  }

  func addTally(_ tally: Tally) {
    do {
      let _ = try db.collection("tallies").addDocument(from: tally)
    } catch {
      print("Error adding tally: \(error)")
    }
  }

  func removeTally(_ tally: Tally) {
    if let id = tally.id {
      db.collection("tallies")
        .document(id)
        .delete { error in
          if let error = error {
            print("Error removing tally: \(error)")
          }
        }
    } else {
      print("Tried to remove tally with nil id")
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
      print("Tried to update tally with nil id")
    }
  }
}
