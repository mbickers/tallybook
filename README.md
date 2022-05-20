# Tallybook
Tallybook is an app to keep track of things you do every day.

Built with
- SwiftUI on iOS,
- Typescript, React and Chakra UI on web,
- Firebase backend.

## Firebase Setup Instructions
To setup Firebase use the following commands, replacing app IDs with the correct values (viewable with `firebase apps:list`)

Initial project setup:
```bash
firebase init
# Add firestore and auth (email/password login only) on Firebase console
firebase deploy
```

To add iOS app:
```bash
firebase apps:create —bundle-id dev.bickers.tallybook iOS tallybook
firebase apps:sdkconfig iOS [iOS app ID] > iOS/Tallybook/GoogleService-Info.plist
```

To add web app:
```bash
firebase apps:create web tallybook
echo REACT_APP_FIREBASE_CONFIG=\" > web/.env.local
firebase apps:sdkconfig web [web app ID]  | grep -zo "{[[:space:][:alnum:]:\",.-]*}"  | tr -d '\n' >> web/.env
echo \" >> web/.env.local
```

When firestore rules are changed: `firebase deploy`.