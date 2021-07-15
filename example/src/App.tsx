import * as React from 'react'

import { StyleSheet, View, Text } from 'react-native'
import Branch from '@sevencooks/react-native-branch'

export default function App() {
  React.useEffect(() => {
    Branch.initSession()
  }, [])

  return (
    <View style={styles.container}>
      <Text>Hello Branch</Text>
    </View>
  )
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
})
