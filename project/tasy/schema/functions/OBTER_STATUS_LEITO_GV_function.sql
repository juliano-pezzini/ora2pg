-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_leito_gv ( cd_setor_atendimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text) RETURNS varchar AS $body$
DECLARE


ds_status_unid_w	varchar(255);


BEGIN

if (cd_setor_atendimento_p IS NOT NULL AND cd_setor_atendimento_p::text <> '') and (cd_unidade_basica_p IS NOT NULL AND cd_unidade_basica_p::text <> '') then
	begin
		select	substr(obter_valor_dominio(82,a.ie_status_unidade),1,255)
		into STRICT	ds_status_unid_w
		from	unidade_atendimento a
		where	cd_setor_atendimento	= cd_setor_atendimento_p
		and		cd_unidade_basica		= cd_unidade_basica_p
		and		cd_unidade_compl		= cd_unidade_compl_p;
	exception
	when others then
		null;
	end;
end if;

return ds_status_unid_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_leito_gv ( cd_setor_atendimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text) FROM PUBLIC;

