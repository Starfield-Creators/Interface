package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class BuffEntry extends MovieClip
   {
      
      public static const TIMER_PADDING:Number = 6;
       
      
      public var Name_mc:MovieClip;
      
      public var Timer_mc:MovieClip;
      
      public var Desc_mc:MovieClip;
      
      public function BuffEntry()
      {
         super();
         this.Name_tf.autoSize = TextFieldAutoSize.LEFT;
         this.Desc_tf.multiline = true;
         this.Desc_tf.wordWrap = true;
         this.Desc_tf.autoSize = TextFieldAutoSize.LEFT;
      }
      
      public function get Name_tf() : TextField
      {
         return this.Name_mc.Text_tf;
      }
      
      public function get Timer_tf() : TextField
      {
         return this.Timer_mc.Text_tf;
      }
      
      public function get Desc_tf() : TextField
      {
         return this.Desc_mc.Text_tf;
      }
      
      public function SetEntry(param1:Object) : *
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc2_:* = param1.sDescription.length > 0;
         if(param1.bHideName)
         {
            gotoAndStop("HideName");
         }
         else
         {
            if(_loc2_)
            {
               gotoAndStop(!!param1.bIsBuff ? "Buff" : "Debuff");
            }
            else
            {
               gotoAndStop(!!param1.bIsBuff ? "Buff_NoDesc" : "Debuff_NoDesc");
            }
            _loc3_ = !!param1.bPermanent ? "" : GlobalFunc.FormatTimeString(param1.fTimeRemaining);
            GlobalFunc.SetText(this.Timer_tf,_loc3_);
            if(_loc3_.length == 0)
            {
               GlobalFunc.SetText(this.Name_tf,param1.sName,true,true,42);
            }
            else
            {
               GlobalFunc.SetText(this.Name_tf,param1.sName,true,true,35);
               this.Timer_mc.x = this.Name_mc.x + this.Name_tf.textWidth + TIMER_PADDING;
            }
         }
         if(_loc2_)
         {
            if(param1.sDescription.charAt(0) == "%")
            {
               _loc4_ = String(param1.sDescription.replace(/[\%]/g,""));
               GlobalFunc.SetText(this.Desc_tf,_loc4_,true);
            }
            else
            {
               GlobalFunc.SetText(this.Desc_tf,param1.sDescription,true);
            }
         }
      }
   }
}
