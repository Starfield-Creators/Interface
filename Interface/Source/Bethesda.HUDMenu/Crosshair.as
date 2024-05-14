package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   public class Crosshair extends BSDisplayObject
   {
      
      internal static const RETICLE_ANIMATION_LENGTH:uint = 60;
      
      internal static const RETICLE_START_FRAME:uint = 1;
      
      internal static const SPREAD_MIN:uint = 0;
      
      internal static const SPREAD_MAX:uint = 100;
      
      internal static const CROSSHAIR_NORMAL:uint = 1;
      
      internal static const CROSSHAIR_EFFECTIVE:uint = 2;
       
      
      public var Player_Pistol_ReticleAnim_mc:MovieClip;
      
      public var Player_Cutter_ReticleAnim_mc:MovieClip;
      
      public var Player_Unarmed_ReticleAnim_mc:MovieClip;
      
      public var Player_Shotgun_ReticleAnim_mc:MovieClip;
      
      public var Player_Rifle_ReticleAnim_mc:MovieClip;
      
      public var Player_Laser_ReticleAnim_mc:MovieClip;
      
      public var Player_Tool_ReticleAnim_mc:MovieClip;
      
      public var Player_Interaction_ReticleAnim_mc:MovieClip;
      
      public var Player_Command_ReticleAnim_mc:MovieClip;
      
      private const HCT_PISTOL:uint = EnumHelper.GetEnum(0);
      
      private const HCT_CUTTER:uint = EnumHelper.GetEnum();
      
      private const HCT_UNARMED:uint = EnumHelper.GetEnum();
      
      private const HCT_SHOTGUN:uint = EnumHelper.GetEnum();
      
      private const HCT_RIFLE:uint = EnumHelper.GetEnum();
      
      private const HCT_LASER:uint = EnumHelper.GetEnum();
      
      private const HCT_TOOL:uint = EnumHelper.GetEnum();
      
      private const HCT_INTERACT:uint = EnumHelper.GetEnum();
      
      private const HCT_COMMAND:uint = EnumHelper.GetEnum();
      
      private const HCT_NONE:uint = EnumHelper.GetEnum();
      
      private var UpOriginal:int = 0;
      
      private var DownOriginal:int = 0;
      
      private var LeftOriginal:int = 0;
      
      private var RightOriginal:int = 0;
      
      private var CurrReticleSpreadVal:Number = 0;
      
      public function Crosshair()
      {
         super();
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         this.UpOriginal = this.Player_Pistol_ReticleAnim_mc.CrosshairBase_mc.CrosshairUp_mc.y;
         this.DownOriginal = this.Player_Pistol_ReticleAnim_mc.CrosshairBase_mc.CrosshairDown_mc.y;
         this.LeftOriginal = this.Player_Pistol_ReticleAnim_mc.CrosshairBase_mc.CrosshairLeft_mc.x;
         this.RightOriginal = this.Player_Pistol_ReticleAnim_mc.CrosshairBase_mc.CrosshairRight_mc.x;
         BSUIDataManager.Subscribe("HudCrosshairData",this.onCrosshairDataChange);
      }
      
      private function SetCrossairEffectiveColor(param1:MovieClip, param2:Object) : *
      {
         var _loc3_:uint = !!param2.bShowEffectiveColor ? CROSSHAIR_EFFECTIVE : CROSSHAIR_NORMAL;
         if(Boolean(param1) && _loc3_ != param1.currentFrame)
         {
            param1.gotoAndStop(!!param2.bShowEffectiveColor ? CROSSHAIR_EFFECTIVE : CROSSHAIR_NORMAL);
         }
      }
      
      public function onCrosshairDataChange(param1:FromClientDataEvent) : *
      {
         var _loc2_:Object = null;
         var _loc4_:Number = NaN;
         var _loc5_:* = false;
         var _loc6_:MovieClip = null;
         _loc2_ = param1.data;
         var _loc3_:* = this.currentFrame != _loc2_.uType + 1;
         this.gotoAndStop(_loc2_.uType + 1);
         if(Boolean(_loc2_.bEnabled) && (!_loc2_.bIronSights || _loc2_.bIn3rdPerson || Boolean(_loc2_.bIsToolGrip)))
         {
            this.visible = true;
            _loc4_ = GlobalFunc.MapLinearlyToRange(RETICLE_START_FRAME,RETICLE_ANIMATION_LENGTH,SPREAD_MAX,SPREAD_MIN,_loc2_.fSpreadPercent,true);
            _loc5_ = !GlobalFunc.CloseToNumber(_loc4_,this.CurrReticleSpreadVal);
            this.CurrReticleSpreadVal = _loc4_;
            switch(_loc2_.uType)
            {
               case this.HCT_PISTOL:
                  _loc4_ = (_loc2_.fSpreadPercent - 100) * -0.5;
                  _loc6_ = this.Player_Pistol_ReticleAnim_mc;
                  this.Player_Pistol_ReticleAnim_mc.CrosshairBase_mc.CrosshairUp_mc.y = this.UpOriginal - _loc4_;
                  this.Player_Pistol_ReticleAnim_mc.CrosshairBase_mc.CrosshairDown_mc.y = this.DownOriginal + _loc4_;
                  this.Player_Pistol_ReticleAnim_mc.CrosshairBase_mc.CrosshairLeft_mc.x = this.LeftOriginal - _loc4_;
                  this.Player_Pistol_ReticleAnim_mc.CrosshairBase_mc.CrosshairRight_mc.x = this.RightOriginal + _loc4_;
                  this.SetCrossairEffectiveColor(this.Player_Pistol_ReticleAnim_mc.CrosshairBase_mc,_loc2_);
                  break;
               case this.HCT_CUTTER:
                  _loc6_ = this.Player_Cutter_ReticleAnim_mc;
                  if(_loc5_)
                  {
                     this.Player_Cutter_ReticleAnim_mc.gotoAndStop(this.CurrReticleSpreadVal);
                  }
                  this.SetCrossairEffectiveColor(_loc6_.CrosshairBase_mc,_loc2_);
                  break;
               case this.HCT_UNARMED:
                  _loc6_ = this.Player_Unarmed_ReticleAnim_mc;
                  break;
               case this.HCT_SHOTGUN:
                  _loc6_ = this.Player_Shotgun_ReticleAnim_mc;
                  if(_loc5_)
                  {
                     this.Player_Shotgun_ReticleAnim_mc.gotoAndStop(this.CurrReticleSpreadVal);
                  }
                  this.SetCrossairEffectiveColor(_loc6_.CrosshairBase_mc,_loc2_);
                  break;
               case this.HCT_RIFLE:
                  _loc6_ = this.Player_Rifle_ReticleAnim_mc;
                  if(_loc5_)
                  {
                     this.Player_Rifle_ReticleAnim_mc.gotoAndStop(this.CurrReticleSpreadVal);
                  }
                  this.SetCrossairEffectiveColor(_loc6_.CrosshairTL_mc,_loc2_);
                  this.SetCrossairEffectiveColor(_loc6_.CrosshairTR_mc,_loc2_);
                  this.SetCrossairEffectiveColor(_loc6_.CrosshairBL_mc,_loc2_);
                  this.SetCrossairEffectiveColor(_loc6_.CrosshairBR_mc,_loc2_);
                  this.SetCrossairEffectiveColor(_loc6_.CrosshairBase_mc,_loc2_);
                  break;
               case this.HCT_LASER:
                  _loc6_ = this.Player_Laser_ReticleAnim_mc;
                  if(_loc5_)
                  {
                     this.Player_Laser_ReticleAnim_mc.gotoAndStop(this.CurrReticleSpreadVal);
                  }
                  this.SetCrossairEffectiveColor(_loc6_.CrosshairLeft_mc,_loc2_);
                  this.SetCrossairEffectiveColor(_loc6_.CrosshairRight_mc,_loc2_);
                  this.SetCrossairEffectiveColor(_loc6_.CrosshairBase_mc,_loc2_);
                  break;
               case this.HCT_TOOL:
                  _loc6_ = this.Player_Tool_ReticleAnim_mc;
                  if(_loc5_)
                  {
                     this.Player_Tool_ReticleAnim_mc.gotoAndStop(this.CurrReticleSpreadVal);
                  }
                  this.SetCrossairEffectiveColor(_loc6_.CrosshairTL_mc,_loc2_);
                  this.SetCrossairEffectiveColor(_loc6_.CrosshairTR_mc,_loc2_);
                  this.SetCrossairEffectiveColor(_loc6_.CrosshairBL_mc,_loc2_);
                  this.SetCrossairEffectiveColor(_loc6_.CrosshairBR_mc,_loc2_);
                  this.SetCrossairEffectiveColor(_loc6_.CrosshairBase_mc,_loc2_);
                  break;
               case this.HCT_INTERACT:
                  _loc6_ = this.Player_Interaction_ReticleAnim_mc;
                  break;
               case this.HCT_COMMAND:
                  _loc6_ = this.Player_Command_ReticleAnim_mc;
                  if(_loc3_)
                  {
                     this.Player_Command_ReticleAnim_mc.gotoAndPlay("Open");
                  }
                  break;
               case this.HCT_NONE:
                  this.visible = false;
                  break;
               default:
                  GlobalFunc.TraceWarning("Unsupported reticle type!");
                  this.visible = false;
            }
         }
         else
         {
            this.visible = false;
         }
      }
   }
}
