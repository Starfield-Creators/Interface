package DataSlateMenu
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class AudioEntry extends MovieClip implements IDataSlateEntry
   {
       
      
      public var AudioPlayWidget_mc:MovieClip;
      
      private var IsPlaying:Boolean = true;
      
      private const EVENT_TOGGLE_AUDIO:String = "DataSlateMenu_toggleAudio";
      
      public function AudioEntry()
      {
         super();
         this.AudioPlayWidget_mc.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this.AudioPlayWidget_mc.addEventListener(MouseEvent.CLICK,this.onClick);
         BSUIDataManager.Subscribe("DataSlateData",this.onDataUpdate);
      }
      
      public function SetData(param1:Object) : void
      {
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(DataSlateMenu.EVENT_PLAY_SFX,{"uType":DataSlateMenu.FOCUS_SOUND}));
      }
      
      private function onDataUpdate(param1:FromClientDataEvent) : void
      {
         if(param1.data.bAudioIsPlaying)
         {
            this.IsPlaying = true;
            this.AudioPlayWidget_mc.gotoAndStop("playing");
         }
         else
         {
            this.IsPlaying = false;
            this.AudioPlayWidget_mc.gotoAndStop("stopped");
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         this.ToggleAudio();
      }
      
      public function ToggleAudio() : void
      {
         if(this.IsPlaying)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(DataSlateMenu.EVENT_PLAY_SFX,{"uType":DataSlateMenu.AUDIO_STOP_SOUND}));
         }
         else
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(DataSlateMenu.EVENT_PLAY_SFX,{"uType":DataSlateMenu.AUDIO_PLAY_SOUND}));
         }
         BSUIDataManager.dispatchEvent(new CustomEvent(this.EVENT_TOGGLE_AUDIO,{}));
      }
   }
}
