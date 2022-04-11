import { useParams } from "react-router-dom"

export const TallyDetail = () => {
  const id = useParams().id
  return <p>{id}</p>
}