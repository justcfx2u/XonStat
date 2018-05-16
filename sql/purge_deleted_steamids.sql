delete from hashkeys where active_ind=false and timezone('UTC', now()) - delete_dt >= '60 days';
