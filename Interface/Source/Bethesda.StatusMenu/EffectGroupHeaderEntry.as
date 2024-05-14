package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.getDefinitionByName;
   
   public class EffectGroupHeaderEntry extends MovieClip
   {
      
      public static const TIMER_PADDING:Number = 6;
       
      
      public var Icon_mc:MovieClip;
      
      public var Name_mc:MovieClip;
      
      public var Timer_mc:MovieClip;
      
      private const IMAGE_SCALE:Number = 1;
      
      private const MAX_CHARACTERS_SHOWN:int = 30;
      
      public function EffectGroupHeaderEntry()
      {
         super();
         this.Name_tf.autoSize = TextFieldAutoSize.LEFT;
      }
      
      public function get Name_tf() : TextField
      {
         return this.Name_mc.Text_tf;
      }
      
      public function SetEntry(param1:Object) : *
      {
         var _loc3_:Class = null;
         var _loc4_:MovieClip = null;
         GlobalFunc.SetText(this.Name_tf,param1.sName.toUpperCase(),false,false,this.MAX_CHARACTERS_SHOWN);
         if(param1.bHasBuffs)
         {
            if(param1.bHasDebuffs)
            {
               this.Timer_mc.gotoAndStop("Mixed");
            }
            else
            {
               this.Timer_mc.gotoAndStop("Buff");
            }
         }
         else
         {
            this.Timer_mc.gotoAndStop("Debuff");
         }
         GlobalFunc.SetText(this.Timer_mc.Text_mc.text_tf,!!param1.bShowTimer ? GlobalFunc.FormatTimeString(param1.fTimeRemaining,false,true) : "");
         if(param1.bShowTimer)
         {
            this.Timer_mc.x = this.Name_mc.x + this.Name_mc.width + TIMER_PADDING;
         }
         var _loc2_:Boolean = false;
         if(param1.sEffectIcon.length > 0)
         {
            try
            {
               _loc3_ = getDefinitionByName(param1.sEffectIcon + (!!param1.bIsPositiveEffect ? "_Positive" : "_Negative")) as Class;
               _loc2_ = true;
            }
            catch(e:Error)
            {
            }
            if(!_loc2_)
            {
               try
               {
                  _loc3_ = getDefinitionByName(param1.sEffectIcon) as Class;
                  _loc2_ = true;
               }
               catch(e:Error)
               {
               }
            }
         }
         if(_loc2_)
         {
            (_loc4_ = new _loc3_()).scaleX = this.IMAGE_SCALE;
            _loc4_.scaleY = this.IMAGE_SCALE;
            this.Icon_mc.removeChildren();
            this.Icon_mc.addChild(_loc4_);
         }
         else
         {
            this.Icon_mc.removeChildren();
         }
      }
   }
}
