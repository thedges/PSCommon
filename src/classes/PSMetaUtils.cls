global class PSMetaUtils {
    public PSMetaUtils() {

    }

    ////////////////////////////////////////////////////////////////////////////////////
    // borrrowed and slightly modified this method from Shane McLaughlin for my needs //
    ////////////////////////////////////////////////////////////////////////////////////
    @AuraEnabled
    global static String getMetaFieldDesc2(String objtype, String filterFields) {
        System.debug('objtype=' + objtype);
        System.debug('filterFields=' + filterFields);

        List<PSField> fieldList = new List<PSField>();


        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objtype);
        if (targetType == null) {
            return '[{"message":"The requested resource does not exist","errorCode":"NOT_FOUND"}]';
        }

        Schema.DescribeSObjectResult sobjResult = targetType.getDescribe();
        Map<String, Schema.SObjectField> fieldMap = sobjResult.fields.getMap();

        // set list of fields to describe
        Set<String> keySet = null;
        keySet = PSDemoUtils.parseCSVString(filterFields);
        if (keySet == null) {
            keySet = fieldMap.keySet();
        }
        System.debug('keySet=' + keySet);

        for (String key : keySet) {
            Schema.DescribeFieldResult descField = fieldMap.get(key).getDescribe();
            PSField field = new PSField();
            field.ftype = descField.getType().name().toLowerCase();
            field.label = descField.getLabel();
            field.name = descField.getName();

            //if a field is a picklist, I want the values
            if (field.ftype == 'picklist') {
                List<Schema.PicklistEntry> pickListValues = descField.getPickListValues();
                List<pickListValues> options = new List<picklistValues>();
                for (Schema.PicklistEntry plv : pickListValues) {
                    field.addOption(plv.getLabel(), plv.getValue());
                }
            }

            fieldList.add(field);
        }

        return JSON.serialize(fieldList);
    }

    ////////////////////////////////////////////////////////////////////////////////////
    // borrrowed and slightly modified this method from Shane McLaughlin for my needs //
    ////////////////////////////////////////////////////////////////////////////////////
    @AuraEnabled
    global static String getMetaFieldDesc(String objtype, String filterFields) {
        System.debug('objtype=' + objtype);
        System.debug('filterFields=' + filterFields);


        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objtype);
        if (targetType == null) {
            return '[{"message":"The requested resource does not exist","errorCode":"NOT_FOUND"}]';
        }

        Schema.DescribeSObjectResult sobjResult = targetType.getDescribe();
        Map<String, Schema.SObjectField> fieldMap = sobjResult.fields.getMap();

        // set list of fields to describe
        Set<String> keySet = null;
        keySet = PSDemoUtils.parseCSVString(filterFields);
        if (keySet == null) {
            keySet = fieldMap.keySet();
        }
        System.debug('keySet=' + keySet);

        List<Object> fields = new List<Object>();
        for (String key : keySet) {
            Schema.DescribeFieldResult descField = fieldMap.get(key).getDescribe();
            Map<String, Object> field = new Map<String, Object>();

            field.put('type', descField.getType().name().toLowerCase());
            field.put('name', descField.getName());
            field.put('value', null);
            field.put('label', descField.getLabel());
            field.put('userCanRead', descField.isAccessible());
            field.put('userCanEdit', descField.isUpdateable());
            field.put('help', descField.getInlineHelpText());
            field.put('default', descField.getDefaultValue());
            field.put('isHTML', descField.isHtmlFormatted());

            //if a field is a picklist, I want the values
            if (field.get('type') == 'picklist') {
                List<Schema.PicklistEntry> pickListValues = descField.getPickListValues();
                List<pickListValues> options = new List<picklistValues>();
                for (Schema.PicklistEntry plv : pickListValues) {
                    pickListValues pv = new pickListValues();
                    pv.label = plv.getLabel();
                    pv.value = plv.getValue();
                    options.add(pv);
                }
                field.put('picklistOptions', options);
            }

            List<String> references = new List<String>();
            for (Schema.sObjectType t : descField.getReferenceTo()) {
                references.add(t.getDescribe().getName());
            }
            if (!references.isEmpty()) {
                field.put('referenceTo', references);
            }

            fields.add(field);
        }

        Map<String, Object> result = new Map<String, Object>();
        result.put('fields', fields);

        Map<string, string> objectProperties = new map<string, string>();
        objectProperties.put('pluralLabel', sobjResult.getLabelPlural());
        result.put('objectProperties', objectProperties);

        return JSON.serialize(result);
    }

    @AuraEnabled
    global static String getSingleFieldDesc(String objtype, String fld) {
        System.debug('objtype=' + objtype);
        System.debug('field=' + fld);

        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objtype);
        if (targetType == null) {
            return '[{"message":"The requested resource does not exist","errorCode":"NOT_FOUND"}]';
        }

        Schema.DescribeSObjectResult sobjResult = targetType.getDescribe();
        Map<String, Schema.SObjectField> fieldMap = sobjResult.fields.getMap();
        Schema.DescribeFieldResult descField = fieldMap.get(fld).getDescribe();

        PSField field = new PSField();
        field.ftype = descField.getType().name().toLowerCase();
        field.label = descField.getLabel();
        field.name = descField.getName();

        //if a field is a picklist, I want the values
        if (field.ftype == 'picklist') {
            List<Schema.PicklistEntry> pickListValues = descField.getPickListValues();
            List<pickListValues> options = new List<picklistValues>();
            for (Schema.PicklistEntry plv : pickListValues) {
                field.addOption(plv.getLabel(), plv.getValue());
            }
        }

        return JSON.serialize(field);
    }

    global class picklistValues {
        String label {get; set;}
        String value {get; set;}
    }
}