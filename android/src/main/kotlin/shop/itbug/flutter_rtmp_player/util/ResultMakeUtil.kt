package com.itbug.flutter_rtmp_plugin.util

import com.google.gson.Gson
import com.itbug.flutter_rtmp_plugin.util.Result


val STATE_RESULT_KEY = "state-change"

data class Result (val type: String,val json: String?,val value: Any?)

class ResultMakeUtil {



    companion object {
        private val  gson  = Gson()

        /// 状态被改变回调
        fun makeStateResult(value: Int) : String  {
            return gson.toJson(Result(
                type = STATE_RESULT_KEY,
                json = null,
                value = value
            ))
        }
    }
}