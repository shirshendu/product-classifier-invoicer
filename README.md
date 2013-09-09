product classification and invoicing
====================================

Some code I wrote for a programming problem

INVOICING
Write a program which does invoicing for a basket.  
Rules while invoicing:
- VAT @ 12.5% on all products except food, toys and medicines.
- Additional Tax on imported goods @ 2.4%, no exemptions.
Given these baskets as a file to your program, your program should print the invoice.

Input 1:
1 soap @ 30.50
1 potato chips packet @ 22.50
1 music CD @ 250.59
1 imported bottle of perfume @ 2100.99
1 packet of crocin @ 19.75

Input 2:
1 imported handbag @ 2200.59
1 imported sunglasses @ 1250.00
1 perfume bottle @ 450.49
1 box of imported chocolates @ 450.25
1 Teddy bear @ 250.59

Additional Clarifications:
- You need to make sure that the code not only works for the test cases described below but also for other datasets and test cases. Ensure that boundary conditions are taken care of.
- Assume "@" to be a unique identifier for splitting between product and price. That is, "@" does not exist in any product name
- each "additional tax" is calculated on cost *after VAT*?
- Since the code is expected to work for test cases other than those provided, there could potentially be any randomly named products. Build a classifier, dictionary-based, or otherwise.
