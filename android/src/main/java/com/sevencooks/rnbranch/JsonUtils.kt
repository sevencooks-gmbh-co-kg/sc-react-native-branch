package com.sevencooks.rnbranch

import com.facebook.react.bridge.WritableArray
import com.facebook.react.bridge.WritableMap
import com.facebook.react.bridge.WritableNativeArray
import com.facebook.react.bridge.WritableNativeMap
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject

@Throws(JSONException::class)
fun convertJsonToMap(jsonObject: JSONObject?): WritableMap? {
    val map: WritableMap = WritableNativeMap()
    if (jsonObject == null) {
        return null
    }
    jsonObject.keys().asSequence().forEach {
        when (val value = jsonObject.get(it)) {
            is JSONArray -> map.putArray(it, convertJsonToArray(value))
            is JSONObject -> map.putMap(it, convertJsonToMap(value))
            is Boolean -> map.putBoolean(it, value)
            is Int -> map.putInt(it, value)
            is Double -> map.putDouble(it, value)
            is String -> map.putString(it, value)
            JSONObject.NULL -> map.putNull(it)
            else -> map.putString(it, value.toString())
        }
    }
    return map
}

@Throws(JSONException::class)
fun convertJsonToArray(jsonArray: JSONArray): WritableArray {
    val array: WritableArray = WritableNativeArray()
    (0 until jsonArray.length()).forEach {
        when (val value = jsonArray.get(it)) {
            is JSONArray -> array.pushArray(convertJsonToArray(value))
            is JSONObject -> array.pushMap(convertJsonToMap(value))
            is Boolean -> array.pushBoolean(value)
            is Int -> array.pushInt(value)
            is Double -> array.pushDouble(value)
            is String -> array.pushString(value)
            else -> array.pushString(value.toString())
        }
    }
    return array
}
