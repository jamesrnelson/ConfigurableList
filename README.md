# Configurable List

The Configurable List allows an admin to add a customizable related list to any record page. This related list can be customized to show up to 8 fields from child records that can be edited in line and saved automatically while editing. This is particularly useful if you have many records storing information that needs to be regularly or quickly updated from the parent record.

The Configurable List can also be displayed from within another Lightning Web Component. The Lightning Web Component can pass in fields as if it were displaying a parent record and its children, or the Lightning Web Component can override the default "related list" behavior and pass in a SOQL query to get a list of records meeting specific criteria that the user would need to edit quickly in relation to each other.

## Deploying the Configurable List

1. Fork this repository and clone a local copy
2. Authorize VSCode to be connected to whatever Salesforce org you would like to deploy the Configurable List to.
3. Ensure you are in the root project folder and run the command `sfdx force:source:deploy -x package.xml`

## Configuring the Configurable List

1. Navigate to the record page of the parent object whose child records you would like to be able to edit
2. Add the configurableList component to the record page
3. Follow help text of configuration attributes in the component editor.
    - Add the API names of fields that you would like to be able to edit
    - Add the Relationship Name in the appropriate place. You can find this by navigating to the child object, and then the lookup or master-detail field that defines the relationship. The relationship name is visible here. If the relationship is a custom one, you will need to append '__r' to the relationship name when adding to the "Relationship Name" configuration attribute.
    - If desiring to display a field as a link to another record, columns 1 and 2 are available for this purpose. The api name of the field in Column 1 or Column 2 should display the text of the link (a formula field that displays a record name, or some other text field). The corresponding Column 1 Linked Record or Column 2 Linked Record should store an ID to the record you wish to link to (e.g. A lookup field that holds an ID, or a formula field that identifies the appropriate record ID to link to.)
