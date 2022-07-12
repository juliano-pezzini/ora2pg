-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_masc_fone_ddd ( nr_ddd_p text, ie_campo_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(20) := '';
nr_ddd_w		smallint := somente_numero(nr_ddd_p);
ie_celular_w		varchar(01);
ie_telefone_w		varchar(01);
ds_mascara_fone_w	varchar(20);
ie_fax_w		regra_mascara_fone.ie_fax%type;

/*ie_campo_p
T - Telefone
C - Celular
*/
c01 CURSOR FOR
SELECT	ds_mascara_fone,
	ie_celular,
	ie_telefone,
	ie_fax
from	regra_mascara_fone
where	( ( nr_ddd	= nr_ddd_w ) or ( nr_ddd = 0 ) )
and	clock_timestamp() between coalesce(dt_inicio_vigencia,clock_timestamp()) and coalesce(dt_fim_vigencia,clock_timestamp())
order by nr_ddd desc, nr_sequencia asc;


BEGIN
if (nr_ddd_w > 0) then
	open C01;
	loop
	fetch C01 into
		ds_mascara_fone_w,
		ie_celular_w,
		ie_telefone_w,
		ie_fax_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if (ie_campo_p = 'T') and (ie_telefone_w = 'S') then
			ds_retorno_w	:= ds_mascara_fone_w;
		elsif (ie_campo_p = 'C') and (ie_celular_w = 'S') then
			ds_retorno_w	:= ds_mascara_fone_w;
		elsif (ie_campo_p = 'F') and (ie_fax_w = 'S') then
			ds_retorno_w	:= ds_mascara_fone_w;
		end if;
		end;
	end loop;
	close C01;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_masc_fone_ddd ( nr_ddd_p text, ie_campo_p text) FROM PUBLIC;

