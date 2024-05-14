package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class DigiKeyPanel extends MovieClip
   {
      
      public static const REFRESH_PICK_RING:String = "RefreshPickRing";
      
      public static const TRY_USE_KEY:String = "SecurityMenu_TryUseKey";
       
      
      public var LinkedObject_mc:MovieClip;
      
      public var SecurityLevel_mc:MovieClip;
      
      public var SecurityLevelAnim_mc:MovieClip;
      
      public var KeyPanel_mc:MovieClip;
      
      public var DigiKeys:Array;
      
      public var NextKeyIndex:int = 0;
      
      private var MaxShownKeys:uint = 0;
      
      private var StartingKeysBGMaskHeight:Number = 0;
      
      private var KeyPanelStartingYPosition:Number = 0;
      
      private var DigiKeyRotation:Array;
      
      private var KeyDataObject:Object;
      
      private var OnAutoAttemptCalled:Object;
      
      private const NUMBER_OF_KEYS_IN_ROW:int = 4;
      
      private var StartScreen:Boolean = true;
      
      private const MAX_KEY_SYMBOLS:uint = 16;
      
      private var SelectedKey:uint = 0;
      
      public function DigiKeyPanel()
      {
         this.DigiKeyRotation = new Array(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
         super();
         addEventListener("ExitMenu",this.ExitMenu);
         BSUIDataManager.Subscribe("SecurityAutoAttemptData",this.OnSecurityAutoAttemptDataChanged);
         if(this.KeyPanel_mc)
         {
            if(this.KeyPanel_mc.KeysBGMask)
            {
               this.StartingKeysBGMaskHeight = this.KeyPanel_mc.KeysBGMask.height;
            }
            this.KeyPanelStartingYPosition = this.KeyPanel_mc.y;
         }
      }
      
      public function Start(param1:Object) : *
      {
         this.StartScreen = false;
         this.SetKeyData(this.KeyDataObject);
         this.OnAutoAttemptCalled = param1;
      }
      
      public function set maxShownKeys(param1:uint) : *
      {
         this.MaxShownKeys = Math.min(param1,this.MAX_KEY_SYMBOLS);
      }
      
      public function set selectedKey(param1:int) : *
      {
         var _loc2_:uint = this.SelectedKey;
         if(param1 >= this.MaxShownKeys)
         {
            this.SelectedKey = 0;
         }
         else if(param1 < 0)
         {
            this.SelectedKey = this.MaxShownKeys - 1;
         }
         else
         {
            this.SelectedKey = param1;
         }
         this.RefreshKeys(_loc2_,this.SelectedKey);
         BSUIDataManager.dispatchEvent(new CustomEvent("SecurityMenu_SelectNewKey",{"iKeyIndex":this.SelectedKey}));
      }
      
      public function get selectedKey() : *
      {
         return this.SelectedKey;
      }
      
      public function ExitMenu() : *
      {
         BSUIDataManager.dispatchEvent(new Event("SecurityMenu_CloseMenu",true));
         BSUIDataManager.Unsubscribe("SecurityAutoAttemptData",this.OnSecurityAutoAttemptDataChanged);
      }
      
      private function OnSecurityAutoAttemptDataChanged(param1:FromClientDataEvent) : *
      {
         if(param1.data.uiCurrentHintKeyIndex < this.MaxShownKeys)
         {
            this.selectedKey = param1.data.uiCurrentHintKeyIndex;
            this.DigiKeyRotation[this.SelectedKey] = param1.data.uiNewKeyRotation;
            this.OnAutoAttemptCalled();
         }
      }
      
      private function handleMouseRelease(param1:CustomEvent) : *
      {
         var _loc2_:* = this.selectedKey;
         var _loc3_:uint = param1.params.Index < this.DigiKeys.length && param1.params.Index < this.KeyDataObject.length ? uint(param1.params.Index) : uint.MAX_VALUE;
         if(_loc3_ != uint.MAX_VALUE)
         {
            if(!this.KeyDataObject[_loc3_].bUsed)
            {
               this.selectedKey = _loc3_;
               this.dispatchEvent(new Event(REFRESH_PICK_RING));
               GlobalFunc.PlayMenuSound("UI_Menu_Minigame_Security_Select_Shape");
            }
         }
         if(_loc2_ == this.selectedKey)
         {
            this.dispatchEvent(new Event(TRY_USE_KEY));
         }
      }
      
      public function SelectUnusedKey(param1:Object) : *
      {
         if(this.selectedKey < param1.length && Boolean(param1[this.selectedKey].bUsed))
         {
            this.SelectNextUnusedKey(param1,true);
         }
      }
      
      public function SelectNextUnusedKey(param1:Object, param2:Boolean = true) : *
      {
         var _loc3_:int = int(param1.length);
         var _loc4_:Boolean = false;
         while(_loc3_ > 0 && _loc4_ == false)
         {
            this.selectedKey += param2 ? 1 : -1;
            if(param1[this.selectedKey].bUsed)
            {
               _loc3_--;
            }
            else
            {
               _loc4_ = true;
            }
         }
      }
      
      private function GetNumOfRows() : int
      {
         return this.MaxShownKeys / this.NUMBER_OF_KEYS_IN_ROW;
      }
      
      private function GetUnusedIndexNearestToSelectedIndexColumn(param1:Object, param2:int, param3:int) : int
      {
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:Point = null;
         var _loc10_:int = 0;
         var _loc11_:Point = null;
         var _loc4_:int = -1;
         if(param2 <= this.GetNumOfRows())
         {
            if((_loc5_ = param3 % this.NUMBER_OF_KEYS_IN_ROW + param2 * this.NUMBER_OF_KEYS_IN_ROW) < this.MaxShownKeys && !param1[_loc5_].bUsed)
            {
               _loc4_ = _loc5_;
            }
            else
            {
               _loc6_ = false;
               _loc7_ = false;
               _loc8_ = false;
               _loc9_ = new Point(1,1);
               _loc11_ = new Point(param2 * this.NUMBER_OF_KEYS_IN_ROW,(param2 + 1) * this.NUMBER_OF_KEYS_IN_ROW - 1);
               while(_loc4_ == -1 && (!_loc7_ || !_loc8_))
               {
                  if(_loc6_)
                  {
                     if(!_loc7_)
                     {
                        _loc10_ = _loc5_ - _loc9_.x;
                        ++_loc9_.x;
                        if(_loc10_ < this.MaxShownKeys)
                        {
                           if(_loc10_ < _loc11_.x)
                           {
                              _loc7_ = true;
                           }
                           else if(!param1[_loc10_].bUsed)
                           {
                              _loc4_ = _loc10_;
                           }
                        }
                     }
                     _loc6_ = false;
                  }
                  else
                  {
                     if(!_loc8_)
                     {
                        _loc10_ = _loc5_ + _loc9_.y;
                        ++_loc9_.y;
                        if(_loc10_ > _loc11_.y || _loc10_ >= this.MaxShownKeys)
                        {
                           _loc8_ = true;
                        }
                        else if(!param1[_loc10_].bUsed)
                        {
                           _loc4_ = _loc10_;
                        }
                     }
                     _loc6_ = true;
                  }
               }
            }
         }
         return _loc4_;
      }
      
      public function SelectNextRowUnusedKey(param1:Object, param2:Boolean = true) : *
      {
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc3_:int = int(param1.length);
         if(param1.length > this.NUMBER_OF_KEYS_IN_ROW && this.MaxShownKeys > this.NUMBER_OF_KEYS_IN_ROW && this.MaxShownKeys <= param1.length)
         {
            _loc4_ = false;
            _loc5_ = -1;
            _loc6_ = int(this.MaxShownKeys);
            _loc7_ = int(this.MaxShownKeys - 1);
            while(_loc7_ >= 0)
            {
               if(!param1[_loc7_].bUsed)
               {
                  break;
               }
               _loc6_--;
               _loc7_++;
            }
            if(_loc6_ > this.NUMBER_OF_KEYS_IN_ROW)
            {
               _loc8_ = Math.floor(this.selectedKey / this.NUMBER_OF_KEYS_IN_ROW);
               _loc9_ = Math.floor(_loc6_ / this.NUMBER_OF_KEYS_IN_ROW);
               _loc10_ = _loc8_;
               if(param2)
               {
                  do
                  {
                     _loc8_++;
                     if(_loc8_ > _loc9_)
                     {
                        _loc8_ = 0;
                     }
                     if(_loc8_ == _loc10_)
                     {
                        break;
                     }
                  }
                  while((_loc5_ = this.GetUnusedIndexNearestToSelectedIndexColumn(param1,_loc8_,this.selectedKey)) == -1);
                  
               }
               else
               {
                  do
                  {
                     if(--_loc8_ < 0)
                     {
                        _loc8_ = _loc9_;
                     }
                     if(_loc8_ == _loc10_)
                     {
                        break;
                     }
                  }
                  while((_loc5_ = this.GetUnusedIndexNearestToSelectedIndexColumn(param1,_loc8_,this.selectedKey)) == -1);
                  
               }
               if(_loc5_ != -1)
               {
                  if(this.selectedKey != _loc5_)
                  {
                     this.selectedKey = _loc5_;
                  }
               }
            }
         }
      }
      
      public function SetKeyData(param1:Object) : *
      {
         var _loc6_:uint = 0;
         var _loc7_:* = false;
         var _loc8_:uint = 0;
         var _loc9_:Boolean = false;
         var _loc10_:Number = NaN;
         this.KeyDataObject = param1;
         this.SelectUnusedKey(param1);
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         while(_loc4_ < param1.length)
         {
            if(param1[_loc4_].TeethA.length > 0)
            {
               _loc2_++;
            }
            if(param1[_loc4_].bUsed)
            {
               _loc3_++;
            }
            else
            {
               _loc3_ = 0;
            }
            _loc6_ = 0;
            while(_loc6_ < 32)
            {
               _loc8_ = uint(this.RoundToothIndex(_loc6_ + this.DigiKeyRotation[_loc4_]));
               _loc9_ = param1[_loc4_].TeethA.indexOf(_loc6_) > -1 && !param1[_loc4_].bUsed;
               if(!this.StartScreen)
               {
                  this.KeyPanel_mc["Key_" + _loc4_]["KeyTooth_mc_" + _loc8_].gotoAndPlay(_loc9_ ? "on" : "off");
               }
               _loc6_++;
            }
            if((_loc7_ = param1[_loc4_].uHintRing < 4) && param1[_loc4_].TeethA.length > 0)
            {
               this.KeyPanel_mc["Key_" + _loc4_].SetHintRing();
            }
            if(!this.StartScreen)
            {
               this.KeyPanel_mc["Key_" + _loc4_].KeySelected_mc.gotoAndPlay(_loc4_ == this.SelectedKey ? "selected" : "unselected");
            }
            else if(param1[_loc4_].TeethA.length > 0)
            {
               this.KeyPanel_mc["Key_" + _loc4_].gotoAndPlay("show");
            }
            _loc4_++;
         }
         this.maxShownKeys = _loc2_ - _loc3_;
         var _loc5_:int = 0;
         while(_loc5_ < this.MAX_KEY_SYMBOLS)
         {
            this.KeyPanel_mc["Key_" + _loc5_].visible = _loc5_ < this.MaxShownKeys;
            _loc5_++;
         }
         if(this.KeyPanel_mc.KeysBGMask)
         {
            this.KeyPanel_mc.KeysBGMask.height = this.StartingKeysBGMaskHeight - this.KeyPanel_mc.Key_0.height * (Math.floor(this.MAX_KEY_SYMBOLS / this.NUMBER_OF_KEYS_IN_ROW) - 1 - Math.floor((this.MaxShownKeys - 1) / this.NUMBER_OF_KEYS_IN_ROW));
            _loc10_ = (this.StartingKeysBGMaskHeight - this.KeyPanel_mc.KeysBGMask.height) / 2;
            dispatchEvent(new CustomEvent(SecurityMenu.MOVE_DIGI_PICK_REMAIN,{"movement":_loc10_},true,true));
            this.KeyPanel_mc.y = this.KeyPanelStartingYPosition + _loc10_;
         }
      }
      
      public function HandleRotation(param1:Boolean) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:Boolean = false;
         this.DigiKeyRotation[this.SelectedKey] += param1 ? 1 : -1;
         var _loc2_:uint = 0;
         while(_loc2_ < 32)
         {
            _loc3_ = uint(this.RoundToothIndex(_loc2_ + this.DigiKeyRotation[this.SelectedKey]));
            _loc4_ = this.KeyDataObject[this.SelectedKey].TeethA.indexOf(_loc2_) > -1 && !this.KeyDataObject[this.SelectedKey].bUsed;
            this.KeyPanel_mc["Key_" + this.SelectedKey]["KeyTooth_mc_" + _loc3_].gotoAndPlay(_loc4_ ? "on" : "off");
            _loc2_++;
         }
      }
      
      private function RoundToothIndex(param1:int) : int
      {
         return param1 - Math.floor(param1 / 32) * 32;
      }
      
      private function RefreshKeys(param1:uint, param2:uint) : *
      {
         this.KeyPanel_mc["Key_" + param1].KeySelected_mc.gotoAndPlay("unselected");
         this.KeyPanel_mc["Key_" + param2].KeySelected_mc.gotoAndPlay("selected");
      }
      
      public function GetCurrentKeyRotation() : int
      {
         return this.RoundToothIndex(this.DigiKeyRotation[this.SelectedKey]);
      }
      
      public function ShowKeyRingPanel() : *
      {
         this.DigiKeys = new Array(this.KeyPanel_mc.Key_0,this.KeyPanel_mc.Key_1,this.KeyPanel_mc.Key_2,this.KeyPanel_mc.Key_3,this.KeyPanel_mc.Key_4,this.KeyPanel_mc.Key_5,this.KeyPanel_mc.Key_6,this.KeyPanel_mc.Key_7,this.KeyPanel_mc.Key_8,this.KeyPanel_mc.Key_9,this.KeyPanel_mc.Key_10,this.KeyPanel_mc.Key_11,this.KeyPanel_mc.Key_12,this.KeyPanel_mc.Key_13,this.KeyPanel_mc.Key_14,this.KeyPanel_mc.Key_15);
         addEventListener("ShowNextKey",this.ShowNextKey);
         var _loc1_:uint = 0;
         while(_loc1_ < this.DigiKeys.length)
         {
            this.DigiKeys[_loc1_].keyIndex = _loc1_;
            this.DigiKeys[_loc1_].addEventListener(DigiKey.KEY_CLICKED,this.handleMouseRelease);
            _loc1_++;
         }
         this.DigiKeys[this.NextKeyIndex].gotoAndPlay("show");
      }
      
      public function ShowNextKey() : *
      {
         if(Boolean(this.KeyDataObject) && this.NextKeyIndex < this.KeyDataObject.length)
         {
            if(this.KeyDataObject[this.NextKeyIndex].TeethA.length > 0)
            {
               this.DigiKeys[this.NextKeyIndex].gotoAndPlay("show");
            }
         }
         ++this.NextKeyIndex;
      }
      
      public function HideKeyRingPanel() : *
      {
         gotoAndPlay("hide");
         this.KeyPanel_mc.gotoAndPlay("hide");
      }
   }
}
