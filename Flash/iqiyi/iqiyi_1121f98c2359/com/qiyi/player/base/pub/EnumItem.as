﻿package com.qiyi.player.base.pub
{

    public class EnumItem extends Object
    {
        public var id:int;
        public var name:String;

        public function EnumItem(param1:int, param2:String, param3:Array)
        {
            this.id = param1;
            this.name = param2;
            param3.push(this);
            return;
        }// end function

        public function toString() : String
        {
            return this.name;
        }// end function

    }
}
