﻿package com.qiyi.player.core.view
{
    import flash.display.*;

    public interface ILayer extends IDestroy
    {

        public function ILayer();

        function set showSubtitle(param1:Boolean) : void;

        function get showSubtitle() : Boolean;

        function set showSubtitleFilter(param1:Boolean) : void;

        function get showSubtitleFilter() : Boolean;

        function set showLogo(param1:Boolean) : void;

        function get showLogo() : Boolean;

        function set showBrand(param1:Boolean) : void;

        function get showBrand() : Boolean;

        function set showBackground(param1:Boolean) : void;

        function get showBackground() : Boolean;

        function toggleVideoInfo() : void;

        function loadLogo(param1:String) : void;

        function setLogo(param1:DisplayObject) : void;

    }
}
