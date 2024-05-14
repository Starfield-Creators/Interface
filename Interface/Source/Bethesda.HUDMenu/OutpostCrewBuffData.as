package
{
   public class OutpostCrewBuffData
   {
       
      
      private var _name:String;
      
      private var _location:String;
      
      private var _crewBuffsA:Array;
      
      public function OutpostCrewBuffData(param1:String, param2:String)
      {
         super();
         this._name = param1;
         this._location = param2;
         this._crewBuffsA = new Array();
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get location() : String
      {
         return this._location;
      }
      
      public function get crewBuffsA() : Array
      {
         return this._crewBuffsA;
      }
      
      public function AddCrewBuff(param1:String) : void
      {
         this._crewBuffsA.push(param1);
      }
   }
}
