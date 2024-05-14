package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class EnemyHealthMeter extends MovieClip
   {
      
      internal static const FADED_IN_FRAME:uint = 10;
      
      internal static const FADED_OUT_FRAME:uint = 20;
      
      internal static const STANDARD_LABEL:String = "Standard";
      
      internal static const MAX_LEGENDARY_RANK:uint = 3;
      
      internal static const LEGENDARY_FRAME_SEGMENTS:Array = [0,21,41,60];
      
      internal static const LEGENDARY_HEALTH_SEGMENT_PERCENTAGE:Number = 1 / Number(LEGENDARY_FRAME_SEGMENTS.length);
      
      internal static const ENEMY_NAME_MAX_CHARACTERS:uint = 14;
       
      
      public var EnemyHealthAnimBase_mc:MovieClip;
      
      private var EnemyIcon_mc:MovieClip;
      
      private var EnemyName_tf:TextField;
      
      private var EnemyShieldAnim_mc:MovieClip;
      
      private var EnemyHealthBarAnim_mc:MovieClip;
      
      private var EnemyHealthBarAnim_Legendary_mc:MovieClip;
      
      private var EMDamageBar_mc:MovieClip;
      
      private var EMIndicatorBackground_mc:MovieClip;
      
      private var currLegendaryRank:int = -1;
      
      private var currLegendarySegment:int = -1;
      
      private var bIsStunned:Boolean = false;
      
      private var EnemyNameMaxLength:uint = 0;
      
      public function EnemyHealthMeter()
      {
         super();
         this.EnemyIcon_mc = this.EnemyHealthAnimBase_mc.EnemyIcon_mc;
         this.EnemyName_tf = this.EnemyHealthAnimBase_mc.EnemyName_tf;
         this.EnemyShieldAnim_mc = this.EnemyHealthAnimBase_mc.EnemyShieldAnim_mc;
         this.EnemyHealthBarAnim_mc = this.EnemyHealthAnimBase_mc.EnemyHealthBarAnim_mc;
         this.EnemyHealthBarAnim_Legendary_mc = this.EnemyHealthAnimBase_mc.EnemyHealthBarAnim_Legendary_mc;
         this.EMDamageBar_mc = this.EnemyHealthAnimBase_mc.EMDamageBar_mc;
         this.EMIndicatorBackground_mc = this.EMDamageBar_mc.EMIndicatorBackground_mc;
         this.EMDamageBar_mc.visible = false;
         Extensions.enabled = true;
         if(this.EnemyNameMaxLength == 0)
         {
            TextFieldEx.setTextAutoSize(this.EnemyName_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         }
         this.visible = true;
         this.gotoAndStop(FADED_OUT_FRAME);
         BSUIDataManager.Subscribe("HudEnemyData",this.UpdateEnemyHealthData);
      }
      
      private function UpdateEnemyHealthData(param1:FromClientDataEvent) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:uint = 0;
         var _loc2_:Boolean = false;
         var _loc3_:uint = 0;
         while(!_loc2_ && param1.data.EnemiesA && _loc3_ < param1.data.EnemiesA.length)
         {
            if(param1.data.EnemiesA[_loc3_].uID == param1.data.uTargetUnderCrosshairID)
            {
               _loc4_ = param1.data.EnemiesA[_loc3_];
               _loc2_ = true;
               this.SetVisible(_loc4_.bOnScreen == true);
               if(Boolean(_loc4_.bIsLegendary) || _loc4_.uLegendaryRank > 0)
               {
                  if(this.currLegendaryRank != _loc4_.uLegendaryRank)
                  {
                     this.currLegendaryRank = _loc4_.uLegendaryRank;
                     this.EnemyHealthAnimBase_mc.gotoAndStop("Legendary_Rank" + GlobalFunc.Clamp(_loc4_.uLegendaryRank,1,MAX_LEGENDARY_RANK).toString());
                  }
                  _loc5_ = LEGENDARY_FRAME_SEGMENTS.length - 1;
                  _loc6_ = Math.floor(_loc4_.fHealth / LEGENDARY_HEALTH_SEGMENT_PERCENTAGE);
                  _loc6_ = GlobalFunc.Clamp(_loc6_,0,_loc5_);
                  _loc7_ = (_loc4_.fHealth - _loc6_ * LEGENDARY_HEALTH_SEGMENT_PERCENTAGE) / LEGENDARY_HEALTH_SEGMENT_PERCENTAGE;
                  if((_loc8_ = uint(LEGENDARY_FRAME_SEGMENTS[GlobalFunc.Clamp(_loc5_ - _loc6_,0,_loc5_)])) != this.currLegendarySegment)
                  {
                     this.currLegendarySegment = _loc8_;
                     this.EnemyHealthBarAnim_Legendary_mc.gotoAndStop(LEGENDARY_FRAME_SEGMENTS[GlobalFunc.Clamp(_loc5_ - _loc6_,0,_loc5_)]);
                  }
                  this.EnemyHealthBarAnim_mc.Fill_mc.width = GlobalFunc.MapLinearlyToRange(0,this.EnemyHealthBarAnim_mc.BG_mc.width,0,1,_loc7_,true);
               }
               else
               {
                  this.currLegendaryRank = -1;
                  this.currLegendarySegment = -1;
                  if(this.EnemyHealthAnimBase_mc.currentFrameLabel != STANDARD_LABEL)
                  {
                     this.EnemyHealthAnimBase_mc.gotoAndStop(STANDARD_LABEL);
                  }
                  this.EnemyHealthBarAnim_mc.Fill_mc.width = GlobalFunc.MapLinearlyToRange(0,this.EnemyHealthBarAnim_mc.BG_mc.width,0,1,_loc4_.fHealth,true);
               }
               if(_loc4_.fElectromagneticHealth < 1 || Boolean(_loc4_.bIsStunned))
               {
                  this.EMDamageBar_mc.visible = true;
                  this.EMDamageBar_mc.EMIndicatorBar_mc.Fill_mc.width = !!_loc4_.bIsStunned ? GlobalFunc.MapLinearlyToRange(0,this.EMDamageBar_mc.EMIndicatorBar_mc.BG_mc.width,0,1,_loc4_.fElectromagneticShockTimeMax != 0 ? _loc4_.fElectromagneticShockTimeLeft / _loc4_.fElectromagneticShockTimeMax : 1,true) : GlobalFunc.MapLinearlyToRange(0,this.EMDamageBar_mc.EMIndicatorBar_mc.BG_mc.width,0,1,1 - _loc4_.fElectromagneticHealth,true);
                  if(_loc4_.bIsStunned)
                  {
                     if(!this.bIsStunned)
                     {
                        this.EMIndicatorBackground_mc.gotoAndPlay("Blink");
                     }
                  }
                  else
                  {
                     this.EMIndicatorBackground_mc.gotoAndStop("Normal");
                  }
                  this.bIsStunned = _loc4_.bIsStunned;
               }
               else
               {
                  this.EMDamageBar_mc.visible = false;
               }
               GlobalFunc.SetText(this.EnemyName_tf,_loc4_.sName,false,false,this.EnemyNameMaxLength);
               this.SetPosition(loaderInfo.width * _loc4_.fScreenPositionX,loaderInfo.height * (1 - _loc4_.fScreenPositionY));
               this.EnemyHealthAnimBase_mc.LegendaryIcon_mc.visible = _loc4_.bIsLegendary;
               GlobalFunc.SetText(this.EnemyHealthAnimBase_mc.LevelNumber_mc.LevelNumber_tf,_loc4_.uEnemyDifficultyLevel);
            }
            _loc3_++;
         }
         if(!_loc2_)
         {
            this.SetVisible(false);
         }
      }
      
      public function SetPosition(param1:Number, param2:Number) : *
      {
         this.x = param1;
         this.y = param2;
      }
      
      public function SetVisible(param1:Boolean) : *
      {
         var _loc2_:uint = uint(this.currentFrame);
         switch(_loc2_)
         {
            case FADED_IN_FRAME:
               if(!param1)
               {
                  gotoAndPlay("FadeOut");
               }
               break;
            case FADED_OUT_FRAME:
               if(param1)
               {
                  gotoAndPlay("FadeIn");
               }
               break;
            default:
               if(_loc2_ < FADED_IN_FRAME && !param1)
               {
                  gotoAndPlay(FADED_IN_FRAME + (FADED_IN_FRAME - _loc2_));
               }
               else if(_loc2_ > FADED_IN_FRAME && _loc2_ < FADED_OUT_FRAME && param1)
               {
                  gotoAndPlay(FADED_IN_FRAME - (_loc2_ - FADED_IN_FRAME));
               }
         }
      }
   }
}
