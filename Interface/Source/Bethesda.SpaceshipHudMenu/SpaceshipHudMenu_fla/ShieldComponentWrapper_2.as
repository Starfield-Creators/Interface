package SpaceshipHudMenu_fla
{
   import adobe.utils.*;
   import fl.motion.AnimatorFactory3D;
   import fl.motion.MotionBase;
   import fl.motion.motion_internal;
   import flash.accessibility.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.globalization.*;
   import flash.media.*;
   import flash.net.*;
   import flash.net.drm.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.sampler.*;
   import flash.sensors.*;
   import flash.system.*;
   import flash.text.*;
   import flash.text.engine.*;
   import flash.text.ime.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   
   public dynamic class ShieldComponentWrapper_2 extends MovieClip
   {
       
      
      public var ShieldComponent_mc:ShieldThrottleComponent;
      
      public var __animFactory_ShieldComponent_mcaf1:AnimatorFactory3D;
      
      public var __animArray_ShieldComponent_mcaf1:Array;
      
      public var ____motion_ShieldComponent_mcaf1_mat3DVec__:Vector.<Number>;
      
      public var ____motion_ShieldComponent_mcaf1_matArray__:Array;
      
      public var __motion_ShieldComponent_mcaf1:MotionBase;
      
      public function ShieldComponentWrapper_2()
      {
         super();
         if(this.__animFactory_ShieldComponent_mcaf1 == null)
         {
            this.__animArray_ShieldComponent_mcaf1 = new Array();
            this.__motion_ShieldComponent_mcaf1 = new MotionBase();
            this.__motion_ShieldComponent_mcaf1.duration = 1;
            this.__motion_ShieldComponent_mcaf1.overrideTargetTransform();
            this.__motion_ShieldComponent_mcaf1.addPropertyArray("blendMode",["normal"]);
            this.__motion_ShieldComponent_mcaf1.addPropertyArray("cacheAsBitmap",[false]);
            this.__motion_ShieldComponent_mcaf1.addPropertyArray("opaqueBackground",[null]);
            this.__motion_ShieldComponent_mcaf1.addPropertyArray("visible",[true]);
            this.__motion_ShieldComponent_mcaf1.is3D = true;
            this.__motion_ShieldComponent_mcaf1.motion_internal::spanStart = 0;
            this.____motion_ShieldComponent_mcaf1_matArray__ = new Array();
            this.____motion_ShieldComponent_mcaf1_mat3DVec__ = new Vector.<Number>(16);
            this.____motion_ShieldComponent_mcaf1_mat3DVec__[0] = 0.922853;
            this.____motion_ShieldComponent_mcaf1_mat3DVec__[1] = 0.047663;
            this.____motion_ShieldComponent_mcaf1_mat3DVec__[2] = -0.382193;
            this.____motion_ShieldComponent_mcaf1_mat3DVec__[3] = 0;
            this.____motion_ShieldComponent_mcaf1_mat3DVec__[4] = -0.136132;
            this.____motion_ShieldComponent_mcaf1_mat3DVec__[5] = 0.968628;
            this.____motion_ShieldComponent_mcaf1_mat3DVec__[6] = -0.207912;
            this.____motion_ShieldComponent_mcaf1_mat3DVec__[7] = 0;
            this.____motion_ShieldComponent_mcaf1_mat3DVec__[8] = 0.360293;
            this.____motion_ShieldComponent_mcaf1_mat3DVec__[9] = 0.2439;
            this.____motion_ShieldComponent_mcaf1_mat3DVec__[10] = 0.90039;
            this.____motion_ShieldComponent_mcaf1_mat3DVec__[11] = 0;
            this.____motion_ShieldComponent_mcaf1_mat3DVec__[12] = 170.86441;
            this.____motion_ShieldComponent_mcaf1_mat3DVec__[13] = 324.091248;
            this.____motion_ShieldComponent_mcaf1_mat3DVec__[14] = -13.857117;
            this.____motion_ShieldComponent_mcaf1_mat3DVec__[15] = 1;
            this.____motion_ShieldComponent_mcaf1_matArray__.push(new Matrix3D(this.____motion_ShieldComponent_mcaf1_mat3DVec__));
            this.__motion_ShieldComponent_mcaf1.addPropertyArray("matrix3D",this.____motion_ShieldComponent_mcaf1_matArray__);
            this.__animArray_ShieldComponent_mcaf1.push(this.__motion_ShieldComponent_mcaf1);
            this.__animFactory_ShieldComponent_mcaf1 = new AnimatorFactory3D(null,this.__animArray_ShieldComponent_mcaf1);
            this.__animFactory_ShieldComponent_mcaf1.addTargetInfo(this,"ShieldComponent_mc",0,true,0,true,null,-1);
         }
      }
   }
}
