-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION esus_verifica_cbo_ficha ( cd_cbo_p text, ie_ficha_esus_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1) := 'S';
nr_seq_regra_w		esus_regra_cbo_lib_ficha.nr_sequencia%type := 0;
qt_reg_cbo_w		bigint := 0;


BEGIN

begin
select	nr_sequencia
into STRICT	nr_seq_regra_w
from	esus_regra_cbo_lib_ficha
where	ie_ficha_esus = ie_ficha_esus_p
and	ie_situacao = 'A';
exception
when others then
	nr_seq_regra_w := 0;
end;

if (nr_seq_regra_w > 0) then
	begin
	ds_retorno_w := 'N';

	select	count(1)
	into STRICT	qt_reg_cbo_w
	from	esus_regra_cbo_lib_item
	where	nr_seq_regra = nr_seq_regra_w
	and	cd_cbo = cd_cbo_p  LIMIT 1;

	if (qt_reg_cbo_w > 0) then
		ds_retorno_w := 'S';
	end if;
	end;
else
	ds_retorno_w := 'S';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION esus_verifica_cbo_ficha ( cd_cbo_p text, ie_ficha_esus_p text) FROM PUBLIC;
