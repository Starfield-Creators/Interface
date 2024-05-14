package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class StreamingInstallMenu extends MovieClip
   {
       
      
      public var Status_tf:TextField;
      
      public var Progress_tf:TextField;
      
      public var Spinner_mc:MovieClip;
      
      public var Background_mc:MovieClip;
      
      public function StreamingInstallMenu()
      {
         super();
         BSUIDataManager.Subscribe("StreamingInstallData",this.onDataUpdate);
      }
      
      private function onDataUpdate(param1:FromClientDataEvent) : void
      {
         GlobalFunc.SetText(this.Progress_tf,param1.data.uInstallProgress + "%",false);
         this.Progress_tf.visible = param1.data.bShowProgressUI;
         this.Status_tf.visible = param1.data.bShowProgressUI;
         this.Spinner_mc.visible = param1.data.bShowProgressUI;
         this.Background_mc.visible = param1.data.bShowBackground;
      }
   }
}
