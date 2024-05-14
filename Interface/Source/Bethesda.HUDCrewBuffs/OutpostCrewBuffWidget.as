package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class OutpostCrewBuffWidget extends MovieClip
   {
      
      public static const ANIMATE_CLIPS:String = "AnimateClips";
      
      public static const CLIP_ROLLON_COMPLETE:String = "ClipRollonComplete";
      
      public static const CLIP_ROLLOFF_COMPLETE:String = "ClipRolloffComplete";
      
      public static const HIDDEN:String = "hidden";
      
      public static const ROLL_OFF:String = "rollOff";
      
      public static const ROLL_ON:String = "rollOn";
      
      private static const CREW_BUFF_SPACING:uint = 12;
       
      
      public var Name_mc:MovieClip;
      
      public var Location_mc:MovieClip;
      
      public var CrewBuffs_mc:MovieClip;
      
      private var CrewBuffDataQueue:Vector.<OutpostCrewBuffData>;
      
      private var CrewBuffItemsA:Array;
      
      private var _nextClipIndex:uint = 0;
      
      private var _playingAnimation:Boolean = false;
      
      public function OutpostCrewBuffWidget()
      {
         this.CrewBuffItemsA = new Array();
         super();
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.Name_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.Location_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         this.CrewBuffDataQueue = new Vector.<OutpostCrewBuffData>();
         BSUIDataManager.Subscribe("HUDCrewBuffData",this.OnCrewBuffDataChange);
      }
      
      public function get totalClips() : int
      {
         return this.CrewBuffItemsA.length;
      }
      
      private function OnCrewBuffDataChange(param1:FromClientDataEvent) : *
      {
         var _loc2_:OutpostCrewBuffData = null;
         var _loc3_:uint = 0;
         if(param1.data.sName != "")
         {
            _loc2_ = new OutpostCrewBuffData(param1.data.sName,param1.data.sLocation);
            _loc3_ = 0;
            while(_loc3_ < param1.data.aCrewBuffs.length)
            {
               _loc2_.AddCrewBuff(param1.data.aCrewBuffs[_loc3_]);
               _loc3_++;
            }
            this.CrewBuffDataQueue.push(_loc2_);
         }
         this.PlayCrewBuffAnimation();
      }
      
      private function PlayCrewBuffAnimation() : void
      {
         var _loc1_:OutpostCrewBuffData = null;
         if(!this._playingAnimation)
         {
            _loc1_ = this.CrewBuffDataQueue.shift();
            if(_loc1_ != null)
            {
               GlobalFunc.SetText(this.Name_mc.Text_tf,_loc1_.name);
               GlobalFunc.SetText(this.Location_mc.Text_tf,_loc1_.location);
               this.CreateClips(_loc1_.crewBuffsA);
               this.Display(true);
            }
            else
            {
               this.gotoAndStop(HIDDEN);
            }
         }
      }
      
      private function CreateClips(param1:Array) : void
      {
         var _loc4_:OutpostCrewBuffItem = null;
         while(this.CrewBuffItemsA.length > 0)
         {
            this.CrewBuffs_mc.removeChild(this.CrewBuffItemsA[0]);
            this.CrewBuffItemsA.splice(0,1);
         }
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = new OutpostCrewBuffItem();
            this.CrewBuffs_mc.addChild(_loc4_);
            _loc4_.SetName(param1[_loc3_]);
            _loc4_.y = _loc2_;
            _loc2_ += _loc4_.height + CREW_BUFF_SPACING;
            _loc4_.x = 0;
            this.CrewBuffItemsA.push(_loc4_);
            _loc3_++;
         }
      }
      
      private function Display(param1:Boolean) : void
      {
         this._playingAnimation = true;
         addEventListener(OutpostCrewBuffWidget.ANIMATE_CLIPS,this.AnimateClips);
         if(param1)
         {
            this.gotoAndPlay(ROLL_ON);
            GlobalFunc.PlayMenuSound("UIOutpostModeNameOutpostPopUp");
         }
         else
         {
            this.gotoAndPlay(ROLL_OFF);
         }
      }
      
      private function AnimateClips(param1:CustomEvent) : void
      {
         removeEventListener(OutpostCrewBuffWidget.ANIMATE_CLIPS,this.AnimateClips);
         if(param1.params.displayClips)
         {
            if(this.totalClips > 0)
            {
               addEventListener(OutpostCrewBuffWidget.CLIP_ROLLON_COMPLETE,this.ShowNextClip);
               this.ShowNextClip();
            }
            else
            {
               this.ShowComplete();
            }
         }
         else if(this.totalClips > 0)
         {
            addEventListener(OutpostCrewBuffWidget.CLIP_ROLLOFF_COMPLETE,this.HideNextClip);
            this.HideNextClip();
         }
         else
         {
            this.HideComplete();
         }
      }
      
      private function ShowNextClip() : void
      {
         var _loc1_:OutpostCrewBuffItem = null;
         if(this._nextClipIndex < this.totalClips)
         {
            _loc1_ = this.CrewBuffItemsA[this._nextClipIndex];
            if(_loc1_ != null)
            {
               _loc1_.gotoAndPlay(ROLL_ON);
            }
            ++this._nextClipIndex;
         }
         else
         {
            removeEventListener(OutpostCrewBuffWidget.CLIP_ROLLON_COMPLETE,this.ShowNextClip);
            this.ShowComplete();
         }
      }
      
      private function ShowComplete() : void
      {
         this._nextClipIndex = 0;
         this.Display(false);
      }
      
      private function HideNextClip() : void
      {
         var _loc1_:OutpostCrewBuffItem = null;
         if(this._nextClipIndex < this.totalClips)
         {
            _loc1_ = this.CrewBuffItemsA[this._nextClipIndex];
            if(_loc1_ != null)
            {
               _loc1_.gotoAndPlay(ROLL_OFF);
            }
            ++this._nextClipIndex;
         }
         else
         {
            removeEventListener(OutpostCrewBuffWidget.CLIP_ROLLOFF_COMPLETE,this.HideNextClip);
            this.HideComplete();
         }
      }
      
      private function HideComplete() : void
      {
         this._playingAnimation = false;
         this._nextClipIndex = 0;
         this.PlayCrewBuffAnimation();
      }
   }
}
