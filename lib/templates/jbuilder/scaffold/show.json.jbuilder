<%- table_path_str = controller_class_path.join("/") + plural_table_name -%>
json.partial! "<%= table_path_str %>", <%= singular_table_name %>: @<%= singular_table_name %>
