package
{
   import Components.IconOrganizer;
   import Shared.AS3.BSScrollingListEntry;
   import Shared.AS3.StyleSheet;
   import Shared.AS3.Styles.StarMap_IconOrganizerStyle;
   import flash.display.MovieClip;
   
   public class QuickSystemSelectEntry extends BSScrollingListEntry
   {
       
      
      public var IconOrganizer_mc:IconOrganizer;
      
      public var EntryText_mc:MovieClip;
      
      public var SelectedEntryText_mc:MovieClip;
      
      public var PlayListUpdateAnimation:Boolean = false;
      
      public function QuickSystemSelectEntry()
      {
         super();
         super._HasDynamicHeight = false;
         super.textField = this.EntryText_mc.text_tf;
         StyleSheet.apply(this.IconOrganizer_mc,false,StarMap_IconOrganizerStyle);
      }
      
      override public function SetEntryText(param1:Object, param2:String) : *
      {
         super.SetEntryText(param1,param2);
         this.SelectedEntryText_mc.text_tf.text = textField.text;
         if(param1.bHasQuestTarget)
         {
            this.IconOrganizer_mc.SetIconVisible("QuestMarker_mc",param1.bQuestActive);
            this.IconOrganizer_mc.SetIconVisible("QuestMarkerInactive_mc",!param1.bQuestActive);
         }
         else
         {
            this.IconOrganizer_mc.SetIconVisible("QuestMarker_mc",false);
            this.IconOrganizer_mc.SetIconVisible("QuestMarkerInactive_mc",false);
         }
         this.IconOrganizer_mc.SetIconVisible("PlayerShipIcon_mc",param1.bHasPlayerInSystem);
         this.IconOrganizer_mc.SetIconVisible("PlottedIcon_mc",param1.bHasPlotTarget);
         this.IconOrganizer_mc.SetIconVisible("OutpostIcon_mc",param1.bHasOutpost);
         this.IconOrganizer_mc.SetIconVisible("CityIcon_mc",param1.bIsSettled);
      }
   }
}
