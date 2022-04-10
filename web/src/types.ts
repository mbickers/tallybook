export enum TallyKind {
  Completion = "Completion",
  Counter = "Counter",
  Amount = "Amount",
}

export interface TallyEntry {
    formattedDate: string,
    value: number
}

export interface EntryList {
    entries: TallyEntry[]
}

export interface Tally {
  kind: TallyKind,
  id?: string,
  name: string,
  entries: EntryList,
  listPriority: number,
  userId?: string,
}

export interface TallyService {
  tallies?: Tally[]
  //addTally: (tally: Tally) => void
  //removeTally: (tally: Tally) => void
  updateTally?: (tally: Tally) => void
}