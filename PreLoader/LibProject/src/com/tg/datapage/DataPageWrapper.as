package com.tg.datapage
{
	import flash.text.TextField;

	public class DataPageWrapper
	{
		public function DataPageWrapper()
		{
			
		}
		
		public static function wrap(totalCount:int, countPerPage:int, 
									previousButton:*, nextButton:*, 
									pageNumberText:TextField = null, 
									previousDisable:* = null, nextDisable:* = null):DataPage
		{
			var dataPage:DataPage = new DataPage(totalCount, countPerPage, 
												 previousButton, nextButton, 
												 pageNumberText, 
												 previousDisable, nextDisable);
			
			return dataPage;
		}
	}
}