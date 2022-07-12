-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION consiste_cep (nr_cep_p text) RETURNS varchar AS $body$
DECLARE


vl_parametro_w	varchar(255);
qt_registro_w		integer	:= 0;


BEGIN

select	coalesce(vl_parametro,vl_parametro_padrao)
into STRICT	vl_parametro_w
from	funcao_parametro
where	cd_funcao = 0
and	nr_sequencia = 25;

if (vl_parametro_w = 'S') then
	select	count(*)
	into STRICT	qt_registro_w
	from	cep_log
	where	cd_cep	= nr_cep_p;

	if (qt_registro_w = 0) then
		select	count(*)
		into STRICT	qt_registro_w
		from	cep_loc
		where	cd_cep	= nr_cep_p;
	end if;
else
	select	count(*)
	into STRICT	qt_registro_w
	from	cep_logradouro
	where	cd_logradouro = nr_cep_p;

	if (qt_registro_w = 0) then
		select	count(*)
		into STRICT	qt_registro_w
		from	cep_localidade
		where	cd_localidade = nr_cep_p;
	end if;
end if;

if (qt_registro_w > 0) then
	return	'S';
else
	return	'N';
end if;

END	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION consiste_cep (nr_cep_p text) FROM PUBLIC;
