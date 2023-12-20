connection: "looker-private-demo"

include: "/views/*.view.lkml"                # include all views in the views/ folder in this project
# include: "/**/*.view.lkml"                 # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard
# include: "/views/order_items.view"

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#access grant
#access_grant: can_view_state_data {
#  user_attribute: can_see_pii
#  allowed_values: [ "Arizona","Bristol","California" ]
#}
# explore: order_items {
#   access_filter: {
#    field: products.brand
#    user_attribute: brand_test
#   }
#   join: orders {
#     relationship: many_to_one
#     sql_on: ${orders.id} = ${order_items.order_id} ;;
#   }
#
#   join: users {
#     relationship: many_to_one
#     sql_on: ${users.id} = ${orders.user_id} ;;
#   }
# }
#access_grant: view_personal_information {
#  user_attribute: can_see_pii_data_swap
#}


explore: order_items {
#  access_filter: {
#    field: products.brand
#    user_attribute: brand_id
#  }
  #sql_always_where: ${created_date} >= '2023-08-01' ;;
  always_filter: {
    filters: [order_items.created_date: "90 days"]
  }
  join: inventory_items {
    type:  full_outer
    relationship: one_to_one
    sql_on: ${inventory_items.id} = ${order_items.inventory_item_id} ;;
  }
  join: users {
    type: left_outer
    relationship: many_to_one
    sql_on: ${users.id} = ${order_items.user_id} ;;
  }
  join: customer_metrics { #joining customer metrics with users
    type: left_outer
    relationship: one_to_one
    sql_on: ${users.id} = ${customer_metrics.user_id} ;;
  }
  join: products {
    type: left_outer
    relationship: many_to_one
    sql_on: ${products.id} = ${inventory_items.product_id} ;;
  }
  join: distribution_centers {
    type: left_outer
    relationship: many_to_one
    sql_on: ${distribution_centers.id} = ${inventory_items.product_distribution_center_id}  ;;
  }
}
