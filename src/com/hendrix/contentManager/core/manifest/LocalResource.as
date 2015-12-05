package com.hendrix.contentManager.core.manifest
{
  import com.hendrix.contentManager.core.interfaces.IId;
  
  public class LocalResource implements IId
  {
    public static const TYPE_BITMAP:          String    = "BITMAP";
    public static const TYPE_XML:             String    = "XML";
    public static const TYPE_BINARY:          String    = "BINARY";
    public static const TYPE_SWF:             String    = "SWF";
    public static const TYPE_SOUND:           String    = "SOUND";
    public static const TYPE_TEXT:            String    = "TEXT";
    public static const TYPE_JSON:            String    = "JSON";
    public static const TYPE_UNAVAILABLE:     String    = "TYPE_UNAVAILABLE";
    
    public static const LocalResource_LOADED:   String = "LocalResource_LOADED";
    public static const LocalResource_NOTLOADED:String = "LocalResource_NOTLOADED";
    
    private var _source:String;
    private var _id:String;
    private var _type:String;
    private var _loaded:String;
    
    public function LocalResource($id:String, $source:String, $type:String = "unavailable")
    {
      _id     = $id;
      _source = $source;
      _type = $type;
      _loaded = LocalResource_NOTLOADED;
    }
    
    public function get id():String {
      return _id;
    }
    public function set id(value:String):void {
      _id = value;
    }
    
    public function get source():String {
      return _source;
    }
    
    public function get loaded():String
    {
      return _loaded;
    }
    
    public function set loaded(value:String):void
    {
      _loaded = value;
    }
    
    public function get type():String
    {
      return _type;
    }
    
    public function set type(value:String):void
    {
      _type = value;
    }
    
    
  }
}