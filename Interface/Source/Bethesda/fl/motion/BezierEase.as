package fl.motion
{
   import flash.geom.Point;
   
   public class BezierEase implements ITween
   {
       
      
      public var points:Array;
      
      private var firstNode:Point;
      
      private var lastNode:Point;
      
      private var _target:String = "";
      
      public function BezierEase(param1:XML = null)
      {
         super();
         this.points = [];
         this.parseXML(param1);
      }
      
      public function get target() : String
      {
         return this._target;
      }
      
      public function set target(param1:String) : void
      {
         this._target = param1;
      }
      
      private function parseXML(param1:XML = null) : BezierEase
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
         this.firstNode = new Point(0,param2);
         this.lastNode = new Point(1,param2 + param3);
         var _loc6_:Array;
         (_loc6_ = [this.firstNode].concat(this.points)).push(this.lastNode);
         return CustomEase.getYForPercent(_loc5_,_loc6_);
      }
   }
}
