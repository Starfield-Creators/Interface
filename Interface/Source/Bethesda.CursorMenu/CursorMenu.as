package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.IMenu;
   import Shared.EnumHelper;
   import fl.motion.AnimatorFactory3D;
   import fl.motion.MotionBase;
   import fl.motion.motion_internal;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.*;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   
   public class CursorMenu extends IMenu
   {
       
      
      public var __animFactory_circle3d_mcaf1:AnimatorFactory3D;
      
      public var __animArray_circle3d_mcaf1:Array;
      
      public var ____motion_circle3d_mcaf1_mat3DVec__:Vector.<Number>;
      
      public var ____motion_circle3d_mcaf1_matArray__:Array;
      
      public var __motion_circle3d_mcaf1:MotionBase;
      
      public var pointer_mc:MovieClip;
      
      public var circle_mc:MovieClip;
      
      public var circle3d_mc:MovieClip;
      
      public var circlex3d_mc:MovieClip;
      
      public var cross_mc:MovieClip;
      
      private var CurrentCursor:MovieClip = null;
      
      private var CursorData:Object = null;
      
      private var IsUsing3D:Boolean = false;
      
      private const CURSOR_DEFAULT:uint = 0;
      
      private const CURSOR_GAME:uint = 1;
      
      private const CURSOR_STATE_DEFAULT:uint = EnumHelper.GetEnum(0);
      
      private const CURSOR_STATE_HIGHLIGHTED:uint = EnumHelper.GetEnum();
      
      public function CursorMenu()
      {
         super();
         this.x = -100;
         this.y = -100;
         addEventListener(Event.ADDED_TO_STAGE,this.onStageInit);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onStageDestruct);
         if(this.__animFactory_circle3d_mcaf1 == null)
         {
            this.__animArray_circle3d_mcaf1 = new Array();
            this.__motion_circle3d_mcaf1 = new MotionBase();
            this.__motion_circle3d_mcaf1.duration = 2;
            this.__motion_circle3d_mcaf1.overrideTargetTransform();
            this.__motion_circle3d_mcaf1.addPropertyArray("blendMode",["normal","normal"]);
            this.__motion_circle3d_mcaf1.addPropertyArray("cacheAsBitmap",[false,false]);
            this.__motion_circle3d_mcaf1.addPropertyArray("opaqueBackground",[null,null]);
            this.__motion_circle3d_mcaf1.addPropertyArray("visible",[true,true]);
            this.__motion_circle3d_mcaf1.is3D = true;
            this.__motion_circle3d_mcaf1.motion_internal::spanStart = 0;
            this.____motion_circle3d_mcaf1_matArray__ = new Array();
            this.____motion_circle3d_mcaf1_mat3DVec__ = new Vector.<Number>(16);
            this.____motion_circle3d_mcaf1_mat3DVec__[0] = 0.999991;
            this.____motion_circle3d_mcaf1_mat3DVec__[1] = -0.00346;
            this.____motion_circle3d_mcaf1_mat3DVec__[2] = 0.002504;
            this.____motion_circle3d_mcaf1_mat3DVec__[3] = 0;
            this.____motion_circle3d_mcaf1_mat3DVec__[4] = 0.003376;
            this.____motion_circle3d_mcaf1_mat3DVec__[5] = 0.999465;
            this.____motion_circle3d_mcaf1_mat3DVec__[6] = 0.032525;
            this.____motion_circle3d_mcaf1_mat3DVec__[7] = 0;
            this.____motion_circle3d_mcaf1_mat3DVec__[8] = -0.002615;
            this.____motion_circle3d_mcaf1_mat3DVec__[9] = -0.032516;
            this.____motion_circle3d_mcaf1_mat3DVec__[10] = 0.999468;
            this.____motion_circle3d_mcaf1_mat3DVec__[11] = 0;
            this.____motion_circle3d_mcaf1_mat3DVec__[12] = 0;
            this.____motion_circle3d_mcaf1_mat3DVec__[13] = 0;
            this.____motion_circle3d_mcaf1_mat3DVec__[14] = 0;
            this.____motion_circle3d_mcaf1_mat3DVec__[15] = 1;
            this.____motion_circle3d_mcaf1_matArray__.push(new Matrix3D(this.____motion_circle3d_mcaf1_mat3DVec__));
            this.____motion_circle3d_mcaf1_matArray__.push(null);
            this.__motion_circle3d_mcaf1.addPropertyArray("matrix3D",this.____motion_circle3d_mcaf1_matArray__);
            this.__animArray_circle3d_mcaf1.push(this.__motion_circle3d_mcaf1);
            this.__animFactory_circle3d_mcaf1 = new AnimatorFactory3D(null,this.__animArray_circle3d_mcaf1);
            this.__animFactory_circle3d_mcaf1.addTargetInfo(this,"circle3d_mc",0,true,0,true,null,-1);
         }
      }
      
      public function UpdateCursorType(param1:uint, param2:String, param3:uint) : *
      {
         var _loc4_:* = false;
         if(this.CurrentCursor != null)
         {
            this.CurrentCursor.visible = false;
         }
         if(param1 == this.CURSOR_GAME || param2.length > 0)
         {
            this.CurrentCursor = this.getChildByName(param2) as MovieClip;
            if(this.CurrentCursor == null)
            {
               this.CurrentCursor = this.getChildByName(param2.toLowerCase() + "_mc") as MovieClip;
            }
            if(this.CurrentCursor != null)
            {
               _loc4_ = param3 == this.CURSOR_STATE_HIGHLIGHTED;
               gotoAndStop(_loc4_ ? "highlight_on" : "highlight_off");
               this.CurrentCursor.visible = true;
            }
            else
            {
               trace("Cursor: " + param2 + " not found on stage, using default pointer");
               this.SetDefaultCursor();
            }
         }
         else
         {
            this.SetDefaultCursor();
         }
      }
      
      private function SetDefaultCursor() : *
      {
         this.CurrentCursor = this.pointer_mc;
         this.CurrentCursor.visible = true;
      }
      
      private function onStageInit(param1:Event) : *
      {
         var i:int = 0;
         var cursorData:Object = null;
         var event:Event = param1;
         stage.stageFocusRect = false;
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMovement);
         i = 0;
         while(i < this.numChildren)
         {
            this.getChildAt(i).visible = false;
            i++;
         }
         this.SetDefaultCursor();
         BSUIDataManager.Subscribe("CursorData",function(param1:FromClientDataEvent):*
         {
            var _loc5_:Number = NaN;
            var _loc6_:Number = NaN;
            cursorData = param1.data;
            var _loc2_:uint = !!cursorData.uCursorType ? uint(cursorData.uCursorType) : 0;
            var _loc3_:String = !!cursorData.sGameCursorName ? String(cursorData.sGameCursorName) : "";
            var _loc4_:uint = !!cursorData.uCursorState ? uint(cursorData.uCursorState) : 0;
            UpdateCursorType(_loc2_,_loc3_,_loc4_);
            if(CurrentCursor != null && cursorData.bUse3D && cursorData.fYaw != undefined && cursorData.fPitch != undefined)
            {
               _loc5_ = 90 - cursorData.fYaw + 180;
               _loc6_ = Number(cursorData.fPitch);
               CurrentCursor.transform.matrix3D.identity();
               CurrentCursor.transform.matrix3D.appendRotation(_loc5_,Vector3D.X_AXIS);
               CurrentCursor.transform.matrix3D.appendRotation(_loc6_,Vector3D.Y_AXIS);
            }
            else if(CurrentCursor != null && !cursorData.bUse3D && IsUsing3D)
            {
               CurrentCursor.transform.matrix3D.identity();
            }
            IsUsing3D = cursorData.bUse3D;
         });
      }
      
      private function onStageDestruct(param1:Event) : *
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMovement);
      }
      
      private function onMouseMovement(param1:Event) : *
      {
         this.x = stage.mouseX;
         this.y = stage.mouseY;
      }
   }
}
