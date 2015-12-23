package com.hendrix.contentManager
{
  import com.hendrix.collection.idCollection.IdCollection;
  import com.hendrix.contentManager.core.downloadManager.DownloadLocal;
  import com.hendrix.contentManager.core.downloadManager.DownloadManager;
  import com.hendrix.contentManager.core.downloadManager.core.DownloadSessionStatus;
  import com.hendrix.contentManager.core.manifest.LocalResource;
  import com.hendrix.contentManager.core.manifest.PackageManifest;
  import com.hendrix.contentManager.core.types.BaseContent;
  import com.hendrix.contentManager.core.types.BinaryContent;
  import com.hendrix.contentManager.core.types.BitmapContent;
  import com.hendrix.contentManager.core.types.JSONContent;
  import com.hendrix.contentManager.core.types.SWFContent;
  import com.hendrix.contentManager.core.types.SoundContent;
  import com.hendrix.contentManager.core.types.TextContent;
  import com.hendrix.contentManager.core.types.XMLContent;
  import com.hendrix.processManager.core.interfaces.IProcess;
  import com.hendrix.processManager.core.types.BaseProcess;
  
  import flash.filesystem.File;
  import flash.net.URLRequest;
  
  public class Package extends BaseProcess
  {
    private var _mrDownloadManager:               DownloadManager     = null;
    private var _numItemstoProcess:               int                   = 0;
    
    protected var _bitmaps:                       IdCollection          = null;
    protected var _xmls:                          IdCollection          = null;
    protected var _sounds:                        IdCollection          = null;
    protected var _binaries:                      IdCollection          = null;
    protected var _swfs:                          IdCollection          = null;
    protected var _txts:                          IdCollection          = null;
    protected var _jsons:                         IdCollection          = null;
    
    private var _manifest:                        PackageManifest       = null;
    
    public function Package($pkgId:String)
    {
      super($pkgId, null);
      
      _manifest                         = new PackageManifest();
      
      _bitmaps                          = new IdCollection("id");
      _xmls                             = new IdCollection("id");
      _sounds                           = new IdCollection("id");
      _binaries                         = new IdCollection("id");
      _swfs                             = new IdCollection("id");
      _txts                             = new IdCollection("id");
      _jsons                            = new IdCollection("id");
    }
    
    /**
     * Loading
     * 
     */
    public function enqueue($url:String, $id:String, $type:String = "TYPE_UNAVAILABLE"):void
    {      
      var file:     File  = ($url.indexOf(':') == -1) ? File.applicationDirectory.resolvePath($url) : new File($url);
      
      if(file.isDirectory) {
        var files:  Array = file.getDirectoryListing();
        
        for each (var f: File in files) {          
          enqueue(f.url, null, $type);
        }
        
        trace('dir');
      }
      else {
        var arr:    Array = file.url.split(File.separator);

        _manifest.addResourceData(new LocalResource($id ? $id : arr[arr.length - 1], $url, $type));
      }

    }
    
    /**
     * load assets from manifest that has been given before hand.
     * if onw queued sources, loaded and then freed then, then one can load again
     * since manifest is saved
     */
    override public function process($onComplete:Function=null, $onError:Function=null):void
    {
      super.process($onComplete, $onError);
      
      realizeRawAssets();
    }
    
    /**
     *  Download Manager finished, make a factory for processes
     */
    private function onDownloadSessionComplete($dss: DownloadSessionStatus):void
    {
      trace("finished download of package: " + _id);
      
      var dls:  Vector.<DownloadLocal>  = _mrDownloadManager.getAllDownloads()
      _numItemstoProcess                  = dls.length;
      
      var idp:  IProcess;
      var lr:   LocalResource;
      
      /**
       * time to process everything
       */
      for(var ix: uint = 0; ix < dls.length; ix++)
      {
        lr                      = _manifest.getResourceData(dls[ix].id);
        
        // if no type was specified, detect it yourself by postfix
        if(lr.type == LocalResource.TYPE_UNAVAILABLE) {
          
          var postFix:  String  = lr.source.substr(dls[ix].url.length - 3).toLowerCase(); //dls[ix].url.substr(dls[ix].url.length - 3).toLowerCase();
          
          if(postFix == "xml")
            lr.type = LocalResource.TYPE_XML;
          else if((postFix == "png") || (postFix == "jpg") || (postFix == "bmp"))
            lr.type = LocalResource.TYPE_BITMAP;
          else if(postFix == "mp3")
            lr.type = LocalResource.TYPE_SOUND;
          else if(postFix == "swf")
            lr.type = LocalResource.TYPE_SWF;
          else if(postFix == "json")
            lr.type = LocalResource.TYPE_JSON;
          else if(postFix == "txt")
            lr.type = LocalResource.TYPE_TEXT;
          else
            lr.type = LocalResource.TYPE_BINARY;
        }
        
        _manifest.getResourceData(dls[ix].id).loaded = LocalResource.LocalResource_LOADED;
        
        // cpuld have used the process manager, but that is probably faster
        switch(lr.type.toUpperCase()) {
          case LocalResource.TYPE_XML:
            idp = new XMLContent(dls[ix].id, dls[ix].bytes) ;
            _xmls.add(idp);
            idp.process(onFinishedProcessing);
            break;
          case LocalResource.TYPE_BITMAP:
            idp = new BitmapContent(dls[ix].id, dls[ix].bytes);
            _bitmaps.add(idp);
            idp.process(onFinishedProcessing);
            break;
          case LocalResource.TYPE_SOUND:
            idp = new SoundContent(dls[ix].id, dls[ix].bytes);
            _sounds.add(idp);
            idp.process(onFinishedProcessing);
            break;
          case LocalResource.TYPE_BINARY:
            idp = new BinaryContent(dls[ix].id, dls[ix].bytes);
            _binaries.add(idp);
            idp.process(onFinishedProcessing);
            break;
          case LocalResource.TYPE_SWF:
            idp = new SWFContent(dls[ix].id, dls[ix].bytes);
            _swfs.add(idp);
            idp.process(onFinishedProcessing);
            break;
          case LocalResource.TYPE_TEXT:
            idp = new TextContent(dls[ix].id, dls[ix].bytes);
            _txts.add(idp);
            idp.process(onFinishedProcessing);
            break;
          case LocalResource.TYPE_JSON:
            idp = new JSONContent(dls[ix].id, dls[ix].bytes);
            _jsons.add(idp);
            idp.process(onFinishedProcessing);
            break;
          default:
            break;
        }
        
      }
      trace();
      
    }
    
    /**
     * processing
     * 
     */
    private function onFinishedProcessing($bc:BaseContent = null):void
    {
      trace("finished processing: " + _id + "::" + $bc.id);
      if(_numItemstoProcess > 0)
        _numItemstoProcess -= 1;
      if(_numItemstoProcess != 0)
        return;
      
      _mrDownloadManager.free();
      _mrDownloadManager  = null;
      
      completeProcessing();
    }
    
    /**
     * signal internal completion of processing, and notify complete
     * 
     */
    protected function completeProcessing():void
    {
      notifyComplete();
    }
    
    /**
     * complete processing all the package, callback to listener
     */
    override public function notifyComplete():void
    {
      trace("content processed");
      
      //realizePackageTextures();
      
      super.notifyComplete();
    }
    
    /**
     * relize bitmaps and xmls based on manifest. this is asynchrounous operation.
     * possible improvement, replace mrDownloadManager with diiferent system that
     * can fetch files from multiple sources: File objects, directories, url, embeded classes etc..
     */
    private function realizeRawAssets():void
    {
      //_cb_onCompleteProcessingExternal  = $cb_onCompleteProcessingExternal;
      
      if(_mrDownloadManager == null)
        _mrDownloadManager              = new DownloadManager(onDownloadSessionComplete);
      
      var lr: LocalResource             = null;
      
      for(var ix:uint = 0;  ix < _manifest.localResources.vec.length; ix++) 
      {
        lr =  _manifest.localResources.vec[ix] as LocalResource;
        
        if(lr.loaded == LocalResource.LocalResource_LOADED)
          continue;
        
        _mrDownloadManager.queueDownload(lr.source, lr.id, false, null);
      }
      
      _mrDownloadManager.startDownloadSession();
    }
    
    public function getContentById($id:String, $type:String = "TYPE_UNAVAILABLE"):BaseContent
    {
      switch($type) {
        case LocalResource.TYPE_BINARY:
          return _binaries.getById($id) as BaseContent;
          break;
        case LocalResource.TYPE_BITMAP:
          return _bitmaps.getById($id) as BaseContent;
          break;
        case LocalResource.TYPE_SOUND:
          return _sounds.getById($id) as BaseContent;
          break;
        case LocalResource.TYPE_SWF:
          return _swfs.getById($id) as BaseContent;
          break;
        case LocalResource.TYPE_XML:
          return _xmls.getById($id) as BaseContent;
          break;
        case LocalResource.TYPE_TEXT:
          return _txts.getById($id) as BaseContent;
          break;
        case LocalResource.TYPE_JSON:
          return _jsons.getById($id) as BaseContent;
          break;
        case LocalResource.TYPE_UNAVAILABLE:
          var bc:BaseContent = _xmls.getById($id) as BaseContent;
          if (bc)
            return bc;
          else if (bc = _binaries.getById($id) as BaseContent)
            return bc;
          else if (bc = _bitmaps.getById($id) as BaseContent)
            return bc;
          else if (bc = _sounds.getById($id) as BaseContent)
            return bc;
          else if (bc = _swfs.getById($id) as BaseContent)
            return bc;
          else if (bc = _txts.getById($id) as BaseContent)
            return bc;
          else if (bc = _jsons.getById($id) as BaseContent)
            return bc;
          
          break;
      }
      return null;
    }
    
    public function disposeContentById($id:String):void
    {
      var bc:   BaseContent   = null;
      var idc:  IdCollection  = null;
      
      bc = _xmls.getById($id) as BaseContent;
      
      if (bc)
        idc = _xmls;
      else if (bc = _binaries.getById($id) as BaseContent)
        idc = _binaries;
      else if (bc = _bitmaps.getById($id) as BaseContent)
        idc = _bitmaps;
      else if (bc = _sounds.getById($id) as BaseContent)
        idc = _sounds;
      else if (bc = _swfs.getById($id) as BaseContent)
        idc = _swfs;
      else if (bc = _txts.getById($id) as BaseContent)
        idc = _txts;
      else if (bc = _jsons.getById($id) as BaseContent)
        idc = _jsons;
      
      bc.dispose();
      _manifest.getResourceData($id).loaded = LocalResource.LocalResource_NOTLOADED;
      
      if(idc)
        idc.removeById($id);
    }
    
    public function disposeAllFromCollection($collection:IdCollection):void
    {
      var sc:BaseContent;
      
      for(var id:String in $collection.dic) 
      {
        sc = $collection.getById(id) as BaseContent;
        _manifest.getResourceData(id).loaded = LocalResource.LocalResource_NOTLOADED;
        sc.dispose();
        $collection.removeById(id);
      }
    }
    
    /**
     * frees the package completely without manifest ofcourse
     */
    override public function dispose():void
    {
      if(_mrDownloadManager) {
        _mrDownloadManager.free();
        
        _mrDownloadManager                = null;
      }
      
      /**
       * TODO: free resources, bitmaps, textures, xmls etc..
       */
      
      unloadPackage();
      
      _manifest = null;
    }
    
    /**
     * only unload the assets from memory
     */
    public function unloadPackage():void
    {
      disposeAllFromCollection(_bitmaps);
      disposeAllFromCollection(_binaries);
      disposeAllFromCollection(_sounds);
      disposeAllFromCollection(_xmls);
      disposeAllFromCollection(_swfs);
      disposeAllFromCollection(_txts);
      disposeAllFromCollection(_jsons);
    }
    
    /**
     * get all content by type 
     * @param type
     * @return 
     * 
     */
    public function getContentByType(type:String = LocalResource.TYPE_BITMAP, raw:Boolean = false):Vector.<Object>
    {
      var vecBC:Vector.<Object> = new Vector.<Object>();
      var rawBC:Vector.<Object> = new Vector.<Object>();
      
      switch(type)
      {
        case LocalResource.TYPE_BITMAP:
        {
          vecBC = _bitmaps.vec;
          break;
        }
        case LocalResource.TYPE_BINARY:
        {
          vecBC = _binaries.vec;
          break;
        }
        case LocalResource.TYPE_SOUND:
        {
          vecBC = _sounds.vec;
          break;
        }
        case LocalResource.TYPE_SWF:
        {
          vecBC = _swfs.vec;
          break;
        }
        case LocalResource.TYPE_XML:
        {
          vecBC = _xmls.vec;
          break;
        }
        case LocalResource.TYPE_TEXT:
        {
          vecBC = _txts.vec;
          break;
        }
        case LocalResource.TYPE_JSON:
        {
          vecBC = _jsons.vec;
          break;
        }
          
      }
      
      if(raw) 
      {
        for(var ix:uint = 0; ix < vecBC.length; ix++) {
          rawBC[ix] = (vecBC[ix] as BaseContent).content;
        }
        
        return rawBC;
      }
      
      return vecBC;
    }
    
  }
}