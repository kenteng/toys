﻿package ebing.utils
{
    import flash.events.*;
    import flash.utils.*;

    public class Timeout extends EventDispatcher
    {
        private var K102608CBE7CA41D7E4462F9F386FB0D623BE87373571K:Number;
        private var K102608E9445BD3FD3C404F8C0DACC766B3CF94373571K:Number;
        private var K102608A6518994C2F84301B9EB1247D89C0219373571K:Number;
        private var K1026082AEABDD45D7B4B92B0D8D77A1818C08A373571K:Boolean = false;
        private var K102608FC828ED2FDC0497BB87AB5C608250113373571K:Boolean = false;
        public static var TIMEOUT:String = "timeout";

        public function Timeout(param1:Number)
        {
            this.init(param1);
            return;
        }// end function

        public function init(param1:Number) : void
        {
            this.K102608CBE7CA41D7E4462F9F386FB0D623BE87373571K = param1;
            return;
        }// end function

        public function start() : void
        {
            if (!this.K102608FC828ED2FDC0497BB87AB5C608250113373571K)
            {
                this.K1026082AEABDD45D7B4B92B0D8D77A1818C08A373571K = false;
                this.K102608A6518994C2F84301B9EB1247D89C0219373571K = 0;
                this.K102608FC828ED2FDC0497BB87AB5C608250113373571K = true;
                this.K102608366E4455253845ADACBB0A69FBC1A7ED373571K();
            }
            return;
        }// end function

        public function stop() : void
        {
            this.K102608A6518994C2F84301B9EB1247D89C0219373571K = 0;
            clearInterval(this.K102608E9445BD3FD3C404F8C0DACC766B3CF94373571K);
            this.K102608FC828ED2FDC0497BB87AB5C608250113373571K = false;
            return;
        }// end function

        public function restart() : void
        {
            if (!this.K102608FC828ED2FDC0497BB87AB5C608250113373571K)
            {
                this.start();
            }
            else
            {
                this.K1026082AEABDD45D7B4B92B0D8D77A1818C08A373571K = false;
                this.K102608A6518994C2F84301B9EB1247D89C0219373571K = 0;
            }
            return;
        }// end function

        private function K102608366E4455253845ADACBB0A69FBC1A7ED373571K() : void
        {
            this.K102608E9445BD3FD3C404F8C0DACC766B3CF94373571K = setInterval(function () : void
            {
                if (++K102608A6518994C2F84301B9EB1247D89C0219373571K == K102608CBE7CA41D7E4462F9F386FB0D623BE87373571K && !K1026082AEABDD45D7B4B92B0D8D77A1818C08A373571K)
                {
                    K1026082AEABDD45D7B4B92B0D8D77A1818C08A373571K = true;
                    K102608A6518994C2F84301B9EB1247D89C0219373571K = 0;
                    dispatchEvent(new Event(TIMEOUT));
                }
                return;
            }// end function
            , 1000);
            return;
        }// end function

        public function get running() : Boolean
        {
            return this.K102608FC828ED2FDC0497BB87AB5C608250113373571K;
        }// end function

    }
}
