package Components.PlanetInfoCard
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class HoverNameplate extends MovieClip
   {
      
      private static const NAMEPLATE_PADDING:uint = 20;
       
      
      public var NameplateText_mc:MovieClip;
      
      public var Mask_mc:MovieClip;
      
      public var NameplateBackground_mc:MovieClip;
      
      public function HoverNameplate()
      {
         super();
         gotoAndStop("Off");
      }
      
      public function Open(param1:String, param2:Point, param3:Number) : *
      {
         GlobalFunc.SetText(this.NameplateText_mc.text_tf,param1);
         var _loc4_:int = this.NameplateText_mc.text_tf.textWidth + NAMEPLATE_PADDING;
         var _loc5_:* = param2.x + param3 + _loc4_ > stage.stageWidth;
         var _loc6_:Point = parent.globalToLocal(param2);
         x = _loc5_ ? _loc6_.x - _loc4_ - param3 : _loc6_.x + param3;
         y = _loc6_.y;
         gotoAndPlay("Open");
         this.Mask_mc.MaskBase_mc.width = _loc4_;
         this.NameplateText_mc.text_tf.width = _loc4_;
         this.NameplateBackground_mc.width = _loc4_;
      }
      
      public function Close() : *
      {
         gotoAndPlay("Close");
      }
   }
}
