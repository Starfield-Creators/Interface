package fl.motion
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Source
   {
       
      
      public var frameRate:Number = NaN;
      
      public var elementType:String = "";
      
      public var symbolName:String = "";
      
      public var instanceName:String = "";
      
      public var linkageID:String = "";
      
      public var x:Number = 0;
      
      public var y:Number = 0;
      
      public var scaleX:Number = 1;
      
      public var scaleY:Number = 1;
      
      public var skewX:Number = 0;
      
      public var skewY:Number = 0;
      
      public var rotation:Number = 0;
      
      public var transformationPoint:Point;
      
      public var dimensions:Rectangle;
      
      public function Source(param1:XML = null)
      {
         super();
         this.parseXML(param1);
      }
      
      private function parseXML(param1:XML = null) : Source
      {
         var _loc3_:XML = null;
         var _loc4_:XML = null;
         var _loc5_:XML = null;
         if(!param1)
         {
            return this;
         }
         if(param1.@instanceName)
         {
            this.instanceName = String(param1.@instanceName);
         }
         if(param1.@symbolName)
         {
            this.symbolName = String(param1.@symbolName);
         }
         if(param1.@linkageID)
         {
            this.linkageID = String(param1.@linkageID);
         }
         if(!isNaN(param1.@frameRate))
         {
            this.frameRate = Number(param1.@frameRate);
         }
         var _loc2_:XMLList = param1.elements();
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.localName() == "transformationPoint")
            {
               _loc4_ = _loc3_.children()[0];
               this.transformationPoint = new Point(Number(_loc4_.@x),Number(_loc4_.@y));
            }
            else if(_loc3_.localName() == "dimensions")
            {
               _loc5_ = _loc3_.children()[0];
               this.dimensions = new Rectangle(Number(_loc5_.@left),Number(_loc5_.@top),Number(_loc5_.@width),Number(_loc5_.@height));
            }
         }
         return this;
      }
   }
}
