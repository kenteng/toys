﻿package com.qiyi.player.wonder.plugins.loading
{

    public class LoadingDef extends Object
    {
        private static var statusBegin:int = 0;
        public static const STATUS_BEGIN:int = statusBegin;
        public static const STATUS_VIEW_INIT:int = statusBegin;
        public static const STATUS_OPEN:int = statusBegin + 1;
        public static const STATUS_END:int = statusBegin + 1;
        public static const STATUS_COUNT:int = STATUS_END - STATUS_BEGIN;
        public static const NOTIFIC_ADD_STATUS:String = "loadingAddStatus";
        public static const NOTIFIC_REMOVE_STATUS:String = "loadingRemoveStatus";

        public function LoadingDef()
        {
            return;
        }// end function

    }
}
