-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_substituir_macro_analise ( ds_macro_p text, nm_atributo_p text, vl_atributo_p bigint) RETURNS varchar AS $body$
DECLARE


cd_procedimento_w		bigint;
nr_seq_material_w		bigint;
ds_resultado_w			varchar(255);


BEGIN

if (upper(nm_atributo_p)		= 'NR_SEQ_SEGURADO') then

	if (ds_macro_p	= '@BENEFICIARIO') then
		ds_resultado_w := To_char(vl_atributo_p);
	end if;
elsif (upper(nm_atributo_p)		= 'NR_SEQ_ITEM') then

	select	a.cd_procedimento,
		a.nr_seq_material
	into STRICT	cd_procedimento_w,
		nr_seq_material_w
	from	pls_auditoria_item a
	where	nr_sequencia = vl_atributo_p;

	if (ds_macro_p	= '@PROCEDIMENTO') then
		ds_resultado_w	:= To_char(cd_procedimento_w);
	elsif (ds_macro_p	= '@MATERIAL') then
		ds_resultado_w	:= To_char(nr_seq_material_w);
	end if;
end if;

return	ds_resultado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_substituir_macro_analise ( ds_macro_p text, nm_atributo_p text, vl_atributo_p bigint) FROM PUBLIC;
