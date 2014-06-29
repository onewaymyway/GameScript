package killClass.data
{
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.smartfoxserver.v2.requests.LoginRequest;

	public class BasicInfos
	{
		public function BasicInfos()
		{
		}
		
		public static var userValue:String="v7SeKMMm2MN8fzm/UIN5OFdY3bmQr9uA";
		public static var userIP:String="x7DhqWJinpaAOXq1NtJJRA==";
		public static var line:int=1;
		public static var room:int=0;
		
		//		erver:ft2.ss911.cn:8005,ft2.ss911.cn:443
		public static var severAdd:String="ft2.ss911.cn";
		public static var port:int=8005;
		
		public static function getLoginData():LoginRequest
		{
			var data:* = new SFSObject();
			data.putUtfString("UV", "v7SeKMMm2MN8fzm/UIN5OFdY3bmQr9uA");
			data.putUtfString("IP", "x7DhqWJinpaAOXq1NtJJRA==");
			data.putInt("L", 1);
			data.putInt("R",0);
			var loginO:LoginRequest= new LoginRequest("", "", "killonline", data);
			return loginO;
		}
	}
}