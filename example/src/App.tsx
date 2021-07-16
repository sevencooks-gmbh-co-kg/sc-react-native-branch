import * as React from 'react'

import { StyleSheet, View, Button, Alert } from 'react-native'
import Branch from '@sevencooks/react-native-branch'

export default function App() {
  React.useEffect(() => {
    Branch.initSession()
    return Branch.subscribe(({ params, error }) => {
      if (!error) {
        Alert.alert('Branch Params', JSON.stringify(params))
      }
    })
  }, [])

  return (
    <View style={styles.container}>
      <Button
        title="Get latest params"
        onPress={async () => {
          const params = await Branch.getLatestReferringParams()
          Alert.alert('Latest Branch Params', JSON.stringify(params))
        }}
      />
      <Button
        title="Generate short url"
        onPress={async () => {
          const branchUniversalObject = {
            canonicalIdentifier: '/lab-123-from-inspo',
          }
          const linkParams = {
            $desktop_url: 'https://link.sevencooks.com/lab-123-from-inspo',
            tags: ['share', 'share_recipe'], // optional stuff
            feature: 'share_recipe', // optional stuff
          }
          const shortUrl = await Branch.generateShortUrl(
            branchUniversalObject,
            linkParams,
          )
          Alert.alert('Branch short url', shortUrl)
        }}
      />
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
