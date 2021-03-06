﻿package com.qiyi.player.core.model.remote
{
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.base.rpc.*;
    import com.qiyi.player.base.rpc.impl.*;
    import com.qiyi.player.core.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class RequestLicenseRemote extends BaseRemoteObject
    {
        private var _drmUrl:String;
        private var _log:ILogger;

        public function RequestLicenseRemote(param1:String)
        {
            this._log = Log.getLogger("com.qiyi.player.core.model.remote.RequestLicenseRemote");
            super(0, "RequestLicenseRemote");
            this._drmUrl = param1;
            _timeout = Config.LICENSE_TIMEOUT;
            return;
        }// end function

        override protected function getRequest() : URLRequest
        {
            if (this._drmUrl == "")
            {
                this._log.warn("drmUrl is empty!");
            }
            return new URLRequest(this._drmUrl);
        }// end function

        override protected function onComplete(event:Event) : void
        {
            var s:String;
            var event:* = event;
            clearTimeout(_waitingResponse);
            _waitingResponse = 0;
            try
            {
                if (_loader.data && _loader.data != "")
                {
                    _data = new XML(_loader.data);
                    super.onComplete(event);
                }
                else
                {
                    throw new Error("");
                }
            }
            catch (e:Error)
            {
                _log.warn("RequestLicenseRemote: failed to parse data");
                s = _loader.data;
                if (s)
                {
                    _log.info(s.substr(0, 100));
                }
                setStatus(RemoteObjectStatusEnum.DataError);
            }
            return;
        }// end function

    }
}
