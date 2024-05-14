package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.IMenu;
   import Shared.GlobalFunc;
   import fl.motion.AnimatorFactory3D;
   import fl.motion.MotionBase;
   import fl.motion.motion_internal;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.filters.*;
   import flash.geom.Matrix3D;
   import flash.geom.Point;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import scaleform.gfx.Extensions;
   
   public class HUDMenu extends IMenu
   {
      
      public static var CENTER_GROUP_POINT:Point = new Point(0,0);
       
      
      public var __animFactory_RightMeters_mcaf1:AnimatorFactory3D;
      
      public var __animArray_RightMeters_mcaf1:Array;
      
      public var ____motion_RightMeters_mcaf1_mat3DVec__:Vector.<Number>;
      
      public var ____motion_RightMeters_mcaf1_matArray__:Array;
      
      public var __motion_RightMeters_mcaf1:MotionBase;
      
      public var __animFactory_BottomLeftGroup_mcaf1:AnimatorFactory3D;
      
      public var __animArray_BottomLeftGroup_mcaf1:Array;
      
      public var ____motion_BottomLeftGroup_mcaf1_mat3DVec__:Vector.<Number>;
      
      public var ____motion_BottomLeftGroup_mcaf1_matArray__:Array;
      
      public var __motion_BottomLeftGroup_mcaf1:MotionBase;
      
      public var FloatingQuestMarkerBase:MovieClip;
      
      public var EnemyHealthMeter_mc:MovieClip;
      
      public var EnemyHealthHolder_mc:MovieClip;
      
      public var HitDamageBase_mc:HitDamageIndicator;
      
      public var TopCenterGroup_mc:MovieClip;
      
      public var HitAndKillIndicator_mc:MovieClip;
      
      public var JetpackMeterAnim_mc:MovieClip;
      
      public var CenterGroup_mc:MovieClip;
      
      public var RolloverWidget_mc:HUDRolloverWidget;
      
      public var SocialCommandIcons_mc:HUDSocialCommandIconWidget;
      
      public var CrewBuffWidget_mc:OutpostCrewBuffWidget;
      
      public var BottomLeftGroup_mc:MovieClip;
      
      public var RightMeters_mc:MovieClip;
      
      private var SkillPatchLoader:Loader = null;
      
      public function HUDMenu()
      {
         super();
         Extensions.enabled = true;
         Extensions.noInvisibleAdvance = true;
         this.SkillPatchLoader = new Loader();
         var _loc1_:URLRequest = new URLRequest("SkillPatches.swf");
         var _loc2_:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
         this.SkillPatchLoader.load(_loc1_,_loc2_);
         addEventListener(Event.ADDED_TO_STAGE,this.__setPerspectiveProjection_);
         if(this.__animFactory_RightMeters_mcaf1 == null)
         {
            this.__animArray_RightMeters_mcaf1 = new Array();
            this.__motion_RightMeters_mcaf1 = new MotionBase();
            this.__motion_RightMeters_mcaf1.duration = 1;
            this.__motion_RightMeters_mcaf1.overrideTargetTransform();
            this.__motion_RightMeters_mcaf1.addPropertyArray("blendMode",["normal"]);
            this.__motion_RightMeters_mcaf1.addPropertyArray("cacheAsBitmap",[false]);
            this.__motion_RightMeters_mcaf1.addPropertyArray("opaqueBackground",[null]);
            this.__motion_RightMeters_mcaf1.addPropertyArray("visible",[true]);
            this.__motion_RightMeters_mcaf1.is3D = true;
            this.__motion_RightMeters_mcaf1.motion_internal::spanStart = 0;
            this.____motion_RightMeters_mcaf1_matArray__ = new Array();
            this.____motion_RightMeters_mcaf1_mat3DVec__ = new Vector.<Number>(16);
            this.____motion_RightMeters_mcaf1_mat3DVec__[0] = 0.958322;
            this.____motion_RightMeters_mcaf1_mat3DVec__[1] = 0;
            this.____motion_RightMeters_mcaf1_mat3DVec__[2] = -0.285688;
            this.____motion_RightMeters_mcaf1_mat3DVec__[3] = 0;
            this.____motion_RightMeters_mcaf1_mat3DVec__[4] = -0.014952;
            this.____motion_RightMeters_mcaf1_mat3DVec__[5] = 0.99863;
            this.____motion_RightMeters_mcaf1_mat3DVec__[6] = -0.050155;
            this.____motion_RightMeters_mcaf1_mat3DVec__[7] = 0;
            this.____motion_RightMeters_mcaf1_mat3DVec__[8] = 0.285297;
            this.____motion_RightMeters_mcaf1_mat3DVec__[9] = 0.052336;
            this.____motion_RightMeters_mcaf1_mat3DVec__[10] = 0.957009;
            this.____motion_RightMeters_mcaf1_mat3DVec__[11] = 0;
            this.____motion_RightMeters_mcaf1_mat3DVec__[12] = 1879.831787;
            this.____motion_RightMeters_mcaf1_mat3DVec__[13] = 1042.355225;
            this.____motion_RightMeters_mcaf1_mat3DVec__[14] = 16.766846;
            this.____motion_RightMeters_mcaf1_mat3DVec__[15] = 1;
            this.____motion_RightMeters_mcaf1_matArray__.push(new Matrix3D(this.____motion_RightMeters_mcaf1_mat3DVec__));
            this.__motion_RightMeters_mcaf1.addPropertyArray("matrix3D",this.____motion_RightMeters_mcaf1_matArray__);
            this.__animArray_RightMeters_mcaf1.push(this.__motion_RightMeters_mcaf1);
            this.__animFactory_RightMeters_mcaf1 = new AnimatorFactory3D(null,this.__animArray_RightMeters_mcaf1);
            this.__animFactory_RightMeters_mcaf1.sceneName = "Scene 1";
            this.__animFactory_RightMeters_mcaf1.addTargetInfo(this,"RightMeters_mc",0,true,0,true,null,-1);
         }
         if(this.__animFactory_BottomLeftGroup_mcaf1 == null)
         {
            this.__animArray_BottomLeftGroup_mcaf1 = new Array();
            this.__motion_BottomLeftGroup_mcaf1 = new MotionBase();
            this.__motion_BottomLeftGroup_mcaf1.duration = 1;
            this.__motion_BottomLeftGroup_mcaf1.overrideTargetTransform();
            this.__motion_BottomLeftGroup_mcaf1.addPropertyArray("blendMode",["normal"]);
            this.__motion_BottomLeftGroup_mcaf1.addPropertyArray("cacheAsBitmap",[false]);
            this.__motion_BottomLeftGroup_mcaf1.addPropertyArray("opaqueBackground",[null]);
            this.__motion_BottomLeftGroup_mcaf1.addPropertyArray("visible",[true]);
            this.__motion_BottomLeftGroup_mcaf1.is3D = true;
            this.__motion_BottomLeftGroup_mcaf1.motion_internal::spanStart = 0;
            this.____motion_BottomLeftGroup_mcaf1_matArray__ = new Array();
            this.____motion_BottomLeftGroup_mcaf1_mat3DVec__ = new Vector.<Number>(16);
            this.____motion_BottomLeftGroup_mcaf1_mat3DVec__[0] = 1.065422;
            this.____motion_BottomLeftGroup_mcaf1_mat3DVec__[1] = -0.06871;
            this.____motion_BottomLeftGroup_mcaf1_mat3DVec__[2] = -0.150934;
            this.____motion_BottomLeftGroup_mcaf1_mat3DVec__[3] = 0;
            this.____motion_BottomLeftGroup_mcaf1_mat3DVec__[4] = -0.037639;
            this.____motion_BottomLeftGroup_mcaf1_mat3DVec__[5] = 1.062183;
            this.____motion_BottomLeftGroup_mcaf1_mat3DVec__[6] = 0.191458;
            this.____motion_BottomLeftGroup_mcaf1_mat3DVec__[7] = 0;
            this.____motion_BottomLeftGroup_mcaf1_mat3DVec__[8] = 0.127329;
            this.____motion_BottomLeftGroup_mcaf1_mat3DVec__[9] = -0.171576;
            this.____motion_BottomLeftGroup_mcaf1_mat3DVec__[10] = 0.976908;
            this.____motion_BottomLeftGroup_mcaf1_mat3DVec__[11] = 0;
            this.____motion_BottomLeftGroup_mcaf1_mat3DVec__[12] = 41.719982;
            this.____motion_BottomLeftGroup_mcaf1_mat3DVec__[13] = 807.84552;
            this.____motion_BottomLeftGroup_mcaf1_mat3DVec__[14] = -4.454321;
            this.____motion_BottomLeftGroup_mcaf1_mat3DVec__[15] = 1;
            this.____motion_BottomLeftGroup_mcaf1_matArray__.push(new Matrix3D(this.____motion_BottomLeftGroup_mcaf1_mat3DVec__));
            this.__motion_BottomLeftGroup_mcaf1.addPropertyArray("matrix3D",this.____motion_BottomLeftGroup_mcaf1_matArray__);
            this.__animArray_BottomLeftGroup_mcaf1.push(this.__motion_BottomLeftGroup_mcaf1);
            this.__animFactory_BottomLeftGroup_mcaf1 = new AnimatorFactory3D(null,this.__animArray_BottomLeftGroup_mcaf1);
            this.__animFactory_BottomLeftGroup_mcaf1.sceneName = "Scene 1";
            this.__animFactory_BottomLeftGroup_mcaf1.addTargetInfo(this,"BottomLeftGroup_mc",0,true,0,true,null,-1);
         }
      }
      
      public function __setPerspectiveProjection_(param1:Event) : void
      {
         root.transform.perspectiveProjection.fieldOfView = 55;
         root.transform.perspectiveProjection.projectionCenter = new Point(960,540);
      }
      
      override protected function onSetSafeRect() : void
      {
         GlobalFunc.LockToSafeRect(this.TopCenterGroup_mc,"TC",SafeX,SafeY);
         GlobalFunc.LockToSafeRect(this.CenterGroup_mc,"CC",SafeX,SafeY);
         GlobalFunc.LockToSafeRect(this.RolloverWidget_mc,"CC",SafeX,SafeY);
         GlobalFunc.LockToSafeRect(this.BottomLeftGroup_mc,"BL",SafeX,SafeY,true);
         GlobalFunc.LockToSafeRect(this.RightMeters_mc,"BR",SafeX,SafeY,true);
         CENTER_GROUP_POINT.x = this.CenterGroup_mc.x;
         CENTER_GROUP_POINT.y = this.CenterGroup_mc.y;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         BSUIDataManager.Subscribe("HudModeData",function(param1:FromClientDataEvent):*
         {
            if(param1.data.ModeVisibilityA.length == HUDUtils.MODE_COUNT)
            {
               TopCenterGroup_mc.visible = param1.data.ModeVisibilityA[HUDUtils.TOP_CENTER_GROUP].bVisible;
               BottomLeftGroup_mc.visible = param1.data.ModeVisibilityA[HUDUtils.BOTTOM_LEFT_GROUP].bVisible;
               RightMeters_mc.visible = param1.data.ModeVisibilityA[HUDUtils.RIGHT_METERS].bVisible;
               CenterGroup_mc.visible = param1.data.ModeVisibilityA[HUDUtils.CENTER_GROUP].bVisible;
               HitAndKillIndicator_mc.visible = param1.data.ModeVisibilityA[HUDUtils.HIT_AND_KILL_INDICATORS].bVisible;
               RolloverWidget_mc.SetVisibility(param1.data.ModeVisibilityA[HUDUtils.QUICK_CONTAINER].bVisible);
               EnemyHealthHolder_mc.visible = param1.data.ModeVisibilityA[HUDUtils.ENEMY_HEALTH_METER].bVisible;
               FloatingQuestMarkerBase.visible = param1.data.ModeVisibilityA[HUDUtils.FLOATING_QUEST_MARKERS].bVisible;
               SocialCommandIcons_mc.visible = param1.data.ModeVisibilityA[HUDUtils.SOCIAL_COMMAND_ICONS].bVisible;
            }
         });
         BSUIDataManager.Subscribe("HUDOpacityData",function(param1:FromClientDataEvent):*
         {
            var _loc3_:MovieClip = null;
            var _loc2_:int = 0;
            while(_loc2_ < numChildren)
            {
               _loc3_ = getChildAt(_loc2_) as MovieClip;
               if(_loc3_)
               {
                  _loc3_.alpha = param1.data.fHUDOpacity;
               }
               _loc2_++;
            }
         });
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(this.RolloverWidget_mc.show)
         {
            _loc3_ = this.RolloverWidget_mc.ProcessUserEvent(param1,param2);
         }
         return _loc3_;
      }
   }
}
