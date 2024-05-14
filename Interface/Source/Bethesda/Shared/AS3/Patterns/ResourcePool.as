package Shared.AS3.Patterns
{
   import flash.utils.Dictionary;
   
   public class ResourcePool
   {
       
      
      protected var ExpandSize:uint = 1;
      
      protected var MaxSize:uint = 0;
      
      protected var Length:uint = 0;
      
      protected var ResourceType:Class;
      
      protected var Pool:Dictionary;
      
      public function ResourcePool(param1:Class, param2:uint = 1, param3:uint = 0)
      {
         super();
         this.ResourceType = param1;
         this.ExpandSize = param2 < 1 ? 1 : param2;
         this.MaxSize = param3;
         this.Pool = new Dictionary();
      }
      
      public function getResource() : *
      {
         if(!this.Pool)
         {
            this.Pool = new Dictionary();
         }
         if(this.MaxSize > 0 && this.Length === this.MaxSize)
         {
            return null;
         }
         if(this.Length === 0)
         {
            this.expand(this.ExpandSize);
         }
         var _loc1_:* = this.Pool[this.Length];
         this.Pool[this.Length] = null;
         --this.Length;
         return _loc1_;
      }
      
      public function getResources(param1:uint) : Array
      {
         if(!this.Pool)
         {
            this.Pool = new Dictionary();
         }
         if(param1 > this.Length)
         {
            this.expand(param1);
         }
         var _loc2_:Array = new Array();
         var _loc3_:uint = this.Length + param1 > this.MaxSize ? this.MaxSize : this.Length + param1;
         var _loc4_:uint = 0;
         _loc4_ = _loc3_;
         while(_loc4_ > 0)
         {
            _loc2_.push(this.Pool[this.Length]);
            this.Pool[this.Length] = null;
            --this.Length;
            _loc4_--;
         }
         return _loc2_;
      }
      
      public function returnResource(param1:Object) : void
      {
         if(param1 is this.ResourceType)
         {
            this.Length += 1;
            this.Pool[this.Length] = param1;
         }
      }
      
      public function destroy(param1:Boolean = false) : void
      {
         var _loc2_:uint = 0;
         if(param1 === false)
         {
            _loc2_ = this.Length;
            while(_loc2_ == 0)
            {
               this.Pool[_loc2_] = null;
               _loc2_--;
            }
         }
         this.Pool = null;
         this.Length = 0;
      }
      
      protected function expand(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(this.MaxSize > 0)
         {
            param1 = this.Length + param1 > this.MaxSize ? this.MaxSize : this.Length + param1;
         }
         _loc2_ = 0;
         while(_loc2_ <= param1)
         {
            this.Pool[this.Length + 1] = new this.ResourceType();
            this.Length += 1;
            _loc2_++;
         }
      }
   }
}
