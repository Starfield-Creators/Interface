package
{
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class OutlineIconsWidget extends MovieClip
   {
      
      internal static const WATCH_RADIUS:Number = 111;
      
      internal static const RAD_TO_DEG:Number = 180 / Math.PI;
       
      
      protected var IconClass:Class;
      
      private var VisibleIconsA:Vector.<OutlineCompassIcon>;
      
      private var IconsA:Vector.<OutlineCompassIcon>;
      
      private var Configured:Boolean;
      
      public function OutlineIconsWidget()
      {
         this.IconClass = getDefinitionByName("OutlineCompassIcon") as Class;
         this.VisibleIconsA = new Vector.<OutlineCompassIcon>();
         this.IconsA = new Vector.<OutlineCompassIcon>();
         super();
         this.Configured = false;
      }
      
      protected function get iconClass() : String
      {
         return getQualifiedClassName(this.IconClass);
      }
      
      protected function set iconClass(param1:String) : *
      {
         this.IconClass = getDefinitionByName(param1) as Class;
      }
      
      public function Configure(param1:String, param2:uint) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:OutlineCompassIcon = null;
         if(!this.Configured)
         {
            this.iconClass = param1;
            _loc3_ = 0;
            while(_loc3_ < param2)
            {
               (_loc4_ = new this.IconClass() as OutlineCompassIcon).visible = false;
               this.IconsA.push(_loc4_);
               addChild(_loc4_);
               _loc3_++;
            }
            this.Configured = true;
         }
      }
      
      public function onDataChange(param1:Array, param2:Number) : void
      {
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:uint = 0;
         var _loc8_:OutlineCompassIcon = null;
         var _loc9_:Point = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:int = 0;
         var _loc15_:* = undefined;
         var _loc3_:Array = new Array();
         var _loc4_:uint = 0;
         while(Boolean(param1) && _loc4_ < param1.length)
         {
            _loc5_ = param1[_loc4_];
            _loc6_ = -1;
            _loc7_ = 0;
            while(_loc6_ < 0 && _loc7_ < this.VisibleIconsA.length)
            {
               if(this.VisibleIconsA[_loc7_].handle == _loc5_.uiHandle)
               {
                  _loc6_ = int(_loc7_);
               }
               _loc7_++;
            }
            _loc8_ = null;
            if(_loc6_ >= 0)
            {
               _loc8_ = this.VisibleIconsA[_loc6_];
            }
            else if(this.IconsA.length > 0)
            {
               this.VisibleIconsA.push(this.IconsA.shift());
               (_loc8_ = this.VisibleIconsA[this.VisibleIconsA.length - 1]).visible = true;
            }
            if(_loc8_)
            {
               _loc8_.SetData(_loc5_);
               if(_loc3_.indexOf(_loc5_.uiHandle,0) < 0)
               {
                  _loc3_.push(_loc5_.uiHandle);
               }
               _loc9_ = new Point(0,1);
               _loc10_ = Math.PI - param2;
               _loc11_ = Math.cos(_loc10_) * _loc9_.x - Math.sin(_loc10_) * _loc9_.y;
               _loc12_ = Math.sin(_loc10_) * _loc9_.x + Math.cos(_loc10_) * _loc9_.y;
               _loc9_.x = _loc11_;
               _loc9_.y = _loc12_;
               _loc11_ = Math.cos(_loc5_.fHeading) * _loc9_.x - Math.sin(_loc5_.fHeading) * _loc9_.y;
               _loc12_ = Math.sin(_loc5_.fHeading) * _loc9_.x + Math.cos(_loc5_.fHeading) * _loc9_.y;
               _loc13_ = (_loc5_.fHeading - param2) * RAD_TO_DEG;
               _loc8_.rotation = _loc13_;
               _loc8_.x = _loc11_ * WATCH_RADIUS;
               _loc8_.y = _loc12_ * WATCH_RADIUS;
            }
            _loc4_++;
         }
         if(this.VisibleIconsA.length > _loc3_.length)
         {
            _loc14_ = int(this.VisibleIconsA.length - 1);
            while(_loc14_ >= 0)
            {
               if((_loc15_ = _loc3_.indexOf(this.VisibleIconsA[_loc14_].handle,0)) < 0)
               {
                  this.VisibleIconsA[_loc14_].visible = false;
                  this.IconsA.push(this.VisibleIconsA.splice(_loc14_,1)[0]);
                  _loc3_.splice(_loc15_,1);
                  _loc14_--;
               }
               _loc14_--;
            }
         }
      }
   }
}
