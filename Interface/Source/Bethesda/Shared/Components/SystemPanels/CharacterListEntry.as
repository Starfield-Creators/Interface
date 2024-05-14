package Shared.Components.SystemPanels
{
   import Shared.AS3.BSContainerEntry;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class CharacterListEntry extends BSContainerEntry
   {
      
      public static const NAME_MAX_LENGTH:* = 30;
       
      
      public var Name_mc:MovieClip;
      
      public var Fill_mc:MovieClip;
      
      public function CharacterListEntry()
      {
         super();
      }
      
      override protected function get baseTextField() : TextField
      {
         return this.Name_mc.Name_tf;
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         var _loc2_:* = param1.sCharacterName;
         GlobalFunc.SetText(this.baseTextField,_loc2_,false,false,NAME_MAX_LENGTH);
      }
   }
}
