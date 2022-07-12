-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_se_hist_contem ( nr_seq_hist_p bigint, ds_conteudo_p text) RETURNS varchar AS $body$
DECLARE


ds_relat_tecnico_w		varchar(32000);
ds_retorno_w		varchar(1);


BEGIN

begin
select	ds_relat_tecnico
into STRICT	ds_relat_tecnico_w
from	man_ordem_serv_tecnico
where	nr_sequencia = nr_seq_hist_p;

ds_relat_tecnico_w	:= upper(ds_relat_tecnico_w);

if (ds_relat_tecnico_w like '%'||upper(ds_conteudo_p)||'%') then
	ds_retorno_w	:= 'S';
else
	ds_retorno_w	:= 'N';
end if;
exception
when others then
	ds_retorno_w	:= 'N';
end;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_se_hist_contem ( nr_seq_hist_p bigint, ds_conteudo_p text) FROM PUBLIC;

