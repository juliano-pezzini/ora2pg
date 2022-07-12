-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nm_medic_cir_agenda ( cd_medico_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE



nm_medico_w			varchar(254);
nm_guerra_w			varchar(254);
nr_crm_w			varchar(254);
nm_pessoa_fisica_w		varchar(254);
uf_crm_w			medico.uf_crm%type;
ds_conselho_w			varchar(50);


BEGIN

if (cd_medico_p IS NOT NULL AND cd_medico_p::text <> '') then
	select 	max(a.nm_guerra),
		max(a.nr_crm),
		max(a.uf_crm),
		max(substr(obter_conselho_profissional(b.nr_seq_conselho, 'S'),1,100)),
		max(b.nm_pessoa_fisica)
	into STRICT 	nm_guerra_w,
		nr_crm_w,
		uf_crm_w,
		ds_conselho_w,
		nm_pessoa_fisica_w
	from 	pessoa_fisica b,
		medico a
	where 	a.cd_pessoa_fisica = b.cd_pessoa_fisica
	and	a.cd_pessoa_fisica = cd_medico_p;
end if;
	
	
	if (nm_pessoa_fisica_w IS NOT NULL AND nm_pessoa_fisica_w::text <> '') then
		nm_medico_w 	:= nm_pessoa_fisica_w || ' ('||ds_conselho_w||' ' || nr_crm_w || ')';
	else
		nm_medico_w     := substr(obter_nome_medico(cd_medico_p,'NCD'),1,200);
	
	end if;

return nm_medico_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nm_medic_cir_agenda ( cd_medico_p text, ie_opcao_p text) FROM PUBLIC;

