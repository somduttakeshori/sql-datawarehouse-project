/*
=========================================================================
Quality checks
=========================================================================
Script Purpose:
This script performs various quality checks for data consistency, accuracy, and standardization across the 'silver' schema.
It includes checks for:
  -Null or duplicate primary keys
  -Unwanted spcaes in string fields.
  -Data Standardization and consistency
  -Invalid date ranges and orders
  -Data consistency between related fields
==========================================================================
*/

-- Check for Nulls or Duplicates in Primary Key
-- Expectation: No Result

SELECT cst_id, COUNT(*) FROM silver.crm_cust_info GROUP BY cst_id HAVING COUNT(*) >1 OR cst_id IS NULL

--Check for unwanted spaces
--Expectation: No Results
SELECT cst_firstname FROM silver.crm_cust_info WHERE cst_firstname != TRIM (cst_firstname)
SELECT cst_lastname FROM silver.crm_cust_info WHERE cst_lastname != TRIM (cst_lastname)

-- Data Standardization & Consistency
SELECT DISTINCT cst_gndr FROM bronze.crm_cust_info

SELECT * FROM silver.crm_prd_info

SELECT prd_id, COUNT(*) FROM bronze.crm_prd_info GROUP BY prd_id HAVING COUNT(*) >1 OR prd_id IS NULL
SELECT prd_nm FROM bronze.crm_prd_info WHERE prd_nm != TRIM (prd_nm)
SELECT DISTINCT prd_line FROM bronze.crm_prd_info

--Check for NULLS or Negative Numbers
SELECT prd_cost FROM bronze.crm_prd_info WHERE prd_cost<0 OR prd_cost IS NULL

--Check for Invalid Date Orders
SELECT * FROM silver.crm_prd_info WHERE prd_end_dt<prd_start

SELECT * FROM bronze.crm_sales_details WHERE sls_order_dt>sls_ship_dt OR sls_ship_dt>sls_due_dt

-- Check Data Consistency: Between Sales, Quantity, and Price
-- >>Sales= Quantity * Price
-- >>Values must not be NULL, zero or negative.

SELECT DISTINCT sls_sales, sls_quantity, sls_price FROM bronze.crm_sales_details WHERE sls_sales!=sls_quantity*sls_price OR
sls_sales IS NULL or  sls_quantity IS NULL OR sls_price IS NULL OR sls_sales <=0 or  sls_quantity <=0 OR sls_price <=0
