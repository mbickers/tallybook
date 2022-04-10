import React, { useContext, useState } from "react"
import { formattedDate } from "./FormattedDate"
import { TallyServiceContext } from "./TallyServiceProvider"
import { Tally, TallyKind } from "./types"

const TallyInput = ({kind, value, updateValue}: {kind: TallyKind, value: number, updateValue: (newValue: number) => void}) => {
    const [fieldValue, updateFieldValue] = useState(String(value))

    const onChangeHandler = (event: React.ChangeEvent<HTMLInputElement>) => {
        if (event.target.value === "") {
            updateFieldValue("")
            return
        }

        const numberValue = Number(event.target.value)
        if (Number.isInteger(numberValue) && numberValue >= 0) {
            updateFieldValue(String(numberValue))
            updateValue(numberValue)
        }
    }

    const onClickHandler = () => {
        updateFieldValue(String(1 + value))
        updateValue(1 + value)
    }

    switch (kind) {
        case TallyKind.Completion:
            return <input type="checkbox" checked={value === 1} onChange={() => updateValue(1-value)} />
        case TallyKind.Amount:
            return <input value={fieldValue} onChange={onChangeHandler} />
        case TallyKind.Counter:
            return <>
                <button onClick={onClickHandler}>+</button>
                <input value={fieldValue} onChange={onChangeHandler} />
            </>
    }
}

const TallyRow = ({ tally }: { tally: Tally }) => {
  const tallyService = useContext(TallyServiceContext)
  const entries = tally.entries.entries
  const todayFormatted = formattedDate(new Date())
  const entriesIncludesToday = entries.length > 0 && entries[0].formattedDate == todayFormatted
  const todayValue = entriesIncludesToday ? entries[0].value : 0

  const updateTodayValue = (newValue: number) => {
      const newEntry = { formattedDate: formattedDate(new Date()), value: newValue }
      const updatedEntries = [newEntry, ...(entriesIncludesToday ? entries.slice(1) : entries)]
      if (tallyService.updateTally) {
        tallyService.updateTally({ ...tally, entries: { entries: updatedEntries} })
      }
  }

  return <div>
    <h2>{tally.name}</h2>
    <TallyInput kind={tally.kind} value={todayValue} updateValue={updateTodayValue} />
  </div>
}

export const TallyList = () => {
  const tallyService = useContext(TallyServiceContext)

  return <>{tallyService.tallies?.map(tally => <TallyRow tally={tally} key={tally.id} />)}</>
}