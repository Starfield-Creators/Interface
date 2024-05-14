package Components.PlanetInfoCard
{
   import flash.display.MovieClip;
   
   public class PlanetInfoCard extends Planet
   {
      
      private static const SYSTEM_SCAN_Y_OFFSET:Number = 85;
      
      private static const SYSTEM_SCAN_Y_OFFSET_LRG:Number = 0;
       
      
      public var Scan_mc:Surveyor;
      
      public var BGSmall_mc:MovieClip;
      
      public var BGLarge_mc:MovieClip;
      
      public var HoverNameplate_mc:HoverNameplate;
      
      private var OriginalScanY:Number;
      
      public function PlanetInfoCard()
      {
         super();
         mouseEnabled = false;
         this.BGSmall_mc.mouseEnabled = false;
         this.BGLarge_mc.mouseEnabled = false;
         var _loc1_:* = BodyDataInfo_mc as StarmapBodyDataInfo;
         if(_loc1_)
         {
            _loc1_.SetHoverNameplates(this.HoverNameplate_mc);
         }
         this.OriginalScanY = this.Scan_mc.y;
      }
      
      internal function get SystemScanYOffset() : Number
      {
         return SYSTEM_SCAN_Y_OFFSET;
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         return this.Scan_mc.ProcessUserEvent(param1,param2);
      }
      
      public function UpdateScanButton(param1:Boolean, param2:Boolean) : *
      {
         if(!param1 && !param2)
         {
            this.SetNoScanMode();
         }
         else
         {
            this.SetFullMode();
            this.Scan_mc.UpdateButton(param1,param2);
         }
      }
      
      public function SetNoScanMode() : *
      {
         this.Scan_mc.visible = false;
         BodyDataInfo_mc.BGLarge_mc.visible = false;
         this.BGSmall_mc.visible = true;
         this.BGLarge_mc.visible = false;
      }
      
      public function SetSystemScanMode() : *
      {
         this.Scan_mc.visible = true;
         this.Scan_mc.y = this.OriginalScanY - this.SystemScanYOffset;
         BodyDataInfo_mc.BGLarge_mc.visible = false;
         this.BGSmall_mc.visible = true;
         this.BGLarge_mc.visible = false;
      }
      
      public function SetFullMode() : *
      {
         this.Scan_mc.visible = true;
         this.Scan_mc.y = this.OriginalScanY;
         BodyDataInfo_mc.BGLarge_mc.visible = false;
         this.BGSmall_mc.visible = false;
         this.BGLarge_mc.visible = true;
      }
      
      public function SetUseTraitIcons(param1:Boolean) : *
      {
         var _loc2_:* = BodyDataInfo_mc as StarmapBodyDataInfo;
         if(_loc2_)
         {
            _loc2_.UseTraitIcons = param1;
         }
      }
      
      public function SetResourcePanelVisible(param1:Boolean) : *
      {
      }
   }
}
