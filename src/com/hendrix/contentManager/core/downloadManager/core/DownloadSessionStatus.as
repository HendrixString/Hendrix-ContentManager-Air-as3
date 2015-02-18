package com.hendrix.contentManager.core.downloadManager.core
{
  public class DownloadSessionStatus
  {
    public var totalFailed:     uint;
    public var totalDownloads:  uint;
    
    private var _retryFactor:   Number
    
    public function DownloadSessionStatus($totalDownloads:uint, $totalFailed:uint)
    {
      totalDownloads  = $totalDownloads;
      totalFailed     = $totalFailed;
      
      _retryFactor    = (totalFailed / totalDownloads); 
    }
    
    public function get retryFactor():Number
    {
      return _retryFactor;
    }
  }
}