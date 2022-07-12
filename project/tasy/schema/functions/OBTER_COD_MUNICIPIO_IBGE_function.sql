-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cod_municipio_ibge (cd_cep_p text) RETURNS varchar AS $body$
DECLARE


nr_localidade_w		integer	:= 0;
cd_cep_w		integer	:= 0;
cd_municipio_ibge_w	varchar(6)	:= '';
ie_cep_novo_w		varchar(01)	:= '';



BEGIN

select	coalesce(vl_parametro, vl_parametro_padrao)
into STRICT	ie_cep_novo_w
from	funcao_parametro
where	cd_funcao	= 0
and	nr_sequencia	= 25;

if (ie_cep_novo_w		= 'S') then
	begin

	select	coalesce(max(a.nr_seq_loc),0)
	into STRICT	nr_localidade_w
	from	cep_log a
	where	a.cd_cep		= Somente_Numero(cd_cep_p);

	if (nr_localidade_w > 0) then
		begin

		select	coalesce(max(cd_cep),0)
		into STRICT	cd_cep_w
		from	cep_loc
		where	nr_sequencia	= nr_localidade_w;

		if (cd_cep_w > 0) then
			begin

			select	a.cd_municipio_ibge
			into STRICT	cd_municipio_ibge_w
			from	cep_municipio b, sus_municipio a
			where	a.cd_municipio_sinpas = b.cd_municipio
			and	b.cd_cep	= cd_cep_w;


			end;
		end if;

		end;
	end if;

	end;
end if;

RETURN cd_municipio_ibge_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cod_municipio_ibge (cd_cep_p text) FROM PUBLIC;
