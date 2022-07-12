-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nf_sem_vinculo (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


qtd_w bigint;
ds_retorno_w varchar(2);


BEGIN

select 	count(*)
into STRICT    qtd_w
from   	nota_fiscal_item a
where  	a.nr_sequencia = nr_sequencia_p
and 	((not exists (	SELECT 1
			from material_fiscal b
			where a.cd_material = b.cd_material ))
		or (exists (select 1
				from material_fiscal b
				where a.cd_material = b.cd_material
				and  coalesce(ie_tipo_servico::text, '') = '')));

if (qtd_w > 0) then
ds_retorno_w := 'S';
else
ds_retorno_w := 'N';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nf_sem_vinculo (nr_sequencia_p bigint) FROM PUBLIC;
