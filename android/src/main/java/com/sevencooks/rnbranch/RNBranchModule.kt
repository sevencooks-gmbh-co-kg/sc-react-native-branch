package com.sevencooks.rnbranch

import android.app.Activity
import android.content.Context
import android.content.Intent
import com.facebook.react.bridge.*
import com.facebook.react.modules.core.DeviceEventManagerModule
import io.branch.indexing.BranchUniversalObject
import io.branch.referral.Branch
import io.branch.referral.BranchError
import io.branch.referral.util.LinkProperties
import org.json.JSONObject
import java.util.ArrayList

class RNBranchModule(private val context: ReactApplicationContext) : ReactContextBaseJavaModule(context) {

    inner class BranchListener : Branch.BranchReferralInitListener {
        override fun onInitFinished(referringParams: JSONObject?, error: BranchError?) {
            val result = JSONObject().put("params", referringParams).put("error", error?.message)

            context
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
                .emit(INIT_SESSION_FINISHED, convertJsonToMap(result))
        }
    }

    init {
        context.addActivityEventListener(object : ActivityEventListener {
            override fun onActivityResult(activity: Activity?, requestCode: Int, resultCode: Int, data: Intent?) {}

            override fun onNewIntent(intent: Intent?) {
                if (intent != null) {
                    intent.putExtra("branch_force_new_session", true)
                    currentActivity?.intent = intent
                    Branch.sessionBuilder(currentActivity).withCallback(BranchListener())
                        .reInit()
                }
            }
        })
    }

    @ReactMethod
    fun initSession() {
        Branch.sessionBuilder(currentActivity).withCallback(BranchListener())
            .withData(currentActivity?.intent?.data).init()
    }

    @ReactMethod
    fun getFirstReferringParams(promise: Promise) {
        promise.resolve(convertJsonToMap(Branch.getInstance().firstReferringParams))
    }

    @ReactMethod
    fun getLatestReferringParams(promise: Promise) {
        promise.resolve(convertJsonToMap(Branch.getInstance().latestReferringParams))
    }

    @ReactMethod
    fun generateShortUrl(branchUniversalObject: ReadableMap, linkProperties: ReadableMap, promise: Promise) {
        val buo = createBranchUniversalObject(branchUniversalObject)
        val linkProps = createLinkProperties(linkProperties)
        buo.generateShortUrl(context, linkProps) { url, error ->
            if (error != null) promise.reject(Throwable(error.message)) else promise.resolve(url)
        }
    }

    @Suppress("UNCHECKED_CAST")
    private fun createBranchUniversalObject(branchUniversalObject: ReadableMap): BranchUniversalObject {
        val buo = BranchUniversalObject()
            .setCanonicalIdentifier(branchUniversalObject.getString("canonicalIdentifier")!!)
        branchUniversalObject.entryIterator.forEach {
            when (it.key) {
                "title" -> buo.setTitle(it.value as String)
                "canonicalUrl" -> buo.setCanonicalUrl(it.value as String)
                "contentDescription" -> buo.setContentDescription(it.value as String)
                "imageUrl" -> buo.setContentImageUrl(it.value as String)
                "keywords" -> buo.addKeyWords(it.value as ArrayList<String>)
            }
        }
        return buo
    }

    private fun createLinkProperties(linkProperties: ReadableMap): LinkProperties {
        val props = LinkProperties()
        linkProperties.entryIterator.forEach {
            when (it.key) {
                "alias" -> props.alias = it.value as String
                "campaign" -> props.campaign = it.value as String
                "channel" -> props.channel = it.value as String
                "feature" -> props.feature = it.value as String
                "stage" -> props.stage = it.value as String
                "tags" -> (it.value as ReadableNativeArray).toArrayList().forEach { tag -> props.addTag(tag as String) }
                else -> props.addControlParameter(it.key, it.value.toString())
            }
        }
        return props
    }

    override fun getName(): String {
        return "RNBranch"
    }

    override fun getConstants(): Map<String, Any> {
        return mapOf(
            "INIT_SESSION_FINISHED" to INIT_SESSION_FINISHED,
        )
    }

    companion object {
        const val INIT_SESSION_FINISHED = "RNBranch.initSessionFinished"

        @JvmStatic
        fun initBranch(context: Context) {
            Branch.getAutoInstance(context)
            Branch.expectDelayedSessionInitialization(true)
        }

        @JvmStatic
        fun enableLogging() {
            Branch.enableLogging()
        }
    }
}
