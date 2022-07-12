-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_prioridade_leg (nr_seq_ordem_serv bigint) RETURNS bigint AS $body$
DECLARE

 
nr_seq_leg_w			bigint;
ie_prioridade_w			varchar(1);
		

BEGIN 
 
select	ie_prioridade 
into STRICT	ie_prioridade_w 
from	man_ordem_servico_v2 a 
where	nr_sequencia = nr_seq_ordem_serv;
 
if (ie_prioridade_w = 'E') then 
	nr_seq_leg_w := 6651;	
end if;
 
if (ie_prioridade_w = 'U') then 
	nr_seq_leg_w := 6655;	
end if;
 
if (ie_prioridade_w = 'A') then 
	nr_seq_leg_w := 6649;	
end if;
 
if (ie_prioridade_w = 'M') then 
	nr_seq_leg_w := 6645;	
end if;
 
if (ie_prioridade_w = 'B') then 
	nr_seq_leg_w := 6646;	
end if;
 
if (ie_prioridade_w = 'S') then 
	nr_seq_leg_w := 6647;	
end if;
 
return	nr_seq_leg_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_prioridade_leg (nr_seq_ordem_serv bigint) FROM PUBLIC;
