package Components
{
   import Shared.GlobalFunc;
   import Shared.InventoryItemUtils;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class ElementalStat extends MovieClip
   {
       
      
      public var Icon_mc:MovieClip;
      
      public var Label_tf:TextField;
      
      public var Value_mc:DeltaTextValue;
      
      public function ElementalStat()
      {
         super();
      }
      
      public function SetElementType(param1:int) : void
      {
         GlobalFunc.SetText(this.Label_tf,InventoryItemUtils.GetElementalLocString(param1));
         if(this.Icon_mc != null)
         {
            this.Icon_mc.gotoAndStop(InventoryItemUtils.GetElementalLabel(param1));
         }
      }
      
      public function SetElementalValue(param1:Number, param2:Number) : void
      {
         this.Value_mc.Update(param1,param2);
      }
      
      public function Update(param1:int, param2:Number, param3:Number = 0) : void
      {
         this.SetElementType(param1);
         this.SetElementalValue(param2,param3);
      }
   }
}
