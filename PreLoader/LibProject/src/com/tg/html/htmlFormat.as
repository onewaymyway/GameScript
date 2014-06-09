package com.tg.html
{
    public function htmlFormat(text:String, fontSize:int = 12, color:int = 0, 
							   bold:Boolean = false, underline:Boolean = false, 
							   align:String = ""):String
    {
        return HtmlText.format(text, Math.max(color, 0), Math.max(fontSize, 0), "", 
							   bold, false, underline, null, align);
    }
}
