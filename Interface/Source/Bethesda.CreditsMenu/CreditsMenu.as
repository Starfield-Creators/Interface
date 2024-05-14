package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.IMenu;
   import Shared.Components.ButtonControls.ButtonBar.ButtonManager;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.Buttons.HoldButton;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class CreditsMenu extends IMenu
   {
       
      
      public var CreditsContainer:MovieClip;
      
      public var Background_mc:MovieClip;
      
      public var ExitButton_mc:HoldButton;
      
      private var MyButtonManager:ButtonManager;
      
      private var StartY:Number = 1080;
      
      private var EndY:Number = -25;
      
      private var TextYRate:Number = 1;
      
      private var _scrollKeyMultiplier:Number = 1;
      
      private const CONTAINER_START:Number = -100;
      
      private const CONTAINER_CENTER:Number = 410;
      
      private const CLIP_SPACING:Number = 64;
      
      private const MOUSE_SPEED_MULTIPLIER:Number = 20;
      
      private const KEY_SPEED_MULTIPLIER:Number = 12;
      
      private const EXIT_MENU_PRESSED:String = "UIStart";
      
      private var startIndex:int;
      
      private var endIndex:int;
      
      private var maxEndIndex:int;
      
      private var CreditsClips:Array;
      
      private var CreditsStrings:Array;
      
      private var creditsInitialized:Boolean = false;
      
      public function CreditsMenu()
      {
         this.MyButtonManager = new ButtonManager();
         super();
         this.CreditsClips = new Array();
         this.CreditsStrings = new Array();
         this.startIndex = -1;
         this.endIndex = -1;
         this.maxEndIndex = -1;
         this.ExitButton_mc.SetButtonData(new ButtonBaseData("$SKIP",new UserEventData("Cancel",this.onQuitPress)));
         this.MyButtonManager.AddButton(this.ExitButton_mc);
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         BSUIDataManager.Subscribe("CreditsMenuData",this.OnCreditsDataUpdate);
      }
      
      override public function onRemovedFromStage() : void
      {
         super.onRemovedFromStage();
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         stage.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
         stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUpHandler);
      }
      
      private function OnCreditsDataUpdate(param1:FromClientDataEvent) : void
      {
         var _loc2_:Object = null;
         var _loc3_:CreditsLine = null;
         if(param1.data.creditsA.length > 0 && !this.creditsInitialized)
         {
            this.creditsInitialized = true;
            this.CreditsContainer.y = this.CONTAINER_START;
            this.TextYRate = param1.data.fScrollSpeed;
            this.CreditsStrings = param1.data.creditsA;
            _loc2_ = this.CreditsStrings[0];
            _loc3_ = !!_loc2_.bCenter ? new CreditsLineCenter() : new CreditsLine();
            _loc3_.SetCreditText(_loc2_.sTitle,_loc2_.contentA);
            _loc3_.x = this.CONTAINER_CENTER;
            _loc3_.y = this.StartY;
            this.CreditsContainer.addChild(_loc3_);
            this.CreditsClips.push(_loc3_);
            this.startIndex = 0;
            this.endIndex = 0;
            this.maxEndIndex = 0;
            addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
            stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
            stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUpHandler);
         }
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         return this.MyButtonManager.ProcessUserEvent(param1,param2);
      }
      
      public function onKeyUpHandler(param1:KeyboardEvent) : *
      {
         if(param1.keyCode == Keyboard.DOWN || param1.keyCode == Keyboard.UP)
         {
            this._scrollKeyMultiplier = 1;
            param1.stopPropagation();
         }
      }
      
      public function onKeyDownHandler(param1:KeyboardEvent) : *
      {
         if(param1.keyCode == Keyboard.UP)
         {
            this._scrollKeyMultiplier = -this.KEY_SPEED_MULTIPLIER;
            param1.stopPropagation();
         }
         else if(param1.keyCode == Keyboard.DOWN)
         {
            this._scrollKeyMultiplier = this.KEY_SPEED_MULTIPLIER;
            param1.stopPropagation();
         }
      }
      
      public function onEnterFrame(param1:Event) : void
      {
         if(this.endIndex == -1 || this.CreditsContainer.y + this.CreditsClips[this.endIndex].y + this.CreditsClips[this.endIndex].height <= this.EndY)
         {
            GlobalFunc.CloseMenu("CreditsMenu");
         }
         this.MoveCredits(-this.TextYRate * this._scrollKeyMultiplier);
      }
      
      public function onMouseWheel(param1:MouseEvent) : void
      {
         this.MoveCredits(this.MOUSE_SPEED_MULTIPLIER * param1.delta);
      }
      
      public function onQuitPress() : void
      {
         GlobalFunc.PlayMenuSound(this.EXIT_MENU_PRESSED);
         GlobalFunc.CloseMenu("CreditsMenu");
      }
      
      public function set buttonVisible(param1:Boolean) : void
      {
         this.ExitButton_mc.Visible = param1;
         this.ExitButton_mc.Enabled = param1;
      }
      
      private function MoveCredits(param1:Number) : void
      {
         var _loc2_:Object = null;
         var _loc3_:CreditsLine = null;
         var _loc4_:Object = null;
         var _loc5_:CreditsLine = null;
         if(this.CreditsStrings.length > 0)
         {
            this.CreditsContainer.y += param1;
            if(param1 < 0)
            {
               while(this.endIndex < this.CreditsStrings.length - 1 && this.CreditsContainer.y + this.CreditsClips[this.endIndex].y + this.CreditsClips[this.endIndex].height <= this.StartY)
               {
                  _loc2_ = this.CreditsStrings[this.endIndex + 1];
                  if(this.endIndex >= this.maxEndIndex)
                  {
                     this.CreditsClips.push(!!_loc2_.bCenter ? new CreditsLineCenter() : new CreditsLine());
                  }
                  else
                  {
                     this.CreditsClips[this.endIndex + 1] = !!_loc2_.bCenter ? new CreditsLineCenter() : new CreditsLine();
                  }
                  _loc3_ = this.CreditsClips[this.endIndex + 1];
                  _loc3_.x = this.CONTAINER_CENTER;
                  _loc3_.y = this.CreditsClips[this.endIndex].y + this.CreditsClips[this.endIndex].height + this.CLIP_SPACING;
                  _loc3_.SetCreditText(_loc2_.sTitle,_loc2_.contentA);
                  this.CreditsContainer.addChild(_loc3_);
                  ++this.endIndex;
                  this.maxEndIndex = Math.max(this.endIndex,this.maxEndIndex);
               }
               while(this.startIndex < this.endIndex && this.CreditsContainer.y + this.CreditsClips[this.startIndex].y + this.CreditsClips[this.startIndex].height <= this.EndY)
               {
                  this.CreditsContainer.removeChild(this.CreditsClips[this.startIndex]);
                  this.CreditsClips[this.startIndex] = null;
                  ++this.startIndex;
               }
            }
            else if(param1 > 0)
            {
               while(this.startIndex > 0 && this.CreditsContainer.y + this.CreditsClips[this.startIndex].y + this.CreditsClips[this.startIndex].height >= this.EndY)
               {
                  _loc4_ = this.CreditsStrings[this.startIndex - 1];
                  this.CreditsClips[this.startIndex - 1] = !!_loc4_.bCenter ? new CreditsLineCenter() : new CreditsLine();
                  (_loc5_ = this.CreditsClips[this.startIndex - 1]).SetCreditText(_loc4_.sTitle,_loc4_.contentA);
                  _loc5_.x = this.CONTAINER_CENTER;
                  _loc5_.y = this.CreditsClips[this.startIndex].y - _loc5_.height - this.CLIP_SPACING;
                  this.CreditsContainer.addChild(_loc5_);
                  --this.startIndex;
               }
               while(this.endIndex > this.startIndex && this.CreditsContainer.y + this.CreditsClips[this.endIndex].y + this.CreditsClips[this.endIndex].height >= this.StartY)
               {
                  this.CreditsContainer.removeChild(this.CreditsClips[this.endIndex]);
                  this.CreditsClips[this.endIndex] = null;
                  --this.endIndex;
               }
            }
         }
      }
   }
}
