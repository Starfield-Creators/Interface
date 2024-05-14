package Shared.Components.SystemPanels
{
   import Shared.AS3.BSContainerEntry;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class HelpTopicListEntry extends BSContainerEntry
   {
      
      private static var _largeTextMode:Boolean = false;
       
      
      public var Topic_mc:MovieClip;
      
      public var Fill_mc:MovieClip;
      
      private const MAX_TRUNCATE_LEN:uint = 24;
      
      private const NO_TRUNCATE_LEN:uint = 0;
      
      public function HelpTopicListEntry()
      {
         super();
         maxCharactersToDisplay = _largeTextMode ? this.MAX_TRUNCATE_LEN : this.NO_TRUNCATE_LEN;
      }
      
      public static function set largeTextMode(param1:Boolean) : *
      {
         _largeTextMode = param1;
      }
      
      override protected function get baseTextField() : TextField
      {
         return this.Topic_mc.Topic_tf;
      }
      
      override protected function TryGetEntryText(param1:Object) : String
      {
         return param1.sTopicName;
      }
   }
}
