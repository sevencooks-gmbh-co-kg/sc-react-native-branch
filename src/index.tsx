import { NativeModules } from 'react-native'

type ScReactNativeBranchType = {
  multiply(a: number, b: number): Promise<number>
}

const { ScReactNativeBranch } = NativeModules

export default ScReactNativeBranch as ScReactNativeBranchType
