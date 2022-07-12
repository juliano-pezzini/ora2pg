-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nome_cert_nasc ( nr_atendimento_p bigint, cd_pediatra_p bigint, ie_opcao_p text, ie_tipo_campo_p text) RETURNS varchar AS $body$
DECLARE

				
ds_name_w			pessoa_fisica.nm_pessoa_fisica%type := '';
cd_medico_w			parto.cd_medico%type;
cd_enfermagem_w		parto.cd_enfermagem%type;

/*
 ie_tipo_campo_p:
 C = Certificante;
 R = Responsavel
*/
BEGIN
if (ie_tipo_campo_p = 'C') then
	begin
	if (cd_pediatra_p IS NOT NULL AND cd_pediatra_p::text <> '') and (ie_opcao_p = '1') then
		select 	obter_nome_pf(cd_pediatra_P)
		into STRICT 	ds_name_w
		;
	elsif (ie_opcao_p <> '1') then
		begin

		select	max(cd_medico),
				max(cd_enfermagem)
		into STRICT	cd_medico_w,
				cd_enfermagem_w
		from 	parto p
		where	p.nr_atendimento = nr_atendimento_p;

		if (ie_opcao_p = '3') and (cd_enfermagem_w IS NOT NULL AND cd_enfermagem_w::text <> '') then
			select 	obter_nome_pf(cd_enfermagem_w)
			into STRICT 	ds_name_w
			;
		elsif (ie_opcao_p = '7') and (cd_medico_w IS NOT NULL AND cd_medico_w::text <> '') then
			select 	obter_nome_pf(cd_medico_w)
			into STRICT 	ds_name_w
			;
		end if;
		end;
	end if;
	end;
else
	begin
	if (cd_pediatra_p IS NOT NULL AND cd_pediatra_p::text <> '') and (ie_opcao_p = '1') then
		select 	obter_nome_pf(cd_pediatra_P)
		into STRICT 	ds_name_w
		;
	elsif (ie_opcao_p <> '1') then
		begin

		select	max(cd_medico),
				max(cd_enfermagem)
		into STRICT	cd_medico_w,
				cd_enfermagem_w
				
		from 	parto p
		where	p.nr_atendimento = nr_atendimento_p;

		if (ie_opcao_p = '2') and (cd_enfermagem_w IS NOT NULL AND cd_enfermagem_w::text <> '') then
			select 	obter_nome_pf(cd_enfermagem_w)
			into STRICT 	ds_name_w
			;
		elsif (ie_opcao_p = '7') and (cd_medico_w IS NOT NULL AND cd_medico_w::text <> '') then
			select 	obter_nome_pf(cd_medico_w)
			into STRICT 	ds_name_w
			;
		end if;
		end;
	end if;
	end;
end if;
return ds_name_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nome_cert_nasc ( nr_atendimento_p bigint, cd_pediatra_p bigint, ie_opcao_p text, ie_tipo_campo_p text) FROM PUBLIC;
