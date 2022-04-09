export enum TallyKind {
  Completion = "Completion",
  Counter = "Counter",
  Amount = "Amount",
}

export interface Tally {
  kind: TallyKind,
  id?: string,
  name: string,
  entries: unknown,
  listPriority: number,
  userId?: string,
}

export interface TallyService {
  tallies?: Tally[]
  //addTally: (tally: Tally) => void
  //removeTally: (tally: Tally) => void
  //updateTally: (tally: Tally) => void
}