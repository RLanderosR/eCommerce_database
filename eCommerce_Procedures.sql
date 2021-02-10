#2 Detailed SQL queries

#Creating a procedure to assign a discount to a product in a specific order based on the list price
DROP PROCEDURE IF EXISTS additional_discount;

DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `additional_discount`(
IN in_order_id INT, 
IN in_prod_id INT,
IN in_discount_in_percent INT
)
BEGIN
	DECLARE disc_price DECIMAL(10,2);
    
	SELECT
		p.unit_price
		INTO disc_price
	FROM
		products AS p
			JOIN
		order_details AS od ON p.product_id = od.product_id
	WHERE
		od.order_id = in_order_id
        AND od.product_id = in_prod_id;

	UPDATE order_details
    SET unit_price = disc_price *(1-(in_discount_in_percent/100)),
		discount = (1-(in_discount_in_percent/100))
    WHERE 
		order_id = in_order_id
        AND product_id = in_prod_id;
        
	UPDATE orders AS o
			JOIN
		(SELECT
			od.order_id, SUM(od.unit_price * od.quantity) AS new_order_value
		FROM
			order_details AS od
		GROUP BY
			od.order_id) AS nod ON o.order_id = nod.order_id
	SET o.order_value = nod.new_order_value
    WHERE
		o.order_id = nod.order_id;
		
END $$

DELIMITER ;

#callig the procedure
CALL additional_discount(1,4,20);

#Revertign to the original Value
UPDATE order_details
    SET unit_price = 19.6,
		discount = null
    WHERE 
		order_id = 1
        AND product_id = 4;

#Creating a procedure to udpate the status of the order based on the item status 
DROP PROCEDURE IF EXISTS overall_order_status;

DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `overall_order_status`(
IN in_order_id INT,
IN in_prod_id INT,
IN in_item_status ENUM('Pending','Shipped','Delivered','Returned','Cancelled')
)
BEGIN
	DECLARE status_pending BOOL;
    DECLARE status_shipped BOOL;
    DECLARE status_delivered BOOL;
    DECLARE status_returned BOOL;
    DECLARE status_cancelled BOOL;
    
    UPDATE order_details
    SET item_status = CONCAT(UPPER(SUBSTRING(in_item_status,1,1)),LOWER(SUBSTRING(in_item_status,2)))
    WHERE
		order_id = in_order_id
        AND product_id = in_prod_id;
    
    SET status_pending = FALSE,
		status_shipped = FALSE,
        status_delivered = FALSE,
		status_returned = FALSE,
		status_cancelled = FALSE;
	
	IF (SELECT item_status
			FROM order_details
			WHERE order_id = in_order_id AND item_status = 'Pending'
			GROUP BY item_status) IS NOT NULL 
        THEN 	
			SET status_pending = TRUE;	
		ELSE	
			SET status_pending = FALSE;
		END IF;
	IF (SELECT item_status
			FROM order_details
			WHERE order_id = in_order_id AND item_status = 'Shipped'
			GROUP BY item_status) IS NOT NULL 
        THEN 	
			SET status_shipped = TRUE;	
		ELSE	
			SET status_shipped = FALSE;
		END IF;
	IF (SELECT item_status
			FROM order_details
			WHERE order_id = in_order_id AND item_status = 'Delivered'
			GROUP BY item_status) IS NOT NULL 
        THEN 	
			SET status_delivered = TRUE;	
		ELSE	
			SET status_delivered = FALSE;
		END IF;
	IF (SELECT item_status
			FROM order_details
			WHERE order_id = in_order_id AND item_status = 'Returned'
			GROUP BY item_status) IS NOT NULL 
        THEN 	
			SET status_returned = TRUE;	
		ELSE	
			SET status_returned = FALSE;
		END IF;
	IF (SELECT item_status
			FROM order_details
			WHERE order_id = in_order_id AND item_status = 'Cancelled'
			GROUP BY item_status) IS NOT NULL 
        THEN 	
			SET status_cancelled = TRUE;	
		ELSE	
			SET status_cancelled = FALSE;
		END IF;

        
	UPDATE orders
	SET order_status = CASE
						   WHEN status_cancelled = TRUE THEN 'Cancelled'
                           WHEN status_returned  = TRUE THEN 'Returned'
                           WHEN status_delivered = TRUE AND (status_pending = TRUE OR 
															 status_shipped = TRUE)
														THEN 'Part_Delivered'
						   WHEN status_delivered = TRUE THEN 'Delivered'
                           WHEN status_shipped = TRUE AND status_pending = TRUE
														THEN 'Part_Shipped'
						   WHEN status_shipped = TRUE THEN 'Shipped'
                           WHEN status_pending = TRUE THEN 'Pending'
                           ELSE order_status
					   END
    WHERE
		order_id = in_order_id;
		
END $$

DELIMITER ;

#callig the procedure to test it
CALL overall_order_status(3,10,'Pending');

