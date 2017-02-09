note
	description: "[
		(1) A Bank consists of many customers.
		There are `count' customers.
		(2) New customers can be added to the bank by name.
		    We never delete a customer record, 
		    even after they leave the bank.
		(3) Each customer shall have a single account at the bank.
		    Initially the balance in the account is zero.
		(4) Money can be deposited to and withdrawn from customer accounts.
		    Money is deposited as a dollar amount, 
		    perhaps with more than two decimal places.
		(5) Money calculations shall be precise 
		  (e.g. adding, subtracting and multiplying 
		  money amounts must be without losing pennies or parts of pennies).
		(6) Money can also be transferred between two customer accounts.
		(7) Balances in accounts shall never be negative.
		(8) Customers are identified by name, 
		    so there cannot be two customers having the same name.	  
		(9) Customers are stored in a list sorted alpahabetically by name.
		(11) The bank has an attribute `total' that stores the total
			of all the balances in the various customer accounts.
			This can be used to check for fraud.
			
			-----------------------------------------
			You will see '--Todo' where you must revise
			-----------------------------------------

		]"
	author: "Benjamin Korobkin, 212231189"
	date: "Due: January 29, 2017"
	revision: "$Revision$"

class
	BANK
inherit
	ANY
		redefine out end
create
	make

feature {NONE} -- Initialization
	make
			-- Create a bank

		do
			-- DONE

			zero := "0"
			one := "1"
			create {SORTED_TWO_WAY_LIST[CUSTOMER]} customers.make
			customers.compare_objects
			total := zero
			count := 0

		end

feature -- bank attributes

	-- don't change the bank attributes

	zero, one: VALUE

	count : INTEGER
		-- total number of bank customers

	total: VALUE
		-- total of all the balances in the customers accounts

	customers : LIST[CUSTOMER]
		-- list of all bank customers


feature -- Commands using a single account

	-- do not change the precondition and postcondition tags
	-- you may change the part of the contract that comes after the tag
	-- you may change the routine implemementations

	new (name1: STRING)
			-- Add a new customer named 'name1'

		require
			customer_not_already_present:
				across customers as c all c.item.name /~ name1 end -- DONE
			customer_not_empty:
				name1 /~ ""
			customer_not_numbers:
				not name1.is_integer



	local
		l_customer: CUSTOMER

		do --DONE
		create l_customer.make (name1)
		customers.extend (l_customer)
		count := count + 1


		ensure
			total_balance_unchanged:
				sum_of_all_balances = old sum_of_all_balances
			num_customers_increased:
				customers.count = old customers.count + 1
			total_unchanged:
				total ~ old total
			customer_added_to_list:
				customer_exists (name1)
				and then customers[customer_id (name1)].name ~ name1
				and then customers[customer_id (name1)].balance ~ zero
			other_customers_unchanged:
				customers_unchanged_other_than(name1, old customers.deep_twin)
		end

	deposit(a_name:STRING; a_value: VALUE)
			-- Deposit an amount of 'a_value' into account owned by 'a_name'.
		require
			customer_exists: across customers as c some c.item.name ~ a_name end
				 -- DONE
			positive_amount: a_value.is_greater (zero)
				--  DONE
			local
				found:BOOLEAN
				c_balance: VALUE
		do  -- DONE
--			from
--				customers.start
--			until
--				found
--			loop
--				if customers.item.name ~ a_name then
--					found := true
--				end
--				customers.forth
--			end
--			c_balance := customers.item.balance
--			c_balance := c_balance.add (a_value)
			customers[customer_id(a_name)].account.deposit (a_value)
			total := total.add (a_value)


		ensure
			deposit_num_customers_unchanged:
				count = old count
				 -- DONE
			total_increased:
				total ~ old total.add (a_value)
				 -- DONE
			deposit_customer_balance_increased:
			old customers[customer_id(a_name)].balance < customers[customer_id(a_name)].balance
				 -- DONE
			deposit_other_customers_unchanged:
				customers_unchanged_other_than(a_name, old customers.deep_twin)
				 -- DONE
			total_balance_increased:
				sum_of_all_balances ~ old sum_of_all_balances.add (a_value)
				 -- DONE!
		end

	withdraw (a_name:STRING; a_value: VALUE)
			-- Withdraw an amount of 'a_value' from account owned by 'a_name'.
		require
			customer_exists:
				current.customer_exists (a_name) = true --DONE
			positive_amount:
				a_value.is_greater (zero) -- DONE
			sufficient_balance: a_value.is_less_equal(current.customer_with_name(a_name).balance) -- DONE

		local
			found:BOOLEAN
			c_balance: VALUE

		do -- DONE

--			from
--				customers.start
--			until
--				found
--			loop
--				if customers.item.name ~ a_name then
--					found := true
--				end
--				customers.forth
--			end
--			c_balance := customers.item.balance
--			c_balance := c_balance.subtract (a_value)
			customers[customer_id(a_name)].account.withdraw (a_value)
			total := total.subtract (a_value)

		ensure
			withdraw_num_customers_unchanged:
				count = old count -- DONE
			total_decreased:
				total ~	old total.subtract (a_value) -- DONE
			withdraw_customer_balance_decreased:
				old customers[customer_id(a_name)].balance > customers[customer_id(a_name)].balance -- DONE
			withdraw_other_customers_unchanged:
				customers_unchanged_other_than(a_name, old customers.deep_twin)
			total_balance_decreased:
				sum_of_all_balances = old sum_of_all_balances.subtract (a_value) -- DONE!
		end

feature -- Command using multiple accounts

	transfer (name1: STRING; name2: STRING; a_value: VALUE)
			-- Transfer an amount of 'a_value' from
			-- account `name1' to account `name2'
		require
			distinct_accounts:
				name1 /~ name2 -- EASY!
			customer1_exists:
				current.customer_exists (name1)-- DONE
			customer2_exists:
				current.customer_exists (name2) -- DONE
			sufficient_balance:
				a_value.is_less_equal(current.customer_with_name(name1).balance) -- DONE
			transfer_amount_positive:
				a_value.is_greater (zero)



		do -- DONE
			current.deposit (name2, a_value)
			current.withdraw (name1, a_value)



		ensure
			same_total:
				total ~ old total -- DONE
			same_count:
				count ~ old count -- DONE
			total_balance_unchanged:
				sum_of_all_balances = old sum_of_all_balances -- DONE
			customer1_balance_decreased:
				current.customer_with_name (name1).balance.is_less_equal (old current.customer_with_name (name1).balance) -- DONE
			customer2_balance_increased:
				current.customer_with_name (name2).balance.is_greater_equal (old current.customer_with_name (name2).balance) -- DONE
			other_customers_unchanged:
				customers_unchanged_other_than2(name1,name2, old customers.deep_twin)
				  -- DONE!
		end

feature -- queries for contracts

	-- You may find the following queries helpful.
	-- Change them as necessary, or add your own
	-- if you add your own, contract them, and test them

	sum_of_all_balances : VALUE
			-- Summation of the balances in all customer accounts
		do
			from
				Result := Result.zero
				customers.start
			until
				customers.after
			loop
				Result := Result + customers.item.balance
				customers.forth
			end
		ensure
			comment("Result = (SUM i : 1..count: customers[i].balance)")
		end

	customer_exists(a_name: STRING): BOOLEAN
			-- Is customer `a_name' in the list?
		do
			from
				customers.start
			until
				customers.after or Result
			loop
				if customers.item.name ~ a_name then
					Result := true
				end
				customers.forth
			end
		ensure
			comment("EXISTS c in customers: c.name = a_name")
		end

	customer_id(a_name:STRING):INTEGER
			-- return index of `a_name' into customers
		local
		  i:INTEGER
		  stop:BOOLEAN
		do
			i := 1
			from
				customers.start
			until
				customers.after or stop
			loop
				if customers.item.name ~ a_name then
					stop := true
				else
				i := i + 1
				end
				customers.forth
			end
			Result := i
			--DONE? We'll see
		end

	customer_with_name (a_name: STRING): CUSTOMER
			-- return customer with name `a_name'
		require
			customer_exists (a_name)
		local
			c:CUSTOMER
			stop:BOOLEAN
		do
			Result := customers[1]
			-- The above is needed to remove the VEVI compile error
			-- of void safety
			from
				customers.start
			until
				customers.after or stop
			loop
				if customers.item.name ~ a_name then
				--	c := customers.item
					stop := true
				else
				customers.forth
				end
			end
			c := customers.item
			Result := c
			-- DONE? We shall see what we shall see

		ensure
			correct_Result: Result.name ~ a_name
		end

	customers_unchanged_other_than (a_name: STRING; old_customers: like customers): BOOLEAN
			-- Are customers other than `a_name' unchanged?
		local
			c_name: STRING
		do
			from
				Result := true
				customers.start
			until
				customers.after or not Result
			loop
				c_name := customers.item.name
				if c_name /~ a_name then
					Result := Result and then
						old_customers.has (customers.item)
				end
				customers.forth
			end
		ensure
			Result =
				across
					customers as c
				all
					c.item.name /~ a_name IMPLIES
						old_customers.has (c.item)
				end
		end

customers_unchanged_other_than2 (name1: STRING; name2: STRING; old_customers: like customers): BOOLEAN
			-- Are customers other than `a_name' unchanged?
		local
			c_name: STRING
		do
			from
				Result := true
				customers.start
			until
				customers.after or not Result
			loop
				c_name := customers.item.name
				if c_name /~ name1 and c_name /~ name2 then
					Result := Result and then
						old_customers.has (customers.item)
				end
				customers.forth
			end
		ensure
			Result =
				across
					customers as c
				all
					c.item.name /~ name1 and c.item.name /~ name2 IMPLIES
						old_customers.has (c.item)
				end
		end

feature -- invariant queries
	unique_customers: BOOLEAN
	local
		occur1:BOOLEAN
		int:INTEGER

		do
			int := 1
			from
				customers.start
				occur1 := true
			until
				customers.after or occur1 = false
			loop
				occur1 := customers.occurrences(customers.item) = 1
				customers.forth
			end-- DONE

		Result := occur1


		ensure
			Result = across
				1 |..| count as i
			all
				across 1 |..| count as j
				all
					customers[i.item] ~ customers[j.item]
					implies i.item = j.item
				end
			end
		end
feature -- Queries on string representation.

	customers_string: STRING
			-- Return printable state of `customers'.
		local
			sorted_customers: TWO_WAY_LIST[CUSTOMER]
		do
			create sorted_customers.make
			across
				customers as c
			loop
				sorted_customers.extend (c.item)
			end

			create Result.make_empty
			across
				sorted_customers as c
			loop
				Result := Result + c.item.out + "%N"
			end
		end


	out : STRING
			-- Return a sorted list of customers.
		do
			Result := customers_string
		end

	comment(s:STRING): BOOLEAN
		do
			Result := true
		end

feature
	customers_sorted: BOOLEAN

	local
		i:INTEGER
		j:INTEGER
		less:BOOLEAN

		do
			from
				i:=1
				j:=2
				less := true
			until
				customers.count = i-1 or customers.count = j or less = false
			loop
				less := customers[i.item].name.is_less_equal(customers[j.item].name)
				i:=i+1
				j:=j+1
			end
			Result := less
		end




invariant
	value_constraints:
		zero = zero.zero and one = one.one
	consistent_count:
		count = customers.count
	consistent_total:
		total = sum_of_all_balances
	customer_names_unique: unique_customers--DONE
		-- cannot have duplicate names in `customers'
	customers_are_sorted: customers_sorted --DONE
end



--%Exported from SVN%
--%2017-01-24:11:37:53%
--%bjk125%
