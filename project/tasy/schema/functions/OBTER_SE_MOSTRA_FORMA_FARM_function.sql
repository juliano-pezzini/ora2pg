-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_mostra_forma_farm ( nr_seq_forma_p bigint, cd_material_p bigint, ie_via_aplic_padrao_p text) RETURNS varchar AS $body$
DECLARE


qt_via_adic_w		bigint;
nr_seq_via_adm_w	bigint;
ie_retorno_w		varchar(1)	:= 'N';
ie_via_aplic_w		varchar(5);
ds_via_forma_w		varchar(255);

c01 CURSOR FOR
	SELECT	ie_via_aplicacao
	from	mat_via_aplic
	where	cd_material	= cd_material_p;


BEGIN

select	count(*)
into STRICT	qt_via_adic_w
from	mat_via_aplic
where	cd_material	= cd_material_p;

if	((coalesce(ie_via_aplic_padrao_p::text, '') = '') and (qt_via_adic_w = 0)) then
	ie_retorno_w	:= 'S';
else
	begin
	ds_via_forma_w	:= '';
	/*
	open c01;
		loop
		fetch c01 into
			ie_via_aplic_w;
			exit when c01%notfound;
			ds_via_forma_w	:= ds_via_forma_w || ie_via_aplic_w || '  ';
		end loop;
	close c01;
	*/
	ds_via_forma_w	:= ds_via_forma_w || ie_via_aplic_padrao_p;

	select	count(*)
	into STRICT	qt_via_adic_w
	from	anvisa_forma_farm_via b,
		via_aplicacao a
	where	a.nr_seq_via_anvisa	= b.nr_seq_via_adm
	and	b.nr_seq_forma_farm	= nr_seq_forma_p
	and	ds_via_forma_w like '%'||ie_via_aplicacao||'%';

	if (qt_via_adic_w > 0) then
		ie_retorno_w	:= 'S';
	end if;

	end;
end if;

return ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_mostra_forma_farm ( nr_seq_forma_p bigint, cd_material_p bigint, ie_via_aplic_padrao_p text) FROM PUBLIC;

