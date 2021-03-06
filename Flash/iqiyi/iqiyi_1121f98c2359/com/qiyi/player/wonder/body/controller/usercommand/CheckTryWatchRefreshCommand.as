﻿package com.qiyi.player.wonder.body.controller.usercommand
{
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.plugins.hint.*;
    import com.qiyi.player.wonder.plugins.hint.model.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;

    public class CheckTryWatchRefreshCommand extends SimpleCommand
    {

        public function CheckTryWatchRefreshCommand()
        {
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            super.execute(param1);
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_3:* = facade.retrieveProxy(HintProxy.NAME) as HintProxy;
            if ((_loc_2.curActor.hasStatus(BodyDef.PLAYER_STATUS_FAILED) || _loc_2.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_START_LOAD) || _loc_2.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY) || _loc_3.hasStatus(HintDef.STATUS_OPEN)) && !_loc_2.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPED) && !_loc_2.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPPING))
            {
                if (_loc_2.curActor.loadMovieParams.movieIsMember)
                {
                    sendNotification(BodyDef.NOTIFIC_PLAYER_REFRESH);
                    sendNotification(HintDef.NOTIFIC_HINT_OPEN_CLOSE, false);
                }
            }
            if (_loc_2.preActor.hasStatus(BodyDef.PLAYER_STATUS_FAILED) || _loc_2.preActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_START_LOAD))
            {
                if (_loc_2.preActor.loadMovieParams.movieIsMember)
                {
                    sendNotification(BodyDef.NOTIFIC_PLAYER_PRE_REFRESH);
                }
            }
            return;
        }// end function

    }
}
