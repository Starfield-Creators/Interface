package Shared.AS3.Data
{
   import flash.events.EventDispatcher;
   
   public class UIDataFromClient extends EventDispatcher
   {
       
      
      private var m_Payload:Object;
      
      private var m_Ready:Boolean = false;
      
      private var m_IsTest:Boolean = false;
      
      public function UIDataFromClient(param1:Object)
      {
         super();
         this.m_Ready = false;
         this.m_Payload = param1;
         this.m_IsTest = false;
      }
      
      public function DispatchChange() : void
      {
         if(this.m_Ready)
         {
            dispatchEvent(new FromClientDataEvent(this));
         }
      }
      
      public function SetReady(param1:Boolean) : void
      {
         if(!this.m_Ready)
         {
            this.m_Ready = true;
            if(param1)
            {
               this.DispatchChange();
            }
         }
      }
      
      public function get data() : Object
      {
         return this.m_Payload;
      }
      
      public function get dataReady() : Boolean
      {
         return this.m_Ready;
      }
      
      public function get isTest() : Boolean
      {
         return this.m_IsTest;
      }
      
      public function set isTest(param1:Boolean) : *
      {
         this.m_IsTest = param1;
      }
   }
}
