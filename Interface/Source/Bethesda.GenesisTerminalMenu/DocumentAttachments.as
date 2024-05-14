package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.GlobalFunc;
   import fl.motion.AnimatorFactory3D;
   import fl.motion.MotionBase;
   import fl.motion.motion_internal;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.filters.*;
   import flash.geom.Matrix3D;
   import flash.ui.Keyboard;
   
   public class DocumentAttachments extends BSDisplayObject
   {
       
      
      public var __animFactory_RightArrow_mcaf1:AnimatorFactory3D;
      
      public var __animArray_RightArrow_mcaf1:Array;
      
      public var ____motion_RightArrow_mcaf1_mat3DVec__:Vector.<Number>;
      
      public var ____motion_RightArrow_mcaf1_matArray__:Array;
      
      public var __motion_RightArrow_mcaf1:MotionBase;
      
      public var __animFactory_LeftArrow_mcaf1:AnimatorFactory3D;
      
      public var __animArray_LeftArrow_mcaf1:Array;
      
      public var ____motion_LeftArrow_mcaf1_mat3DVec__:Vector.<Number>;
      
      public var ____motion_LeftArrow_mcaf1_matArray__:Array;
      
      public var __motion_LeftArrow_mcaf1:MotionBase;
      
      public var Bounds_mc:MovieClip;
      
      public var LeftArrow_mc:MovieClip;
      
      public var RightArrow_mc:MovieClip;
      
      public var Header_mc:MovieClip;
      
      private var IconWidthScale:Number = 1;
      
      private var IconHeightScale:Number = 1;
      
      private var _attachmentsV:Vector.<DesktopIconObject>;
      
      private var _currentIndex:Number = 0;
      
      private var _paddingX:Number = 10;
      
      private var _maxCol:Number = 0;
      
      private var FactionName:String = "Generic";
      
      private const _ATTACHMENTS:String = "$ATTACHMENTS";
      
      private const LEFT:Number = -1;
      
      private const RIGHT:Number = 1;
      
      public function DocumentAttachments()
      {
         super();
         this._attachmentsV = new Vector.<DesktopIconObject>();
         this.LeftArrow_mc.addEventListener(MouseEvent.CLICK,this.onScrollLeft);
         this.RightArrow_mc.addEventListener(MouseEvent.CLICK,this.onScrollRight);
         addEventListener(DesktopIconObject.ICON_HIGHLIGHTED_EVENT,this.onIconHighlighted);
         if(this.__animFactory_RightArrow_mcaf1 == null)
         {
            this.__animArray_RightArrow_mcaf1 = new Array();
            this.__motion_RightArrow_mcaf1 = new MotionBase();
            this.__motion_RightArrow_mcaf1.duration = 1;
            this.__motion_RightArrow_mcaf1.overrideTargetTransform();
            this.__motion_RightArrow_mcaf1.addPropertyArray("blendMode",["normal"]);
            this.__motion_RightArrow_mcaf1.addPropertyArray("cacheAsBitmap",[false]);
            this.__motion_RightArrow_mcaf1.addPropertyArray("opaqueBackground",[null]);
            this.__motion_RightArrow_mcaf1.addPropertyArray("visible",[true]);
            this.__motion_RightArrow_mcaf1.is3D = true;
            this.__motion_RightArrow_mcaf1.motion_internal::spanStart = 0;
            this.____motion_RightArrow_mcaf1_matArray__ = new Array();
            this.____motion_RightArrow_mcaf1_mat3DVec__ = new Vector.<Number>(16);
            this.____motion_RightArrow_mcaf1_mat3DVec__[0] = -1;
            this.____motion_RightArrow_mcaf1_mat3DVec__[1] = 0;
            this.____motion_RightArrow_mcaf1_mat3DVec__[2] = 0;
            this.____motion_RightArrow_mcaf1_mat3DVec__[3] = 0;
            this.____motion_RightArrow_mcaf1_mat3DVec__[4] = 0;
            this.____motion_RightArrow_mcaf1_mat3DVec__[5] = 1;
            this.____motion_RightArrow_mcaf1_mat3DVec__[6] = 0;
            this.____motion_RightArrow_mcaf1_mat3DVec__[7] = 0;
            this.____motion_RightArrow_mcaf1_mat3DVec__[8] = 0;
            this.____motion_RightArrow_mcaf1_mat3DVec__[9] = 0;
            this.____motion_RightArrow_mcaf1_mat3DVec__[10] = 1;
            this.____motion_RightArrow_mcaf1_mat3DVec__[11] = 0;
            this.____motion_RightArrow_mcaf1_mat3DVec__[12] = 1151;
            this.____motion_RightArrow_mcaf1_mat3DVec__[13] = 40;
            this.____motion_RightArrow_mcaf1_mat3DVec__[14] = 0;
            this.____motion_RightArrow_mcaf1_mat3DVec__[15] = 1;
            this.____motion_RightArrow_mcaf1_matArray__.push(new Matrix3D(this.____motion_RightArrow_mcaf1_mat3DVec__));
            this.__motion_RightArrow_mcaf1.addPropertyArray("matrix3D",this.____motion_RightArrow_mcaf1_matArray__);
            this.__animArray_RightArrow_mcaf1.push(this.__motion_RightArrow_mcaf1);
            this.__animFactory_RightArrow_mcaf1 = new AnimatorFactory3D(null,this.__animArray_RightArrow_mcaf1);
            this.__animFactory_RightArrow_mcaf1.addTargetInfo(this,"RightArrow_mc",0,true,0,true,null,-1);
         }
         if(this.__animFactory_LeftArrow_mcaf1 == null)
         {
            this.__animArray_LeftArrow_mcaf1 = new Array();
            this.__motion_LeftArrow_mcaf1 = new MotionBase();
            this.__motion_LeftArrow_mcaf1.duration = 1;
            this.__motion_LeftArrow_mcaf1.overrideTargetTransform();
            this.__motion_LeftArrow_mcaf1.addPropertyArray("blendMode",["normal"]);
            this.__motion_LeftArrow_mcaf1.addPropertyArray("cacheAsBitmap",[false]);
            this.__motion_LeftArrow_mcaf1.addPropertyArray("opaqueBackground",[null]);
            this.__motion_LeftArrow_mcaf1.addPropertyArray("visible",[true]);
            this.__motion_LeftArrow_mcaf1.is3D = true;
            this.__motion_LeftArrow_mcaf1.motion_internal::spanStart = 0;
            this.____motion_LeftArrow_mcaf1_matArray__ = new Array();
            this.____motion_LeftArrow_mcaf1_mat3DVec__ = new Vector.<Number>(16);
            this.____motion_LeftArrow_mcaf1_mat3DVec__[0] = 1;
            this.____motion_LeftArrow_mcaf1_mat3DVec__[1] = 0;
            this.____motion_LeftArrow_mcaf1_mat3DVec__[2] = 0;
            this.____motion_LeftArrow_mcaf1_mat3DVec__[3] = 0;
            this.____motion_LeftArrow_mcaf1_mat3DVec__[4] = 0;
            this.____motion_LeftArrow_mcaf1_mat3DVec__[5] = 1;
            this.____motion_LeftArrow_mcaf1_mat3DVec__[6] = 0;
            this.____motion_LeftArrow_mcaf1_mat3DVec__[7] = 0;
            this.____motion_LeftArrow_mcaf1_mat3DVec__[8] = 0;
            this.____motion_LeftArrow_mcaf1_mat3DVec__[9] = 0;
            this.____motion_LeftArrow_mcaf1_mat3DVec__[10] = 1;
            this.____motion_LeftArrow_mcaf1_mat3DVec__[11] = 0;
            this.____motion_LeftArrow_mcaf1_mat3DVec__[12] = -70;
            this.____motion_LeftArrow_mcaf1_mat3DVec__[13] = 40;
            this.____motion_LeftArrow_mcaf1_mat3DVec__[14] = 0;
            this.____motion_LeftArrow_mcaf1_mat3DVec__[15] = 1;
            this.____motion_LeftArrow_mcaf1_matArray__.push(new Matrix3D(this.____motion_LeftArrow_mcaf1_mat3DVec__));
            this.__motion_LeftArrow_mcaf1.addPropertyArray("matrix3D",this.____motion_LeftArrow_mcaf1_matArray__);
            this.__animArray_LeftArrow_mcaf1.push(this.__motion_LeftArrow_mcaf1);
            this.__animFactory_LeftArrow_mcaf1 = new AnimatorFactory3D(null,this.__animArray_LeftArrow_mcaf1);
            this.__animFactory_LeftArrow_mcaf1.addTargetInfo(this,"LeftArrow_mc",0,true,0,true,null,-1);
         }
      }
      
      public function set Faction(param1:String) : *
      {
         this.FactionName = param1;
         this.UpdateIconFaction();
      }
      
      public function get HasAttachments() : Boolean
      {
         return this._attachmentsV.length > 0;
      }
      
      override public function onAddedToStage() : void
      {
         this.IconWidthScale = 1 / scaleX;
         this.IconHeightScale = 1 / scaleY;
         this.UpdateScales();
      }
      
      public function InitializeIcons(param1:Array) : void
      {
         var _loc2_:Object = null;
         var _loc3_:* = undefined;
         var _loc4_:DesktopIconObject = null;
         while(this._attachmentsV.length > 0)
         {
            removeChild(this._attachmentsV.pop());
         }
         for each(_loc2_ in param1)
         {
            _loc3_ = this._attachmentsV.length;
            (_loc4_ = new DesktopIconObject(_loc2_.iIconId,_loc2_.sIconName,_loc2_.bIsLocked,_loc2_.iIconStyle,_loc2_.iParentStackLevel)).gotoAndStop(this.FactionName);
            _loc4_.scaleX = this.IconWidthScale;
            _loc4_.scaleY = this.IconHeightScale;
            if(this._maxCol == 0)
            {
               this._maxCol = Math.floor(this.Bounds_mc.width / (_loc4_.width + this._paddingX));
            }
            _loc4_.x = Math.round(_loc4_.width + this._paddingX) * _loc3_;
            if(_loc3_ == this._currentIndex)
            {
               _loc4_.Highlight();
            }
            else
            {
               _loc4_.Dehighlight();
            }
            addChild(_loc4_);
            this._attachmentsV.push(_loc4_);
            _loc4_.visible = _loc3_ < this._maxCol;
         }
         this.LeftArrow_mc.visible = false;
         if(this._attachmentsV.length > 0)
         {
            this._attachmentsV[this._currentIndex].Highlight();
            this.RightArrow_mc.visible = this._attachmentsV.length > this._maxCol;
            GlobalFunc.SetText(this.Header_mc.text_tf,this._ATTACHMENTS);
            GlobalFunc.SetText(this.Header_mc.text_tf,this.Header_mc.text_tf.text + ": (" + this._attachmentsV.length + ")");
         }
         else
         {
            this.Header_mc.visible = false;
            this.RightArrow_mc.visible = false;
         }
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(param1 == "Accept" && !param2 && this._attachmentsV.length > 0)
         {
            this._attachmentsV[this._currentIndex].onClick();
            _loc3_ = true;
         }
         return _loc3_;
      }
      
      public function HandleInputEvent(param1:KeyboardEvent) : Boolean
      {
         var _loc2_:Boolean = false;
         switch(param1.keyCode)
         {
            case Keyboard.LEFT:
               if(this._currentIndex > 0)
               {
                  this.MoveHighlight(this.LEFT);
                  if(!this.IconWithinBoundsX(this._attachmentsV[this._currentIndex]))
                  {
                     this.ScrollAttachments(this.LEFT);
                  }
               }
               _loc2_ = true;
               break;
            case Keyboard.RIGHT:
               if(this._currentIndex < this._attachmentsV.length - 1)
               {
                  this.MoveHighlight(this.RIGHT);
                  if(!this.IconWithinBoundsX(this._attachmentsV[this._currentIndex]))
                  {
                     this.ScrollAttachments(this.RIGHT);
                  }
               }
               _loc2_ = true;
         }
         return _loc2_;
      }
      
      private function ScrollAttachments(param1:Number) : *
      {
         var _loc2_:DesktopIconObject = null;
         for each(_loc2_ in this._attachmentsV)
         {
            _loc2_.x -= (Math.round(_loc2_.width) + this._paddingX) * param1;
            _loc2_.visible = this.IconWithinBoundsX(_loc2_);
         }
         this.LeftArrow_mc.visible = !this._attachmentsV[0].visible;
         this.RightArrow_mc.visible = !this._attachmentsV[this._attachmentsV.length - 1].visible;
      }
      
      public function onScrollLeft() : void
      {
         this.ScrollAttachments(this.LEFT);
      }
      
      public function onScrollRight() : void
      {
         this.ScrollAttachments(this.RIGHT);
      }
      
      private function IconWithinBoundsX(param1:DesktopIconObject) : Boolean
      {
         return param1.x >= this.Bounds_mc.x && param1.x + param1.width < this.Bounds_mc.x + this.Bounds_mc.width;
      }
      
      private function MoveHighlight(param1:int) : void
      {
         this._attachmentsV[this._currentIndex].Dehighlight();
         this._currentIndex += param1;
         this._attachmentsV[this._currentIndex].Highlight();
      }
      
      private function onIconHighlighted(param1:Event) : void
      {
         if(this._attachmentsV[this._currentIndex] != param1.target)
         {
            this._attachmentsV[this._currentIndex].Dehighlight();
            this._currentIndex = this._attachmentsV.indexOf(param1.target);
         }
      }
      
      private function UpdateIconFaction() : void
      {
         var _loc2_:DesktopIconObject = null;
         this.IconWidthScale = 1 / scaleX;
         this.IconHeightScale = 1 / scaleY;
         var _loc1_:int = 0;
         while(_loc1_ < this._attachmentsV.length)
         {
            _loc2_ = this._attachmentsV[_loc1_];
            _loc2_.UpdateFaction(this.FactionName);
            if(_loc1_ == this._currentIndex)
            {
               _loc2_.Highlight();
            }
            else
            {
               _loc2_.Dehighlight();
            }
            _loc1_++;
         }
         this.UpdateScales();
      }
      
      private function UpdateScales() : void
      {
         this.Header_mc.scaleX = this.IconWidthScale;
         this.Header_mc.scaleY = this.IconHeightScale;
         this.LeftArrow_mc.scaleX = this.IconWidthScale;
         this.LeftArrow_mc.scaleY = this.IconHeightScale;
         this.RightArrow_mc.scaleX = this.IconWidthScale;
         this.RightArrow_mc.scaleY = this.IconHeightScale;
      }
   }
}
