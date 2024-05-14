package Components.ShipEditorWidgets
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class PersistentContent extends BSDisplayObject
   {
       
      
      public var NameLabel_mc:MovieClip;
      
      public var SubtextLabel_mc:MovieClip;
      
      public var LocationIcon_mc:MovieClip;
      
      public function PersistentContent()
      {
         super();
      }
      
      private function get NameText() : TextField
      {
         return this.NameLabel_mc.text_tf;
      }
      
      private function get SubtextText() : TextField
      {
         return this.SubtextLabel_mc.text_tf;
      }
      
      override public function onAddedToStage() : void
      {
         gotoAndPlay("Open");
      }
      
      public function UpdateValues(param1:Object) : void
      {
         GlobalFunc.SetText(this.NameText,param1.sName);
         GlobalFunc.SetText(this.SubtextText,param1.sSubtext);
      }
   }
}
