package Shared.Components.ContentLoaders
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.getDefinitionByName;
   
   public class SymbolLoaderClip extends BaseLoaderClip
   {
       
      
      private var _SymbolInstance:MovieClip = null;
      
      private var _SymbolName:String = "";
      
      public function SymbolLoaderClip()
      {
         super();
      }
      
      public function get symbolInstance() : MovieClip
      {
         return this._SymbolInstance;
      }
      
      public function LoadSymbol(param1:String, param2:String = "") : void
      {
         if(this._SymbolName != param1)
         {
            this.Unload();
            this._SymbolName = param1;
            this.LoadSymbolHelper(param2);
         }
         else if(_OnLoadAttemptComplete != null)
         {
            _OnLoadAttemptComplete();
         }
      }
      
      override public function Unload() : void
      {
         super.Unload();
         this.destroySymbol();
      }
      
      override protected function onLoadFailed(param1:Event) : void
      {
         trace("WARNING: SymbolLoaderClip:onLoadFailed | " + this._SymbolName);
         super.onLoadFailed(param1);
      }
      
      override protected function onLoaded(param1:Event) : void
      {
         this.LoadSymbolHelper();
         super.onLoaded(param1);
      }
      
      private function destroySymbol() : void
      {
         RemoveDisplayObject(this._SymbolInstance);
         this._SymbolName = "";
      }
      
      private function LoadSymbolHelper(param1:String = "") : void
      {
         var _loc3_:URLRequest = null;
         var _loc4_:LoaderContext = null;
         var _loc2_:Boolean = this.SymbolSetup();
         if(!_loc2_)
         {
            if(param1 != "")
            {
               _loc3_ = new URLRequest(param1 + ".swf");
               _loc4_ = new LoaderContext(false,ApplicationDomain.currentDomain);
               super.Load(_loc3_,_loc4_);
            }
            else
            {
               trace("SymbolLoaderClip: Load Symbol Failure [" + this._SymbolName + "]");
               this.Unload();
               ShowError();
               if(_OnLoadAttemptComplete != null)
               {
                  _OnLoadAttemptComplete();
               }
            }
         }
      }
      
      private function SymbolSetup() : Boolean
      {
         var _loc1_:Class = null;
         if(this._SymbolName != "" && ApplicationDomain.currentDomain.hasDefinition(this._SymbolName))
         {
            _loc1_ = getDefinitionByName(this._SymbolName) as Class;
            if(_loc1_ != null)
            {
               this._SymbolInstance = new _loc1_();
               if(this._SymbolInstance != null)
               {
                  this._SymbolInstance.name = "SymbolInstance";
                  AddDisplayObject(this._SymbolInstance);
                  if(_OnLoadAttemptComplete != null)
                  {
                     _OnLoadAttemptComplete();
                  }
               }
            }
         }
         return this._SymbolInstance != null;
      }
   }
}
