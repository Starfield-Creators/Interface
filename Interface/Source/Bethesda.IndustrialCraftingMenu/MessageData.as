package
{
   public class MessageData
   {
       
      
      private var _messageText:String;
      
      private var _soundName:String;
      
      public function MessageData(param1:String, param2:String)
      {
         super();
         this._messageText = param1;
         this._soundName = param2;
      }
      
      public function get messageText() : String
      {
         return this._messageText;
      }
      
      public function get soundName() : String
      {
         return this._soundName;
      }
   }
}
