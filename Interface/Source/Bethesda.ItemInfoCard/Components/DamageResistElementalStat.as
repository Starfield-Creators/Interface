package Components
{
   import Shared.GlobalFunc;
   import Shared.InventoryItemUtils;
   import flash.display.MovieClip;
   
   public class DamageResistElementalStat extends ElementalStat
   {
       
      
      public var ResistIcon_mc:MovieClip;
      
      private var ElemType:int;
      
      public function DamageResistElementalStat()
      {
         super();
      }
      
      public function SetEquipmentType(param1:String) : *
      {
         gotoAndStop(param1);
         this.UpdateElementInfo();
      }
      
      override public function SetElementType(param1:int) : void
      {
         this.ElemType = param1;
         GlobalFunc.SetText(Label_tf,InventoryItemUtils.GetElementalLocString(param1));
         this.UpdateElementInfo();
      }
      
      private function UpdateElementInfo() : *
      {
         switch(currentFrameLabel)
         {
            case InventoryItemUtils.TYPE_NAME_WEAPON:
               if(Icon_mc != null)
               {
                  Icon_mc.gotoAndStop(InventoryItemUtils.GetElementalLabel(this.ElemType));
               }
               break;
            case InventoryItemUtils.TYPE_NAME_ARMOR:
               if(this.ResistIcon_mc != null)
               {
                  this.ResistIcon_mc.gotoAndStop(InventoryItemUtils.GetElementalLabel(this.ElemType));
               }
         }
      }
   }
}
