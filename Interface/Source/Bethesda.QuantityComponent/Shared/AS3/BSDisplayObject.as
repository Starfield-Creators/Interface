package Shared.AS3
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.GlobalFunc;
   import Shared.PlatformUtils;
   import flash.display.DisplayObject;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.getQualifiedClassName;
   
   public class BSDisplayObject extends MovieClip
   {
       
      
      private var _uiPlatform:uint = 4294967295;
      
      private var _uiController:uint = 4294967295;
      
      private var _bIsDirty:Boolean;
      
      public var onAddChild:Function;
      
      public var onRemoveChild:Function;
      
      public function BSDisplayObject()
      {
         super();
         this._bIsDirty = false;
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStageEvent);
         if(loaderInfo is LoaderInfo)
         {
            loaderInfo.addEventListener(Event.INIT,this.onLoadedInitEvent);
         }
      }
      
      protected function IsPlatformValueValid() : Boolean
      {
         return this._uiPlatform != PlatformUtils.PLATFORM_INVALID;
      }
      
      public function get uiPlatform() : uint
      {
         if(!this.IsPlatformValueValid())
         {
            GlobalFunc.TraceWarning("uiPlatform has been accessed before it has been set to a valid value!");
         }
         return this._uiPlatform;
      }
      
      protected function IsControllerValueValid() : Boolean
      {
         return this._uiController != PlatformUtils.PLATFORM_INVALID;
      }
      
      public function get uiController() : uint
      {
         if(!this.IsControllerValueValid())
         {
            GlobalFunc.TraceWarning("uiController has been accessed before it has been set to a valid value!");
         }
         return this._uiController;
      }
      
      public function get bIsDirty() : Boolean
      {
         return this._bIsDirty;
      }
      
      public function SetIsDirty() : void
      {
         this._bIsDirty = true;
         this.requestRedraw();
      }
      
      final private function ClearIsDirty() : void
      {
         this._bIsDirty = false;
      }
      
      final private function onLoadedInitEvent(param1:Event) : void
      {
         if(loaderInfo is LoaderInfo)
         {
            loaderInfo.removeEventListener(Event.INIT,this.onLoadedInitEvent);
         }
         this.onLoadedInit();
      }
      
      final private function onAddedToStageEvent(param1:Event) : void
      {
         var arEvent:Event = param1;
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStageEvent);
         this.onAddedToStage();
         if(this.bIsDirty)
         {
            this.requestRedraw();
         }
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStageEvent);
         BSUIDataManager.Subscribe("ControlMapData",function(param1:FromClientDataEvent):*
         {
            OnControlMapChanged(param1.data);
         });
         BSUIDataManager.Subscribe("PlatformData",function(param1:FromClientDataEvent):*
         {
            OnPlatformChanged(param1.data);
         });
      }
      
      final private function onRemovedFromStageEvent(param1:Event) : void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStageEvent);
         if(stage)
         {
            stage.removeEventListener(Event.RENDER,this.onRenderEvent);
         }
         this.onRemovedFromStage();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStageEvent);
      }
      
      final private function onRenderEvent(param1:Event) : void
      {
         this.renderObject();
      }
      
      final private function renderObject() : void
      {
         if(stage)
         {
            stage.removeEventListener(Event.RENDER,this.onRenderEvent);
         }
         if(this.bIsDirty)
         {
            this.ClearIsDirty();
            try
            {
               this.redrawDisplayObject();
            }
            catch(e:Error)
            {
               trace(this + " " + this.name + ": " + e.getStackTrace());
            }
         }
         GlobalFunc.BSASSERT(!this.bIsDirty,"BSDisplayObject: " + getQualifiedClassName(this) + ": " + this.name + ": redrawDisplayObject caused the object to be dirtied. This should never happen as it wont be rendered for that change until it changes for yet another reason later.");
      }
      
      public function redrawWithParent() : void
      {
         this.renderObject();
      }
      
      public function redrawDisplayObject() : void
      {
      }
      
      protected function OnControlMapChanged(param1:Object) : void
      {
         if(this._uiController != param1.uiController)
         {
            this._uiController = param1.uiController;
            this.SetIsDirty();
         }
      }
      
      protected function OnPlatformChanged(param1:Object) : void
      {
         if(this._uiPlatform != param1.uPlatform)
         {
            this._uiPlatform = param1.uPlatform;
            this.SetIsDirty();
         }
      }
      
      private function requestRedraw() : void
      {
         if(stage)
         {
            stage.addEventListener(Event.RENDER,this.onRenderEvent);
            stage.invalidate();
         }
      }
      
      public function onLoadedInit() : void
      {
      }
      
      public function onAddedToStage() : void
      {
      }
      
      public function onRemovedFromStage() : void
      {
      }
      
      override public function addChild(param1:DisplayObject) : DisplayObject
      {
         var _loc2_:DisplayObject = super.addChild(param1);
         if(this.onAddChild is Function)
         {
            this.onAddChild(param1,getQualifiedClassName(param1));
         }
         return _loc2_;
      }
      
      override public function removeChild(param1:DisplayObject) : DisplayObject
      {
         var _loc2_:DisplayObject = super.removeChild(param1);
         if(this.onRemoveChild is Function)
         {
            this.onRemoveChild(param1,getQualifiedClassName(param1));
         }
         return _loc2_;
      }
   }
}
