package
{
   import Components.BSButton;
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.BSScrollingContainer;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import scaleform.gfx.TextFieldEx;
   
   public class DropDownBox extends BSDisplayObject
   {
      
      public static var DropEntrySelectedEvent:String = "DropEntrySelectedEvent";
       
      
      public var DropList_mc:MovieClip;
      
      public var DropButton_mc:WeaponGroupButton;
      
      public function DropDownBox()
      {
         super();
      }
      
      public function get DropContainer() : BSScrollingContainer
      {
         return this.DropList_mc.DropSlots_mc;
      }
      
      override public function onAddedToStage() : void
      {
         var _loc1_:BSScrollingConfigParams = null;
         this.DropButton_mc.addEventListener(BSButton.BUTTON_CLICKED_EVENT,this.onButtonClicked);
         this.DropList_mc.visible = false;
         _loc1_ = new BSScrollingConfigParams();
         _loc1_.VerticalSpacing = 3;
         _loc1_.EntryClassName = "ListEntry";
         _loc1_.TextOption = TextFieldEx.TEXTAUTOSZ_SHRINK;
         this.DropContainer.Configure(_loc1_);
         this.DropContainer.addEventListener(ScrollingEvent.ITEM_PRESS,this.onItemPressed);
      }
      
      public function IsListActive() : Boolean
      {
         return this.DropList_mc.visible;
      }
      
      public function SetButtonText(param1:String) : *
      {
         GlobalFunc.SetText(this.DropButton_mc.ButtonText_tf.text_tf,param1);
      }
      
      public function FillDropList(param1:Array) : *
      {
         this.DropContainer.InitializeEntries(param1);
      }
      
      public function Select() : *
      {
         this.DropButton_mc.Select();
         stage.focus = this.DropButton_mc;
      }
      
      public function Deselect() : *
      {
         this.DropButton_mc.Deselect();
      }
      
      public function onButtonClicked() : *
      {
         this.DropList_mc.visible = !this.DropList_mc.visible;
         if(this.DropList_mc.visible)
         {
            stage.focus = this.DropContainer;
         }
         else
         {
            stage.focus = this.DropButton_mc;
         }
      }
      
      public function onItemPressed() : *
      {
         var _loc1_:Object = this.DropList_mc.DropSlots_mc.selectedEntry;
         dispatchEvent(new CustomEvent(DropEntrySelectedEvent,{
            "target":this,
            "object":_loc1_
         },true));
         this.onButtonClicked();
      }
   }
}
