-- 1
CREATE FUNCTION prod_change_price(@prod_id CHAR(10), @percentage INT, @symbol char)
returns decimal(8,2)
BEGIN
    DECLARE @current decimal(8,2)
    SET @current = (SELECT prod_price from  Products WHERE prod_id=@prod_id)
    if (@symbol = '+')
        SET @current = @current * (1 + @percentage / 100.0)
    ELSE if(@symbol = '-')
        SET @current = @current * (1 - @percentage / 100.0)
    ELSE
        return CAST('error' as int)
    RETURN @current
end

DROP FUNCTION prod_change_price;

SELECT prod_price from Products WHERE  prod_id = 'BNBG01';

select dbo.prod_change_price('BNBG01', 10, '+');

-- 2
CREATE FUNCTION getState(@vend_id char(10))
returns varchar(15)
begin
    DECLARE @result varchar(15)
    set @result = CAST((select vend_state from Vendors where vend_id=@vend_id) AS VARCHAR(15))
    if @result is NULL
        SET @result = 'UNKNOWN'
    return @result
end

drop function getState;
select dbo.getState('FNG01');


-- 3
CREATE FUNCTION country(@country_name CHAR(50))
    RETURNS TABLE
--             (
--                 vend_count INT,
--                 cust_count INT,
--                 country    CHAR
--             )
AS
RETURN (
    SELECT
        COUNT(*) AS vend_count,
        NULL AS cust_count,
        @country_name AS country
    FROM Vendors
    WHERE vend_country = @country_name
    UNION ALL
    SELECT
        NULL AS vend_count,
        COUNT(*) AS cust_count,
        @country_name AS country
    FROM Customers
    WHERE cust_country = @country_name
);

drop function country;

select * from dbo.country ('England');


-- 4
CREATE FUNCTION vend_email(@vendor_name CHAR(50))
    RETURNS VARCHAR(255)
AS
BEGIN
    DECLARE @first_name VARCHAR(255);
    DECLARE @last_name VARCHAR(255);
    DECLARE @space_pos INT = CHARINDEX(' ', @vendor_name);


    SELECT @first_name = LEFT(@vendor_name, @space_pos - 1),
           @last_name = SUBSTRING(@vendor_name, @space_pos + 1, 1)
    FROM vendors
    WHERE vend_name = @vendor_name;

    RETURN LOWER(@first_name + '.' + @last_name + '@gmail.com');
END;

drop function vend_email;

SELECT vend_name, dbo.vend_email(vend_name) as vend_email from Vendors;

-- 5
CREATE FUNCTION dbo.GetNumCustomersByMonth (@month_name VARCHAR(20))
RETURNS INT
AS
BEGIN
  DECLARE @num_customers INT;

  SELECT @num_customers = COUNT(DISTINCT cust_id)
  FROM Orders
  WHERE DATENAME(month, order_date) = @month_name;

  RETURN @num_customers;
END;


select dbo.GetNumCustomersByMonth('Май');

-- 6
CREATE FUNCTION dbo.DaysSinceOrderDate (@order_num INT)
RETURNS INT
AS
BEGIN
  DECLARE @days_since_order INT;

  SELECT @days_since_order = DATEDIFF(day, order_date, GETDATE())
  FROM Orders
  WHERE order_num = @order_num;

  RETURN @days_since_order;
END;

select dbo.DaysSinceOrderDate(20005);

-- 7
CREATE FUNCTION dbo.GetTotalPrice (@order_num INT)
RETURNS MONEY
AS
BEGIN
  DECLARE @total_price MONEY;

  SELECT @total_price = quantity * item_price
  FROM OrderItems
  WHERE order_num = @order_num;

  RETURN @total_price;
END;

drop function GetTotalPrice;
SELECT dbo.GetTotalPrice(20005);


-- 8
CREATE FUNCTION dbo.GetAddressNumber (@address CHAR(50))
RETURNS INT
AS
BEGIN
  DECLARE @address_number VARCHAR(10);

  SELECT @address_number = SUBSTRING(@address, 1, PATINDEX('%[^0-9]%', @address + ' ') - 1);

  RETURN CONVERT(INT, @address_number);
END;

SELECT cust_address from Customers  WHERE cust_id=1000000001;
SELECT dbo.GetAddressNumber('200 Maple Lane');


-- 9
CREATE FUNCTION dbo.IsPalindrome (@input VARCHAR(255))
RETURNS BIT
AS
BEGIN
  DECLARE @length INT = LEN(@input);
  DECLARE @left INT = 1, @right INT = @length;

  WHILE @left < @right
  BEGIN
    IF SUBSTRING(@input, @left, 1) <> SUBSTRING(@input, @right, 1)
      RETURN 0;

    SET @left = @left + 1;
    SET @right = @right - 1;
  END

  RETURN 1;
END;

select dbo.IsPalindrome('ADA');

-- 10 custom(factorial)
CREATE FUNCTION dbo.Factorial (@num INT)
RETURNS BIGINT
AS
BEGIN
  DECLARE @result BIGINT = 1;

  IF @num < 0
    SET @result = NULL;
  ELSE
  BEGIN
    WHILE @num > 0
    BEGIN
      SET @result = @result * @num;
      SET @num = @num - 1;
    END
  END

  RETURN @result;
END;

SELECT dbo.Factorial(3);



