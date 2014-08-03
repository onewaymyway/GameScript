package killClass
{
	public class MoneySystem
	{
		public function MoneySystem()
		{
			moneyDic={};
		}
		private static var instance:MoneySystem;
		public static function get me():MoneySystem
		{
			if(!instance)
			{
				instance=new MoneySystem();
			}
			return instance;
		}
		
		public var moneyDic:Object;
		
		public function addMoney(uid:int,money:int):int
		{
			if(!moneyDic[uid])
			{
				moneyDic[uid]=0;
			}
			moneyDic[uid]+=money;
			return moneyDic[uid];
		}
		public function spendMoney(uid:int,money:int):int
		{
			if(getMoney(uid)<money) return -1;
			moneyDic[uid]=moneyDic[uid]-money;
			return moneyDic[uid];
		}
		public function getMoney(uid:int):int
		{
			return moneyDic[uid];
		}
	}
}