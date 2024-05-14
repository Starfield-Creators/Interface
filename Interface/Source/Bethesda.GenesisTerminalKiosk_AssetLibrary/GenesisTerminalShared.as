package
{
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class GenesisTerminalShared
   {
      
      public static const MENU_ITEM_CLICK_EVENT:String = "Terminal_MenuItemClick";
      
      public static const CLOSE_VIEW_EVENT:String = "Terminal_CloseView";
      
      public static const CLOSE_TOP_VIEW_EVENT:String = "Terminal_CloseTopView";
      
      public static const CLOSE_ALL_VIEWS_EVENT:String = "Terminal_CloseAllViews";
      
      public static const DT_BODY_TEXT:uint = EnumHelper.GetEnum(0);
      
      public static const DT_SUBHEADER:uint = EnumHelper.GetEnum();
      
      public static const DT_IMAGE:uint = EnumHelper.GetEnum();
      
      public static const DT_INVALID:uint = EnumHelper.GetEnum();
       
      
      public function GenesisTerminalShared()
      {
         super();
      }
      
      public static function GetSubTags(param1:String) : Vector.<String>
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:Vector.<String> = new Vector.<String>();
         var _loc3_:int = param1.indexOf(">");
         var _loc4_:int;
         if((_loc4_ = param1.indexOf("<")) != -1)
         {
            _loc4_ = param1.indexOf("<",_loc4_ + 1);
            if(_loc3_ == -1)
            {
               throw new Error("Malformed tag -- No closing bracket! " + param1.substr(0,64));
            }
            if(_loc4_ != -1 && _loc4_ < _loc3_)
            {
               throw new Error("Malformed tag -- No closing bracket! " + param1.substr(0,64));
            }
            _loc6_ = (_loc5_ = param1.indexOf("\'")) != -1 ? param1.indexOf("\'",_loc5_ + 1) : -1;
            while(_loc5_ != -1 && _loc6_ != -1 && _loc5_ < _loc3_)
            {
               _loc2_.push(param1.slice(_loc5_ + 1,_loc6_));
               _loc6_ = (_loc5_ = param1.indexOf("\'",_loc6_ + 1)) != -1 ? param1.indexOf("\'",_loc5_ + 1) : -1;
            }
            if(_loc5_ == -1 && _loc6_ != -1 || _loc5_ != -1 && _loc6_ == -1)
            {
               throw new Error("Malformed tag -- Quote mismatch! " + param1.substr(0,64));
            }
            if(_loc2_.length == 0)
            {
               throw new Error("Malformed tag -- No subtags! " + param1.substr(0,64));
            }
            return _loc2_;
         }
         throw new Error("Malformed tag -- No open bracket! " + param1.substr(0,64));
      }
      
      public static function GetNextToken(param1:String) : Object
      {
         var _loc3_:Boolean = false;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:Boolean = false;
         var _loc2_:Object = new Object();
         if(param1 == null || param1 == "")
         {
            _loc2_.type = DT_INVALID;
         }
         else if(param1.substr(0,6) == "<image")
         {
            _loc3_ = true;
            _loc2_.type = DT_IMAGE;
            if((_loc4_ = GetSubTags(param1)).length != 2)
            {
               throw new Error("Malformed tag -- Wrong number of subtags! Expected: 2 " + param1.substr(0,64));
            }
            _loc2_.arg0 = _loc4_[0];
            _loc2_.arg1 = _loc4_[1];
            _loc5_ = param1.indexOf(">");
            _loc2_.resultStr = param1.slice(_loc5_ + 1);
         }
         else if(param1.substr(0,7) == "<header")
         {
            _loc2_.type = DT_SUBHEADER;
            if((_loc6_ = GetSubTags(param1)).length != 2)
            {
               throw new Error("Malformed tag -- Wrong number of subtags! Expected: 2 " + param1.substr(0,64));
            }
            _loc2_.arg0 = _loc6_[0];
            _loc2_.arg1 = _loc6_[1];
            _loc7_ = param1.indexOf(">");
            _loc2_.resultStr = param1.slice(_loc7_ + 1);
         }
         else
         {
            _loc2_.type = DT_BODY_TEXT;
            _loc8_ = param1.indexOf("<",1);
            while(_loc8_ != -1)
            {
               if(_loc9_ = param1.substr(_loc8_,6) == "<image" || param1.substr(_loc8_,7) == "<header")
               {
                  break;
               }
               _loc8_ = param1.indexOf("<",_loc8_ + 1);
            }
            if(_loc8_ == -1)
            {
               _loc2_.arg0 = param1.slice();
               _loc2_.resultStr = "";
            }
            else
            {
               _loc2_.arg0 = param1.slice(0,_loc8_);
               _loc2_.resultStr = param1.slice(_loc8_);
            }
         }
         return _loc2_;
      }
      
      public static function SetAndScaleTextfieldText(param1:TextField, param2:String, param3:Number) : void
      {
         GlobalFunc.SetText(param1,param2);
         var _loc4_:TextFormat;
         (_loc4_ = param1.getTextFormat()).size = param3;
         if(param1.wordWrap)
         {
            while(param1.maxScrollV > 1)
            {
               _loc4_.size = GlobalFunc.GetFontSize(_loc4_) - 1;
               param1.setTextFormat(_loc4_);
            }
         }
         else if(param1.textWidth > param1.width)
         {
            _loc4_.size = (_loc4_.size as Number) * (param1.width / param1.textWidth);
            param1.setTextFormat(_loc4_);
         }
      }
   }
}
