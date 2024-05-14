package
{
   import Shared.EnumHelper;
   import Shared.FactionUtils;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class FactionStandingEntry extends MovieClip
   {
      
      public static const ACTIVITY_QUEST_TYPE:* = EnumHelper.GetEnum(0);
      
      public static const MAIN_QUEST_TYPE:* = EnumHelper.GetEnum();
      
      public static const FACTION_QUEST_TYPE:* = EnumHelper.GetEnum();
      
      public static const MISC_QUEST_TYPE:* = EnumHelper.GetEnum();
      
      public static const MISSION_QUEST_TYPE:* = EnumHelper.GetEnum();
      
      public static const COMPLETED_QUEST_TYPE:* = EnumHelper.GetEnum();
      
      public static const REPUTATION_NEUTRAL:* = EnumHelper.GetEnum(0);
      
      public static const REPUTATION_HOSTILE:* = EnumHelper.GetEnum();
      
      public static const REPUTATION_ALLY:* = EnumHelper.GetEnum();
      
      public static const REPUTATION_FRIEND:* = EnumHelper.GetEnum();
       
      
      public var Name_mc:MovieClip;
      
      public var Standing_mc:MovieClip;
      
      public var MiscText_mc:MovieClip;
      
      public var FactionIcon_mc:MovieClip;
      
      private const NEUTRAL_LABEL:String = "Neutral";
      
      private const ALLY_LABEL:String = "Ally";
      
      private const HOSTILE_LABEL:String = "Hostile";
      
      public function FactionStandingEntry()
      {
         super();
         stop();
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.Name_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.Standing_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.MiscText_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      public function get Name_tf() : TextField
      {
         return this.Name_mc.Text_tf;
      }
      
      public function get Standing_tf() : TextField
      {
         return this.Standing_mc.Text_tf;
      }
      
      public function get MiscText_tf() : TextField
      {
         return this.MiscText_mc.Text_tf;
      }
      
      public function SetEntry(param1:Object) : *
      {
         var _loc2_:Boolean = false;
         if(param1.sDescription.length > 0 || param1.uBounty > 0)
         {
            _loc2_ = true;
         }
         switch(param1.uReputation)
         {
            case REPUTATION_NEUTRAL:
               gotoAndStop(_loc2_ ? "NeutralWithDescription" : "Neutral");
               GlobalFunc.SetText(this.Standing_tf,"$Neutral");
               break;
            case REPUTATION_HOSTILE:
               gotoAndStop(_loc2_ ? "HostileWithDescription" : "Hostile");
               GlobalFunc.SetText(this.Standing_tf,"$Hostile");
               break;
            case REPUTATION_ALLY:
               gotoAndStop(_loc2_ ? "AllyWithDescription" : "Ally");
               GlobalFunc.SetText(this.Standing_tf,"$Ally");
               break;
            case REPUTATION_FRIEND:
               gotoAndStop(_loc2_ ? "AllyWithDescription" : "Ally");
               GlobalFunc.SetText(this.Standing_tf,"$Friend");
         }
         if(_loc2_)
         {
            GlobalFunc.SetText(this.MiscText_tf,param1.sDescription.length > 0 ? String(param1.sDescription) : param1.uBounty + " $$Bounty");
         }
         GlobalFunc.SetText(this.Name_tf,param1.sName);
         GlobalFunc.SetText(this.Name_tf,this.Name_tf.text.toUpperCase());
         if(param1 != null && param1.iFaction != null && param1.iType != MISC_QUEST_TYPE)
         {
            this.FactionIcon_mc.Icons_mc.gotoAndStop(FactionUtils.GetFactionIconLabel(param1.iFaction));
         }
         else
         {
            this.FactionIcon_mc.Icons_mc.gotoAndStop(FactionUtils.GetFactionIconLabel(FactionUtils.FACTION_NONE));
         }
      }
   }
}
