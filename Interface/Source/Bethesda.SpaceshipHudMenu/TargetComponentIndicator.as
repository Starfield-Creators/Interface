package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class TargetComponentIndicator extends MovieClip
   {
       
      
      public var ComponentName_mc:MovieClip;
      
      private var LastName:String = null;
      
      private var LastDestroyed:Boolean = false;
      
      public function TargetComponentIndicator()
      {
         super();
      }
      
      public function get ComponentName_tf() : TextField
      {
         return this.ComponentName_mc.Text_tf;
      }
      
      public function Update(param1:Object) : *
      {
         var _loc2_:* = GlobalFunc.ConvertScreenPercentsToLocalPoint(param1.fScreenPositionX,param1.fScreenPositionY,parent as MovieClip);
         x = _loc2_.x;
         y = _loc2_.y;
         if(this.LastDestroyed != param1.bDestroyed)
         {
            gotoAndStop(!!param1.bDestroyed ? "Destroyed" : "Operational");
            this.LastDestroyed = param1.bDestroyed;
         }
         if(this.LastName != param1.sAbbreviation)
         {
            GlobalFunc.SetText(this.ComponentName_tf,param1.sAbbreviation);
            this.LastName = param1.sAbbreviation;
         }
      }
   }
}
