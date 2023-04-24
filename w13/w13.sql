-- 1
CREATE TRIGGER tr_VendorsChanges
ON Vendors
FOR INSERT, UPDATE, DELETE
AS
BEGIN
    PRINT 'CHANGES WERE MADE AT ' + CONVERT(VARCHAR(30), GETDATE(), 120)
END


INSERT INTO Vendors VALUES('SIL101', 'Ana Sokmok', '158 salamaleikum', 'Karagandy', NULL, 95159, 'SI')

-- 2

CREATE TRIGGER trg_ReturnQuantity
ON OrderItems
AFTER DELETE
AS
BEGIN

  -- Update Products table with the new quantity
  UPDATE p
  SET p.amount = p.amount + d.quantity
  FROM Products p
  INNER JOIN deleted d
    ON p.prod_id = d.prod_id;
END;


SELECT * FROM OrderItems WHERE order_num=20009 and prod_id='BNBG03';
select * from Products where prod_id='BNBG03';
delete from OrderItems where order_num=20009 and prod_id='BNBG03';
SELECT * FROM Products where prod_id='BNBG03';


-- 3
CREATE TRIGGER trg_UniqueIdCustomer
on Customers
AFTER INSERT
as
BEGIN
    DECLARE  @latestId CHAR(10) = (SELECT MAX(cust_id) from Customers)
    update Customers
    set cust_id = CAST(CAST(@latestId as INT) + 1 as CHAR(10)) where cust_id=(select cust_id from inserted)
END

insert INTO Customers values ('1', 'Some Name', 'Tole bi 59', 'Almaty', NULL, '050000', 'Kazakhstan', 'John Cena', NULL);


-- 4
CREATE TRIGGER trg_DeleteVendor
ON Vendors
FOR DELETE
AS
BEGIN
  DECLARE @vend_id CHAR(10)
  SET @vend_id = (SELECT TOP 1 vend_id FROM DELETED)

  -- Delete related data from Products table
  DELETE FROM Products WHERE vend_id = @vend_id

  -- Delete related data from Orders table
  DELETE FROM OrderItems WHERE prod_id IN (SELECT prod_id FROM Products WHERE vend_id = @vend_id)
  DELETE FROM Orders WHERE order_num IN (SELECT order_num FROM OrderItems)

  -- Delete vendor record
  DELETE FROM Vendors WHERE vend_id = @vend_id
END


INSERT INTO Vendors VALUES ('AAA123', 'Name', 'address', 'Atyrau', NULL, '06000','KZ')
INSERT INTO Products VALUES('AAA1', 'AAA123','1 prod', 100, 10.6, '')
INSERT INTO Products VALUES('AAA2', 'AAA123','2 prod', 52, 5.5, '')
INSERT INTO OrderItems (order_num, prod_id, quantity, item_price) VALUES (20010, 'AAA1', 20, 12.72);
SELECT * FROM OrderItems WHERE prod_id='AAA1'
SELECT * FROM Products WHERE vend_id = 'AAA123'
SELECT * FROM Vendors WHERE vend_id = 'AAA123'
DELETE FROM Vendors WHERE vend_id = 'AAA123'
SELECT * FROM OrderItems WHERE prod_id='AAA1'
SELECT * FROM Products WHERE vend_id = 'AAA123'
SELECT * FROM Vendors WHERE vend_id = 'AAA123'

-- 5
CREATE TRIGGER trg_increase_product_price
ON Products
AFTER INSERT
AS
BEGIN
    UPDATE Products
    SET Products.prod_price = Products.prod_price * 1.20
    FROM inserted i
    WHERE Products.prod_id = i.prod_id;

    DECLARE @msg VARCHAR(100);
    SET @msg = 'New product has been added: ' + TRIM((SELECT prod_name FROM inserted));
    PRINT @msg;
END;


INSERT INTO Products
VALUES('BR04', 'BRS01', '20 inch teddy bear', 50, 12, '20 inch teddy bear, comes with cap and jacket');


-- 6
CREATE TRIGGER SetOrderDate
ON Orders
FOR INSERT
AS
BEGIN
  SET NOCOUNT ON;

  UPDATE Orders
  SET order_date = CONVERT(datetime, GETDATE())
  WHERE order_num IN (SELECT order_num FROM inserted);
END;


INSERT INTO Orders
VALUES(20010, '2019-05-01', '1000000006');

select * from Orders;