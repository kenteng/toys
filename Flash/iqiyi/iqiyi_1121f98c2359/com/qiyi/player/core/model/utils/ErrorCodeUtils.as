﻿package com.qiyi.player.core.model.utils
{
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.base.rpc.*;
    import com.qiyi.player.core.model.remote.*;

    public class ErrorCodeUtils extends Object
    {

        public function ErrorCodeUtils()
        {
            return;
        }// end function

        private static function getRemoteObjectErrorCode(param1:int, param2:EnumItem) : int
        {
            if (param2 == null)
            {
                return 0;
            }
            switch(param2)
            {
                case RemoteObjectStatusEnum.Timeout:
                {
                    return (param1 + 1);
                }
                case RemoteObjectStatusEnum.ConnectError:
                {
                    return param1 + 2;
                }
                case RemoteObjectStatusEnum.DataError:
                {
                    return param1 == 100 ? (param1 + 7) : (param1 + 3);
                }
                case RemoteObjectStatusEnum.AuthenticationError:
                {
                    return param1 + 4;
                }
                case RemoteObjectStatusEnum.SecurityError:
                {
                    return param1 + 5;
                }
                case RemoteObjectStatusEnum.UnknownError:
                {
                    return param1 + 6;
                }
                default:
                {
                    break;
                }
            }
            return 0;
        }// end function

        public static function getErrorCodeByRemoteObject(param1:Object, param2:EnumItem) : int
        {
            if (param1 == null || param2 == null)
            {
                return 0;
            }
            if (param1 is RequestMetaRemote)
            {
                return getRemoteObjectErrorCode(200, param2);
            }
            if (param1 is FirstDispatchRemote)
            {
                return getRemoteObjectErrorCode(3100, param2);
            }
            if (param1 is SecondDispatchRemote)
            {
                return getRemoteObjectErrorCode(3200, param2);
            }
            if (param1 is MemberDispatchRemote)
            {
                return getRemoteObjectErrorCode(3200, param2);
            }
            if (param1 is MixerRemote)
            {
                return getRemoteObjectErrorCode(700, param2);
            }
            if (param1 is AuthenticationRemote)
            {
                return getRemoteObjectErrorCode(500, param2);
            }
            return 0;
        }// end function

    }
}
