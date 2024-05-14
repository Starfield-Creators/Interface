package fl.motion
{
   import flash.geom.Point;
   
   public class CustomEase implements ITween
   {
       
      
      public var points:Array;
      
      private var firstNode:Point;
      
      private var lastNode:Point;
      
      private var _target:String = "";
      
      public function CustomEase(param1:XML = null)
      {
         super();
         this.points = [];
         this.parseXML(param1);
         this.firstNode = new Point(0,0);
         this.lastNode = new Point(1,1);
      }
      
      internal static function getYForPercent(param1:Number, param2:Array) : Number
      {
         var _loc8_:int = 0;
         var _loc9_:fl.motion.BezierSegment = null;
         var _loc3_:fl.motion.BezierSegment = new fl.motion.BezierSegment(param2[0],param2[1],param2[2],param2[3]);
         var _loc4_:Array = [_loc3_];
         var _loc5_:int = 3;
         while(_loc5_ < param2.length - 3)
         {
            _loc4_.push(new fl.motion.BezierSegment(param2[_loc5_],param2[_loc5_ + 1],param2[_loc5_ + 2],param2[_loc5_ + 3]));
            _loc5_ += 3;
         }
         var _loc6_:fl.motion.BezierSegment = _loc3_;
         if(param2.length >= 5)
         {
            _loc8_ = 0;
            while(_loc8_ < _loc4_.length)
            {
               if((_loc9_ = _loc4_[_loc8_]).a.x <= param1 && param1 <= _loc9_.d.x)
               {
                  _loc6_ = _loc9_;
                  break;
               }
               _loc8_++;
            }
         }
         return _loc6_.getYForX(param1);
      }
      
      public function get target() : String
      {
         return this._target;
      }
      
      public function set target(param1:String) : void
      {
         this._target = param1;
      }
      
      private function parseXML(param1:XML = null) : CustomEase
      {
         var _loc3_:XML = null;
         if(!param1)
         {
            return this;
         }
         if(param1.@target.length())
         {
            this.target = param1.@target;
         }
         var _loc2_:XMLList = param1.elements();
         for each(_loc3_ in _loc2_)
         {
            this.points.push(new Point(Number(_loc3_.@x),Number(_loc3_.@y)));
         }
         return this;
      }
      
      public function getValue(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         if(param4 <= 0)
         {
            return NaN;
         }
         var _loc5_:Number;
         if((_loc5_ = param1 / param4) <= 0)
         {
            return param2;
         }
         if(_loc5_ >= 1)
         {
            return param2 + param3;
         }
         var _loc6_:Array;
         (_loc6_ = [this.firstNode].concat(this.points)).push(this.lastNode);
         var _loc7_:Number = getYForPercent(_loc5_,_loc6_);
         return param2 + _loc7_ * param3;
      }
   }
}
