public class FileUploaderClass {
    @AuraEnabled
    public static List<string> uploadFile(string documentId)
    {
        
        try {
            if(String.isEmpty(documentId))
            throw new AuraHandledException('Document Id cannot be null or Empty.');
            contentVersion contentVersionObj=[select Id,versionData from  contentVersion where 
                                             contentDocumentId =: documentId
                                             limit 1];
            string data=contentVersionObj.VersionData.toString();
            
            List<string> cvsFilesLines=data.split('\n');
            system.debug('cvs lines'+cvsFilesLines);
            return cvsFilesLines;
        }
        catch(DmlException e){
            system.debug(e);
            return null;
        }   
        
        
    }
    @AuraEnabled(cacheAble=true)
    public static List<SObjectDescribe> getCreatableObjects() {
        List<SObjectDescribe> creatableObjects = new List<SObjectDescribe>();
    
        for (Schema.SObjectType objectType : Schema.getGlobalDescribe().values()) {
            Schema.DescribeSObjectResult describeResult = objectType.getDescribe();
    
            if (describeResult.isCreateable() && !describeResult.isCustomSetting()) {
                creatableObjects.add(new SObjectDescribe(describeResult.getLabel(), describeResult.getName()));
            }
        }
        System.debug('Creatable Objects: ' + creatableObjects);
        return creatableObjects;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<SObjectFieldDescribe> getFieldForSObjects(String objectName) {
       
    
        // Get the object description.
        Schema.DescribeSObjectResult objectDescribe = Schema.getGlobalDescribe().get(objectName).getDescribe();
        List<SObjectFieldDescribe> fieldList = new List<SObjectFieldDescribe>();
        // Iterate through fields.
        for (Schema.SObjectField field : objectDescribe.fields.getMap().values()) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
    
            // Check if the field is creatable.
            if (fieldDescribe.isCreateable()) {
                fieldList.add(new SObjectFieldDescribe(fieldDescribe.getLabel(), fieldDescribe.getName()));
            }
        }
    
        return fieldList;
    }
 @AuraEnabled(cacheable=false)
public static void insertRecords(List<Map<String,Object>> records,String objectName){
   List<SObject> sObjectList=new List<SObject>();
    for(Map<String ,Object> record:records){

        SObject SObjectRecord=(SObject)Schema.getGlobalDescribe().get(objectName).newSObject();

        for(String field:record.keySet()){
            SObjectRecord.put(field,record.get(field));
        }
        sObjectList.add(SObjectRecord);

    }
    system.debug('recod is '+sObjectList[0]);
    insert sObjectList;
}
    
   

}