public with sharing class PSField {
	public PSField() {
		ftype = 'unknown';
		name = null;
		label = null;
		value = null;
		options = new List<PicklistOption>();
	}

    public String ftype {get; set;}
    public String label {get; set;}
    public String name {get; set;}
    public String value {get; set;}
    public List<PicklistOption> options {get; set;}

    public void addOption(String label, String value)
    {
    	if (options == null) options = new List<PicklistOption>();
    	options.add(new PicklistOption(label, value));
    }

    public class PicklistOption {
        String label {get; set;}
        String value {get; set;}

        public PicklistOption(String l, String v)
        {
           label = l;
           value = v;
        }
    }
}