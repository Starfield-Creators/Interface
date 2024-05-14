package
{
   import Components.Icons.DynamicPoiIcon;
   import Components.StarMapWidgets.SystemView;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.BSGalaxyTypes;
   import Shared.Components.ContentLoaders.LibraryLoader;
   import Shared.Components.ContentLoaders.LibraryLoaderConfig;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class LocationTextWidget extends MovieClip
   {
      
      public static const LOCATION_DISCOVERY_END:String = "LocationTextWidget_LocationDiscoveryEnd";
      
      public static const FINSHED_QUEUE:String = "LocationTextWidget_FinishedQueue";
      
      public static const SYSTEM_VIEW_PLANET_SCALE:Number = 1;
      
      public static const SYSTEM_VIEW_MOON_SCALE:Number = 1;
       
      
      public var LocationTextAnim_mc:MovieClip;
      
      public var PlanetLocationTextAnim_mc:MovieClip;
      
      private var Playing:Boolean = false;
      
      private var CurrentAnimClip:MovieClip = null;
      
      private var QueuedMessages:Array;
      
      private var TraitIconsLoader:LibraryLoader;
      
      public function LocationTextWidget()
      {
         this.QueuedMessages = new Array();
         super();
         this.TraitIconsLoader = new LibraryLoader(LibraryLoaderConfig.PLANET_TRAITS_LIBRARY_CONFIG);
         BSUIDataManager.Subscribe("HUDLocationData",this.OnLocationDataChange);
         this.LocationTextAnim_mc.addEventListener(LOCATION_DISCOVERY_END,this.OnAnimEnd);
         this.PlanetLocationTextAnim_mc.addEventListener(LOCATION_DISCOVERY_END,this.OnAnimEnd);
      }
      
      public function get LocationDiscoveredText_mc() : MovieClip
      {
         return this.CurrentAnimClip != null ? this.CurrentAnimClip.LocationDiscoveredText_mc : null;
      }
      
      public function get LocationText_mc() : MovieClip
      {
         return this.CurrentAnimClip != null ? this.CurrentAnimClip.LocationText_mc : null;
      }
      
      private function OnAnimEnd() : *
      {
         this.Playing = false;
         this.TryPlayNextAnim(true);
      }
      
      private function GetDesiredSystemScale() : Number
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc1_:Number = 1;
         var _loc2_:SystemView = this.PlanetLocationTextAnim_mc.SpaceLocationIcon_mc.SystemView_mc;
         if(Boolean(_loc2_) && _loc2_.NumChildren > 0)
         {
            _loc3_ = _loc2_.GetTargetChildX(_loc2_.NumChildren - 1) + _loc2_.GetChildSpacingX() / 2;
            _loc4_ = this.PlanetLocationTextAnim_mc.SpaceLocationIcon_mc.width / 2;
            _loc1_ = GlobalFunc.Clamp(_loc4_ / _loc3_,0.01,1);
         }
         return _loc1_;
      }
      
      private function TryPlayNextAnim(param1:Boolean = false) : *
      {
         var _loc2_:Object = null;
         var _loc3_:MovieClip = null;
         if(this.QueuedMessages.length > 0 && visible && !this.Playing)
         {
            _loc2_ = this.QueuedMessages[0];
            this.QueuedMessages.splice(0,1);
            if(_loc2_.uCelestialType != BSGalaxyTypes.BT_UNDEFINED)
            {
               this.CurrentAnimClip = this.PlanetLocationTextAnim_mc;
               this.CurrentAnimClip.LocationIcon_mc.visible = false;
               this.CurrentAnimClip.LocationDetailsText_mc.LocationDetailsBackground_mc.visible = true;
               this.PlanetLocationTextAnim_mc.SpaceLocationIcon_mc.UpdateSystemView(_loc2_.SystemBodyInfo,_loc2_.SystemBodyInfo.focusedCelestialBodyID);
               this.PlanetLocationTextAnim_mc.SpaceLocationIcon_mc.gotoAndPlay("Open");
               switch(_loc2_.uCelestialType)
               {
                  case BSGalaxyTypes.BT_MOON:
                     GlobalFunc.SetText(this.CurrentAnimClip.LocationDetailsText_mc.LocationDetailsText_tf,"$SYSTEM SUBTITLE MOON",false,false,0,false,0,new Array(_loc2_.sSubtitle,_loc2_.SystemBodyInfo.systemName));
                     this.PlanetLocationTextAnim_mc.SpaceLocationIcon_mc.FocusBody(_loc2_.SystemBodyInfo.focusedBodyID,SYSTEM_VIEW_PLANET_SCALE);
                     break;
                  case BSGalaxyTypes.BT_PLANET:
                     GlobalFunc.SetText(this.CurrentAnimClip.LocationDetailsText_mc.LocationDetailsText_tf,"$SYSTEM SUBTITLE",false,false,0,false,0,new Array(_loc2_.SystemBodyInfo.systemName));
                     this.PlanetLocationTextAnim_mc.SpaceLocationIcon_mc.FocusBody(_loc2_.SystemBodyInfo.focusedBodyID,SYSTEM_VIEW_MOON_SCALE);
                     break;
                  default:
                     GlobalFunc.SetText(this.CurrentAnimClip.LocationDetailsText_mc.LocationDetailsText_tf,"");
                     this.PlanetLocationTextAnim_mc.SpaceLocationIcon_mc.FocusBody(0,this.GetDesiredSystemScale());
               }
            }
            else
            {
               this.CurrentAnimClip = this.LocationTextAnim_mc;
               GlobalFunc.SetText(this.CurrentAnimClip.LocationDetailsText_mc.LocationDetailsText_tf,"");
               this.CurrentAnimClip.LocationDetailsText_mc.LocationDetailsBackground_mc.visible = false;
               if(_loc2_.sIconLinkageName != "")
               {
                  this.CurrentAnimClip.TraitIcon_mc.visible = true;
                  this.CurrentAnimClip.LocationIcon_mc.visible = false;
                  _loc3_ = this.TraitIconsLoader.LoadClip(_loc2_.sIconLinkageName);
                  if(_loc3_ != null)
                  {
                     _loc3_.width = this.CurrentAnimClip.TraitIcon_mc.width;
                     _loc3_.height = this.CurrentAnimClip.TraitIcon_mc.height;
                     this.CurrentAnimClip.TraitIcon_mc.Icon_mc.removeChildren();
                     this.CurrentAnimClip.TraitIcon_mc.Icon_mc.addChild(_loc3_);
                  }
               }
               else
               {
                  this.CurrentAnimClip.TraitIcon_mc.visible = false;
                  this.CurrentAnimClip.LocationIcon_mc.visible = true;
                  this.CurrentAnimClip.LocationIcon_mc.SetLocation(_loc2_.uPoiType,0,DynamicPoiIcon.GetSpaceMarkerState(true));
               }
            }
            GlobalFunc.SetText(this.LocationText_mc.LocationText_tf,_loc2_.sLocationName);
            this.LocationDiscoveredText_mc.visible = Boolean(_loc2_.bDiscovered) && _loc2_.uCelestialType == BSGalaxyTypes.BT_UNDEFINED;
            if(this.LocationDiscoveredText_mc.visible)
            {
               GlobalFunc.SetText(this.LocationDiscoveredText_mc.LocationDiscoveredText_tf,_loc2_.sSubtitle);
            }
            this.CurrentAnimClip.gotoAndPlay(2);
            if(this.LocationDiscoveredText_mc != null && this.LocationDiscoveredText_mc.visible)
            {
               GlobalFunc.PlayMenuSound("UIDiscoverLocation");
            }
            else if(this.CurrentAnimClip.TraitIcon_mc != null && Boolean(this.CurrentAnimClip.TraitIcon_mc.visible))
            {
               GlobalFunc.PlayMenuSound("UIMenuMonocleScannerTraitDiscovered");
            }
            this.Playing = true;
         }
         else if(this.QueuedMessages.length == 0 && param1)
         {
            BSUIDataManager.dispatchEvent(new Event(FINSHED_QUEUE));
         }
      }
      
      private function OnLocationDataChange(param1:FromClientDataEvent) : *
      {
         var _loc2_:Object = null;
         for each(_loc2_ in param1.data.LocationsA)
         {
            this.QueuedMessages.push(_loc2_);
         }
         this.TryPlayNextAnim();
      }
      
      public function SetVisible(param1:Boolean) : *
      {
         if(visible != param1)
         {
            visible = param1;
            this.TryPlayNextAnim();
         }
      }
   }
}
