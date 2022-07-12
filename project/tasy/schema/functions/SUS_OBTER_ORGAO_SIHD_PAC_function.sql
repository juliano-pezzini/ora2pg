-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_orgao_sihd_pac ( nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
 
cd_pessoa_fisica_w	varchar(10);
cd_estabelecimento_w	smallint;
cd_municipio_ibge_w	varchar(6);
cd_orgao_emissor_sihd_w	varchar(10);

 

BEGIN 
 
select	cd_pessoa_fisica, 
	cd_estabelecimento 
into STRICT	cd_pessoa_fisica_w, 
	cd_estabelecimento_w 
from	atendimento_paciente 
where	nr_atendimento = nr_atendimento_p;
 
if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then 
	select	coalesce(max(cd_municipio_ibge),'0') 
	into STRICT	cd_municipio_ibge_w 
	from	compl_pessoa_fisica 
	where	ie_tipo_complemento	= 1 
	and	cd_pessoa_fisica	= cd_pessoa_fisica_w;
 
	if (cd_municipio_ibge_w IS NOT NULL AND cd_municipio_ibge_w::text <> '') and (cd_municipio_ibge_w <> '0') then 
		select	cd_orgao_emissor_sihd 
		into STRICT	cd_orgao_emissor_sihd_w 
		from	sus_municipio 
		where	cd_municipio_ibge	= cd_municipio_ibge_w;
	end if;
 
	if (coalesce(cd_orgao_emissor_sihd_w::text, '') = '') then 
		select	cd_orgao_emissor_sihd 
		into STRICT	cd_orgao_emissor_sihd_w 
		from	sus_parametros 
		where	cd_estabelecimento	= cd_estabelecimento_w;
	end if;
end if;
 
return	cd_orgao_emissor_sihd_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_orgao_sihd_pac ( nr_atendimento_p bigint) FROM PUBLIC;
