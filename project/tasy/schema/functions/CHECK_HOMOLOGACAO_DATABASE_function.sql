-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION check_homologacao_database () RETURNS varchar AS $body$
DECLARE

qt_registro_w 	bigint;
nm_user_w 	varchar(10);
ds_Sep_bv_w 	varchar(50);
ie_retorno_w	varchar(1);

BEGIN
ie_retorno_w := 'N';
ds_sep_bv_w := obter_separador_bv;

qt_registro_w := obter_valor_dinamico_bv('select 1 from estabelecimento where cd_cgc = :cd_cgc and cd_estabelecimento = :cd_estabelecimento and ie_situacao = :ie_situacao', 'cd_cgc=01950338000177'||ds_sep_bv_w||'cd_estabelecimento=1'||ds_sep_bv_w||'ie_situacao=A', qt_registro_w);
if ( qt_registro_w > 0 ) then
	ie_retorno_w := 'S';
end if;

if	ie_retorno_w = 'N' then

	select 	count(*)
	into STRICT	qt_registro_w
	from	estabelecimento 
	where	ie_situacao = 'A'
	and	cd_cgc in ('12104241000402','12104241000160','12104241000240','12104241000321','12104241000593','12104241000674','12104241000755');

	if qt_registro_w > 0 then
		ie_retorno_w := 'S';
	end if;

end if;

return ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION check_homologacao_database () FROM PUBLIC;
