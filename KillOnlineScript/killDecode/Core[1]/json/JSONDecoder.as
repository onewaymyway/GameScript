package json
{

    public class JSONDecoder extends Object
    {
        private var value:Object;
        private var tokenizer:JSONTokenizer;
        private var token:JSONToken;

        public function JSONDecoder(param1:String)
        {
            tokenizer = new JSONTokenizer(param1);
            nextToken();
            value = parseValue();
            return;
        }// end function

        private function parseObject() : Object
        {
            var _loc_2:String = null;
            var _loc_1:* = new Object();
            nextToken();
            if (token.type == JSONTokenType.RIGHT_BRACE)
            {
                return _loc_1;
            }
            while (true)
            {
                
                if (token.type == JSONTokenType.STRING)
                {
                    _loc_2 = String(token.value);
                    nextToken();
                    if (token.type == JSONTokenType.COLON)
                    {
                        nextToken();
                        _loc_1[_loc_2] = parseValue();
                        nextToken();
                        if (token.type == JSONTokenType.RIGHT_BRACE)
                        {
                            return _loc_1;
                        }
                        if (token.type == JSONTokenType.COMMA)
                        {
                            nextToken();
                        }
                        else
                        {
                            tokenizer.parseError("Expecting } or , but found " + token.value);
                        }
                    }
                    else
                    {
                        tokenizer.parseError("Expecting : but found " + token.value);
                    }
                    continue;
                }
                tokenizer.parseError("Expecting string but found " + token.value);
            }
            return null;
        }// end function

        private function parseValue() : Object
        {
            switch(token.type)
            {
                case JSONTokenType.LEFT_BRACE:
                {
                    return parseObject();
                }
                case JSONTokenType.LEFT_BRACKET:
                {
                    return parseArray();
                }
                case JSONTokenType.STRING:
                case JSONTokenType.NUMBER:
                case JSONTokenType.TRUE:
                case JSONTokenType.FALSE:
                case JSONTokenType.NULL:
                {
                    return token.value;
                }
                default:
                {
                    tokenizer.parseError("Unexpected " + token.value);
                    break;
                }
            }
            return null;
        }// end function

        private function nextToken() : JSONToken
        {
            var _loc_1:* = tokenizer.getNextToken();
            token = tokenizer.getNextToken();
            return _loc_1;
        }// end function

        public function getValue()
        {
            return value;
        }// end function

        private function parseArray() : Array
        {
            var _loc_1:* = new Array();
            nextToken();
            if (token.type == JSONTokenType.RIGHT_BRACKET)
            {
                return _loc_1;
            }
            while (true)
            {
                
                _loc_1.push(parseValue());
                nextToken();
                if (token.type == JSONTokenType.RIGHT_BRACKET)
                {
                    return _loc_1;
                }
                if (token.type == JSONTokenType.COMMA)
                {
                    nextToken();
                    continue;
                }
                tokenizer.parseError("Expecting ] or , but found " + token.value);
            }
            return null;
        }// end function

    }
}
