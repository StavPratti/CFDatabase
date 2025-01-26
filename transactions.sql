update accounts set balance=1000 where accno='A900'
update accounts set balance=2000 where accno='A901'

select * 
  from accounts where accno='A900' or accno='A901'

-- Transaction T1
begin try 
   begin transaction  t1
    update accounts set balance = balance - 500 
      where accno='A900'
  
    update accounts set balance = balance + 500
      where accno='A901'
	commit transaction t1
	print '*** T1 commited ***'
end try 

begin catch 
    rollback transaction t1
	print '***** t1 rolled back ****'
end catch
