package Shared.AS3.Data
{
   import Shared.EnumHelper;
   
   public class DataProviderUtils
   {
      
      public static const ACA_CLEAR:int = EnumHelper.GetEnum(0);
      
      public static const ACA_INSERT:int = EnumHelper.GetEnum();
      
      public static const ACA_REMOVE:int = EnumHelper.GetEnum();
      
      public static const ACA_SWAP:int = EnumHelper.GetEnum();
      
      public static const ACA_RESIZE:int = EnumHelper.GetEnum();
       
      
      public function DataProviderUtils()
      {
         super();
      }
      
      public static function ActionTypeToString(param1:int) : String
      {
         var _loc2_:String = "Unknown";
         switch(param1)
         {
            case DataProviderUtils.ACA_CLEAR:
               _loc2_ = "Clear";
               break;
            case DataProviderUtils.ACA_INSERT:
               _loc2_ = "Insert";
               break;
            case DataProviderUtils.ACA_REMOVE:
               _loc2_ = "Remove";
               break;
            case DataProviderUtils.ACA_SWAP:
               _loc2_ = "Swap";
               break;
            case DataProviderUtils.ACA_RESIZE:
               _loc2_ = "Resize";
         }
         return _loc2_;
      }
   }
}
