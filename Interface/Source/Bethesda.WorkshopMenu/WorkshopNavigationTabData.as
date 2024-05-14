package
{
   public class WorkshopNavigationTabData
   {
       
      
      public var Text:String = "";
      
      public var CategoryID:uint = 0;
      
      public var Selectable:Boolean = true;
      
      public function WorkshopNavigationTabData(param1:String, param2:uint, param3:Boolean)
      {
         super();
         this.Text = param1;
         this.CategoryID = param2;
         this.Selectable = param3;
      }
   }
}
