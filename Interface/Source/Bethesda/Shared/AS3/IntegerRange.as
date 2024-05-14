package Shared.AS3
{
   public class IntegerRange
   {
       
      
      public var LowBoundInclusive:int;
      
      public var HighBoundExclusive:int;
      
      public function IntegerRange(param1:*, param2:*)
      {
         super();
         this.LowBoundInclusive = param1;
         this.HighBoundExclusive = param2;
      }
      
      public function ForEachExclusiveValue(param1:IntegerRange, param2:Function) : *
      {
         var _loc3_:uint = 0;
         var _loc4_:int = Math.min(param1.LowBoundInclusive,this.HighBoundExclusive);
         _loc3_ = uint(this.LowBoundInclusive);
         while(_loc3_ < _loc4_)
         {
            param2(_loc3_);
            _loc3_++;
         }
         _loc3_ = Math.max(param1.HighBoundExclusive,this.LowBoundInclusive);
         while(_loc3_ < this.HighBoundExclusive)
         {
            param2(_loc3_);
            _loc3_++;
         }
      }
   }
}
