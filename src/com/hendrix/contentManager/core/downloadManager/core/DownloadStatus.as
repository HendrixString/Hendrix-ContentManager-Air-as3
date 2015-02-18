package com.hendrix.contentManager.core.downloadManager.core
{
  public class DownloadStatus
  {
    public static var STATUS_DOWNLOAD_SUCCEED:  String    = "STATUS_DOWNLOAD_SUCCEED";
    public static var STATUS_WRITE_SUCCEED:     String    = "STATUS_WRITE_SUCCEED";
    public static var STATUS_FAILED:            String    = "STATUS_FAILED";
    
    public var status:                          String    = null;
    public var id:                              String    = null;
    
    public function DownloadStatus($status:String, $id:String)
    {
      status  = $status;
      id      = $id;
    }
    
  }
}