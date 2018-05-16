delete from player_nicks where timezone('UTC', now()) - create_dt >= '60 days' and (last_used_dt is null or timezone('UTC', now()) - create_dt >= '60 days');
