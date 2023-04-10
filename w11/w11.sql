-- 1
CREATE PROCEDURE GetVendorProducts
AS
BEGIN
  SELECT v.vend_name, TRIM(STRING_AGG(ISNULL(p.prod_name, 'NULL'), ',') WITHIN GROUP (ORDER BY ISNULL(p.prod_name, 'NULL'))) AS products
  FROM Vendors v
  LEFT JOIN Products p ON v.vend_id = p.vend_id
  GROUP BY v.vend_name
END

-- 2
CREATE PROCEDURE UpdateCustomerEmails
AS
BEGIN
  UPDATE Customers
  SET cust_email = CONCAT('kztoys', '.', LOWER(REPLACE(cust_name, ' ', '')), '@example.com')
  WHERE cust_email IS NULL
END

SELECT * FROM Customers;


-- 3
CREATE PROCEDURE GetCustomerVisits
AS
BEGIN
  SELECT c.cust_id, c.cust_name,
         CASE
            WHEN COUNT(DISTINCT o.order_num) >= 2 THEN 'REGULAR CUSTOMER'
            ELSE 'SELDOM CUSTOMER'
         END AS visit_regularity
  FROM Customers c
  LEFT JOIN Orders o ON c.cust_id = o.cust_id
  LEFT JOIN OrderItems oi ON o.order_num = oi.order_num
  GROUP BY c.cust_id, c.cust_name
END

-- 4
CREATE PROCEDURE GetVendorInfo
AS
BEGIN
  SELECT vend_id, vend_name, vend_country,
         CASE
            WHEN LEN(vend_country) % 2 = 0 THEN 'Even'
            ELSE 'Odd'
         END AS country_desc
  FROM Vendors
END


-- 5
CREATE PROCEDURE GetProductCost
  @prod_id char(10)
AS
BEGIN
  SELECT prod_id, prod_name, amount, prod_price, amount * prod_price AS full_cost
  FROM Products
  WHERE prod_id = @prod_id
END;

EXEC GetProductCost @prod_id='BR01';

-- 6
CREATE PROCEDURE CheckVendorLocations
AS
BEGIN
  IF EXISTS (SELECT * FROM Vendors WHERE vend_address IS NULL OR vend_city IS NULL OR vend_state IS NULL OR vend_zip IS NULL OR vend_country IS NULL)
  BEGIN
    PRINT 'There are some vendors with unknown locations'
  END
  ELSE
  BEGIN
    PRINT 'Information about location is filled'
  END
END

-- 7
CREATE PROCEDURE CheckVendorInCustomerState
  @cust_id char(10)
AS
BEGIN
  SELECT TOP 1 'Vendor found in ' + cust_state AS message
  FROM Customers c
  INNER JOIN Orders o ON c.cust_id = o.cust_id
  INNER JOIN OrderItems oi ON o.order_num = oi.order_num
  INNER JOIN Products p ON oi.prod_id = p.prod_id
  INNER JOIN Vendors v ON p.vend_id = v.vend_id
  WHERE c.cust_id = @cust_id AND v.vend_state = c.cust_state
END

EXEC CheckVendorInCustomerState @cust_id = '1000000001';

-- 8
CREATE PROCEDURE ShowProductsByPriceRange
AS
BEGIN
  DECLARE @avg_price decimal(8,2), @second_avg_price decimal(8,2);
  SELECT @avg_price = AVG(prod_price) FROM Products;
  SELECT TOP 1 @second_avg_price = AVG(prod_price)
  FROM (
    SELECT TOP 2 prod_price
    FROM Products
    GROUP BY prod_price
    ORDER BY prod_price DESC
  ) sub
  GROUP BY prod_price
  ORDER BY prod_price ASC;
  SELECT *
  FROM Products
  WHERE prod_price BETWEEN @avg_price AND @second_avg_price;
END

EXEC ShowProductsByPriceRange;


-- 9
CREATE PROCEDURE ShowCustomerPurchaseStatus
AS
BEGIN
    WITH customer_purchase_info AS
    (
        SELECT o.cust_id, COUNT(*) AS num_items, SUM(oi.quantity * oi.item_price) AS total_spent,
            ROW_NUMBER() OVER (ORDER BY SUM(oi.quantity * oi.item_price) DESC) AS row_num
        FROM Orders o
        INNER JOIN OrderItems oi ON o.order_num = oi.order_num
        GROUP BY o.cust_id
    )
    SELECT c.cust_id, c.cust_name, c.cust_country, c.cust_email,
        cpi.num_items, cpi.total_spent,
        CASE
            WHEN cpi.row_num = 1 THEN 'maximum'
            WHEN cpi.row_num = 2 THEN 'second maximum'
            ELSE 'usual'
        END AS purchase_status
    FROM Customers c
    LEFT JOIN customer_purchase_info cpi ON c.cust_id = cpi.cust_id;
END

EXEC ShowCustomerPurchaseStatus;

-- 10
CREATE PROCEDURE GetProductsWithinRange
    @minPrice DECIMAL(8, 2),
    @maxPrice DECIMAL(8, 2)
AS
BEGIN
    SELECT prod_id, prod_name, prod_price
    FROM Products
    WHERE prod_price BETWEEN @minPrice AND @maxPrice
    ORDER BY prod_price ASC;
END

EXEC GetProductsWithinRange @minPrice = 10, @maxPrice = 20;






