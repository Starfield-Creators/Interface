package Shared.AS3
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import flash.events.EventDispatcher;
   
   public class BS3DSceneRectManager extends EventDispatcher
   {
      
      private static var _instance:BS3DSceneRectManager;
       
      
      public function BS3DSceneRectManager()
      {
         super();
         if(_instance != null)
         {
            throw new Error(this + " is a Singleton. Access using getInstance()");
         }
      }
      
      private static function GetInstance() : BS3DSceneRectManager
      {
         if(!_instance)
         {
            _instance = new BS3DSceneRectManager();
         }
         return _instance;
      }
      
      public static function Register3DSceneRect(param1:BSAnimating3DSceneRect) : *
      {
         param1.addEventListener(BSAnimating3DSceneRect.UPDATE_SCENE_RECT,updateSceneRect);
         updateSceneRect(new CustomEvent(BSAnimating3DSceneRect.UPDATE_SCENE_RECT,{"ScreenRect":param1.QData()}));
      }
      
      public static function updateSceneRect(param1:CustomEvent) : *
      {
         BSUIDataManager.dispatchEvent(new CustomEvent("UpdateSceneRectEvent",param1.params.ScreenRect));
      }
   }
}
