﻿package com.qiyi.player.wonder.common.ui
{
    import flash.display.*;
    import flash.filters.*;
    import flash.text.*;

    public class FastCreator extends Object
    {
        private static const GRAY_FILTER:ColorMatrixFilter = new ColorMatrixFilter([0.3086, 0.694, 0.082, 0, 0, 0.3086, 0.694, 0.082, 0, 0, 0.3086, 0.694, 0.082, 0, 0, 0, 0, 0, 1, 0]);
        public static const FONT_MSYH:String = "微软雅黑";
        public static const FONT_SIMSUN:String = "宋体";

        public function FastCreator()
        {
            return;
        }// end function

        public static function createLabel(param1:String, param2:uint, param3:int = 12, param4:String = "center", param5:Boolean = false, param6:String = "微软雅黑", param7:Array = null) : TextField
        {
            var _loc_8:* = new TextField();
            _loc_8.type = TextFieldType.DYNAMIC;
            _loc_8.selectable = false;
            if (param4 != "")
            {
                _loc_8.autoSize = param4;
            }
            else
            {
                _loc_8.autoSize = TextFieldAutoSize.LEFT;
            }
            _loc_8.defaultTextFormat = createTextFormat(param6, param3, param2, param5);
            if (param7)
            {
                _loc_8.filters = param7;
            }
            _loc_8.htmlText = param1;
            return _loc_8;
        }// end function

        public static function createInput(param1:String, param2:uint, param3:int = 12, param4:Boolean = false, param5:String = "微软雅黑", param6:Array = null) : TextField
        {
            var _loc_7:* = new TextField();
            _loc_7.type = TextFieldType.INPUT;
            _loc_7.defaultTextFormat = createTextFormat(param5, param3, param2, param4);
            if (param6)
            {
                _loc_7.filters = param6;
            }
            _loc_7.text = param1;
            return _loc_7;
        }// end function

        public static function createTextFormat(param1:String = null, param2:Object = null, param3:Object = null, param4:Object = null, param5:Object = null, param6:Object = null, param7:String = null, param8:String = null, param9:String = null, param10:Object = null, param11:Object = null, param12:Object = null, param13:Object = null) : TextFormat
        {
            var _loc_14:* = new TextFormat(param1, param2, param3, param4, param5, param6, param7, param8, param9, param10, param11, param12, param13);
            return _loc_14;
        }// end function

        public static function createRectSprite(param1:Number, param2:Number, param3:Number = 1, param4:uint = 0) : Sprite
        {
            var _loc_5:* = new Sprite();
            _loc_5.graphics.beginFill(param4, param3);
            _loc_5.graphics.drawRect(0, 0, param1, param2);
            _loc_5.graphics.endFill();
            return _loc_5;
        }// end function

        public static function createCircleSprite(param1:int, param2:uint = 1, param3:uint = 0) : Sprite
        {
            var _loc_4:* = new Sprite();
            _loc_4.graphics.beginFill(param3, param2);
            _loc_4.graphics.drawCircle(0, 0, param1);
            _loc_4.graphics.endFill();
            return _loc_4;
        }// end function

        public static function appendHtmlPatch(param1:String, param2:uint, param3:int = 0, param4:String = "宋体", param5:int = 12) : String
        {
            if (param1 != null)
            {
                return "<textformat leading=\'" + param3 + "\'><font color=\'#" + param2.toString(16) + "\' face=\'" + param4 + "\' size=\'" + param5 + "\'>" + param1 + "</font></textformat>";
            }
            return "";
        }// end function

        public static function grayDisplayObject(param1:DisplayObject, param2:Boolean = true) : DisplayObject
        {
            if (param2)
            {
                param1.filters = [GRAY_FILTER];
            }
            else
            {
                param1.filters = null;
            }
            return param1;
        }// end function

        public static function removeAllChild(param1:DisplayObjectContainer) : void
        {
            while (param1.numChildren > 0)
            {
                
                param1.removeChildAt(0);
            }
            return;
        }// end function

    }
}
