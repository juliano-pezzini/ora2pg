-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_loc (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_resultado_w		varchar(240)	:= '';
ie_municipio_ibge_w	varchar(1):= 'N';


BEGIN

select	coalesce(vl_parametro,vl_parametro_padrao)
into STRICT	ie_municipio_ibge_w
from	funcao_parametro
where	cd_funcao = 7002
and	nr_sequencia = 18;

if (ie_municipio_ibge_w = 'N') then

	begin
	select	nm_localidade
	into STRICT 	ds_resultado_w
	from	cep_loc
	where	nr_sequencia = nr_sequencia_p;
	exception
		when others then
			ds_resultado_w	:= '';
	end;

else
	begin
	select	ds_municipio
	into STRICT	ds_resultado_w
	from	sus_municipio
	where   cd_municipio_ibge = nr_sequencia_p;
	exception
		when others then
			ds_resultado_w	:= '';
	end;
end if;


RETURN ds_resultado_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_loc (nr_sequencia_p bigint) FROM PUBLIC;
