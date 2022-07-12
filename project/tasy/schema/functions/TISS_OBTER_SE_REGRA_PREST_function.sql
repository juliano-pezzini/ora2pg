-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tiss_obter_se_regra_prest (nr_seq_procedimento_p bigint, nr_seq_campo_prest_p bigint) RETURNS varchar AS $body$
DECLARE


count_w 	bigint;
ds_retorno_w	varchar(10);


BEGIN

select	count(*)
into STRICT	count_w
from	proc_paciente_tiss_prest
where	nr_seq_procedimento	= nr_seq_procedimento_p
and	nr_seq_campo_prest	= nr_seq_campo_prest_p;

ds_retorno_w := 'N';

if (count_w > 0) then
	ds_retorno_w := 'S';
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tiss_obter_se_regra_prest (nr_seq_procedimento_p bigint, nr_seq_campo_prest_p bigint) FROM PUBLIC;
