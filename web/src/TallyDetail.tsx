import { useContext } from "react"
import { useParams } from "react-router-dom"
import { TallyServiceContext } from "./TallyServiceProvider"

export const TallyDetail = () => {
  const id = useParams().id
  const tallyService = useContext(TallyServiceContext)
  const tally = tallyService.tallies?.find(tally => tally.id == id)

  if (!tally) {
      return <p>Unable to view tally {id}</p>
  }

  return <table>
      <tbody>
          {tally.entries.entries.map(entry => (
              <tr key={entry.formattedDate}>
                  <td>{entry.formattedDate}</td>
                  <td>{entry.value}</td>
              </tr>
          ))}
      </tbody>
  </table>
}