import { NativeEventEmitter, NativeModules } from 'react-native'
import type {
  BranchCallback,
  BranchParams,
  BranchUniversalObject,
  LinkProperties,
} from './types'

interface RNBranchT {
  INIT_SESSION_FINISHED: string
  initSession: () => void
  getFirstReferringParams: () => Promise<BranchParams>
  getLatestReferringParams: () => Promise<BranchParams>
  generateShortUrl: (
    branchUniversalObject: BranchUniversalObject,
    linkProperties: LinkProperties,
  ) => Promise<string>
}
const RNBranch: RNBranchT = NativeModules.RNBranch

export const Branch = {
  initSession: RNBranch.initSession,
  getLatestReferringParams: RNBranch.getLatestReferringParams,
  getFirstReferringParams: RNBranch.getFirstReferringParams,
  subscribe: (cb: BranchCallback) => {
    const eventEmitter = new NativeEventEmitter(NativeModules.SCBranch)
    const listener = eventEmitter.addListener(
      RNBranch.INIT_SESSION_FINISHED,
      cb,
    )
    return () => {
      listener.remove()
    }
  },
  generateShortUrl: RNBranch.generateShortUrl,
}
