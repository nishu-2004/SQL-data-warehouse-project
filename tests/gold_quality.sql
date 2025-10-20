/*
=========================================================================================================================================
Purpose:
    This script is used to perform integration between multiple columns in different tables (eg:- gender) and also to test the quality of the tables in the gold schema.

STEPS:
  1. Check for duplicate customer or product keys.
  2. Integrate gender data (CRM as master).
  3. Validate data quality of dim_customers and dim_products.
  4. Verify referential integrity between fact_sales and its dimensions.
==========================================================================================================================================
*/
use data_warehouse;


-- check for duplicates

select cst_id,count(*) from(
select 
    ci.[cst_id]
    ,ci.[cst_key]
    ,ci.[cst_firstname]
    ,ci.[cst_lastname]
    ,ci.[cst_marital_status]
    ,ci.[cst_gndr]
    ,ci.[cst_create_date],
    ca.bdate,
    ca.gen,
    la.cntry
from silver.crm_cust_info ci
left join 
silver.erp_cust_az12 ca
on ci.cst_key = ca.cid
left join 
silver.erp_loc_a101 la
on ci.cst_key = la.cid
)t group by cst_id
having count(*)>1



-- gender integration
select distinct 
    ci.[cst_gndr],
    ca.gen,
    case 
        when ci.cst_gndr!='n/a' then ci.cst_gndr -- CRM is master for gender info
        else coalesce(ca.gen,'n/a')
    end as new_gender
from silver.crm_cust_info ci
left join 
silver.erp_cust_az12 ca
on ci.cst_key = ca.cid
left join 
silver.erp_loc_a101 la
on ci.cst_key = la.cid
order by 1,2



--quality of dim_customer view

select 
    distinct gender
from gold.dim_customers



select * from silver.crm_prd_info

--product information
-- current information
select prd_key,
count(*)
from(
select 
    pn.prd_id,
    pn.cat_id,
    pn.prd_key,
    pn.prd_nm,
    pn.prd_cost,
    pn.prd_line,
    pn.prd_start_dt,
    pc.cat,
    pc.subcat,
    pc.maintenance
from silver.crm_prd_info pn
left join silver.erp_px_cat_g1v2 pc
on pn.cat_id = pc.id
where pn.prd_end_dt is null
)t group by prd_key 
having count(*)>1
-- no duplicates



--quality of dim_products
select * from gold.dim_products



-- silver.crm_sales_details to build the facts
select 
    sd.sls_ord_num as order_number,
    pr.product_key ,
    cu.customer_key
    ,sd.[sls_order_dt] as order_date
    ,sd.[sls_ship_dt] as shipping_date
    ,sd.[sls_due_dt] as due_date
    ,sd.[sls_sales] as sales_amount
    ,sd.[sls_quantity] as quantity
    ,sd.[sls_price] as price
from silver.crm_sales_details as sd
left join gold.dim_products pr 
on pr.product_number = sd.sls_prd_key
left join gold.dim_customers cu 
on sd.sls_cust_id = cu.customer_id



-- quality check of gold.fact_sales view

select * from gold.fact_sales f
left join gold.dim_customers c
on c.customer_key = f.customer_key 
left join gold.dim_products p
on p.product_key = f.product_key
where c.customer_key is null
