﻿package CPlayer.CNetStream.Cipher.vfs
{
    import flash.utils.*;

    public class FileHandle extends Object
    {
        private var _backingStore:IBackingStore = null;
        private var _backingStoreRelativePath:String = null;
        private var _bytes:ByteArray = null;
        private var _callback:ISpecialFile = null;
        public var readable:Boolean;
        public var writeable:Boolean;
        public var appending:Boolean;
        private var _isDirectory:Boolean = false;
        private var _path:String = null;
        public var position:uint;

        public function FileHandle(param1:IBackingStore = null, param2:String = null, param3:ByteArray = null, param4:ISpecialFile = null, param5:Boolean = true, param6:Boolean = false, param7:Boolean = false, param8:Boolean = false, param9:String = null, param10:uint = 0)
        {
            _backingStore = param1;
            _backingStoreRelativePath = param2;
            _bytes = param3;
            _callback = param4;
            readable = param5;
            writeable = param6;
            appending = param7;
            _isDirectory = param8;
            _path = param9;
            position = param10;
            return;
        }// end function

        public function get backingStore() : IBackingStore
        {
            return _backingStore;
        }// end function

        public function get backingStoreRelativePath() : String
        {
            return _backingStoreRelativePath;
        }// end function

        public function get bytes() : ByteArray
        {
            return _bytes;
        }// end function

        public function get callback() : ISpecialFile
        {
            return _callback;
        }// end function

        public function get isDirectory() : Boolean
        {
            return _isDirectory;
        }// end function

        public function get path() : String
        {
            return _path;
        }// end function

        public static function makeSpecialFile(param1:ISpecialFile) : FileHandle
        {
            var _loc_2:* = new FileHandle;
            _loc_2.writeable = true;
            _loc_2.readable = true;
            _loc_2._callback = param1;
            return _loc_2;
        }// end function

        public static function makeRegularFile(param1:String, param2:String, param3:IBackingStore, param4:ByteArray, param5:Boolean) : FileHandle
        {
            var _loc_6:* = new FileHandle;
            new FileHandle._path = param1;
            _loc_6._backingStore = param3;
            _loc_6._backingStoreRelativePath = param2;
            _loc_6._bytes = param4;
            _loc_6._isDirectory = param5;
            _loc_6.writeable = !param3.readOnly;
            _loc_6.readable = true;
            _loc_6.position = 0;
            return _loc_6;
        }// end function

    }
}
