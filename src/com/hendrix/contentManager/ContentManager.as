package com.hendrix.contentManager
{
  import com.hendrix.collection.idCollection.IdCollection;
  import com.hendrix.contentManager.core.types.BaseContent;
  import com.hendrix.processManager.ProcessManager;
  import com.hendrix.processManager.core.interfaces.IProcess;
  
  public class ContentManager
  {
    public static var CONTENT_LOADED: String            = "CONTENT_LOADED";
    
    protected var _packages:          IdCollection      = null;
    
    public function ContentManager()
    {     
      _packages   = new IdCollection("id");
    }
    
    public function addOrGetContentPackage($pkgId:String):Package
    {
      var pack: Package = _packages.getById($pkgId) ? _packages.getById($pkgId) as Package : new Package($pkgId);
      
      if(!_packages.hasById($pkgId))
        _packages.add(pack);
      
      return pack;
    }
    
    /**
     * load packages and callback, example  
     * @param $packs ="packA,packB,packC" or "*" for all
     * @return <code>True</code> if can do, <code>False</code> if already loading or failed
     */
    public function loadPackages($packsIds:String, $cb_onComplete:Function = null):Boolean
    {
      var arrPacks: Array             = $packsIds.split(",");
      
      var pm:       ProcessManager  = null;
      
      var pack:     IProcess          = null;
      
      var count:    uint              = arrPacks.length;
      
      if(count == 0)
        return false;
      
      if(arrPacks[0] == "*") {
        pm                            = new ProcessManager(false, false);
        for(var ix:uint = 0; ix <  _packages.count; ix++)
        {
          pack                        = _packages.vec[ix] as IProcess;
          if(pack == null)
            return false;
          pm.enqueue(pack);
        }
        
        pm.onComplete                 = $cb_onComplete;
        pm.start();
        return true;
      }
      
      if(count == 1){ 
        pack                          = _packages.getById(arrPacks[0]) as IProcess;
        if(pack == null)
          return false;
        pack.process($cb_onComplete);
        return true;
      }
      
      pm                              = new ProcessManager(false, false);
      for(ix = 0; ix <  count; ix++)
      {
        pack                        = _packages.getById(arrPacks[ix]) as IProcess;
        if(pack == null)
          return false;
        pm.enqueue(pack);
      }
      
      pm.onComplete                   = $cb_onComplete;
      pm.start();
      
      return true;
    }
    
    public function dispose(): void
    {
      var id:       String;
      var mrBatch:  Package;
      
      for (var ix: uint = 0; ix < _packages.vec.length; ix++)
      {
        id                = _packages.vec[ix][_packages.idField];
        mrBatch           = _packages.getById(id) as Package;
        mrBatch.dispose();
        mrBatch           = null;
      }
      _packages.removeAll();
      _packages           = null;
    }
    
    /**
     * example: disposeTexture("packA::tex1"), disposeTexture("packA::*")
     */ 
    public function disposeContent($id:String):void
    {
      var arr:  Array     = $id.split("::");
      
      var mrb:  Package = _packages.getById(arr[0]) as Package;
      
      mrb.disposeContentById(arr[1]);
    }
    
    public function getContentById($id:String, $type:String = "TYPE_UNAVAILABLE"):BaseContent
    {
      var arr:  Array     = $id.split("::");
      
      var mrb:  Package = _packages.getById(arr[0]) as Package;
      
      return mrb.getContentById(arr[1]);
    }
    
    public function disposePackage($pkgId:String):void
    {
      var pkg:Package = _packages.getById($pkgId) as Package;
      if(pkg) {
        pkg.dispose()
        _packages.removeById($pkgId);
        pkg             = null;
      }
    }
    
    /**
     * unload the assets from memory but not the manifest
     */
    public function unloadPackage($pkgId:String):void
    {
      var pkg:Package = _packages.getById($pkgId) as Package;
      if(pkg) {
        pkg.unloadPackage()
      }
    }
    
  }
}
