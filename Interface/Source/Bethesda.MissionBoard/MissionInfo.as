package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.BSScrollingBar;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class MissionInfo extends BSDisplayObject
   {
       
      
      public var MissionName_mc:MovieClip;
      
      public var MissionType_mc:MovieClip;
      
      public var MissionDescription_mc:MovieClip;
      
      public var MissionDataBlock_0_mc:MissionDataBlock;
      
      public var MissionDataBlock_1_mc:MissionDataBlock;
      
      public var MissionDataBlock_2_mc:MissionDataBlock;
      
      public var MissionDataBlock_3_mc:MissionDataBlock;
      
      public var MissionDataBlock_4_mc:MissionDataBlock;
      
      public var MissionDataBlock_5_mc:MissionDataBlock;
      
      public var RewardAmount_mc:MovieClip;
      
      private var textFieldSizeMap:Object;
      
      private const MaxDetailsC:int = 6;
      
      private const THUMBSTICK_THRESHOLD:Number = 0.3;
      
      public function MissionInfo()
      {
         this.textFieldSizeMap = new Object();
         super();
      }
      
      private function set MissionName(param1:String) : void
      {
         GlobalFunc.SetText(this.MissionName_mc.text_tf,param1);
         this.ShrinkFontToFit(this.MissionName_mc.text_tf);
      }
      
      private function set MissionType(param1:String) : void
      {
         GlobalFunc.SetText(this.MissionType_mc.text_tf,param1);
      }
      
      private function set MissionDescription(param1:String) : void
      {
         GlobalFunc.SetText(this.MissionDescription_mc.text_tf,param1);
      }
      
      private function set RewardAmount(param1:String) : void
      {
         GlobalFunc.SetText(this.RewardAmount_mc.text_tf,param1);
      }
      
      private function get MissionDescriptionTextField() : TextField
      {
         return this.MissionDescription_mc.text_tf;
      }
      
      private function get MissionDescriptionScrollBar() : BSScrollingBar
      {
         return this.MissionDescription_mc.ScrollBar;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         BSUIDataManager.Subscribe("MissionInfo",this.UpdateMissionInfo);
         this.MissionDescriptionTextField.addEventListener(Event.SCROLL,function(param1:Event):*
         {
            MissionDescriptionScrollBar.UpdateScrollInfo(MissionDescriptionTextField.scrollV - 1);
         });
      }
      
      private function SetupDataBlock(param1:int, param2:String, param3:String, param4:String) : *
      {
         var _loc5_:* = "MissionDataBlock_" + param1 + "_mc";
         var _loc6_:MissionDataBlock;
         if((_loc6_ = getChildByName(_loc5_) as MissionDataBlock) != null)
         {
            _loc6_.TextField1 = param2;
            if(param4 == "")
            {
               _loc6_.TextField2Large = param3;
            }
            else
            {
               _loc6_.TextField2 = param3;
            }
            _loc6_.TextField3 = param4;
         }
      }
      
      private function UpdateMissionInfo(param1:FromClientDataEvent) : *
      {
         var _loc4_:* = undefined;
         if(!param1.data)
         {
            return;
         }
         this.MissionName = param1.data.sTitle;
         this.MissionType = param1.data.sType;
         this.MissionDescription = param1.data.sDescription;
         this.RewardAmount = param1.data.fReward;
         this.MissionDescriptionTextField.scrollV = 0;
         this.MissionDescriptionScrollBar.Update(0,this.MissionDescriptionTextField.maxScrollV - 1,this.MissionDescriptionTextField.numLines);
         var _loc2_:* = param1.data.aDetailsDataA as Array;
         var _loc3_:int = 0;
         while(_loc3_ < this.MaxDetailsC)
         {
            if(_loc4_ = !!_loc2_ ? _loc2_[_loc3_] : null)
            {
               this.SetupDataBlock(_loc3_,_loc2_[_loc3_].sTitle,_loc2_[_loc3_].sPrimaryText,_loc2_[_loc3_].sSecondaryText);
            }
            else
            {
               this.SetupDataBlock(_loc3_,"","","");
            }
            _loc3_++;
         }
      }
      
      public function OnRightStickInput(param1:Number, param2:Number, param3:Number, param4:Boolean, param5:Boolean) : *
      {
         if(param4)
         {
            if(Math.abs(param2) > this.THUMBSTICK_THRESHOLD)
            {
               if(param2 > 0)
               {
                  ++this.MissionDescriptionTextField.scrollV;
               }
               else
               {
                  --this.MissionDescriptionTextField.scrollV;
               }
            }
         }
      }
      
      public function UpdateFaction(param1:String) : void
      {
         gotoAndStop(param1);
         this.MissionDataBlock_0_mc.gotoAndStop(param1);
         this.MissionDataBlock_1_mc.gotoAndStop(param1);
         this.MissionDataBlock_2_mc.gotoAndStop(param1);
         this.MissionDataBlock_3_mc.gotoAndStop(param1);
         this.MissionDataBlock_4_mc.gotoAndStop(param1);
         this.MissionDataBlock_5_mc.gotoAndStop(param1);
      }
      
      private function ShrinkFontToFit(param1:TextField) : *
      {
         var _loc3_:int = 0;
         var _loc2_:TextFormat = param1.getTextFormat();
         if(this.textFieldSizeMap[param1] == null)
         {
            this.textFieldSizeMap[param1] = _loc2_.size;
         }
         _loc2_.size = this.textFieldSizeMap[param1];
         param1.setTextFormat(_loc2_);
         while(param1.maxScrollV > 1 && _loc2_.size > 4)
         {
            _loc3_ = _loc2_.size as int;
            _loc2_.size = _loc3_ - 1;
            param1.setTextFormat(_loc2_);
         }
      }
   }
}
