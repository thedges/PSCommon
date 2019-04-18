import { LightningElement, api, track } from 'lwc';

export default class PsDynField extends LightningElement {
    _fieldDef;
    @track value;

    @api
    set fieldDef(val) {
      console.log('fieldDef=' + JSON.stringify(val));
      this._fieldDef = val;
      
      if (this._fieldDef.ftype === 'richtext')
      {
        var input = this.template.querySelector('.slds-rich-text-area__content p');
        if (input != null) input.value = val.value;
      }

      this.value = val.value;

    }

    get fieldDef() {
        return this._fieldDef;
    }

    get booleanOptions() {
        return [
            { label: 'True', value: 'true' },
            { label: 'False', value: 'false' }
        ];
    }


    get isPicklist() {
        return this.fieldDef.ftype === 'picklist';
    }

    get isMultiPicklist() {
        return this.fieldDef.ftype === 'multipicklist';
    }

    get isBoolean() {
        return this.fieldDef.ftype === 'boolean';
    }

    get isText() {
        return this.fieldDef.ftype === 'string';
    }

    get isTextarea() {
        return this.fieldDef.ftype === 'textarea';
    }

    get isRichtext() {
        return this.fieldDef.ftype === 'richtext';
    }

    get isDatetime() {
        return this.fieldDef.ftype === 'datetime';
    }

    get isDate() {
        return this.fieldDef.ftype === 'date';
    }

    get isCurrency() {
        return this.fieldDef.ftype === 'currency';
    }

    get isDouble() {
        return this.fieldDef.ftype === 'double';
    }

    get isEmail() {
        return this.fieldDef.ftype === 'email';
    }

    get isPercent() {
        return this.fieldDef.ftype === 'percent';
    }

    get isPhone() {
        return this.fieldDef.ftype === 'phone';
    }

    get isReference() {
        return this.fieldDef.ftype === 'reference';
    }

    get isUrl() {
        return this.fieldDef.ftype === 'url';
    }

    handleChange(event) {
        console.log('event=' + event);
        console.log('event.type=' + event.type);
 
        if (event.type === 'change')
        {
            console.log('event.detail=' + event.detail);
            console.log('value=' + event.detail.value);
            const fieldChangeEvent = new CustomEvent('fieldchange', {
                detail: { name: this._fieldDef.name, type: this._fieldDef.ftype, value: event.detail.value}
            });
            this.dispatchEvent(fieldChangeEvent);
            this.value = event.detail.value;
        } else if (event.type === 'blur')
        {
            const fieldChangeEvent = new CustomEvent('fieldchange', {
                detail: { name: this._fieldDef.name, type: this._fieldDef.ftype, value: event.target.value}
            });
            this.dispatchEvent(fieldChangeEvent);
            this.value = event.target.value;
        }

        console.log('event sent!');
    }
}