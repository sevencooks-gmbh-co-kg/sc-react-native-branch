import { NativeEventEmitter, NativeModules } from 'react-native'
import type {
  BranchCallback,
  BranchParams,
  BranchUniversalObject,
  LinkProperties,
} from './types'

interface RNBranch {
  INIT_SESSION_FINISHED: string
  initSession: () => void
  getFirstReferringParams: () => Promise<BranchParams>
  getLatestReferringParams: () => Promise<BranchParams>
  generateShortUrl: (
    branchUniversalObject: BranchUniversalObject,
    linkProperties: LinkProperties,
  ) => Promise<string>
}
const SCBranch: RNBranch = NativeModules.SCBranch

export const Branch = {
  initSession: SCBranch.initSession,
  getLatestReferringParams: SCBranch.getLatestReferringParams,
  getFirstReferringParams: SCBranch.getFirstReferringParams,
  subscribe: (cb: BranchCallback) => {
    const eventEmitter = new NativeEventEmitter(NativeModules.SCBranch)
    const listener = eventEmitter.addListener(
      SCBranch.INIT_SESSION_FINISHED,
      cb,
    )
    return () => {
      listener.remove()
    }
  },
  generateShortUrl: SCBranch.generateShortUrl,
}
