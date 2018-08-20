<%- table_path_str = controller_class_path.join("/") + plural_table_name -%>
json.array! @<%= plural_table_name %>, partial: '<%= table_path_str %>/<%= singular_table_name %>', as: :<%= singular_table_name %>
