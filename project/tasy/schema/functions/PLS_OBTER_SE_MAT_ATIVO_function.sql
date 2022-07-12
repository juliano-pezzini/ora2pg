-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_mat_ativo ( nr_seq_material_p text, dt_material_p timestamp) RETURNS varchar AS $body$
DECLARE


/*
ds_retorno_w:

S - Material ativo
N - Material inativo
D- Material fora da data da regra de vigência
*/
ds_retorno_w		varchar(1)	:= 'S';
qt_material_ativo_w	bigint;

BEGIN

select	count(1)
into STRICT	qt_material_ativo_w
from	pls_material
where	nr_sequencia = nr_seq_material_p;

if (qt_material_ativo_w > 0)	then
	begin
	select	'S'
	into STRICT	ds_retorno_w
	from	pls_material
	where	ie_situacao = 'A'
	and	nr_sequencia = nr_seq_material_p
	and	(dt_inclusao IS NOT NULL AND dt_inclusao::text <> '');
	exception
	when others then
		ds_retorno_w	:= 'N';
	end;

	if (ds_retorno_w = 'S') then
		begin
		select	'S'
		into STRICT	ds_retorno_w
		from	pls_material
		where	nr_sequencia = nr_seq_material_p
		and (coalesce(dt_material_p::text, '') = '' or
			trunc(dt_material_p) between trunc(dt_inclusao) and trunc(coalesce(dt_exclusao,dt_material_p+1))
			);
		exception
		when others then
			ds_retorno_w	:= 'N';
		end;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_mat_ativo ( nr_seq_material_p text, dt_material_p timestamp) FROM PUBLIC;
