package com.hendrix.contentManager.core.manifest
{
  import com.hendrix.collection.idCollection.IdCollection;
  
  public class PackageManifest
  {
    public var localResources:IdCollection;
    
    /**
     * keeps original asset data on disk
     */
    public function PackageManifest()
    {
      localResources = new IdCollection("id");
    }
    
    public function addResourceData($assetData:LocalResource):void
    {
      localResources.add($assetData);
    }
    
    public function getResourceData($id:String):LocalResource
    {
      return localResources.getById($id) as LocalResource;
    }
    
  }
}