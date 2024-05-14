package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.IMenu;
   import Shared.GlobalFunc;
   import Shared.InventoryItemUtils;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class FanfareMenu extends IMenu
   {
      
      public static const HEADER_MAX_LENGTH:uint = 28;
      
      public static const HEADER_MAX_LENGTH_LRG:uint = 25;
       
      
      public var MenuHolder_mc:MovieClip;
      
      private var LifespanTimer:Timer = null;
      
      private var HeaderMaxLength:uint = 28;
      
      public function FanfareMenu()
      {
         super();
         BSUIDataManager.Subscribe("FanfareData",this.onDataUpdate);
      }
      
      public function onDataUpdate(param1:FromClientDataEvent) : *
      {
         switch(param1.data.ItemData.uRarity)
         {
            case InventoryItemUtils.RARITY_STANDARD:
               GlobalFunc.SetText(this.MenuHolder_mc.Header_mc.Text_tf,"$Fanfare_SkillBook",false,false,this.HeaderMaxLength);
               GlobalFunc.PlayMenuSound("UIMenuSkillsBonusMagazineA");
               break;
            case InventoryItemUtils.RARITY_RARE:
               GlobalFunc.SetText(this.MenuHolder_mc.Header_mc.Text_tf,"$Fanfare_Rare",false,false,this.HeaderMaxLength);
               break;
            case InventoryItemUtils.RARITY_EPIC:
               GlobalFunc.SetText(this.MenuHolder_mc.Header_mc.Text_tf,"$Fanfare_Epic",false,false,this.HeaderMaxLength);
               break;
            case InventoryItemUtils.RARITY_LEGENDARY:
               GlobalFunc.SetText(this.MenuHolder_mc.Header_mc.Text_tf,"$Fanfare_Legendary",false,false,this.HeaderMaxLength);
               GlobalFunc.PlayMenuSound("UIMenuSkillsBonusLegendaryA");
         }
         this.MenuHolder_mc.Header_mc.gotoAndStop(InventoryItemUtils.GetFrameLabelFromRarity(param1.data.ItemData.uRarity));
         this.MenuHolder_mc.ItemCard_mc.SetItemData(param1.data.ItemData,param1.data.ItemData);
         this.LifespanTimer = new Timer(4000,1);
         this.LifespanTimer.addEventListener(TimerEvent.TIMER,this.handleLifespanTimer);
         this.LifespanTimer.start();
      }
      
      protected function handleLifespanTimer() : void
      {
         GlobalFunc.CloseMenu("FanfareMenu");
      }
      
      override protected function onSetSafeRect() : void
      {
         GlobalFunc.LockToSafeRect(this.MenuHolder_mc,"R",SafeX + this.MenuHolder_mc.width,SafeY);
      }
   }
}
