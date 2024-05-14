package Shared.Components.ButtonControls.ButtonBar
{
   import Shared.Components.ButtonControls.Buttons.IButton;
   
   public class ButtonManager
   {
       
      
      private var ButtonsA:Array;
      
      private var ButtonsPriorityA:Array;
      
      public function ButtonManager()
      {
         super();
         this.ButtonsA = new Array();
         this.ButtonsPriorityA = new Array();
      }
      
      public function get NumButtons() : int
      {
         return this.ButtonsA.length;
      }
      
      public function AddButton(param1:IButton) : *
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         while(_loc3_ < this.ButtonsA.length && !_loc2_)
         {
            if(param1.HandlePriority > this.ButtonsA[_loc3_].HandlePriority)
            {
               this.ButtonsPriorityA.splice(_loc3_,0,param1);
               _loc2_ = true;
            }
            _loc3_++;
         }
         if(!_loc2_)
         {
            this.ButtonsPriorityA.push(param1);
         }
         this.ButtonsA.push(param1);
      }
      
      public function RemoveButton(param1:IButton) : *
      {
         var _loc2_:int = this.ButtonsA.indexOf(param1);
         if(_loc2_ >= 0)
         {
            this.ButtonsA.removeAt(_loc2_);
         }
         _loc2_ = this.ButtonsPriorityA.indexOf(param1);
         if(_loc2_ >= 0)
         {
            this.ButtonsPriorityA.removeAt(_loc2_);
         }
      }
      
      public function ClearButtons() : *
      {
         this.ButtonsA.splice(0);
         this.ButtonsPriorityA.splice(0);
      }
      
      public function GetButtonByIndex(param1:uint) : Object
      {
         var _loc2_:Object = null;
         if(param1 < this.NumButtons)
         {
            _loc2_ = this.ButtonsA[param1];
         }
         return _loc2_;
      }
      
      public function GetNumFilteredButtons(param1:Function) : int
      {
         return this.ButtonsA.filter(param1).length;
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc4_:* = undefined;
         var _loc3_:Boolean = false;
         for each(_loc4_ in this.ButtonsPriorityA)
         {
            if(_loc4_.HandleUserEvent)
            {
               _loc3_ = Boolean(_loc4_.HandleUserEvent(param1,param2,_loc3_)) || _loc3_;
            }
         }
         return _loc3_;
      }
   }
}
