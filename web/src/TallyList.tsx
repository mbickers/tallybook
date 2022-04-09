import { useContext } from "react"
import { formattedDate } from "./FormattedDate"
import { TallyServiceContext } from "./TallyServiceProvider"
import { Tally } from "./types"

const TallyRow = ({ tally }: { tally: Tally }) => {
  const entries = tally.entries.entries
  const todayValue = (entries.length > 0 && entries[0].formattedDate == formattedDate(new Date())) ? entries[0].value : 0
  return <div>
    <h2>{tally.name}</h2>
    <p>{todayValue}</p>
  </div>
}

export const TallyList = () => {
  const tallyService = useContext(TallyServiceContext)

  return <>{tallyService.tallies?.map(tally => <TallyRow tally={tally} key={tally.id} />)}</>
}