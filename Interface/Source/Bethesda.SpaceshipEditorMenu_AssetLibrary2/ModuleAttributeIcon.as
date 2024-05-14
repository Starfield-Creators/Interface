package
{
   import Shared.GlobalFunc;
   
   public class ModuleAttributeIcon extends AttributeIcon
   {
      
      public static const RANK_PADDING:int = 10;
       
      
      public function ModuleAttributeIcon()
      {
         super();
      }
      
      private function get LargeTextMode() : Boolean
      {
         return false;
      }
      
      override protected function UpdateData(param1:Object) : void
      {
         super.UpdateData(param1);
         GlobalFunc.SetText(Info_mc.Rank_mc.Text_tf,"$(Rank #)",false,false,0,false,0,[rank]);
      }
      
      override protected function RefreshValidState() : void
      {
         super.RefreshValidState();
         if(this.LargeTextMode)
         {
            Info_mc.Rank_mc.Text_tf.x = Info_mc.Background_mc.width - Info_mc.Rank_mc.width * 1.5 - RANK_PADDING;
         }
         else
         {
            Info_mc.Rank_mc.Text_tf.x = Info_mc.Name_mc.x + Info_mc.Name_mc.Text_tf.textWidth + RANK_PADDING;
         }
      }
   }
}
