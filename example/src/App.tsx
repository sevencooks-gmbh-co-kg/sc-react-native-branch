import * as React from 'react';

import { StyleSheet, View, Text, Button } from 'react-native';
// import ScReactNativeBranch from 'sc-react-native-branch';
import { NativeModules } from 'react-native';
const { SCBranch } = NativeModules

export default function App() {
  const [result, setResult] = React.useState<number | undefined>();

  return (
    <View style={styles.container}>
      <Text>Result: {result}</Text>
      <Button title="test" onPress={() => {

    console.log({SCBranch})
    SCBranch.validateSDKIntegration()
    // ScReactNativeBranch.validateSDKIntegration()// .then(setResult);
      }} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
