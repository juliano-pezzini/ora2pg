-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_pront_atend_same ( nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

ds_retorno_w	varchar(1);
nr_total_w	smallint;

BEGIN
select	count(*)
into STRICT	nr_total_w
from	same_prontuario
where	nr_atendimento = nr_atendimento_p;
if (nr_total_w > 0) then
	ds_retorno_w := 'S';
else	
	ds_retorno_w := 'N';
end if;
return	ds_retorno_w;
end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_pront_atend_same ( nr_atendimento_p bigint) FROM PUBLIC;

