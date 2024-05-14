package
{
   import flash.display.MovieClip;
   
   public class OffscreenMarker extends MovieClip
   {
       
      
      public var questIndicator_Active_mc:MovieClip;
      
      public var questIndicator_Inactive_mc:MovieClip;
      
      private var markerData:Object;
      
      public function OffscreenMarker()
      {
         super();
         this.SetVisible(false);
      }
      
      public function SetData(param1:Object) : *
      {
         this.markerData = param1;
         this.SetPosition(this.markerData.fPosX,this.markerData.fPosY);
      }
      
      public function get Width() : Number
      {
         if(this.markerData.bActive)
         {
            return this.questIndicator_Active_mc.width;
         }
         return this.questIndicator_Inactive_mc.width;
      }
      
      public function get Height() : Number
      {
         if(this.markerData.bActive)
         {
            return this.questIndicator_Active_mc.height;
         }
         return this.questIndicator_Inactive_mc.height;
      }
      
      private function SetPosition(param1:Number, param2:Number) : *
      {
         x = param1;
         y = param2;
      }
      
      public function SetVisible(param1:Boolean) : void
      {
         this.questIndicator_Active_mc.visible = param1 && Boolean(this.markerData.bActive);
         this.questIndicator_Inactive_mc.visible = param1 && !this.markerData.bActive;
      }
   }
}
