﻿package com.qiyi.player.core.model.def
{
    import com.qiyi.player.base.pub.*;

    public class TryWatchEnum extends Object
    {
        public static const ITEMS:Array = [];
        public static const NONE:EnumItem = new EnumItem(0, "none", ITEMS);
        public static const PART:EnumItem = new EnumItem(1, "part", ITEMS);
        public static const TOTAL:EnumItem = new EnumItem(2, "total", ITEMS);

        public function TryWatchEnum()
        {
            return;
        }// end function

    }
}
