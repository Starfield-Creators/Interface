package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class MessagePopup extends BSDisplayObject
   {
      
      private static const MESSAGE_LABEL:String = "Message";
      
      private static const WARNING_LABEL:String = "Warning";
      
      private static const ERROR_LABEL:String = "Error";
      
      private static const SHOW:String = "show";
      
      private static const FADE_OUT:String = "fade_out";
      
      private static const HIDE:String = "hide";
      
      private static const MESSAGE:uint = EnumHelper.GetEnum(0);
      
      private static const WARNING:uint = EnumHelper.GetEnum();
      
      private static const ERROR:uint = EnumHelper.GetEnum();
       
      
      public var MessageContainer_mc:MovieClip;
      
      private var messagesA:Array;
      
      private var currentMessage:int = 0;
      
      public function MessagePopup()
      {
         super();
         gotoAndStop(HIDE);
         this.messagesA = new Array();
      }
      
      private function get MessageText() : TextField
      {
         return this.MessageContainer_mc.MessageText_mc.text_tf;
      }
      
      public function get IsFadingOut() : Boolean
      {
         return currentLabel == FADE_OUT;
      }
      
      public function get IsHidden() : Boolean
      {
         return currentLabel == HIDE;
      }
      
      public function get IsShown() : Boolean
      {
         return currentLabel == SHOW;
      }
      
      override public function onAddedToStage() : void
      {
         BSUIDataManager.Subscribe("MessagePopupData",this.UpdateMessages);
      }
      
      private function UpdateMessages(param1:FromClientDataEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:Array = param1.data.aMessageList;
         if(_loc2_.length > 0)
         {
            for each(_loc3_ in _loc2_)
            {
               this.messagesA.push(_loc3_);
            }
            if(this.IsHidden || this.IsFadingOut)
            {
               this.messagesA.splice(0,this.currentMessage);
               this.currentMessage = -1;
               this.DisplayNextMessage();
            }
         }
      }
      
      public function DisplayNextMessage() : void
      {
         var _loc1_:* = ++this.currentMessage < this.messagesA.length;
         if(_loc1_)
         {
            this.SetMessageBody(this.messagesA[this.currentMessage].sBodyText);
            this.SetMessageType(this.messagesA[this.currentMessage].uMessageType);
            gotoAndPlay(SHOW);
         }
         else if(this.IsShown)
         {
            gotoAndPlay(FADE_OUT);
         }
      }
      
      private function SetMessageBody(param1:String) : void
      {
         GlobalFunc.SetText(this.MessageText,param1);
      }
      
      private function SetMessageType(param1:uint) : void
      {
         switch(param1)
         {
            case MESSAGE:
               this.MessageContainer_mc.gotoAndStop(MESSAGE_LABEL);
               break;
            case WARNING:
               this.MessageContainer_mc.gotoAndStop(WARNING_LABEL);
               break;
            case ERROR:
               this.MessageContainer_mc.gotoAndStop(ERROR_LABEL);
         }
      }
   }
}
