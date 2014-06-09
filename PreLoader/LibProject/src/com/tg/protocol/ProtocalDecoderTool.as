package com.tg.protocol
{
	public class ProtocalDecoderTool
	{
		public function ProtocalDecoderTool()
		{
		}
		/**
		 * 从服务器返回数组中读取数据 
		 * @param baseDataArray 当前解码的数组
		 * @param properties 当前使用的属性表
		 * @param decodeLib 解析文件用的字典文件
		 * @return 
		 * 
		 */
		public static function getDataObject(baseDataArray:Array,properties:Array,decodeLib:Object):Object
		{
			var i:int;
			var len:int;
			len=properties.length;
			var rst:Object={};
			for(i=0;i<len;i++)
			{
				if(baseDataArray[i] is Array)
				{
					var tArr:Array=[];
					var dataArr:Array=baseDataArray[i] as Array;
					var j:int=0;
					var tLen:int;
					tLen=dataArr.length;
					rst[properties[i]]=tArr;
					for(j=0;j<tLen;j++)
					{
						//tArr.push(dataArr[j]);
						tArr.push(getDataObject(dataArr[j],decodeLib[properties[i]],decodeLib));
					}
					
					//rst[properties[i]]=getDataObject(baseDataArray[i],decodeLib[properties[i]],decodeLib)
				}
				else
				{
					rst[properties[i]]=baseDataArray[i];
				}
				
			}
			return rst;
		}
	}
}