-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gerar_registro_tumor ( cd_pessoa_fisica_p text, dt_registro_p timestamp, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(20);
ano_w		varchar(4);
qt_registro_w	varchar(10);
qt_tumor_w	smallint;
cd_cnes_w	varchar(11);
nr_registro_w	varchar(4);

C01 CURSOR FOR
	SELECT	substr(nr_registro,16,4)
	from	can_ficha_admissao
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	to_char(dt_preench_ficha,'yyyy') = ano_w;


BEGIN

ano_w	:= to_char(dt_registro_p,'yyyy');

OPEN C01;
LOOP
	FETCH C01 INTO
		nr_registro_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	nr_registro_w	:= nr_registro_w;
END LOOP;
CLOSE C01;

qt_registro_w	:= nr_registro_w;

if (coalesce(nr_registro_w::text, '') = '') then
	select	lpad(count(*) +1,4,'0')
	into STRICT	qt_registro_w
	from	can_ficha_admissao
	where	to_char(dt_preench_ficha,'yyyy') = ano_w;
end if;

select	lpad(max(cd_cnes),11,'0')
into STRICT	cd_cnes_w
from	sus_parametros
where	cd_estabelecimento	= cd_estabelecimento_p;

if (coalesce(cd_cnes_w::text, '') = '') then
	select	lpad(max(cd_cnes_hospital),11,'0')
	into STRICT	cd_cnes_w
	from	sus_parametros_apac
	where	cd_estabelecimento	= cd_estabelecimento_p;
end if;


select	count(*) + 1
into STRICT	qt_tumor_w
from	can_ficha_admissao
where	cd_pessoa_fisica	= cd_pessoa_fisica_p
and	to_char(dt_preench_ficha,'yyyy') = ano_w;

ds_retorno_w	:= cd_cnes_w || ano_w || qt_registro_w ||qt_tumor_w;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gerar_registro_tumor ( cd_pessoa_fisica_p text, dt_registro_p timestamp, cd_estabelecimento_p bigint) FROM PUBLIC;
