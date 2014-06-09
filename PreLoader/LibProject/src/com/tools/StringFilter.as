package com.tools
{ 	
	/** 敏感字符 空格检测器
	 * @author Hdz
	 * 创建时间：2013-11-22 上午10:03:12
	 * 
	 */
	public class StringFilter
	{
		private static var strData:Array = [];
		
		public function StringFilter()
		{
			throw new Error("请直接调用 无需实例化.");
		}
		
		
		/**
		 * 根据传入的字符串，返回过滤后的字符串  适合与聊天
		 * @param str 需要过滤的字符
		 * @return 过滤后的字符
		 * 
		 */		
		public static function getFilterStr(str:String):String
		{
			
			if(strData.length==0)strData = STR_FILTER.split(",");
			
			var bool:Boolean = false;
			var index:int;
			var str2:String = trimStr(str);//去空格后的字符串
			for(var i:int=0;i<strData.length;i++)
			{
				index = str2.search(strData[i]);
				if(index != -1)
				{
					var len:int = strData[i].length;
					str2 = str2.replace(strData[i], getOneStr(len));
					bool = true;
				}
				
			}
			
			
			if(bool) return str2;
			else return str;
			
		}
		
		/**  修剪字符串中的空格
		 * 
		 * @param _str1 要修剪的字符串
		 * @return  
		 * 
		 */		
		public static function trimStr(_str1:String):String
		{ 
			
			var newStr:String = _str1;
			while(newStr.indexOf(" ") != -1){		//半角
				newStr = newStr.replace(" ", "");
			}
			
			while(newStr.indexOf("　") != -1){		//全角
				newStr = newStr.replace("　", "");
			}
			
			return newStr;
		}
		
		public static function isUsableA(str:String):Boolean
		{
			if(str.indexOf(" ")  != -1)
			{
				return false;
			}
			if(str.indexOf("　") != -1)
			{
				return false;
			}
			str = getFilterStr(str);
			if(str.indexOf("*") != -1)
			{
				return false;
			}
			return true;
		}
		
		/**
		 * 获取替换字符的个数 
		 * @param index
		 * @return 
		 * 
		 */		
		private static function getOneStr(len:int):String
		{
			var s:String="";
			for(var i:int=0;i<len;i++)
			{
				s+="*";
			}
			return s;
		}
		
		
		private static const STR_FILTER:String = "YY,yy,Y Y,y y,yY,y Y,Yy,Y y,歪歪,歪 歪,ｙｙ,ＹＹ,ｙ　Ｙ,Ｙ　ｙ,ｙ　ｙ,Ｙ　Ｙ,歪　歪,歪,管理员," +
			"耀月,耀月传说,外挂,游戏管理员,游戏管理者,新手指导员,新手辅导员,游戏向导,游戏监督员,游戏送奖员,客户服务,说唐,官方,中奖,工作人员" +
			"客服测试员,客服,客服人员,挂机,私服,代练,系统公告,WG,wg,kf,KF,waigua,WAIGUA,Admin,admin,GM,gm,Gamemaster,GAMEMASTER,rushGM," +
			"rushgm,Rushgm,GM-rush,GM-Rush,活动,装备展示,装备演示,比赛,裁判,检查,中华人民共和国,中華人民共和國,16大,17大,18大,十六大,十七大,十八大,仙侠奇缘," +
			"天安门,中南海,领导,共产党,中国共产党,国民党万岁,中共,共军,中华民国,中華民國,中共中央,共產黨,党中央,总书记,国家主席,总理,政治局," +
			"常委,共党,习近平,xijinping,毛泽东,毛澤東,maozedong,邓小平,邓晓平,鄧小平,dengxiaoping,胡锦涛,hujingtao,温家宝,wenjiabao,周恩来,zhouenlai," +
			"李鹏,lipeng,韩正,黄菊,江泽民,江澤民,jiangzeming,朱镕基,朱鎔基,zhurongji,李肇星,谢丽娟,陈至立,吴邦国,贾庆林,邹家华,王乐泉,王兆国," +
			"曾庆红,吴官正,李长春,陈良宇,李岚清,李嵐清,lilanqing,罗干,胡锦濤,溫家寶,周恩來,李鵬,韓正,黃菊,吴仪,謝麗娟,陳至立,吳邦國,賈慶林,曾慶紅," +
			"吳官正,李長春,陳良宇,羅幹,李瑞环,尉健行,乔石,马克思,恩格斯,列宁,赵紫阳,胡耀邦,刘少奇,回良玉,刘淇,刘云山,张立昌,张德江,永康,俞正声," +
			"贺国强,郭伯雄,曹刚川,曾培炎,MAOZEDONG,DENGXIAOPING,HUJINTAO,hujintao,WENJIABAO,ZHOUENLAI,xijinping,XIJINPING,FBI,fbi,國民黨," +
			"台独,臺獨,台湾国,陈水扁,陈总统,没有人权,政府无能,台湾独立,台湾总统,两国论,一边一国,独裁,统治,台湾共和国,新党,民进党,台联,亲民党,宋楚瑜," +
			"李登辉,连战,蒋中正,蒋介石,蒋经国,吕秀莲,孙中山,孙逸仙,孙文,江贼民,阿拉,基督,佛祖,妈祖,萨达姆,拉登,恐怖主义,爆炸,集会,游行,示威,西藏分裂," +
			"新疆独立,东突,自焚,垮台,倒台,镇压,迫害,纳粹,日本帝国,大东亚,共荣圈,赤匪,共匪,政变,保卫台湾,皇军,造反,民运,打倒,推翻,藏独,穆罕默德,圣母," +
			"观世音,耶和华,耶稣,���教,道教,基督教,回教,密宗,伊斯兰,高丽棒子,南蛮子,穆斯林,回回,一贯道,法轮功,李洪志,摩门教,吾尔开西,89动乱," +
			"89暴乱,1989六四,64动乱,六四运动,89运动,1989年6月4日,一九八九六四,六四平暴,六四之前,六四以前,六四之后,六四以后,一九八九年六月四日," +
			"血洗天安门,血洒天安门,天安门屠城,六四屠城,六四周年祭,六四平反,平反六四,蒋彦永,蒋彦勇,蒋彦永上书,蒋彦勇上书,天安门母亲,天安们母亲运动," +
			"讨伐中宣部,炮打中宣部,丁加班,何加栋,刘晓竹,鲍彤,刘晓波,丁子霖,中宣部是中国的艾滋病,好死不如赖活着,六四回忆录,六四参加者,六四参加者回忆录," +
			"八九年那个春夏之交,学生爱国者运动,学生爱国者运动证明,六四死难者,六四真相,89学潮,八九学潮,公审江泽民,公审李鹏,全球公审江泽民,六四正名," +
			"六四事件,天安门残案,天安门惨案,89风波,八九风波,生者与死者,晚年周恩来,一党专制,警匪一家,三个代婊,江[泽]民,大纪元,江核心,江独裁,天安门档案," +
			"多维新闻,大FA弟子,梅花网,真善忍,大法,法$轮,法$$轮,法^轮,法^^轮,法@轮,法@@轮,法~轮,法~~轮,法輪,法轮大法,法(轮)功,法×,FLG,F.L.G," +
			"大法弟子,4.25,劳+教+所,美金,美元,葫芦案,巡府媳,苏秀文,黑省副省长,信不信我撞死你,省长的儿媳妇,省长儿媳妇,宝马,可怜卖菜妇,黑AL6666," +
			"告全体网民书,宝-马撞人案,真理组织,禽流感,新唐人电视台,全球华人春节联欢晚会,宝马车撞人案,孙大午,朱胜文,广西禽流感,流行禽流感,韩桂芝," +
			"刘杰,黑龙江农垦总局逊克农场,张震,民主党派,云龙湖,红顶商人,朱林,梓霖,学生爱国运动正名,娄义,先审后贴,预审查,新闻管制,舆论钳制,2.23会议," +
			"邪教,昝爱宗,六月four日,怀念十五年前的大学生,89年的斗争,15年前的“共和国卫士”,15年纪念日,天安门情人,六四点击,瓦良格,如何推翻中共," +
			"306医院,解放军306医院,邹德威,网址,免费影院,徐建国案件,江苏省党政一把手,铁路的招标,铁路招标,非典,爱滋,sex,Liusishijian,FUCK,Fuck," +
			"fuck,SHIT,Shit,shit,BITCH,bitch,FuckYou,fuckyou,FUCKYOU,TMB,NND,TNND,BC,傻B,傻b,SB,sb,傻×,傻瓜,我日,我奸,靠,我靠,操,我操," +
			"批,我拷,狗日的,扒光,白痴,白癡,白烂,包皮,笨蛋,色情,情色,嫖娼,卖淫,淫秽,屄,逼,我擦,逼样,婊子,婊子养的,操机掰,操妳,操妳妈,操妳娘,操妳全家," +
			"操妳祖宗,操你全家,操你祖宗,懆您妈,懆您娘,肏,插你,插死你,吃屎,吹箫,打炮,荡妇,屌,爹娘,放荡,肥西,干x娘,干机掰,干妳老母,干妳妈,干妳马," +
			"干妳娘,干你老母,干你良,干你娘,干您娘,干七八,干死CS,干死GM,干死客服,干死你,赣您娘,灨你娘,狗狼养的,狗娘养的,狗屁,龟儿子,龟头,鬼公," +
			"花柳,机八,机巴,机机歪歪,鸡8,鸡八,鸡叭,鸡吧,鸡芭,鸡鸡,鸡奸,雞巴,几八,几巴,几叭,几芭,妓,妓女,妓院,奸你,姦,贱B,贱货,贱人,賤,交配,姣西," +
			"叫床,她马��,军妓,靠爸,靠北,靠背,靠母,靠腰,口肯,懒8,懒八,懒叫,懒教,烂逼,烂货,爛,浪叫,老二,老味,轮奸,妈B,妈逼,妈比,妈的,妈的B,妈个B," +
			"妈妈的,媽,卖B,卖比,淫荡,淫妇,淫西,奶子,妳她妈的,妳老母的,妳妈的,妳马的,妳娘的,你她马的,你妈,你妈的,你马的,你娘卡好,你娘咧,你是鸡," +
			"你是鸭,你他马的,你它妈的,你它马的,屁股,月经,杂种,做爱,嫖客,姘头,仆,仆街,强奸你,日你,日他娘,乳头,撒尿,塞你爸,塞你公,塞你老母,塞你老师," +
			"塞你母,塞你娘,赛妳阿母,赛你老母,三级片,骚,骚逼,驶你爸,驶你公,驶你老母,驶你老师,驶你母,驶你娘,傻比,射精,射你,他妈,他妈ㄉ王八蛋," +
			"他奶娘的,他奶奶的,外阴,下贱,下三烂,性爱,性交,性无能,阳具,阳萎,勃起,野鸡,阴唇,阴毛,招妓,小鸡鸡,小鸡巴,大鸡巴,卵,精子,卵子,大卵子," +
			"大卵泡,小卵子,小卵泡,阴茎,阴道,阴部,屁眼,妈个比,妈个老比,淫棍,乳房,瘪三,刚瘪三,小瘪三,老���三,十三点,刚度,册那,小乳头,阴户,潮湿内裤," +
			"湿透的内裤,肉缝,肉棒,淫水,肉壁,肉棍子,跳蛋,震动棒,充气娃娃,口交,肛交,中出,嘿咻,颜射,吞精,深喉,肉穴,小肉粒,阴核,巨乳,日你妈,日你老母," +
			"日你老娘,日批,干你妈,你奶奶的,贼你妈,操你妈,操你娘,操你奶奶,操你老母,操你老妈,娘个比,他妈的,他妈地,她妈地,它妈地,我操你祖宗十八代," +
			"奶奶的熊,你个傻比,个老子的,骚货,骚比,小骚货,小骚比,老骚货,老骚比,瓜娃子,瓜婆娘,瓜批,操比,操逼,后庭,双峰微颤,贝肉,玉杵,密洞,抽插," +
			"乳波臀浪,乳交,打飞机,捣管子,撸管子,傻逼,2B,山炮,想上你,黑社会,黑帮老大,黑帮大嫂,地痞流氓,江湖混混,新义安,联英社,斧头帮,山口组,三合会," +
			"畜之道,黑手党,青龙帮,竹联帮,恐怖组织,泰米尔猛虎组织,东突厥斯坦恐怖组织,胡景涛,胡景濤,鬼畜之道,弱智,猪猡,狗卵,狗比,错比,屎摊,狗屎,贱比," +
			"神经病,鸟人,KAO,孬比,孬B,孬逼,你妈比,淫贱,性饥渴,性欲,强暴,戳B,戳比,日B,日逼,骚卵,kao,王刚,王岐山,刘延东,李克强,李源潮,汪洋,张高丽," +
			"周永康,贺国强　贾庆林,徐才厚,薄熙来王兆国,乌云其木格,韩启德,华建敏,周铁农,李建国,司马义·铁力瓦尔地,蒋树声,陈昌智,严隽琪,桑国卫,廖晖," +
			"杜青林,阿沛·阿旺晋美,帕巴拉·格列朗杰,马万祺,白立忱,陈奎元,阿不来提·阿不都热西提,李兆焯,黄孟复,董建华,张梅颖,张榕明,钱运录,孙家正," +
			"李金华,郑万通,邓朴方,万钢,林文漪,厉无畏,罗富和,陈宗兴,王志珍,汪歧山,梁光烈,马凯,孟建柱,戴秉国,杨洁篪,张平,周济,李毅中,杨晶,耿惠昌,马馼," +
			"李学举,吴爱英,谢旭人,尹蔚民,徐绍史,姜伟新,刘志军,李盛霖,陈雷,孙政才,周生贤,陈德铭,蔡武,陈竺,李斌,周小川,刘家义,王胜俊,曹建明,西藏国,"+
			"神仙道,龙将,梦幻飞仙,凡人修真,盛世三国,傲视遮天,傲剑,神曲,诛神,大唐真龙贰,斗破苍穹Ⅱ,龙城,火影世界,英雄王座,天地英雄,神魔遮天,天之刃," +
			"英雄远征,范特西篮球经理,江湖令,一骑当先,卧龙吟,弹弹堂,明朝江湖,热血三国,明朝传奇,征战四方,凡人修真,九天仙梦,功夫,傲视千雄,傲视天地," +
			"飘渺雪域,魔神战纪,三界乾坤,洪荒神话,诸子百家,降龙十八掌,远古封神,新西游征途,战千雄,航海之王,剑侠奇缘,三十六计,王国印记,南帝北丐,热血三国," +
			"热血武林,飘渺西游,名将志,王朝霸域,传奇国度,遮天,战神传奇,侠客世界,仙逆,武林之王,苍穹破,大汉无双,斗罗大陆,斗法封妖,大商战,玛雅预言,霸刀,蹦蹦堂," +
			"除魔,极品修真,六界传说,龙剑,乱世天下,冒险王,幻龙骑士,幻世轩辕,幻灵王,怪兽总动员,火影死神传,海贼大冒险,小小海贼王,侠义无双,新世纪,书剑江湖,神戒," +
			"天地诸神,天命之光,吞食天地,天下盛境,山海创世录,神魔斗,逆天诀,泡泡星球,梦回三国,梦幻修仙,http,www,.cn,.com,.net,http://";
	
	}
}