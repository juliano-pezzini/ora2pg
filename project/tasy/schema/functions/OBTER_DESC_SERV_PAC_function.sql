-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_serv_pac (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_servico_w	varchar(255);
			

BEGIN 
 
if (coalesce(nr_sequencia_p,0) > 0) then 
 
	select	substr(ds_servico,1,255) 
	into STRICT	ds_servico_w 
	from	regra_servicos_paciente 
	where	nr_sequencia = nr_sequencia_p;
 
end if;
 
return	ds_servico_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_serv_pac (nr_sequencia_p bigint) FROM PUBLIC;

