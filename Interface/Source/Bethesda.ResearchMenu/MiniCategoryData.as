package
{
   public class MiniCategoryData
   {
       
      
      public var IconName:String = "";
      
      public var CategoryID:uint = 0;
      
      public var HasNew:Boolean = false;
      
      public function MiniCategoryData(param1:String, param2:uint, param3:Boolean)
      {
         super();
         this.IconName = param1;
         this.CategoryID = param2;
         this.HasNew = param3;
      }
   }
}
