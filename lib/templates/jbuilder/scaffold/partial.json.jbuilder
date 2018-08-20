<%- table_path_str = controller_class_path.join("/") + plural_table_name -%>
json.extract! <%= singular_table_name %>, <%= attributes_list_with_timestamps %>
json.url <%= table_path_str %>_url(<%= singular_table_name %>, format: :json)
