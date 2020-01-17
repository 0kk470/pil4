-- Exercise 32.1: Modify the function dir_iter in the directory example so that it closes the DIR structure
-- as soon as it reaches the end of the traversal. With this change, the program does not need to wait for a
-- garbage collection to release a resource that it knows it will not need anymore.
-- (When you close the directory, you should set the address stored in the userdata to NULL, to signal to the
-- finalizer that the directory is already closed. Also, dir_iter will have to check whether the directory
-- is closed before using it.)



-- Exercise 32.2: In the lxp example, we used user values to associate the callback table with the userdata
-- that represents a parser. This choice created a small problem, because what the C callbacks receive is the
-- lxp_userdata structure, and that structure does not offer direct access to the table. We solved this
-- problem by storing the callback table at a fixed stack index during the parse of each fragment.
-- An alternative design would be to associate the callback table with the userdata through references (the
-- section called “The registry”): we create a reference to the callback table and store the reference (an integer)
-- in the lxp_userdata structure. Implement this alternative. Do not forget to release the reference when
-- closing the parser.