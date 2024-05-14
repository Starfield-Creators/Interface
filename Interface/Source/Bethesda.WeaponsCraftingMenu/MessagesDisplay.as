package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import scaleform.gfx.TextFieldEx;
   
   public class MessagesDisplay extends BSDisplayObject
   {
      
      public static const FADE_IN_FINISHED:String = "FadeInFinished";
      
      public static const FADE_OUT_FINISHED:String = "FadeOutFinished";
       
      
      public var Message_mc:MovieClip;
      
      private var _messages:Vector.<MessageData>;
      
      private var _playingAnimation:Boolean = false;
      
      private var _messagesAllowed:Boolean = false;
      
      public function MessagesDisplay()
      {
         super();
         this._messages = new Vector.<MessageData>();
         TextFieldEx.setTextAutoSize(this.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         addEventListener(FADE_IN_FINISHED,this.FadeInComplete);
         addEventListener(FADE_OUT_FINISHED,this.FadeOutComplete);
      }
      
      private function get Text_tf() : TextField
      {
         return this.Message_mc.Text_tf;
      }
      
      public function set messagesAllowed(param1:Boolean) : void
      {
         this._messagesAllowed = param1;
         this.visible = this._messagesAllowed;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         BSUIDataManager.Subscribe("HUDMessageData",this.OnMessageDataUpdate);
      }
      
      public function ClearAllMessages() : void
      {
         this._messages.length = 0;
         this._playingAnimation = true;
         gotoAndPlay("fastFadeOut");
      }
      
      private function FadeInMessage() : void
      {
         this._playingAnimation = true;
         gotoAndPlay("fadeIn");
      }
      
      private function FadeOutMessage() : void
      {
         gotoAndPlay("fadeOut");
      }
      
      private function ShowNextMessage() : void
      {
         var _loc1_:MessageData = null;
         if(!this._playingAnimation && this._messagesAllowed)
         {
            _loc1_ = this._messages.shift();
            if(_loc1_ != null)
            {
               GlobalFunc.SetText(this.Text_tf,_loc1_.messageText);
               GlobalFunc.PlayMenuSound(_loc1_.soundName);
               this.FadeInMessage();
            }
         }
      }
      
      private function OnMessageDataUpdate(param1:FromClientDataEvent) : void
      {
         if(param1.data.bClearMessages)
         {
            this.ClearAllMessages();
         }
         else if(this._messagesAllowed && param1.data.NextMessage.sText != "")
         {
            this._messages.push(new MessageData(param1.data.NextMessage.sText,param1.data.NextMessage.sSound));
            this.ShowNextMessage();
         }
      }
      
      private function FadeInComplete() : void
      {
         this.FadeOutMessage();
      }
      
      private function FadeOutComplete() : void
      {
         this._playingAnimation = false;
         GlobalFunc.SetText(this.Text_tf,"");
         this.ShowNextMessage();
      }
   }
}
