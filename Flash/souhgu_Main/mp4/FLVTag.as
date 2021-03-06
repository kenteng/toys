﻿package mp4
{
    import flash.utils.*;

    public class FLVTag extends Object
    {
        protected var bytes:ByteArray = null;
        public static const TAG_TYPE_AUDIO:int = 8;
        public static const TAG_TYPE_VIDEO:int = 9;
        public static const TAG_TYPE_SCRIPTDATAOBJECT:int = 18;
        public static const TAG_FLAG_ENCRYPTED:int = 32;
        public static const TAG_TYPE_ENCRYPTED_AUDIO:int = 40;
        public static const TAG_TYPE_ENCRYPTED_VIDEO:int = 41;
        public static const TAG_TYPE_ENCRYPTED_SCRIPTDATAOBJECT:int = 50;
        static const TAG_HEADER_BYTE_COUNT:int = 11;
        static const PREV_TAG_BYTE_COUNT:int = 4;

        public function FLVTag(param1:int)
        {
            this.bytes = new ByteArray();
            this.bytes.length = TAG_HEADER_BYTE_COUNT;
            this.bytes[0] = param1;
            return;
        }// end function

        public function read(param1:ByteArray) : void
        {
            this.readType(param1);
            this.readRemainingHeader(param1);
            this.readData(param1);
            this.readPrevTag(param1);
            return;
        }// end function

        public function readType(param1:ByteArray) : void
        {
            if (param1.bytesAvailable < 1)
            {
                throw new Error("FLVTag.readType() input too short");
            }
            param1.readBytes(this.bytes, 0, 1);
            return;
        }// end function

        public function readRemaining(param1:ByteArray) : void
        {
            this.readRemainingHeader(param1);
            this.readData(param1);
            this.readPrevTag(param1);
            return;
        }// end function

        public function readRemainingHeader(param1:ByteArray) : void
        {
            if (param1.bytesAvailable < 10)
            {
                throw new Error("FLVTag.readHeader() input too short");
            }
            param1.readBytes(this.bytes, 1, (TAG_HEADER_BYTE_COUNT - 1));
            return;
        }// end function

        public function readData(param1:ByteArray) : void
        {
            if (this.dataSize > 0)
            {
                if (param1.bytesAvailable < this.dataSize)
                {
                    throw new Error("FLVTag().readData input shorter than dataSize");
                }
                param1.readBytes(this.bytes, TAG_HEADER_BYTE_COUNT, this.dataSize);
            }
            return;
        }// end function

        public function readPrevTag(param1:ByteArray) : void
        {
            if (param1.bytesAvailable < 4)
            {
                throw new Error("FLVTag.readPrevTag() input too short");
            }
            param1.readUnsignedInt();
            return;
        }// end function

        public function write(param1:ByteArray) : void
        {
            param1.writeBytes(this.bytes, 0, TAG_HEADER_BYTE_COUNT + this.dataSize);
            param1.writeUnsignedInt(TAG_HEADER_BYTE_COUNT + this.dataSize);
            return;
        }// end function

        public function writeHeader(param1:ByteArray) : void
        {
            param1.writeBytes(this.bytes, 0, TAG_HEADER_BYTE_COUNT);
            return;
        }// end function

        public function writePrevTagSize(param1:ByteArray) : void
        {
            param1.writeUnsignedInt(TAG_HEADER_BYTE_COUNT + this.dataSize);
            return;
        }// end function

        public function get tagType() : uint
        {
            return this.bytes[0];
        }// end function

        public function set tagType(param1:uint) : void
        {
            this.bytes[0] = param1;
            return;
        }// end function

        public function get isEncrpted() : Boolean
        {
            return this.bytes[0] & TAG_FLAG_ENCRYPTED ? (true) : (false);
        }// end function

        public function get dataSize() : uint
        {
            return this.bytes[1] << 16 | this.bytes[2] << 8 | this.bytes[3];
        }// end function

        public function set dataSize(param1:uint) : void
        {
            this.bytes[1] = param1 >> 16 & 255;
            this.bytes[2] = param1 >> 8 & 255;
            this.bytes[3] = param1 & 255;
            return;
        }// end function

        public function get timestamp() : uint
        {
            return this.bytes[7] << 24 | this.bytes[4] << 16 | this.bytes[5] << 8 | this.bytes[6];
        }// end function

        public function set timestamp(param1:uint) : void
        {
            this.bytes[7] = param1 >> 24 & 255;
            this.bytes[4] = param1 >> 16 & 255;
            this.bytes[5] = param1 >> 8 & 255;
            this.bytes[6] = param1 & 255;
            return;
        }// end function

        public function get data() : ByteArray
        {
            var _loc_1:* = new ByteArray();
            _loc_1.writeBytes(this.bytes, TAG_HEADER_BYTE_COUNT, this.dataSize);
            return _loc_1;
        }// end function

        public function set data(param1:ByteArray) : void
        {
            this.bytes.length = TAG_HEADER_BYTE_COUNT + param1.length;
            this.bytes.position = TAG_HEADER_BYTE_COUNT;
            this.bytes.writeBytes(param1, 0, param1.length);
            this.dataSize = param1.length;
            return;
        }// end function

    }
}
