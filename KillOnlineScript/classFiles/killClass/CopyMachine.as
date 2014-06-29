package killClass
{
	public class CopyMachine
	{
		
		public var isCopyOn:Boolean;
		
		
		public var isOnlyMe:Boolean;
		
		public var copyList:UserList;
		
		public function CopyMachine()
		{
			isCopyOn=false;
			isOnlyMe=false;
			copyList=new UserList();
		}
		
	}
}