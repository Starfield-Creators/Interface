package Components
{
   import Shared.AS3.BSDisplayObject;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   public class MyShipEntry extends BSDisplayObject
   {
      
      private static const PADDING:int = 4;
       
      
      public var ShipName_mc:MovieClip;
      
      public var ShipAvailability_mc:MovieClip;
      
      public var ShipUnavailable_mc:MovieClip;
      
      public var ShipCost_mc:MovieClip;
      
      public const SELECTED:String = "Selected";
      
      public const UNSELECTED:String = "Unselected";
      
      public const EMPTY:String = "Empty";
      
      private var ShipIndex:uint;
      
      private var Selected:Boolean = false;
      
      public function MyShipEntry()
      {
         super();
      }
      
      override public function onAddedToStage() : void
      {
         this.SetVendorMode(false);
         this.SetUnselected();
      }
      
      public function SetSelected() : *
      {
         this.Selected = true;
         gotoAndStop(this.SELECTED);
      }
      
      public function SetUnselected() : *
      {
         this.Selected = false;
         gotoAndStop(this.UNSELECTED);
      }
      
      public function SetEmpty() : *
      {
         gotoAndStop(this.EMPTY);
      }
      
      public function SetName(param1:String) : *
      {
         GlobalFunc.SetText(this.ShipName_mc.text_tf,param1);
      }
      
      public function SetAvailability(param1:String) : *
      {
         GlobalFunc.SetText(this.ShipAvailability_mc.text_tf,param1);
      }
      
      public function SetCost(param1:uint) : *
      {
         GlobalFunc.SetText(this.ShipCost_mc.text_tf,GlobalFunc.FormatNumberToString(param1));
         this.ShipCost_mc.Icon_mc.x = this.ShipCost_mc.text_tf.textWidth + PADDING;
      }
      
      public function SetIndex(param1:uint) : *
      {
         this.ShipIndex = param1;
      }
      
      public function GetIndex() : uint
      {
         return this.ShipIndex;
      }
      
      public function IsSelected() : Boolean
      {
         return this.Selected;
      }
      
      public function SetVendorMode(param1:Boolean) : void
      {
         this.ShipAvailability_mc.visible = !param1;
         this.ShipCost_mc.visible = param1;
      }
   }
}
