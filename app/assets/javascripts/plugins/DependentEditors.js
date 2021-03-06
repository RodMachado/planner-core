/*
 * 
 */

;(function(Form) {

/*
 * 
 */
_.extend(Form.Editor.prototype, {
    dependsOnChanged : function(form, editor, extra) {
        var groupElement = this.$el.parents('.form-group');

        this.setInitValue(groupElement, editor.getValue(), this.options.schema.dependentValues);
    },

    setInitValue : function(element, value, expectedValues) {
        if ( ( value != null) && ($.inArray(value.toString(), expectedValues) > -1) ) {
            element.first().removeClass('hidden-form-group');
        } else {
            element.first().addClass('hidden-form-group');
        }
    },
    
    getDependantValue : function(form) {
        var intialDependantValue = '';
        var dependsOn = this.options.schema.dependsOn;
        
        if ((typeof this.form.model != 'undefined') && (this.form.model != null)) {
            intialDependantValue = this.form.model.get(dependsOn);
        } else if ((typeof this.form.data != 'undefined') && (this.form.data != null)) {
            intialDependantValue = this.form.data[dependsOn];
        };
        
        return intialDependantValue;
    },

    dependInit : function(form) {
            _.defer( function(editor, el, dependsOn, expectedValues) {
                var intialDependantValue = null;
                var cid = null;
                if ((typeof editor.form.model != 'undefined') && (editor.form.model != null)) {
                    intialDependantValue = editor.form.model.get(dependsOn);
                    cid = editor.form.model.cid;
                } else if ((typeof editor.form.data != 'undefined') && (editor.form.data != null)) {
                    intialDependantValue = editor.form.data[dependsOn];
                    cid = editor.cid;
                };
                
                var groupElement = el.parents('.form-group');
                editor.setInitValue(groupElement, intialDependantValue, expectedValues);
            }, this, this.$el, this.options.schema.dependsOn, this.options.schema.dependentValues );
    }
});

/*
 *
 */
Form.editors.DependentText = Form.editors.Text.extend({

    initialize: function(options) {
        this.options = options || {};
        Form.editors.Text.prototype.initialize.call(this, options);
    },

    render: function() {
        this.form.on(this.options.schema.dependsOn + ':change', this.dependsOnChanged, this );
       
        this.setValue(this.value);

        this.dependInit(this.form);

        return this;
    }

});

Form.editors.DependentTextArea = Form.editors.TextArea.extend({

    initialize: function(options) {
        this.options = options || {};
        Form.editors.TextArea.prototype.initialize.call(this, options);
    },

    render: function() {
        this.form.on(this.options.schema.dependsOn + ':change', this.dependsOnChanged, this );
       
        this.setValue(this.value);

        this.dependInit(this.form);

        return this;
    }

});

Form.editors.DependentHtml = Form.editors.Html.extend({

    initialize: function(options) {
        this.options = options || {};
        Form.editors.Html.prototype.initialize.call(this, options);
    },

    render: function() {
        console.debug(this.options);
        this.form.on(this.options.schema.dependsOn + ':change', this.dependsOnChanged, this );
        
        this.createCkWidget();
       
        this.setValue(this.value);

        this.dependInit(this.form);

        return this;
    }

});

Form.editors.DependentCheckbox = Form.editors.Checkbox.extend({

    initialize: function(options) {
        this.options = options || {};
        Form.editors.Checkbox.prototype.initialize.call(this, options);
    },
    
    render: function() {
        this.form.on(this.options.schema.dependsOn + ':change', this.dependsOnChanged, this );
       
        this.setValue(this.value);

        this.dependInit(this.form);
        
        return this;
    }

});

Form.editors.DependentSelect = Form.editors.Select.extend({

    initialize: function(options) {
        this.options = options || {};
        Form.editors.Select.prototype.initialize.call(this, options);
    },
    
    render: function() {
        this.form.on(this.options.schema.dependsOn + ':change', this.dependsOnChanged, this );
       
        this.setOptions(this.schema.options);
        
        this.dependInit(this.form);
        
        return this;
    }

});

Form.editors.DependentValueSelect = Form.editors.Select.extend({

    tagName: 'div',

    render : function() {
        if (this.isSelectField) {
            this.setOptions(this.schema.options);

            var html= this.$el.html();
            this.$el.attr('name', '');
            this.$el.attr('id', '');
            this.$el.html("<select name='" + this.id + "' id='" +  this.id + "'>" + html + "</select>"); // need id and name
            this.setValue(this.value);
        } else {
            this.$el.attr('name', '');
            this.$el.attr('id', '');
            this.$el.html("<input name='" + this.id + "' id='" +  this.id + "'></input>"); // need id and name
            this.setValue(this.value);
        };
        
        return this;
    },

    updateOptions : function(form, editor, extra) {
        // The value for the options has changed, so re-render the selectable options
        if (this.options.schema.altField) {
            var v = editor.$el.find('select')[0].value;
            if ($.inArray(v.toString(), this.options.schema.dependentValues) > -1) {
                this.isSelectField = true;
            } else {
                this.isSelectField = false;
            };
        }
        this.render();
    },
    
    getValue: function() {
        if (this.$el.find('select').length > 0 ) {
            return this.$el.find('select')[0].value;
        } else {
            var e = this.$el.find('input');
            return e[0].value;
        }
    },

    setValue: function(value) {
        if (this.$el.find('select').length > 0 ) {
            this.$el.find('select').val(value);
        } else {
            var e = this.$el.find('input');
            if (e.length > 0) {
                e.val(value);
            }
        }
    },


    initialize: function(options) {
        this.options = options || {};
        // Call parent initializer
        Backbone.Form.editors.Select.prototype.initialize.call(this, options);
        
        var depVal = this.getDependantValue(this.form);
        if (this.options.schema.altField) {
            this.isSelectField = ($.inArray(depVal.toString(), this.options.schema.dependentValues) > -1); // TODO - need to initialize properly, also need to set the value....
        } else {
            this.isSelectField = true;
        }

        this.form.on(options.schema.dependsOn + ':change', this.updateOptions, this );
    },
});

Form.editors.DependentCheckboxes = Form.editors.Checkboxes.extend({

    initialize: function(options) {
        this.options = options || {};
        Form.editors.Checkboxes.prototype.initialize.call(this, options);
    },
    
    render: function() {
        this.form.on(this.options.schema.dependsOn + ':change', this.dependsOnChanged, this );
       
        this.setValue(this.value);

        this.dependInit(this.form);
        
        return this;
    }

});

Form.editors.DependentNumber = Form.editors.Number.extend({

    initialize: function(options) {
        this.options = options || {};
        Form.editors.Number.prototype.initialize.call(this, options);
    },
    
    render: function() {
        this.form.on(this.options.schema.dependsOn + ':change', this.dependsOnChanged, this );
       
        this.setValue(this.value);

        this.dependInit(this.form);
        
        return this;
    }

});

Form.editors.DependentTime = Form.editors.Time.extend({

    initialize: function(options) {
        this.options = options || {};
        Form.editors.Time.prototype.initialize.call(this, options);
    },
    
    render: function() {
        this.form.on(this.options.schema.dependsOn + ':change', this.dependsOnChanged, this );
        var options = this.options,
            schema = this.schema;

        // Set the time options - set this to units of 15
        var timeOptions = _.map(_.range(0,60, schema.minsInterval), function(time) {
            return '<option value="'+time+'">' + time + '</option>';
        });
        var hourOptions = _.map(_.range(0,23, 1), function(hour) {
            return '<option value="'+hour+'">' + hour + '</option>';
        });
        
        var $el = $($.trim(this.template({
            hours: hourOptions.join(''),
            times: timeOptions.join(''),
            })));
            
        this.$time = $el.find('[data-type="time"]');
        this.$hour = $el.find('[data-type="hour"]');
        
        this.setValue(this.value);
        
        this.setElement($el);
        this.$el.attr('id', this.id);
        this.$el.attr('name', this.getName());

        if (this.hasFocus) this.trigger('blur', this);
        
        this.dependInit(this.form);
        
        return this;
    },
});

Form.editors.DependentDatetime = Form.editors.Datetime.extend({

    initialize: function(options) {
        this.options = options || {};
        Form.editors.Datetime.prototype.initialize.call(this, options);
    },

    render: function() {
        this.form.on(this.options.schema.dependsOn + ':change', this.dependsOnChanged, this );
        var options = this.options,
            schema = this.schema,
            ctl = this;

        var $el = $($.trim(this.template({})));
        
        this.setElement($el);
        
        var element = this.$el;
        
        this.picker = element.find('.datetimefield').datetimepicker(this.schema.picker);
        this.setInitialValue(this.value);
        
        this.dependInit(this.form);
        
        return this;
    }

});

Form.editors.DependentList = Form.editors.List.extend({

    initialize: function(options) {
        this.options = options || {};
        Form.editors.List.prototype.initialize.call(this, options);
    },
    
    render: function() {
        this.form.on(this.options.schema.dependsOn + ':change', this.dependsOnChanged, this );
        var self = this,
            value = this.value || [];

        //Create main element
        var $el = $($.trim(this.template()));

        //Store a reference to the list (item container)
        this.$list = $el.is('[data-items]') ? $el : $el.find('[data-items]');

        //Add existing items
        if (value.length) {
            _.each(value, function(itemValue) {
            self.addItem(itemValue);
            });
        }

        //If no existing items create an empty one, unless the editor specifies otherwise
        else {
            if (!this.Editor.isAsync) this.addItem();
        }

        this.setElement($el);
        this.$el.attr('id', this.id);
        this.$el.attr('name', this.key);
            
        if (this.hasFocus) this.trigger('blur', this);
      
        this.dependInit(this.form);
            
        return this;
    }
});

/*
 * 
 */

})(Backbone.Form);
