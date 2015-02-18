package com.hendrix.contentManager.core.downloadManager
{
  import com.hendrix.contentManager.core.downloadManager.core.Download;
  import com.hendrix.contentManager.core.downloadManager.core.DownloadStatus;
  
  import flash.events.Event;
  import flash.events.IOErrorEvent;
  import flash.filesystem.File;
  import flash.filesystem.FileMode;
  import flash.filesystem.FileStream;
  
  /**
   * extends MrDownload to perform saving to local disk of a file
   */ 
  public class DownloadLocal extends Download
  {
    private var _file:                    File      = null;
    private var _onFinishCallback:        Function  = null;
    private var _destLocalFolderPath:     String    = null;
    private var _destLocalNativePath:     String    = null;
    private var _fileExists:              Boolean;
    private var _writeToDisk:             Boolean;
    
    public function DownloadLocal($url:String, $destLocalFolderPath:String, $onFinishCallback:Function  = null, $progressCallBack:Function = null, $id:String = null, $writeToDisk:Boolean = true)
    {
      super($url, $progressCallBack, $id);
      
      _destLocalFolderPath    = $destLocalFolderPath;
      _onFinishCallback       = $onFinishCallback;
      _fileExists             = isFileExists();
      if(_destLocalFolderPath)
        _destLocalNativePath    = _destLocalFolderPath + "\\" + _fileName;
      _writeToDisk            = $writeToDisk;
      
    }
    
    override protected function urlLoaderCompleteHandler(e:Event):void 
    {
      super.urlLoaderCompleteHandler(e);
      
      if(_writeToDisk == false){
        _status = new DownloadStatus(DownloadStatus.STATUS_WRITE_SUCCEED, _id);
        _onFinishCallback(_status);
        return;
      }
      
      var fileStream: FileStream  = new FileStream();
      _file                       = new File(_destLocalNativePath);
      
      try {
        fileStream.open(_file, FileMode.WRITE);
        fileStream.writeBytes(_bytes);
        fileStream.close();
        _status = new DownloadStatus(DownloadStatus.STATUS_WRITE_SUCCEED, _id);
        trace("complete writing file");
      }
      catch(err:Error){
        _status = new DownloadStatus(DownloadStatus.STATUS_FAILED, _id);
        trace(err);
      }
      _onFinishCallback(_status);
    }
    
    override protected function onIOError(e: IOErrorEvent): void
    {
      super.onIOError(e);
      if(_onFinishCallback != null)
        _onFinishCallback(_status);
    }
    
    private function isFileExists():Boolean
    {
      var checkFile:File = null;
      
      if(_writeToDisk == true)
        checkFile = new File(_destLocalFolderPath + "/" + _fileName);
      else
        return false;
      
      return checkFile.exists;
    }
    
    public function get fileExists():Boolean
    {
      return _fileExists;
    }
    
    public function get destLocalNativePath():String
    {
      return _destLocalNativePath;
    }
    
    override public function dispose():void
    {
      super.dispose();
      
      _onFinishCallback = null;
    }
  }
}