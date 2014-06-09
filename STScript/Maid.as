//女仆采摘培养脚本
import com.tg.st.mod.MaidNew.model.MaidNewCall;
import com.tg.st.data.protocal.MaidNewStruct;
import com.tg.st.service.Data;

var i:int;
var len:int;
len=20;
Data.call(MaidNewStruct.maidDoWork,[], culture);
//culture();
function culture():void
{
	len--;
	if(len>0)
	{
		MaidNewCall.culture(culture);
	}
}