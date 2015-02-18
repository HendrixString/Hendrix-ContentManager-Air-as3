package com.hendrix.contentManager.core.downloadManager
{
  import com.hendrix.contentManager.core.downloadManager.core.DownloadManagerSettings;
  import com.hendrix.contentManager.core.downloadManager.core.DownloadSessionStatus;
  import com.hendrix.contentManager.core.downloadManager.core.DownloadStatus;
  
  import flash.utils.Dictionary;
  
  public class DownloadManager
  {
    
    private var _mrLocalDownloads:      Vector.<DownloadLocal>  = null;
    
    private var _numDownloadsLeft:      uint                      = 0;
    
    private var _cb_onSessionComplete:  Function                  = null;
    
    private var _downloadsByIdDic:      Dictionary                = null;
    
    private var _totalFailed:           uint                      = 0;
    
    private var _isSessionStarted:      Boolean                   = false;
    
    private var _totalSessionsTries:    uint                      = 0;
    
    public function DownloadManager($cb_onSessionComplete:  Function  = null)
    {
      _cb_onSessionComplete = $cb_onSessionComplete;
      _mrLocalDownloads     = new Vector.<DownloadLocal>();
      _downloadsByIdDic     = new Dictionary();
      _numDownloadsLeft     = 0;
    }
    
    /**
     * returns true/false if download session can be started
     */ 
    public function startDownloadSession(): Boolean
    {
      _totalFailed  = 0;
      
      if(_totalSessionsTries == DownloadManagerSettings.MAX_SESSION_DOWNLOAD_TRIES_PER_LOW_RETRY_FACTOR)
        return false; 
      
      if(_mrLocalDownloads.length == 0)
        return false;
      
      _numDownloadsLeft = _mrLocalDownloads.length;
      _isSessionStarted = true;
      
      var mrLocalDownload:DownloadLocal;
      var totalDownloads:uint = _mrLocalDownloads.length;
      for(var ix:uint = 0; ix < totalDownloads;  ix++)  
      {
        mrLocalDownload = _mrLocalDownloads[ix];
        
        // if it is destnativepath is set then it means user wants to download to disk,
        // but we also check it that file is already there
        if(mrLocalDownload.fileExists && mrLocalDownload.destLocalNativePath)
          onDownloadComplete(new DownloadStatus(DownloadStatus.STATUS_WRITE_SUCCEED, mrLocalDownload.id));
        else
          mrLocalDownload.downloadFile();
      }
      
      _totalSessionsTries += 1;
      
      return true;
    }
    
    public function queueDownload($url:String, $downloadId: String  = null, $writeToDisk:Boolean = true, $destLocalFolderPath:String = null):void
    {
      if($url == null)
        return;
      
      var ld: DownloadLocal = new DownloadLocal($url, $destLocalFolderPath, onDownloadComplete, null, $downloadId, $writeToDisk);
      
      //if(ld.fileExists == false) {
      _mrLocalDownloads.push(ld);
      _downloadsByIdDic[ld.id] = ld;
      //}
      
      if(_isSessionStarted)
        ld.downloadFile();
    }
    
    public function getAllDownloads():Vector.<DownloadLocal>
    {
      return _mrLocalDownloads;
    }
    
    public function getDownloadByID($id:String):DownloadLocal
    {
      var dl:DownloadLocal  = _downloadsByIdDic[$id] as DownloadLocal;
      return dl;
    }
    
    private function onDownloadComplete($status:DownloadStatus):void
    {
      /**
       * check status
       */ 
      if($status.status == DownloadStatus.STATUS_FAILED) 
      {
        var dl: DownloadLocal = getDownloadByID($status.id);
        if(dl.numTries <= DownloadManagerSettings.MAX_DOWNLOAD_TRIES_PER_FAILURE) 
        {
          dl.downloadFile();
          return;
        }
        
        _totalFailed += 1;
      }
      
      /**
       */ 
      
      _numDownloadsLeft -= 1;
      
      if(_numDownloadsLeft == 0) {
        var dss:  DownloadSessionStatus = new DownloadSessionStatus(_mrLocalDownloads.length, _totalFailed);
        if(_cb_onSessionComplete is Function)
          _cb_onSessionComplete(dss);
      }
      
    }
    
    /**
     * frees and disposes all the binary data,
     * make sure you use it if you made a deep copy of the data
     * other wise it will get lost 
     * 
     */
    public function free():void
    {
      trace("MrDownloadManager.free()")
      
      for (var k:Object in _downloadsByIdDic) {
        delete _downloadsByIdDic[k]
      }
      
      for(var ix:uint = 0; ix < _mrLocalDownloads.length; ix++) {
        _mrLocalDownloads[ix].dispose();
        _mrLocalDownloads[ix] = null;
      }
      
      _mrLocalDownloads.length = 0;
      _mrLocalDownloads     = null;
      _cb_onSessionComplete = null;
      _downloadsByIdDic     = null;
    }
    
  }
}