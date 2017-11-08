# Create a data product
custom_data_product = domain.create_data_product(id: 'data-product')
# Create new lifecycle segment without referencing a data product
first_segment = domain.create_segment(segment_id: 'segment-1', master_project: project)
# the API defaults the data product to 'default', which should be present in all domains
# that means the above call is equal to
default_data_product = domain.data_products('default')
default_data_product.create_segment(segment_id: 'segment-1', master_project: project)
# Create another segment as a part of the data product
second_segment = custom_data_product.create_segment(segment_id: 'segment-2', master_project: project)
# the first_segment is then only present in the default_data_product
default_data_product.segments.find { |s| s.segment_id == first_segment.segment_id }
# => #<DataProduct:#>
# and not present in the custom_data_product we created
custom_data_product.segments.find { |s| s.segment_id == first_segment.segment_id }
# => nil
