package Shared.Components.SystemPanels
{
   import Shared.AS3.BSContainerEntry;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class GameDataListEntry extends BSContainerEntry
   {
      
      public static const LOCATION_NAME_MAX_TRUNCATE_LEN:* = 42;
       
      
      public var SlotNumber_mc:MovieClip;
      
      public var Location_mc:MovieClip;
      
      public var PlayerLevel_mc:MovieClip;
      
      public var PlayTime_mc:MovieClip;
      
      public var SaveDate_mc:MovieClip;
      
      public var SaveTime_mc:MovieClip;
      
      public var Fill_mc:MovieClip;
      
      public function GameDataListEntry()
      {
         super();
         Extensions.enabled = true;
      }
      
      public static function FormatPlayTime(param1:String) : *
      {
         var _loc4_:String = null;
         var _loc2_:String = "";
         var _loc3_:Array = param1.split(".");
         if(_loc3_.length == 6)
         {
            if((_loc4_ = String(_loc3_[0])).charAt(0) != "0")
            {
               _loc2_ += _loc3_[0] + " ";
            }
            _loc2_ += _loc3_[1] + " " + _loc3_[2];
         }
         else
         {
            _loc2_ = "-d -h -m";
         }
         return _loc2_;
      }
      
      protected function get SlotNumber_tf() : TextField
      {
         return this.SlotNumber_mc.text_tf;
      }
      
      protected function get Location_tf() : TextField
      {
         return this.Location_mc.Location_tf;
      }
      
      protected function get PlayerLevel_tf() : TextField
      {
         return this.PlayerLevel_mc.text_tf;
      }
      
      protected function get PlayTime_tf() : TextField
      {
         return this.PlayTime_mc.PlayTime_tf;
      }
      
      protected function get SaveTime_tf() : TextField
      {
         return this.SaveTime_mc.text_tf;
      }
      
      protected function get SaveDate_tf() : TextField
      {
         return this.SaveDate_mc.text_tf;
      }
      
      override public function Configure(param1:String = "none", param2:Boolean = false) : *
      {
         TextFieldEx.setTextAutoSize(this.Location_tf,param1);
         TextFieldEx.setTextAutoSize(this.PlayTime_tf,param1);
         this.Location_tf.multiline = param2;
         this.PlayTime_tf.multiline = param2;
         if(param2)
         {
            this.Location_tf.autoSize = TextFieldAutoSize.LEFT;
            this.Location_tf.multiline = true;
            this.Location_tf.wordWrap = true;
            this.PlayTime_tf.autoSize = TextFieldAutoSize.RIGHT;
            this.PlayTime_tf.multiline = true;
            this.PlayTime_tf.wordWrap = true;
         }
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         GlobalFunc.SetText(this.SlotNumber_tf,String(param1.iCurrentSlotNumber));
         var _loc2_:String = "";
         if(param1.bAutosave)
         {
            _loc2_ = "$$AUTOSAVE ";
         }
         else if(param1.bExitsave)
         {
            _loc2_ = "$$EXITSAVE ";
         }
         else if(param1.bQuicksave)
         {
            _loc2_ = "$$QUICKSAVE ";
         }
         GlobalFunc.SetText(this.Location_tf,_loc2_ + param1.sLocation,false,false,LOCATION_NAME_MAX_TRUNCATE_LEN);
         if(param1.uGameEntryIndex != -1)
         {
            GlobalFunc.SetText(this.PlayerLevel_tf,"$$Level " + param1.uLevel);
            GlobalFunc.SetText(this.SaveDate_tf,param1.sFileDate);
            GlobalFunc.SetText(this.SaveTime_tf,param1.sFileTime);
         }
         else
         {
            GlobalFunc.SetText(this.PlayerLevel_tf,"");
            GlobalFunc.SetText(this.SaveDate_tf,"");
            GlobalFunc.SetText(this.SaveTime_tf,"");
         }
         if(param1.sPlayTime)
         {
            GlobalFunc.SetText(this.PlayTime_tf,FormatPlayTime(param1.sPlayTime));
         }
         else
         {
            GlobalFunc.SetText(this.PlayTime_tf,"");
         }
      }
   }
}
