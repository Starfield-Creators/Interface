package
{
   import Shared.AS3.DepthTestedObject;
   
   public class IMarker extends DepthTestedObject
   {
       
      
      private var BodyID:uint;
      
      public function IMarker()
      {
         super();
      }
      
      public function get bodyID() : uint
      {
         return this.BodyID;
      }
      
      public function set bodyID(param1:uint) : void
      {
         this.BodyID = param1;
      }
      
      public function QWidth() : Number
      {
         return 0;
      }
      
      public function QHeight() : Number
      {
         return 0;
      }
      
      public function ResetValues() : void
      {
      }
      
      public function Update(param1:Object) : void
      {
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         return false;
      }
      
      public function SetPosition(param1:Number, param2:Number, param3:Number) : void
      {
         x = param1;
         y = param2;
         SetZ(param3);
      }
   }
}
