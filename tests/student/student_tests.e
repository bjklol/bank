note
	description: "Studenst write their tests here"
	author: "Benjamin Korobkin"
	date: "January 29, 2017"
	revision: "$Revision$"

class
	STUDENT_TESTS

inherit
	ES_TEST

create
	make

feature  -- Initialization
	make
			-- Initialization for `Current'.
		do
			add_violation_case_with_tag ("transfer_amount_positive", agent t_transfer_pre_5)
			add_violation_case_with_tag ("customer_not_empty",agent t_new_pre_2)
			add_violation_case_with_tag ("customer_not_numbers",agent t_new_pre_3)
		end

feature -- tests
	t_transfer_pre_5
		local
			b:BANK
			v:VALUE
		do
			comment ("t_transfer_pre_5: transfer a negative amount to account")
			create b.make
			b.new ("John")
			b.new ("Jane")
			v := "-333.00"
			b.transfer ("John", "Jane", v)
		end
feature
	t_new_pre_2
		local
			b:BANK
		do
			comment ("t_new_pre_2: enter a customer with no name")
			create b.make
			b.new ("")
		end
feature
	t_new_pre_3
		local
			b:BANK
		do
			comment ("t_new_pre_3: Enter a customer name as a number")
			create b.make
			b.new("123")
		end
end
