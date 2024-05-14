package
{
   import Shared.AS3.BSScrollingContainer;
   import Shared.GlobalFunc;
   
   public class ConfirmList extends BSScrollingContainer
   {
       
      
      private var _baseEntries:Array;
      
      private var _multipliedEntries:Array;
      
      private var _multiplier:uint = 1;
      
      private const MAX_REQ_NAME_LENGTH:uint = 26;
      
      public function ConfirmList()
      {
         this._baseEntries = new Array();
         this._multipliedEntries = new Array();
         super();
      }
      
      public function set multipler(param1:uint) : void
      {
         this._multiplier = param1;
         this.InitializeEntries(this._baseEntries);
      }
      
      override public function InitializeEntries(param1:Array) : void
      {
         ComponentsList_Entry.nameCutOffLength = this.MAX_REQ_NAME_LENGTH;
         this._baseEntries = param1;
         this._multipliedEntries.length = 0;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            this._multipliedEntries.push(GlobalFunc.CloneObject(param1[_loc2_]));
            this._multipliedEntries[_loc2_].uRequiredAmt *= this._multiplier;
            _loc2_++;
         }
         super.InitializeEntries(this._multipliedEntries);
      }
   }
}
