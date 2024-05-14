package Shared.Components.SystemPanels
{
   import Components.DisplayList;
   import Components.DisplayList_Entry;
   import flash.utils.getDefinitionByName;
   
   public class SettingsControlConflictEntry extends DisplayList_Entry
   {
      
      public static var ConflictInfoClassName:String = "Shared.Components.SystemPanels.SettingsControlConflictInfo";
       
      
      public var InfoList_mc:DisplayList;
      
      private const COLUMNS:Number = 1;
      
      private const ROWS:Number = 5;
      
      private const SPACING:Number = 0;
      
      private const HORIZONTAL_PADDING:Number = 14;
      
      private const VERTICAL_PADDING:Number = 5;
      
      public function SettingsControlConflictEntry()
      {
         super();
      }
      
      override public function SetEntryData(param1:Object) : *
      {
         var _loc2_:Class = getDefinitionByName(ConflictInfoClassName) as Class;
         this.InfoList_mc.Configure(_loc2_,this.COLUMNS,this.ROWS,this.SPACING,this.SPACING,this.HORIZONTAL_PADDING,this.VERTICAL_PADDING);
         this.InfoList_mc.entryData = param1.aConflictingControls;
      }
   }
}
