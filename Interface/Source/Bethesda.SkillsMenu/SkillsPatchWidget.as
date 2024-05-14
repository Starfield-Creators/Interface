package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Data.UIDataFromClient;
   import Shared.AS3.Events.CustomEvent;
   import Shared.GlobalFunc;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.getDefinitionByName;
   
   public class SkillsPatchWidget extends EventDispatcher
   {
      
      public static const PATCHES_LOADED:String = "PatchesLoaded";
      
      private static var LargeTextMode:Boolean = false;
       
      
      private var PatchData:String = "PatchData";
      
      private var MAX_PERK_RANK:uint = 5;
      
      private var PatchDataObject:Object = null;
      
      private var SKILL_ROW_X:uint = 0;
      
      private var SKILL_ROW_Y:uint = 0;
      
      private var SKILL_ROW_SPACING:uint = 140;
      
      private var SKILL_COLUMN_SPACING:uint = 128;
      
      private var LINE_OFFSET_X:uint = 30;
      
      private var LINE_OFFSET_Y_LOW:uint = 50;
      
      private var LINE_OFFSET_Y:uint = 60;
      
      private var NAMEPLATE_BG_BUFFER:uint = 15;
      
      private var PATCH_UNAVAILABLE:String = "Unavailable";
      
      private var PATCH_AVAILABLE:String = "Available";
      
      private var PATCH_RANK:String = "Rank";
      
      private var PatchClips:Array;
      
      private var UpdatedPatch:uint = 4294967295;
      
      private var SkillPatchLoader:Loader = null;
      
      private var MAX_VISUAL_RANK:uint = 4;
      
      private var Initialized:* = false;
      
      public function SkillsPatchWidget()
      {
         var req:URLRequest;
         var loaderContext:LoaderContext;
         this.PatchClips = new Array();
         super();
         this.SkillPatchLoader = new Loader();
         req = new URLRequest(LargeTextMode ? "SkillPatches_LRG.swf" : "SkillPatches.swf");
         loaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
         this.SkillPatchLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(param1:Event):*
         {
            var _loc2_:UIDataFromClient = BSUIDataManager.GetDataFromClient("PatchData");
            if(_loc2_.dataReady)
            {
               PatchDataObject = _loc2_.data;
               if(PatchDataObject)
               {
                  InitializeSkills(PatchDataObject.Patches.dataA);
               }
               BSUIDataManager.Subscribe(PatchData,onPatchDataUpdate);
            }
         });
         this.SkillPatchLoader.load(req,loaderContext);
      }
      
      public static function set largeTextMode(param1:Boolean) : *
      {
         LargeTextMode = param1;
      }
      
      private function onPatchDataUpdate(param1:FromClientDataEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:MovieClip = null;
         this.PatchDataObject = param1.data;
         if(!this.Initialized || this.PatchClips.length == 0)
         {
            this.InitializeSkills(this.PatchDataObject.Patches.dataA);
         }
         else
         {
            _loc2_ = 0;
            while(_loc2_ < this.PatchClips.length && param1.data.Patches.updatedindicesA && _loc2_ < param1.data.Patches.updatedindicesA.length)
            {
               _loc3_ = uint(param1.data.Patches.updatedindicesA[_loc2_]);
               _loc4_ = this.PatchClips[_loc3_];
               this.UpdateSkill(_loc4_,param1.data.Patches.dataA,_loc3_);
               _loc2_++;
            }
         }
         if(this.PatchClips.length > 0)
         {
            dispatchEvent(new Event(PATCHES_LOADED,true));
         }
      }
      
      public function onSkillSelected(param1:CustomEvent) : *
      {
      }
      
      private function UpdateSkill(param1:MovieClip, param2:Array, param3:uint) : *
      {
         var _loc4_:String = null;
         var _loc5_:Boolean = false;
         var _loc6_:String = null;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:uint = 0;
         var _loc10_:String = null;
         var _loc11_:MovieClip = null;
         if(param3 < param2.length && Boolean(param2[param3]))
         {
            GlobalFunc.SetText(param1.SkillNameplate_mc.SkillLabel_mc.Text_tf,param2[param3].sName,false,false,0,true);
            _loc4_ = "Rank" + Math.max(1,Math.min(5,param2[param3].uRankCount));
            param1.SkillNameplate_mc.gotoAndStop(_loc4_);
            _loc5_ = (param1 as PatchClip).QSelected();
            param1.SkillNameplate_mc.visible = _loc5_;
            _loc6_ = !!param2[param3].bAvailable ? "Rank" + param2[param3].uRank : "Unavailable";
            param1.PatchBackground_mc.gotoAndStop(_loc6_);
            _loc7_ = 0;
            while(_loc7_ < this.MAX_PERK_RANK)
            {
               _loc10_ = "Empty";
               if(this.UpdatedPatch != uint.MAX_VALUE && this.UpdatedPatch == param2[param3].uPerkID && _loc7_ == param2[param3].uRank - 1)
               {
                  _loc10_ = "ConfirmNew";
               }
               else if(_loc7_ <= param2[param3].uRank - 1)
               {
                  _loc10_ = "Filled";
               }
               else if(_loc7_ == param2[param3].uRank)
               {
                  _loc10_ = "NextAvailable";
               }
               if((_loc11_ = _loc11_ = param1.SkillNameplate_mc.getChildByName("Star" + (_loc7_ + 1).toString() + "_mc") as MovieClip) != null)
               {
                  _loc11_.gotoAndStop(_loc10_);
               }
               _loc7_++;
            }
            (param1 as PatchClip).SetData(param2[param3]);
            if(this.UpdatedPatch != uint.MAX_VALUE && this.UpdatedPatch == param2[param3].uPerkID)
            {
               param1.gotoAndPlay("ConfirmPurchase");
               param1.addEventListener("TIMELINE_CONFIRM_NEW",this.onConfirmNew);
               this.UpdatedPatch = uint.MAX_VALUE;
            }
            if(param1.PatchArtClip_mc.getChildAt(0))
            {
               if(param2[param3].uRank == 0)
               {
                  param1.PatchArtClip_mc.getChildAt(0).gotoAndStop(!!param2[param3].bAvailable ? "Available" : "Unavailable");
               }
               else
               {
                  param1.PatchArtClip_mc.getChildAt(0).gotoAndStop("Rank" + Math.min(param2[param3].uRank,this.MAX_VISUAL_RANK));
               }
            }
            _loc8_ = param2[param3].uRequiredPurchasesToUnlock == 0 && param2[param3].uRank > 0 && param2[param3].uRank != param2[param3].uRankCount && (param2[param3].uRank < param2[param3].RankDataA.length ? !param2[param3].RankDataA[param2[param3].uRank].bLocked : false);
            _loc9_ = 0;
            while(_loc8_ && _loc9_ < param2[param3].RequirementsA.length)
            {
               _loc8_ = param2[param3].RequirementsA[_loc9_].fPercentComplete >= 0;
               _loc9_++;
            }
            if(_loc8_)
            {
               param1.Highlight_mc.gotoAndStop("Start");
            }
            else
            {
               param1.Highlight_mc.gotoAndStop("Stop");
            }
         }
      }
      
      private function onConfirmNew(param1:Event) : *
      {
         this.SetPatchData(param1.target.PatchArtClip_mc.getChildAt(0),(param1.target as PatchClip).QData());
      }
      
      private function InitializeSkills(param1:Array) : *
      {
         var lastClip:MovieClip;
         var index:uint = 0;
         var ClipClassReference:Class = null;
         var clip:MovieClip = null;
         var rect:Rectangle = null;
         var ClassReference:Class = null;
         var patchClip:MovieClip = null;
         var DefaultClassReference:Class = null;
         var defaultPatchClip:MovieClip = null;
         var aData:Array = param1;
         this.Initialized = true;
         this.PatchClips.splice(0);
         lastClip = null;
         index = 0;
         index = 0;
         while(index < aData.length)
         {
            ClipClassReference = getDefinitionByName("Patch_Container_" + aData[index].uCategory) as Class;
            clip = new ClipClassReference();
            try
            {
               ClassReference = getDefinitionByName(aData[index].sArtName) as Class;
               patchClip = new ClassReference();
               clip.PatchArtClip_mc.addChild(patchClip);
               this.SetPatchData(patchClip,aData[index]);
            }
            catch(e:ReferenceError)
            {
               DefaultClassReference = getDefinitionByName("Patch_" + aData[index].uCategory + "_Default") as Class;
               defaultPatchClip = new DefaultClassReference();
               clip.PatchArtClip_mc.addChild(defaultPatchClip);
               SetPatchData(defaultPatchClip,aData[index]);
            }
            clip.Highlight_mc.gotoAndStop("Stop");
            this.UpdateSkill(clip,aData,index);
            rect = clip.SkillNameplate_mc.SkillLabel_mc.Text_tf.getBounds(clip.SkillNameplate_mc);
            clip.SkillNameplate_mc.Ranks_Nameplate_BG_mc.x = rect.topLeft.x - this.NAMEPLATE_BG_BUFFER;
            clip.SkillNameplate_mc.Ranks_Nameplate_BG_mc.width = rect.width + this.NAMEPLATE_BG_BUFFER * 2;
            this.PatchClips.push(clip);
            index++;
         }
      }
      
      public function PopulateSkillTier(param1:MovieClip, param2:uint, param3:uint, param4:Function) : Boolean
      {
         var _loc5_:Boolean = false;
         var _loc6_:uint = 0;
         var _loc7_:Array = new Array();
         var _loc8_:uint = 0;
         while(_loc8_ < this.PatchDataObject.Patches.dataA.length)
         {
            if(param2 == this.PatchDataObject.Patches.dataA[_loc8_].uCategory && param3 == this.PatchDataObject.Patches.dataA[_loc8_].uSkillGroup)
            {
               _loc6_++;
               _loc7_.push(_loc8_);
               _loc5_ ||= this.PatchDataObject.Patches.dataA[_loc8_].uRequiredPurchasesToUnlock > 0;
            }
            _loc8_++;
         }
         var _loc9_:uint = 0;
         while(_loc9_ < _loc7_.length)
         {
            param4(this.PatchClips[_loc7_[_loc9_]],param1,_loc9_,_loc6_,param2);
            _loc9_++;
         }
         return _loc5_;
      }
      
      private function SortPatches(param1:Object, param2:Object) : Number
      {
         if(param1.uSkillGroup > param2.uSkillGroup)
         {
            return 1;
         }
         if(param1.uSkillGroup < param2.uSkillGroup)
         {
            return -1;
         }
         if(param1.uCategory > param2.uCategory)
         {
            return 1;
         }
         if(param1.uColumn < param2.uColumn)
         {
            return -1;
         }
         return (param1.sName as String).localeCompare(param2.sName as String);
      }
      
      private function SetPatchData(param1:MovieClip, param2:Object) : *
      {
         if(param2.bAvailable == false)
         {
            param1.gotoAndStop(this.PATCH_UNAVAILABLE);
         }
         else if(param2.uRank == 0)
         {
            param1.gotoAndStop(this.PATCH_AVAILABLE);
         }
         else if(param2.uRank <= param2.uRankCount)
         {
            param1.gotoAndStop(this.PATCH_RANK + param2.uRank.toString());
         }
         else
         {
            trace("Data set incorrecty for perk " + param2.sName);
         }
      }
      
      public function GetPatchSelectedIndex() : uint
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this.PatchClips.length)
         {
            if(this.PatchClips[_loc1_].QSelected())
            {
               return _loc1_;
            }
            _loc1_++;
         }
         return uint.MAX_VALUE;
      }
      
      public function GetPatchData(param1:uint) : Object
      {
         return Boolean(this.PatchDataObject) && param1 < this.PatchDataObject.Patches.dataA.length ? this.PatchDataObject.Patches.dataA[param1] : null;
      }
   }
}
