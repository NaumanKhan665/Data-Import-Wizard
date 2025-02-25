public class SObjectDescribe {
    @AuraEnabled  public String label { get; set; }
    @AuraEnabled public String name { get; set; }

    // Constructor to initialize the object.
    public SObjectDescribe(String label, String name) {
        this.label = label;
        this.name = name;
    }
}
