package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class FactionAndExplorationEntry extends MovieClip
   {
      
      public static const FEE_FACTION:String = "Faction";
      
      public static const FEE_EXPLORATION:String = "Exploration";
      
      public static const FEE_HEADER:String = "Header";
      
      public static const FEE_DIVIDER:String = "Divider";
       
      
      public var Faction_mc:FactionStandingEntry;
      
      public var Exploration_mc:ExplorationEntry;
      
      public var Header_mc:MovieClip;
      
      public function FactionAndExplorationEntry()
      {
         super();
      }
      
      public function get Header_tf() : TextField
      {
         return this.Header_mc.Text_tf;
      }
      
      public function SetEntry(param1:Object) : void
      {
         if(currentFrameLabel != param1.sType)
         {
            gotoAndStop(param1.sType);
         }
         else
         {
            stop();
         }
         switch(param1.sType)
         {
            case FEE_FACTION:
               this.Faction_mc.SetEntry(param1);
               break;
            case FEE_EXPLORATION:
               this.Exploration_mc.SetEntry(param1);
               break;
            case FEE_HEADER:
               GlobalFunc.SetText(this.Header_tf,param1.sName);
               break;
            case FEE_DIVIDER:
               break;
            default:
               GlobalFunc.TraceWarning("FactionAndExplorationEntry.SetEntryText given an object of unknown type: " + param1.sType);
         }
      }
   }
}
