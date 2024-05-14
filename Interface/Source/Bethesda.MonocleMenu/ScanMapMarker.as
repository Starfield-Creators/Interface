package
{
   import Components.Icons.DynamicPoiIcon;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class ScanMapMarker extends MovieClip
   {
       
      
      public var Range_tf:TextField;
      
      public var Internal_mc:DynamicPoiIcon;
      
      private var TEXT_Y_OFFSET:Number = 3;
      
      public function ScanMapMarker()
      {
         super();
      }
      
      public function get internalIcon() : DynamicPoiIcon
      {
         return this.Internal_mc;
      }
      
      public function set range(param1:uint) : *
      {
         GlobalFunc.SetText(this.Range_tf,param1 + "M");
      }
   }
}
