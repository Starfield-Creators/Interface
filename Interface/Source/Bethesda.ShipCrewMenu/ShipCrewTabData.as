package
{
   public class ShipCrewTabData
   {
       
      
      public var Text:String = "";
      
      public var Type:uint;
      
      public var CurrentOnly:Boolean = false;
      
      public function ShipCrewTabData(param1:String, param2:uint, param3:Boolean)
      {
         this.Type = ShipCrewUtils.ASSIGNMENT_TYPE_FLAG_MISC;
         super();
         this.Text = param1;
         this.Type = param2;
         this.CurrentOnly = param3;
      }
   }
}
