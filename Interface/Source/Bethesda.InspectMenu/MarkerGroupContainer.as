package
{
   import Components.Icons.MapIconsLibrary;
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import Shared.GlobalFunc;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class MarkerGroupContainer extends BSDisplayObject
   {
      
      public static const StarMapMenu_MarkerGroupContainerVisibilityChanged:String = "StarMapMenu_MarkerGroupContainerVisibilityChanged";
       
      
      public var PlayerShip_mc:MovieClip;
      
      public var ContainerHitbox_mc:MovieClip;
      
      public var POIBlocker_mc:MovieClip;
      
      public var PlayerMarker_mc:MovieClip;
      
      private const MARKER_ENTRY_PADDING:uint = 5;
      
      private const PLAYER_MARKER_OFFSET:int = -47;
      
      private var Entries:Array;
      
      private var ShipMarkerEntry:MarkerGroupEntry;
      
      private var CurrentHighlightedEntry:MarkerGroupEntry;
      
      private var MarkerGroupEntryContainer:MovieClip;
      
      private var HitboxHeight:Number = 0;
      
      public function MarkerGroupContainer()
      {
         this.MarkerGroupEntryContainer = new MovieClip();
         super();
         GlobalFunc.SetText(this.PlayerShip_mc.PlayerShipText_mc.text_tf,"$MY SHIP");
      }
      
      override public function get visible() : Boolean
      {
         return super.visible;
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         BSUIDataManager.dispatchEvent(new CustomEvent(StarMapMenu_MarkerGroupContainerVisibilityChanged,{"isVisible":param1}));
      }
      
      override public function onAddedToStage() : void
      {
         this.HitboxHeight = this.ContainerHitbox_mc.height;
         addChild(this.MarkerGroupEntryContainer);
         this.PlayerShip_mc.addEventListener(MouseEvent.ROLL_OVER,function(param1:MouseEvent):*
         {
            CurrentHighlightedEntry = ShipMarkerEntry;
            GlobalFunc.PlayMenuSound("UIMenuSurfaceMapRollover");
            PlayerShip_mc.gotoAndPlay("idle_to_over");
         });
         this.PlayerShip_mc.addEventListener(MouseEvent.ROLL_OUT,function(param1:MouseEvent):*
         {
            CurrentHighlightedEntry = null;
            PlayerShip_mc.gotoAndPlay("over_to_idle");
         });
      }
      
      public function Populate(param1:Array, param2:DisplayObject) : *
      {
         var _loc5_:MarkerGroupEntry = null;
         this.MarkerGroupEntryContainer.y = 0;
         this.MarkerGroupEntryContainer.removeChildren();
         this.ShipMarkerEntry = null;
         this.Entries = param1;
         this.SetPlayerShipVisible(false);
         this.PlayerMarker_mc.visible = false;
         this.ContainerHitbox_mc.width = 0;
         var _loc3_:uint = 0;
         while(_loc3_ < this.Entries.length)
         {
            if((_loc5_ = this.Entries[_loc3_]).HasPlayerMarker)
            {
               this.PlayerMarker_mc.visible = true;
            }
            if((_loc5_ as MarkerGroupEntry).MarkerData.type == MarkerGroupEntry.MARKER_TYPE_SHIP)
            {
               this.SetPlayerShipVisible(true);
               this.ShipMarkerEntry = _loc5_;
            }
            else
            {
               _loc5_.x = 0;
               _loc5_.y = _loc5_.height * this.MarkerGroupEntryContainer.numChildren;
               _loc5_.y += _loc3_ > 0 ? this.MARKER_ENTRY_PADDING : 0;
               _loc5_.addEventListener(MarkerGroupEntry.StarMapMenu_MarkerGroupEntryHighlighted,this.OnEntryHighlighted);
               _loc5_.addEventListener(MarkerGroupEntry.StarMapMenu_MarkerGroupEntryUnhighlighted,this.OnEntryUnhighlighted);
               this.MarkerGroupEntryContainer.addChild(_loc5_);
               if(this.ContainerHitbox_mc.width < _loc5_.hitboxWidth)
               {
                  this.ContainerHitbox_mc.width = _loc5_.hitboxWidth;
               }
            }
            _loc3_++;
         }
         var _loc4_:* = this.PlayerShip_mc.visible ? this.Entries.length - 1 : this.Entries.length;
         this.ContainerHitbox_mc.height = this.HitboxHeight * _loc4_;
         if(this.MarkerGroupEntryContainer.hitTestObject(param2))
         {
            this.MarkerGroupEntryContainer.y = -(this.ContainerHitbox_mc.height - this.Entries[0].height / 2);
         }
         this.PlayerMarker_mc.y = this.PLAYER_MARKER_OFFSET + this.MarkerGroupEntryContainer.y;
         this.ContainerHitbox_mc.y = this.MarkerGroupEntryContainer.y;
      }
      
      public function SetPlayerShipVisible(param1:Boolean) : *
      {
         this.PlayerShip_mc.visible = param1;
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(this.CurrentHighlightedEntry != null)
         {
            _loc3_ = this.CurrentHighlightedEntry.ProcessUserEvent(param1,param2);
         }
         return _loc3_;
      }
      
      public function LoadEntryIcons(param1:MapIconsLibrary) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:MarkerGroupEntry = null;
         for(_loc2_ in this.Entries)
         {
            _loc3_ = _loc2_ as MarkerGroupEntry;
            if(_loc3_.needsLocationLoaded)
            {
               _loc3_.LoadLocationIcon(param1);
            }
         }
      }
      
      private function OnEntryHighlighted(param1:CustomEvent) : void
      {
         this.CurrentHighlightedEntry = param1.params.aEntry;
      }
      
      private function OnEntryUnhighlighted(param1:CustomEvent) : void
      {
         if(param1.params.aEntry == this.CurrentHighlightedEntry)
         {
            this.CurrentHighlightedEntry = null;
         }
      }
   }
}
