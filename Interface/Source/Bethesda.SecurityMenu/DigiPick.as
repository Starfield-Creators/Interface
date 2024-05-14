package
{
   import flash.display.MovieClip;
   
   public class DigiPick extends MovieClip
   {
       
      
      public var LockRing_mc_0:MovieClip;
      
      public var LockRing_mc_1:MovieClip;
      
      public var LockRing_mc_2:MovieClip;
      
      public var LockRing_mc_3:MovieClip;
      
      public var PickRings_mc:MovieClip;
      
      private var LockRings:Array;
      
      private var PickRings:Array;
      
      private const SLOT_COUNT:uint = 32;
      
      private var DigiPickData:Object = null;
      
      private var PickRingData:Object = null;
      
      private var PickRingIndex:int = -1;
      
      private var KeyIndex:int = 0;
      
      public var RingHighlightingEnabled:Boolean = false;
      
      private var StartScreen:Boolean = true;
      
      public function DigiPick()
      {
         this.LockRings = new Array();
         this.PickRings = new Array();
         super();
         this.LockRings.push(this.LockRing_mc_0);
         this.LockRings.push(this.LockRing_mc_1);
         this.LockRings.push(this.LockRing_mc_2);
         this.LockRings.push(this.LockRing_mc_3);
         this.PickRings.push(this.PickRings_mc.PickRing_mc_0);
         this.PickRings.push(this.PickRings_mc.PickRing_mc_1);
         this.PickRings.push(this.PickRings_mc.PickRing_mc_2);
         this.PickRings.push(this.PickRings_mc.PickRing_mc_3);
         this.PickRings_mc.gotoAndPlay("off");
      }
      
      public function Start() : *
      {
         this.StartScreen = false;
         this.SetPickRingData(this.PickRingData);
      }
      
      public function get pickRotation() : *
      {
         return this.PickRingData != null ? this.PickRingData.uiRotatePosition : 0;
      }
      
      public function RotateLeft() : *
      {
         if(this.PickRingData != null)
         {
            if(this.PickRingData.uiRotatePosition > 0)
            {
               --this.PickRingData.uiRotatePosition;
            }
            else
            {
               this.PickRingData.uiRotatePosition = this.SLOT_COUNT - 1;
            }
            this.SetPickRingData(this.PickRingData);
         }
      }
      
      public function RotateRight() : *
      {
         if(this.PickRingData != null)
         {
            if(this.PickRingData.uiRotatePosition < this.SLOT_COUNT - 1)
            {
               this.PickRingData.uiRotatePosition += 1;
            }
            else
            {
               this.PickRingData.uiRotatePosition = 0;
            }
            this.SetPickRingData(this.PickRingData);
         }
      }
      
      public function SetDigiPickData(param1:Object) : *
      {
         var _loc2_:uint = 0;
         var _loc3_:* = undefined;
         var _loc4_:uint = 0;
         var _loc5_:Boolean = false;
         this.DigiPickData = param1;
         if(param1)
         {
            this.CheckRingCompletion(param1);
            _loc2_ = 0;
            while(_loc2_ < param1.RingDataA.dataA.length && _loc2_ < param1.uiRingsShown)
            {
               _loc3_ = !!param1.RingDataA.dataA[_loc2_].bHighlighted ? "hint" : "on";
               _loc4_ = 0;
               while(_loc4_ < this.SLOT_COUNT)
               {
                  _loc5_ = !param1.RingDataA.dataA[_loc2_].bCompleted && param1.RingDataA.dataA[_loc2_].OpenSlotsA.indexOf(_loc4_) == -1;
                  this.LockRings[_loc2_]["LockRingSlot_mc_" + _loc4_.toString()].gotoAndPlay(_loc5_ ? _loc3_ : "off");
                  _loc4_++;
               }
               _loc2_++;
            }
            while(_loc2_ < param1.uiRingsMax)
            {
               _loc4_ = 0;
               while(_loc4_ < this.SLOT_COUNT)
               {
                  this.LockRings[_loc2_]["LockRingSlot_mc_" + _loc4_.toString()].gotoAndPlay("off");
                  _loc4_++;
               }
               _loc2_++;
            }
            _loc2_ = 0;
            while(_loc2_ < this.LockRings.length)
            {
               this.LockRings[_loc2_].Highlight_mc.gotoAndStop("hide");
               _loc2_++;
            }
         }
      }
      
      public function CheckRingCompletion(param1:Object) : *
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.LockRings.length)
         {
            this.LockRings[_loc2_].gotoAndStop("inactive");
            _loc2_++;
         }
         var _loc3_:int = 0;
         while(param1.RingDataA.dataA != null && _loc3_ < param1.RingDataA.dataA.length && _loc3_ < 4)
         {
            if(!param1.RingDataA.dataA[_loc3_].bCompleted)
            {
               if(this.PickRingIndex != _loc3_)
               {
                  this.PickRingIndex = _loc3_;
                  this.PickRings_mc.gotoAndPlay("showRing" + this.PickRingIndex.toString());
                  this.LockRings[_loc3_].gotoAndStop("normal");
                  break;
               }
               this.LockRings[this.PickRingIndex].gotoAndStop("normal");
               break;
            }
            _loc3_++;
         }
      }
      
      public function SetPickRingData(param1:Object) : *
      {
         var _loc2_:Array = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         this.PickRingData = param1;
         if(!this.StartScreen && this.PickRingData != null)
         {
            _loc2_ = param1.uiPickDataA.slice();
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc2_[_loc3_] += param1.uiRotatePosition;
               if(_loc2_[_loc3_] >= this.SLOT_COUNT)
               {
                  _loc2_[_loc3_] -= this.SLOT_COUNT;
               }
               _loc3_++;
            }
            _loc4_ = 0;
            while(_loc4_ < this.SLOT_COUNT)
            {
               this.PickRings_mc["PickRing_mc_" + this.PickRingIndex.toString()]["Pick_mc_" + _loc4_.toString()].gotoAndPlay(_loc2_.indexOf(_loc4_) == -1 ? "off" : "show");
               _loc4_++;
            }
         }
      }
   }
}
