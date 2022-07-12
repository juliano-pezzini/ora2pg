-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_antec_exame (nr_seq_exame_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);


BEGIN
select	max(coalesce(ds_exame,substr(Obter_Desc_Exame(nr_seq_exame),1,255)))
into STRICT	ds_retorno_w
from	parto_antec_familiar_exame
where	nr_sequencia = nr_seq_exame_p;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_antec_exame (nr_seq_exame_p bigint) FROM PUBLIC;

