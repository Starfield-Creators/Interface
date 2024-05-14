package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   public class DesktopIconHolder extends MovieClip
   {
       
      
      public var Border_mc:MovieClip;
      
      private var _desktopIconsV:Vector.<DesktopIconObject>;
      
      private var _maxRows:int = -1;
      
      private var _paddingX:int = 25;
      
      private var _paddingY:int = 5;
      
      private var _currentIndex:* = 0;
      
      private var _countInLastColumn:* = 0;
      
      private var IconWidthScale:Number = 1;
      
      private var IconHeightScale:Number = 1;
      
      private var FactionName:String = "Generic";
      
      public function DesktopIconHolder()
      {
         super();
         this._desktopIconsV = new Vector.<DesktopIconObject>();
         addEventListener(DesktopIconObject.ICON_HIGHLIGHTED_EVENT,this.onIconHighlighted);
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
      }
      
      public function set Faction(param1:String) : *
      {
         this.FactionName = param1;
         this.UpdateIconFaction();
      }
      
      public function ShowIconAsMinimized(param1:int, param2:Boolean) : *
      {
         if(param1 < 0 || param1 >= this._desktopIconsV.length)
         {
            return;
         }
         var _loc3_:DesktopIconObject = this._desktopIconsV[param1];
         _loc3_.ShowMinimized = param2;
      }
      
      public function InitializeDesktopIcons(param1:Array, param2:Boolean = false) : void
      {
         var _loc3_:Object = null;
         var _loc4_:* = undefined;
         var _loc5_:DesktopIconObject = null;
         while(this._desktopIconsV.length > 0)
         {
            removeChild(this._desktopIconsV.pop());
         }
         for each(_loc3_ in param1)
         {
            _loc4_ = this._desktopIconsV.length;
            (_loc5_ = new DesktopIconObject(_loc3_.iIconId,_loc3_.sIconName,_loc3_.bIsLocked,_loc3_.iIconStyle,_loc3_.iParentStackLevel)).name = _loc3_.iIconId + ": " + _loc3_.sIconName;
            _loc5_.gotoAndStop(this.FactionName);
            _loc5_.scaleX = this.IconWidthScale;
            _loc5_.scaleY = this.IconHeightScale;
            if(this._maxRows == -1)
            {
               this._maxRows = this.Border_mc.height / _loc5_.height;
            }
            _loc5_.x = (_loc5_.width + this._paddingX) * Math.floor(_loc4_ / this._maxRows);
            _loc5_.y = (_loc5_.height + this._paddingY) * (_loc4_ % this._maxRows);
            if(_loc4_ == this._currentIndex)
            {
               _loc5_.Highlight();
            }
            else
            {
               _loc5_.Dehighlight();
            }
            addChild(_loc5_);
            this._desktopIconsV.push(_loc5_);
         }
         this._currentIndex = Math.min(this._currentIndex,this._desktopIconsV.length);
         this._countInLastColumn = this._desktopIconsV.length % this._maxRows;
         if(this._countInLastColumn == 0)
         {
            this._countInLastColumn = this._maxRows;
         }
         if(param2 && this._desktopIconsV.length > 0)
         {
            this._desktopIconsV[this._currentIndex].Highlight();
         }
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(param1 == "Accept" && !param2 && this._desktopIconsV.length > 0)
         {
            this._desktopIconsV[this._currentIndex].onClick();
            GlobalFunc.PlayMenuSound("Play_UI_Terminal_General_OK");
            _loc3_ = true;
         }
         return _loc3_;
      }
      
      public function onKeyDownHandler(param1:KeyboardEvent) : void
      {
         var _loc2_:String = "";
         switch(param1.keyCode)
         {
            case Keyboard.UP:
               if(this._currentIndex % this._maxRows > 0)
               {
                  this.ChangeHighlightedIcon(this._currentIndex - 1);
               }
               break;
            case Keyboard.DOWN:
               if(this._currentIndex < this._desktopIconsV.length - 1 && this._currentIndex % this._maxRows < this._maxRows - 1)
               {
                  this.ChangeHighlightedIcon(this._currentIndex + 1);
               }
               break;
            case Keyboard.LEFT:
               if(this._currentIndex - this._maxRows >= 0)
               {
                  this.ChangeHighlightedIcon(this._currentIndex - this._maxRows);
               }
               break;
            case Keyboard.RIGHT:
               if(this._currentIndex < this._desktopIconsV.length - this._countInLastColumn)
               {
                  this.ChangeHighlightedIcon(Math.min(this._desktopIconsV.length - 1,this._currentIndex + this._maxRows));
               }
         }
      }
      
      private function onIconHighlighted(param1:Event) : void
      {
         if(this._desktopIconsV[this._currentIndex] != param1.target)
         {
            this._desktopIconsV[this._currentIndex].Dehighlight();
            this._currentIndex = this._desktopIconsV.indexOf(param1.target);
         }
      }
      
      private function ChangeHighlightedIcon(param1:int) : void
      {
         this._desktopIconsV[this._currentIndex].Dehighlight();
         this._currentIndex = param1;
         this._desktopIconsV[this._currentIndex].Highlight();
         GlobalFunc.PlayMenuSound("UITerminalGeneralFocus");
      }
      
      private function UpdateIconFaction() : void
      {
         var _loc2_:DesktopIconObject = null;
         this.IconWidthScale = 1 / scaleX;
         this.IconHeightScale = 1 / scaleY;
         var _loc1_:int = 0;
         while(_loc1_ < this._desktopIconsV.length)
         {
            _loc2_ = this._desktopIconsV[_loc1_];
            _loc2_.UpdateFaction(this.FactionName);
            if(_loc1_ == this._currentIndex)
            {
               _loc2_.Highlight();
            }
            else
            {
               _loc2_.Dehighlight();
            }
            _loc2_.scaleX = this.IconWidthScale;
            _loc2_.scaleY = this.IconHeightScale;
            _loc2_.x = (_loc2_.width + this._paddingX) * Math.floor(_loc1_ / this._maxRows);
            _loc2_.y = (_loc2_.height + this._paddingY) * (_loc1_ % this._maxRows);
            _loc1_++;
         }
      }
   }
}
