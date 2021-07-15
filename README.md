# sc-react-native-branch

Sevencooks Branch SDK for React Native

## Installation

```sh
yarn add @sevencooks/react-native-branch
```

## Linking

### >= 0.60

Autolinking will just do the job.

### < 0.60

#### Mostly automatic

```sh
react-native link @sevencooks/react-native-branch
```

## Setup

### Android

#### `android/app/src/main/.../MainApplication.java`

Add `import com.sevencooks.rnbranch`

Add `RNBranchModule.initBranch(this)` in your `onCreate` method.

```java
@Override
public void onCreate() {
  super.onCreate();
  // Add this
  RNBranchModule.initBranch(this);
}
```

## Usage

```typescript
import Branch from '@sevencooks/react-native-branch'

// Anywhere in your most top component e.g. App.js
React.useEffect(() => Branch.initSession(), [])

// Subscribe to events
Branch.subscribe(({ params, error }) => {
  console.log({ params, error })
})

// Get latest deep link params
const params = await Branch.getLatestReferringParams()

// create a new shortLink
const url = await Branch.generateShortUrl(
  branchUniversalOpjectData,
  linkProperties,
)
// See https://help.branch.io/developers-hub/docs/native-sdks-overview for further instructions.
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
