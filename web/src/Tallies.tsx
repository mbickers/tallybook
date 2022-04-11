import { TallyList } from "./TallyList"
import { TallyServiceProvider } from "./TallyServiceProvider"
import { UserProvider } from "./UserProvider"

export const Tallies = () => {
    return (
        <UserProvider>
            <TallyServiceProvider>
                <TallyList />
            </TallyServiceProvider>
        </UserProvider>
    )
}