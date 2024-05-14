package privatePkg
{
   import fl.Layer;
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class CameraGuide
   {
       
      
      internal var guideMovieClip:DisplayObject;
      
      internal var deltaX:Number;
      
      internal var deltaY:Number;
      
      internal var deltaZ:Number;
      
      public function CameraGuide()
      {
         super();
         this.Reset();
      }
      
      private function Reset() : *
      {
         this.guideMovieClip = null;
         this.deltaX = 0;
         this.deltaY = 0;
         this.deltaZ = 0;
      }
      
      public function AttachGuide(param1:DisplayObject, param2:Number = 0, param3:Number = 0, param4:Number = 0) : *
      {
         if(param1 == null)
         {
            this.Reset();
            return;
         }
         this.guideMovieClip = param1;
         this.deltaX = param2;
         this.deltaY = param3;
         this.deltaZ = param4;
         this.guideMovieClip.addEventListener(Event.REMOVED_FROM_STAGE,this.guideRemovedFromStage);
      }
      
      public function ChangeDelta(param1:Number, param2:Number, param3:Number) : *
      {
         this.deltaX = param1;
         this.deltaY = param2;
         this.deltaZ = param3;
      }
      
      public function IsAttachedToGuide() : Boolean
      {
         if(this.guideMovieClip == null)
         {
            return false;
         }
         return true;
      }
      
      public function DetachGuide() : *
      {
         this.Reset();
      }
      
      public function GetAttachmentPoint() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_["x"] = this.guideMovieClip.x + this.deltaX;
         _loc1_["y"] = this.guideMovieClip.y + this.deltaY;
         var _loc2_:* = this.guideMovieClip.parent;
         while(_loc2_)
         {
            if(_loc2_.parent == this.guideMovieClip.root)
            {
               break;
            }
            _loc2_ = _loc2_.parent;
         }
         var _loc3_:* = 0;
         if(_loc2_)
         {
            _loc3_ = Layer.getLayerZDepth(this.guideMovieClip.root,_loc2_.name);
         }
         _loc1_["z"] = _loc3_ + this.deltaZ;
         return _loc1_;
      }
      
      private function guideRemovedFromStage(... rest) : *
      {
         this.guideMovieClip.removeEventListener(Event.REMOVED_FROM_STAGE,this.guideRemovedFromStage);
         this.Reset();
      }
   }
}
