package Shared
{
   import flash.text.TextField;
   
   public class WorkshopUtils
   {
      
      public static const GRID_ICON_TEXTURE_BUFFER:String = "WorkshopIconTextureBuffer";
      
      public static const IDLE:int = EnumHelper.GetEnum(0);
      
      public static const INSPECT_ITEM:int = EnumHelper.GetEnum();
      
      public static const INSPECT_IDLE:int = EnumHelper.GetEnum();
      
      public static const UPDATE_NEW_ITEM_PLACEMENT:int = EnumHelper.GetEnum();
      
      public static const UPDATE_EXISTING_ITEM_PLACEMENT:int = EnumHelper.GetEnum();
      
      public static const UPDATE_NEW_DEPLOYABLE_PLACEMENT:int = EnumHelper.GetEnum();
      
      public static const UPDATE_WIRE_PLACEMENT:int = EnumHelper.GetEnum();
      
      public static const UPDATE_TRANSFER_LINK_PLACEMENT:int = EnumHelper.GetEnum();
      
      public static const MODIFY_ITEM_COLORS:int = EnumHelper.GetEnum();
      
      public static const BULLDOZE_STATE:int = EnumHelper.GetEnum();
      
      public static const INSPECT_COLORS:int = EnumHelper.GetEnum();
      
      public static const WIA_NONE:int = 0;
      
      public static const WIA_MOVE:int = 1 << EnumHelper.GetEnum(0);
      
      public static const WIA_GROUP_SELECT:int = 1 << EnumHelper.GetEnum();
      
      public static const WIA_BLUEPRINT:int = 1 << EnumHelper.GetEnum();
      
      public static const WIA_REPLACE:int = 1 << EnumHelper.GetEnum();
      
      public static const WIA_DELETE:int = 1 << EnumHelper.GetEnum();
      
      public static const WIA_WIRE:int = 1 << EnumHelper.GetEnum();
      
      public static const WIA_FULL_MODE:int = 1 << EnumHelper.GetEnum();
      
      public static const WIA_TRANSFER_LINK:int = 1 << EnumHelper.GetEnum();
      
      public static const WIA_REVERT:int = 1 << EnumHelper.GetEnum();
      
      public static const WIA_REPAIR:int = 1 << EnumHelper.GetEnum();
      
      public static const WIA_CYCLE_SNAP_BEHAVIOR_ENTRY:int = 1 << EnumHelper.GetEnum();
      
      public static const WIA_SET_COLORS:int = 1 << EnumHelper.GetEnum();
      
      public static const WIA_ACTIVATE:int = 1 << EnumHelper.GetEnum();
      
      public static const WIA_COUNT:int = EnumHelper.GetEnum();
      
      public static const WQM_IDLE:int = EnumHelper.GetEnum(0);
      
      public static const WQM_OUTPOST_INTERACT:int = EnumHelper.GetEnum();
      
      public static const WQM_HUD_INTERACT:int = EnumHelper.GetEnum();
      
      public static const WQM_HUD_PERFORMING_ACTION:int = EnumHelper.GetEnum();
      
      public static const WCT_SELECT_CONNECTION:int = EnumHelper.GetEnum(-1);
      
      public static const WCT_TRANSFER_CONNECTION:int = EnumHelper.GetEnum();
      
      public static const WCT_WIRE_CONNECTION:int = EnumHelper.GetEnum();
      
      public static const WRT_NONE:int = EnumHelper.GetEnum(0);
      
      public static const WRT_SOLID:int = EnumHelper.GetEnum();
      
      public static const WRT_LIQUID:int = EnumHelper.GetEnum();
      
      public static const WRT_GAS:int = EnumHelper.GetEnum();
      
      public static const WRT_MANUFACTURED:int = EnumHelper.GetEnum();
      
      public static const WRT_POWER:int = EnumHelper.GetEnum();
      
      public static const WSM_NONE:int = EnumHelper.GetEnum(0);
      
      public static const WSM_ADJUSTING:int = EnumHelper.GetEnum();
      
      public static const WSM_BULLDOZING:int = EnumHelper.GetEnum();
      
      public static const WSM_ROTATING:int = EnumHelper.GetEnum();
      
      public static const WIM_NONE:int = EnumHelper.GetEnum(-1);
      
      public static const WIM_BUILD_MODE:int = EnumHelper.GetEnum();
      
      public static const WIM_MODIFY_MODE:int = EnumHelper.GetEnum();
      
      public static const WIM_BULLDOZE_MODE:int = EnumHelper.GetEnum();
      
      public static const WIM_COLOR_MODE:int = EnumHelper.GetEnum();
      
      public static const PREVIOUS_VARIANT:int = EnumHelper.GetEnum(0);
      
      public static const NEXT_VARIANT:int = EnumHelper.GetEnum();
      
      public static const ABT_DELETE:int = EnumHelper.GetEnum(0);
      
      public static const ABT_EXTRAS:int = EnumHelper.GetEnum();
      
      public static const ABT_COUNT:int = EnumHelper.GetEnum();
      
      public static const DEFAULT_COLORS:int = EnumHelper.GetEnum(0);
      
      public static const CUSTOM_COLORS:int = EnumHelper.GetEnum();
      
      public static const OPEN_FRAME:String = "Open";
      
      public static const CLOSE_FRAME:String = "Close";
      
      public static const SHOWN_FRAME:String = "Shown";
      
      public static const HIDDEN_FRAME:String = "Hidden";
      
      public static const BUILD_MODE_TEXT:String = "$BUILD MODE";
      
      public static const MODIFY_MODE_TEXT:String = "$MODIFY MODE";
      
      public static const BULLDOZE_MODE_TEXT:String = "$CLEAR MODE";
      
      public static const COLOR_MODE_TEXT:String = "$COLOR MODE";
      
      public static const OPEN_ANIM_FINISHED:String = "OpenAnimationFinished";
      
      public static const CLOSE_ANIM_FINISHED:String = "CloseAnimationFinished";
      
      public static const START_ACTION:String = "WorkshopShared_StartAction";
      
      public static const SET_ACTION_HANDLES:String = "WorkshopShared_SetActionHandles";
      
      public static const WORKSHOP_INPUT_CONTEXT:String = "Workshop:";
      
      public static const QUICK_MENU_INPUT_CONTEXT:String = "Workshop_QuickMenu:";
       
      
      public function WorkshopUtils()
      {
         super();
      }
      
      public static function GetActorValueIcon(param1:String) : String
      {
         return param1;
      }
      
      public static function GetResourceIconFrameLabel(param1:uint) : String
      {
         var _loc2_:String = "none";
         switch(param1)
         {
            case WRT_SOLID:
               _loc2_ = "solid";
               break;
            case WRT_LIQUID:
               _loc2_ = "liquid";
               break;
            case WRT_GAS:
               _loc2_ = "gas";
               break;
            case WRT_MANUFACTURED:
               _loc2_ = "manufactured";
               break;
            case WRT_POWER:
               _loc2_ = "power";
         }
         return _loc2_;
      }
      
      public static function StateToInteractMode(param1:uint) : int
      {
         var _loc2_:int = WIM_NONE;
         switch(param1)
         {
            case UPDATE_NEW_ITEM_PLACEMENT:
               _loc2_ = WIM_BUILD_MODE;
               break;
            case INSPECT_IDLE:
            case INSPECT_ITEM:
               _loc2_ = WIM_MODIFY_MODE;
               break;
            case BULLDOZE_STATE:
               _loc2_ = WIM_BULLDOZE_MODE;
               break;
            case INSPECT_COLORS:
               _loc2_ = WIM_COLOR_MODE;
         }
         return _loc2_;
      }
      
      public static function GetInteractModeText(param1:int) : String
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case WIM_BUILD_MODE:
               _loc2_ = BUILD_MODE_TEXT;
               break;
            case WIM_MODIFY_MODE:
               _loc2_ = MODIFY_MODE_TEXT;
               break;
            case WIM_BULLDOZE_MODE:
               _loc2_ = BULLDOZE_MODE_TEXT;
               break;
            case WIM_COLOR_MODE:
               _loc2_ = COLOR_MODE_TEXT;
         }
         return _loc2_;
      }
      
      public static function StateIsInteractiveMode(param1:uint) : Boolean
      {
         return param1 == WorkshopUtils.INSPECT_IDLE || param1 == WorkshopUtils.INSPECT_ITEM || param1 == WorkshopUtils.UPDATE_NEW_ITEM_PLACEMENT || param1 == WorkshopUtils.BULLDOZE_STATE || param1 == WorkshopUtils.INSPECT_COLORS;
      }
      
      public static function CheckActionFlags(param1:int, param2:int) : Boolean
      {
         return (param1 & param2) != 0;
      }
      
      public static function GetBuildable(param1:Object) : Boolean
      {
         var _loc2_:VariantData = GetCurrentVariantData(param1);
         return _loc2_.buildReqsMet && _loc2_.skillReqsMet;
      }
      
      public static function GetHasVariants(param1:Object) : Boolean
      {
         return param1.aObjectVariants != null && param1.aObjectVariants.length > 1;
      }
      
      public static function GetVariantId(param1:Object) : uint
      {
         var _loc2_:VariantData = GetCurrentVariantData(param1);
         return _loc2_.id;
      }
      
      public static function GetProducedResourcesString(param1:Array) : String
      {
         var _loc2_:* = "";
         var _loc3_:uint = param1.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ += param1[_loc4_].sName;
            if(param1[_loc4_].sAmountProduced.length > 0)
            {
               _loc2_ += ": " + param1[_loc4_].sAmountProduced;
            }
            if(_loc4_ < _loc3_ - 1)
            {
               _loc2_ += ", ";
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public static function GetCurrentVariantData(param1:Object) : VariantData
      {
         var _loc3_:Object = null;
         var _loc2_:uint = uint(param1.uCurrentVariantID);
         for each(_loc3_ in param1.aObjectVariants)
         {
            if(_loc3_.uID == _loc2_)
            {
               return new VariantData(_loc3_.iconImage,_loc3_.sDisplayName,_loc3_.sVariantCount,_loc3_.bBuildReqsMet,_loc3_.bSkillReqsMet,_loc3_.uID);
            }
         }
         GlobalFunc.TraceWarning("WorkshopUtils::GetCurrentVariantData -- Give PreviewIconData is missing its current variant.");
         return new VariantData();
      }
      
      public static function SetSingleLineText(param1:TextField, param2:String, param3:Boolean) : void
      {
         GlobalFunc.SetText(param1,param2);
         if(param3)
         {
            GlobalFunc.TruncateSingleLineText(param1);
         }
      }
   }
}

class VariantData
{
    
   
   public var iconImage:Object = null;
   
   public var name:String = "";
   
   public var count:String = "";
   
   public var buildReqsMet:Boolean = false;
   
   public var skillReqsMet:Boolean = false;
   
   public var id:uint = 0;
   
   public function VariantData(param1:Object = null, param2:String = "", param3:String = "", param4:Boolean = false, param5:Boolean = false, param6:uint = 0)
   {
      super();
      this.iconImage = param1;
      this.name = param2;
      this.count = param3;
      this.buildReqsMet = param4;
      this.skillReqsMet = param5;
      this.id = param6;
   }
}
