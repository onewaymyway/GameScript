package killClass
{
	public class UserList
	{
		public var userList:Array=[];
		public function UserList()
		{
		}
		public function addID(id:int):void
		{
			var i:int;
			var len:int;
			len=userList.length;
			for(i=0;i<len;i++)
			{
				if(userList[i]==id)
				{
					return;
				}
			}
			userList.push(id);
		}
		public function removeID(id:int):void
		{
			var i:int;
			var len:int;
			len=userList.length;
			for(i=0;i<len;i++)
			{
				if(userList[i]==id)
				{
					userList.splice(i,1);
					return;
				}
			}
		}
		
		public function isInList(id:int):Boolean
		{
			var i:int;
			var len:int;
			len=userList.length;
			for(i=0;i<len;i++)
			{
				if(userList[i]==id)
				{
					return true;
				}
			}
			return false;
		}
		
	}
}