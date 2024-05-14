package Shared.Components.ButtonControls.ButtonFactory
{
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonData;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import flash.utils.getDefinitionByName;
   
   public class ButtonFactory
   {
       
      
      public function ButtonFactory()
      {
         super();
      }
      
      public static function AddToButtonBar(param1:String, param2:ButtonData, param3:ButtonBar) : IButton
      {
         var _loc5_:IButton;
         var _loc4_:Class;
         (_loc5_ = new (_loc4_ = getDefinitionByName(param1) as Class)()).SetButtonData(param2);
         param3.AddButton(_loc5_);
         return _loc5_;
      }
   }
}
