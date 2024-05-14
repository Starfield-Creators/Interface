package Shared.AS3
{
   import Shared.AS3.Events.CustomEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Rectangle;
   
   public class BSAnimating3DSceneRect extends MovieClip
   {
      
      public static const UPDATE_SCENE_RECT:String = "UPDATE_SCENE_RECT";
       
      
      internal var SceneRectData:Object;
      
      internal var MaskClip:MovieClip = null;
      
      internal var isDirty:Boolean = false;
      
      public function BSAnimating3DSceneRect()
      {
         this.SceneRectData = new Object();
         super();
         this.SceneRectData.sSceneRectName = this.name;
         this.SetBackgroundColor(0);
         this.refreshSceneRect();
         addEventListener(Event.ENTER_FRAME,this.refreshSceneRect);
      }
      
      public function SetMask(param1:MovieClip) : *
      {
         this.MaskClip = param1;
      }
      
      public function SetBackgroundColor(param1:uint) : *
      {
         this.SetSceneRectVar("uColor",param1);
      }
      
      public function QData() : Object
      {
         return this.SceneRectData;
      }
      
      private function SetSceneRectVar(param1:String, param2:*) : *
      {
         if(this.SceneRectData[param1] == undefined || this.SceneRectData[param1] !== param2)
         {
            this.SceneRectData[param1] = param2;
            this.isDirty = true;
         }
      }
      
      protected function refreshSceneRect() : *
      {
         var _loc3_:Rectangle = null;
         var _loc4_:Rectangle = null;
         this.SetSceneRectVar("bVisible",this.visible);
         var _loc1_:Rectangle = this.getBounds(this);
         var _loc2_:Rectangle = new Rectangle();
         _loc2_.topLeft = this.localToGlobal(_loc1_.topLeft);
         _loc2_.bottomRight = this.localToGlobal(_loc1_.bottomRight);
         this.SetSceneRectVar("fTopLeftX",_loc2_.topLeft.x);
         this.SetSceneRectVar("fTopLeftY",_loc2_.topLeft.y);
         this.SetSceneRectVar("fBottomRightX",_loc2_.bottomRight.x);
         this.SetSceneRectVar("fBottomRightY",_loc2_.bottomRight.y);
         if(this.MaskClip != null)
         {
            _loc3_ = this.MaskClip.getBounds(this);
            (_loc4_ = new Rectangle()).topLeft = this.localToGlobal(_loc3_.topLeft);
            _loc4_.bottomRight = this.localToGlobal(_loc3_.bottomRight);
            this.SetSceneRectVar("bHasMask",true);
            this.SetSceneRectVar("fMaskTopLeftX",_loc4_.topLeft.x);
            this.SetSceneRectVar("fMaskTopLeftY",_loc4_.topLeft.y);
            this.SetSceneRectVar("fMaskBottomRightX",_loc4_.bottomRight.x);
            this.SetSceneRectVar("fMaskBottomRightY",_loc4_.bottomRight.y);
         }
         else
         {
            this.SetSceneRectVar("bHasMask",false);
         }
         if(this.isDirty)
         {
            dispatchEvent(new CustomEvent(UPDATE_SCENE_RECT,{"ScreenRect":this.QData()}));
            this.isDirty = false;
         }
      }
   }
}
