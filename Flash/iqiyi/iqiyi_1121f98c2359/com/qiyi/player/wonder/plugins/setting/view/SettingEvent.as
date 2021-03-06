﻿package com.qiyi.player.wonder.plugins.setting.view
{
    import com.qiyi.player.wonder.common.event.*;

    public class SettingEvent extends CommonEvent
    {
        public static const Evt_Open:String = "evtSettingOpen";
        public static const Evt_Close:String = "evtSettingClose";
        public static const Evt_DefinitionOpen:String = "evtDefinitionOpen";
        public static const Evt_DefinitionClose:String = "evtDefinitionClose";
        public static const Evt_FilterOpen:String = "evtFilterOpen";
        public static const Evt_FilterClose:String = "evtFilterClose";
        public static const Evt_DefinitionChangeClick:String = "evtDefinitionChangeClick";
        public static const Evt_VideoRateChanged:String = "evtSettingVideoRateChanged";
        public static const Evt_VideoRateIndexSubmit:String = "evtSettingVideoIndexSubmit";
        public static const Evt_SkipTitleTail:String = "evtSettingSkipTitleTail";
        public static const Evt_SkipAD:String = "evtSettingSkipAD";
        public static const Evt_BrightnessChanged:String = "evtSettingBrightnessChanged";
        public static const Evt_ContrastChanged:String = "evtSettingContrastChanged";
        public static const Evt_TitleLanguageChanged:String = "evtSettingTitleLanguageChanged";
        public static const Evt_TitleFontColorChanged:String = "evtSettingTitleFontColorChanged";
        public static const Evt_TitleFontSizeChanged:String = "evtSettingTitleFontSizeChanged";
        public static const Evt_AudioTrackChanged:String = "evtSettingAudioTrackChanged";
        public static const Evt_DefinitionChanged:String = "evtSettingDefinitionChanged";
        public static const Evt_SettingTabChanged:String = "evtSettingSettingTabChanged";
        public static const Evt_OtherSettingItemChanged:String = "evtSettingOtherSettingsChanged";

        public function SettingEvent(param1:String, param2:Object = null)
        {
            super(param1, param2);
            return;
        }// end function

    }
}
