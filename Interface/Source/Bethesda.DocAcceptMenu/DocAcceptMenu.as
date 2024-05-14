package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.IMenu;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.Components.SystemPanels.HelpPanelScrollableDescription;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.utils.getTimer;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class DocAcceptMenu extends IMenu
   {
       
      
      public var ScrollableDescription_mc:HelpPanelScrollableDescription;
      
      public var textField:TextField;
      
      public var DescriptionHeader_tf:TextField;
      
      public var ButtonBar_mc:ButtonBar;
      
      private var LEGAL_TERMS_OF_SERVICE:uint;
      
      private var LEGAL_CODE_OF_CONDUCT:uint;
      
      private var LEGAL_PRIVACY_POLICY:uint;
      
      private var LEGAL_EULA:uint;
      
      private var DocumentIndex:uint = 0;
      
      private var DocListA:Array;
      
      private var bHeld:Boolean = false;
      
      private var bHoldingUp:Boolean = false;
      
      private var ButtonHeldStartTime:Number = 0;
      
      private const TIME_TO_WAIT_BEFORE_CONSIDERED_HELD:Number = 500;
      
      internal var NextButton:IButton = null;
      
      public function DocAcceptMenu()
      {
         this.LEGAL_TERMS_OF_SERVICE = EnumHelper.GetEnum(0);
         this.LEGAL_CODE_OF_CONDUCT = EnumHelper.GetEnum();
         this.LEGAL_PRIVACY_POLICY = EnumHelper.GetEnum();
         this.LEGAL_EULA = EnumHelper.GetEnum();
         super();
         Extensions.enabled = true;
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_CENTER,15);
         ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$ACCEPT",[new UserEventData("Accept",this.onAccept)]),this.ButtonBar_mc);
         this.NextButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$NEXT",[new UserEventData("XButton",this.onNext)]),this.ButtonBar_mc);
         this.NextButton.Visible = false;
         this.NextButton.Enabled = false;
         this.ButtonBar_mc.RefreshButtons();
         TextFieldEx.setVerticalAlign(this.textField,TextFieldEx.VALIGN_CENTER);
         stage.focus = this.ScrollableDescription_mc;
         BSUIDataManager.Subscribe("DocAcceptData",this.OnDocumentsReceived);
      }
      
      private function OnDocumentsReceived(param1:FromClientDataEvent) : *
      {
         this.DocListA = GlobalFunc.CloneObject(param1.data.DocListA) as Array;
         var _loc2_:Array = param1.data.DocListA;
         if(_loc2_.length > 0)
         {
            this.ScrollableDescription_mc.SetData({"sDescription":_loc2_[0].DocBody + "\n\n"});
         }
         this.NextButton.Visible = this.DocListA.length > 1;
         this.NextButton.Enabled = this.NextButton.Visible;
         this.ButtonBar_mc.RefreshButtons();
      }
      
      private function onAccept() : *
      {
         GlobalFunc.PlayMenuSound("UIMenuInventoryMenuClose");
         BSUIDataManager.dispatchEvent(new Event("DocAcceptMenu_Accept",true));
      }
      
      private function onNext() : *
      {
         if(this.DocumentIndex < this.DocListA.length - 1)
         {
            ++this.DocumentIndex;
            this.ScrollableDescription_mc.SetData({"sDescription":this.DocListA[this.DocumentIndex].DocBody + "\n\n"});
            GlobalFunc.PlayMenuSound(GlobalFunc.FOCUS_SOUND);
            if(this.DocumentIndex == this.DocListA.length - 1)
            {
               this.NextButton.Enabled = false;
            }
         }
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(param2 == false)
         {
            if(param1 == "Accept")
            {
               this.onAccept();
               _loc3_ = true;
            }
            else if(param1 == "XButton")
            {
               this.onNext();
               _loc3_ = true;
            }
            else if(param1 == "Up")
            {
               this.ScrollableDescription_mc.MoveScroll(HelpPanelScrollableDescription.SCROLL_DELTA);
            }
            else if(param1 == "Down")
            {
               this.ScrollableDescription_mc.MoveScroll(-1 * HelpPanelScrollableDescription.SCROLL_DELTA);
            }
         }
         return _loc3_;
      }
      
      public function OnLeftStickInput(param1:Number, param2:Number, param3:Number, param4:Boolean, param5:Boolean) : *
      {
         if(Math.abs(param2) > 0.1)
         {
            if(!this.bHeld)
            {
               this.ButtonHeldStartTime = getTimer();
               addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            }
            if((!this.bHoldingUp || !this.bHeld) && param2 < 0)
            {
               this.bHeld = true;
               this.bHoldingUp = true;
               this.ScrollableDescription_mc.MoveScroll(HelpPanelScrollableDescription.SCROLL_DELTA);
            }
            else if((this.bHoldingUp || !this.bHeld) && param2 > 0)
            {
               this.bHeld = true;
               this.bHoldingUp = false;
               this.ScrollableDescription_mc.MoveScroll(-1 * HelpPanelScrollableDescription.SCROLL_DELTA);
            }
         }
         else if(this.bHeld)
         {
            this.bHeld = false;
            removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      public function onEnterFrame(param1:Event) : *
      {
         if(this.bHeld)
         {
            if(getTimer() - this.ButtonHeldStartTime >= this.TIME_TO_WAIT_BEFORE_CONSIDERED_HELD)
            {
               if(this.bHoldingUp)
               {
                  this.ScrollableDescription_mc.MoveScroll(HelpPanelScrollableDescription.SCROLL_DELTA);
               }
               else
               {
                  this.ScrollableDescription_mc.MoveScroll(-1 * HelpPanelScrollableDescription.SCROLL_DELTA);
               }
            }
         }
      }
   }
}
