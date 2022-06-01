package com.itbug.flutter_rtmp_plugin.util

import com.google.gson.Gson


fun Any?.print() {
    AnyWrapUtil.printJsonString(this)
}

inline fun <reified T> Any?.parse(): T {
    return AnyWrapUtil.parse<T>(this)
}

/**
 * Any 相关工具类
 */
class AnyWrapUtil {

    companion object {


        /**
         * 转换成实体类
         */
        inline fun <reified T> parse(params: Any?): T {
            val gson = Gson()
            val toJson = gson.toJson(params)
            return gson.fromJson(toJson, T::class.java)
        }

        /**
         * 打印一下json
         */
        fun printJsonString(params: Any?) {
            println(Gson().toJson(params))
        }

    }
}