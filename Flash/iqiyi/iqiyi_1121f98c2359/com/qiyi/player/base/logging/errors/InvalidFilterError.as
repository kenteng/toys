﻿package com.qiyi.player.base.logging.errors
{

    public class InvalidFilterError extends Error
    {

        public function InvalidFilterError(param1:String)
        {
            super(param1);
            return;
        }// end function

        public function toString() : String
        {
            return String(message);
        }// end function

    }
}
