package
{
   import Components.Icons.SocialSkillIcons;
   import Shared.AS3.BSContainerEntry;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.gfx.TextFieldEx;
   
   public class SocialSkillListEntry extends BSContainerEntry
   {
       
      
      public var BG_mc:MovieClip;
      
      public var TextHolder_mc:MovieClip;
      
      public var SocialSkillIcons_mc:SocialSkillIcons;
      
      public function SocialSkillListEntry()
      {
         super();
         TextFieldEx.setTextAutoSize(this.TextHolder_mc.SuccessPct_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      override protected function get baseTextField() : TextField
      {
         return this.TextHolder_mc.SpellName_tf;
      }
      
      override protected function TryGetEntryText(param1:Object) : String
      {
         return param1.sName;
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         super.SetEntryText(param1);
         if(param1.uDurationSecs > 0)
         {
            GlobalFunc.SetText(this.TextHolder_mc.SuccessPct_tf,param1.uPercentSuccess + "%, " + this.FormatTimeString(param1.uDurationSecs));
         }
         else
         {
            GlobalFunc.SetText(this.TextHolder_mc.SuccessPct_tf,param1.uPercentSuccess + "%");
         }
         this.TextHolder_mc.alpha = param1.uPercentSuccess > 0 ? 1 : 0.5;
         this.SocialSkillIcons_mc.SetData(param1);
      }
      
      private function FormatTimeString(param1:Number) : String
      {
         var _loc2_:* = 0;
         var _loc3_:Number = Math.floor(param1 / 3600);
         _loc2_ = param1 % 3600;
         var _loc4_:Number = Math.floor(_loc2_ / 60);
         _loc2_ = param1 % 60;
         var _loc5_:Number = Math.floor(_loc2_);
         var _loc6_:Boolean = false;
         var _loc7_:* = "";
         if(_loc3_ > 0)
         {
            _loc7_ = _loc3_ + "h";
            _loc6_ = true;
         }
         if(_loc4_ > 0)
         {
            if(_loc6_)
            {
               _loc7_ += " ";
            }
            else
            {
               _loc6_ = true;
            }
            _loc7_ = _loc7_ + _loc4_ + "m";
         }
         if(_loc5_ > 0)
         {
            if(_loc6_)
            {
               _loc7_ += " ";
            }
            _loc7_ = _loc7_ + _loc5_ + "s";
         }
         if(_loc7_.length == 0)
         {
            _loc7_ = "0s";
         }
         return _loc7_;
      }
   }
}
