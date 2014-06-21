package json
{

    public class JSONTokenizer extends Object
    {
        private var loc:int;
        private var ch:String;
        private var obj:Object;
        private var jsonString:String;

        public function JSONTokenizer(param1:String)
        {
            jsonString = param1;
            loc = 0;
            nextChar();
            return;
        }// end function

        private function skipComments() : void
        {
            if (ch == "/")
            {
                nextChar();
                switch(ch)
                {
                    case "/":
                    {
                        do
                        {
                            
                            nextChar();
                        }while (ch != "\n" && ch != "")
                        nextChar();
                        break;
                    }
                    case "*":
                    {
                        nextChar();
                        while (true)
                        {
                            
                            if (ch == "*")
                            {
                                nextChar();
                                if (ch == "/")
                                {
                                    nextChar();
                                    break;
                                }
                            }
                            else
                            {
                                nextChar();
                            }
                            if (ch == "")
                            {
                                parseError("Multi-line comment not closed");
                            }
                        }
                        break;
                    }
                    default:
                    {
                        parseError("Unexpected " + ch + " encountered (expecting \'/\' or \'*\' )");
                        break;
                    }
                }
            }
            return;
        }// end function

        private function isDigit(param1:String) : Boolean
        {
            return param1 >= "0" && param1 <= "9";
        }// end function

        private function readString() : JSONToken
        {
            var _loc_3:String = null;
            var _loc_4:int = 0;
            var _loc_1:* = new JSONToken();
            _loc_1.type = JSONTokenType.STRING;
            var _loc_2:String = "";
            nextChar();
            while (ch != "\"" && ch != "")
            {
                
                if (ch == "\\")
                {
                    nextChar();
                    switch(ch)
                    {
                        case "\"":
                        {
                            _loc_2 = _loc_2 + "\"";
                            break;
                        }
                        case "/":
                        {
                            _loc_2 = _loc_2 + "/";
                            break;
                        }
                        case "\\":
                        {
                            _loc_2 = _loc_2 + "\\";
                            break;
                        }
                        case "b":
                        {
                            _loc_2 = _loc_2 + "\b";
                            break;
                        }
                        case "f":
                        {
                            _loc_2 = _loc_2 + "\f";
                            break;
                        }
                        case "n":
                        {
                            _loc_2 = _loc_2 + "\n";
                            break;
                        }
                        case "r":
                        {
                            _loc_2 = _loc_2 + "\r";
                            break;
                        }
                        case "t":
                        {
                            _loc_2 = _loc_2 + "\t";
                            break;
                        }
                        case "u":
                        {
                            _loc_3 = "";
                            _loc_4 = 0;
                            while (_loc_4 < 4)
                            {
                                
                                if (!isHexDigit(nextChar()))
                                {
                                    parseError(" Excepted a hex digit, but found: " + ch);
                                }
                                _loc_3 = _loc_3 + ch;
                                _loc_4++;
                            }
                            _loc_2 = _loc_2 + String.fromCharCode(parseInt(_loc_3, 16));
                            break;
                        }
                        default:
                        {
                            _loc_2 = _loc_2 + ("\\" + ch);
                            break;
                        }
                    }
                }
                else
                {
                    _loc_2 = _loc_2 + ch;
                }
                nextChar();
            }
            if (ch == "")
            {
                parseError("Unterminated string literal");
            }
            nextChar();
            _loc_1.value = _loc_2;
            return _loc_1;
        }// end function

        private function nextChar() : String
        {
            var _loc_1:* = jsonString.charAt(loc++);
            ch = jsonString.charAt(loc++);
            return _loc_1;
        }// end function

        public function getNextToken() : JSONToken
        {
            var _loc_2:String = null;
            var _loc_3:String = null;
            var _loc_4:String = null;
            var _loc_1:* = new JSONToken();
            skipIgnored();
            switch(ch)
            {
                case "{":
                {
                    _loc_1.type = JSONTokenType.LEFT_BRACE;
                    _loc_1.value = "{";
                    nextChar();
                    break;
                }
                case "}":
                {
                    _loc_1.type = JSONTokenType.RIGHT_BRACE;
                    _loc_1.value = "}";
                    nextChar();
                    break;
                }
                case "[":
                {
                    _loc_1.type = JSONTokenType.LEFT_BRACKET;
                    _loc_1.value = "[";
                    nextChar();
                    break;
                }
                case "]":
                {
                    _loc_1.type = JSONTokenType.RIGHT_BRACKET;
                    _loc_1.value = "]";
                    nextChar();
                    break;
                }
                case ",":
                {
                    _loc_1.type = JSONTokenType.COMMA;
                    _loc_1.value = ",";
                    nextChar();
                    break;
                }
                case ":":
                {
                    _loc_1.type = JSONTokenType.COLON;
                    _loc_1.value = ":";
                    nextChar();
                    break;
                }
                case "t":
                {
                    _loc_2 = "t" + nextChar() + nextChar() + nextChar();
                    if (_loc_2 == "true")
                    {
                        _loc_1.type = JSONTokenType.TRUE;
                        _loc_1.value = true;
                        nextChar();
                    }
                    else
                    {
                        parseError("Expecting \'true\' but found " + _loc_2);
                    }
                    break;
                }
                case "f":
                {
                    _loc_3 = "f" + nextChar() + nextChar() + nextChar() + nextChar();
                    if (_loc_3 == "false")
                    {
                        _loc_1.type = JSONTokenType.FALSE;
                        _loc_1.value = false;
                        nextChar();
                    }
                    else
                    {
                        parseError("Expecting \'false\' but found " + _loc_3);
                    }
                    break;
                }
                case "n":
                {
                    _loc_4 = "n" + nextChar() + nextChar() + nextChar();
                    if (_loc_4 == "null")
                    {
                        _loc_1.type = JSONTokenType.NULL;
                        _loc_1.value = null;
                        nextChar();
                    }
                    else
                    {
                        parseError("Expecting \'null\' but found " + _loc_4);
                    }
                    break;
                }
                case "\"":
                {
                    _loc_1 = readString();
                    break;
                }
                default:
                {
                    if (isDigit(ch) || ch == "-")
                    {
                        _loc_1 = readNumber();
                    }
                    else
                    {
                        if (ch == "")
                        {
                            return null;
                        }
                        parseError("Unexpected " + ch + " encountered");
                    }
                    break;
                }
            }
            return _loc_1;
        }// end function

        private function skipWhite() : void
        {
            while (isWhiteSpace(ch))
            {
                
                nextChar();
            }
            return;
        }// end function

        public function parseError(param1:String) : void
        {
            throw new JSONParseError(param1, loc, jsonString);
        }// end function

        private function isWhiteSpace(param1:String) : Boolean
        {
            return param1 == " " || param1 == "\t" || param1 == "\n";
        }// end function

        private function skipIgnored() : void
        {
            skipWhite();
            skipComments();
            skipWhite();
            return;
        }// end function

        private function isHexDigit(param1:String) : Boolean
        {
            var _loc_2:* = param1.toUpperCase();
            return isDigit(param1) || _loc_2 >= "A" && _loc_2 <= "F";
        }// end function

        private function readNumber() : JSONToken
        {
            var _loc_1:* = new JSONToken();
            _loc_1.type = JSONTokenType.NUMBER;
            var _loc_2:String = "";
            if (ch == "-")
            {
                _loc_2 = _loc_2 + "-";
                nextChar();
            }
            if (!isDigit(ch))
            {
                parseError("Expecting a digit");
            }
            if (ch == "0")
            {
                _loc_2 = _loc_2 + ch;
                nextChar();
                if (isDigit(ch))
                {
                    parseError("A digit cannot immediately follow 0");
                }
            }
            else
            {
                while (isDigit(ch))
                {
                    
                    _loc_2 = _loc_2 + ch;
                    nextChar();
                }
            }
            if (ch == ".")
            {
                _loc_2 = _loc_2 + ".";
                nextChar();
                if (!isDigit(ch))
                {
                    parseError("Expecting a digit");
                }
                while (isDigit(ch))
                {
                    
                    _loc_2 = _loc_2 + ch;
                    nextChar();
                }
            }
            if (ch == "e" || ch == "E")
            {
                _loc_2 = _loc_2 + "e";
                nextChar();
                if (ch == "+" || ch == "-")
                {
                    _loc_2 = _loc_2 + ch;
                    nextChar();
                }
                if (!isDigit(ch))
                {
                    parseError("Scientific notation number needs exponent value");
                }
                while (isDigit(ch))
                {
                    
                    _loc_2 = _loc_2 + ch;
                    nextChar();
                }
            }
            var _loc_3:* = Number(_loc_2);
            if (isFinite(_loc_3) && !isNaN(_loc_3))
            {
                _loc_1.value = _loc_3;
                return _loc_1;
            }
            parseError("Number " + _loc_3 + " is not valid!");
            return null;
        }// end function

    }
}
