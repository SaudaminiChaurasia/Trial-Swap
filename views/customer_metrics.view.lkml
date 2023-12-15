view: customer_metrics {

   derived_table: {
     sql: SELECT
      user_id,
      COUNT(order_id) AS order_count,
      SUM(sale_price) AS total_sales,
        FROM `looker-private-demo.thelook.order_items`
          AS order_items
        LEFT JOIN `looker-private-demo.thelook.users`
          AS users ON users.id = order_items.user_id
        GROUP BY user_id ;;
   }


   dimension: user_id {
     description: "Unique ID for each user that has ordered"
     primary_key: yes
     type: number
     sql: ${TABLE}.user_id ;;
   }

   dimension: lifetime_orders {
     description: "The total number of orders for each user"
     type: number
     sql: ${TABLE}.order_count ;;
   }

  dimension: repeat_customer  {
    type: yesno
    sql: ${lifetime_orders}>1 ;;
  }

   measure: total_lifetime_orders {
     description: "Use this for counting lifetime orders across many users"
     type: sum
     sql: ${lifetime_orders} ;;
   }
}
