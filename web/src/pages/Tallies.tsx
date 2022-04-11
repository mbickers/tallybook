import { TallyList } from "../components/TallyList"
import { TallyServiceProvider } from "../providers/TallyServiceProvider"
import { UserProvider } from "../providers/UserProvider"

export const Tallies = () => {
    return (
        <UserProvider>
            <TallyServiceProvider>
                <TallyList />
            </TallyServiceProvider>
        </UserProvider>
    )
}