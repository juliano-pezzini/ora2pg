-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_diag ( cd_pessoa_fisica_p text, cd_doenca_p text, ie_opcao_p text default null) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w		varchar(60)	:= wheb_mensagem_pck.get_texto(309379); -- Ativo 
dt_diagnostico_w	timestamp;
dt_status_w		timestamp;
ie_status_w		varchar(255);

BEGIN
 
begin 
select	max(a.dt_atualizacao) 
into STRICT	dt_diagnostico_w 
from	diagnostico_doenca a, 
	diagnostico_medico b, 
	atendimento_paciente x 
where	a.nr_atendimento	= x.nr_atendimento 
and	x.nr_atendimento	= b.nr_atendimento 
and	x.cd_pessoa_fisica	= cd_pessoa_fisica_p 
and	a.cd_doenca		= cd_doenca_p 
and	a.nr_atendimento	= b.nr_atendimento 
and	a.dt_diagnostico	= b.dt_diagnostico;
exception 
	when others then 
	dt_diagnostico_w	:= to_date('02/01/1800','DD/MM/YYYY');
end;
 
begin 
select	max(dt_atualizacao) 
into STRICT	dt_status_w 
from	diagnostico_doenca_hist 
where	cd_pessoa_fisica	= cd_pessoa_fisica_p 
and	cd_doenca		= cd_doenca_p 
and	ie_status not in ('P','S');
exception 
	when others then 
	dt_status_w	:= to_date('01/01/1800','DD/MM/YYYY');
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(309379); -- Ativo 
end;
 
if (dt_status_w IS NOT NULL AND dt_status_w::text <> '') and (dt_status_w < dt_diagnostico_w) then 
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(309379); -- Ativo 
elsif (dt_status_w IS NOT NULL AND dt_status_w::text <> '') and (dt_status_w <> to_date('01/01/1800','DD/MM/YYYY')) then
	select	substr(obter_valor_dominio(1332,ie_status),1,60), 
		ie_status 
	into STRICT	ds_retorno_w, 
		ie_status_w 
	from	diagnostico_doenca_hist 
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p 
	and	cd_doenca		= cd_doenca_p 
	and	dt_atualizacao		= dt_status_w;
	 
	select	coalesce(max(ds_status),ds_retorno_w) 
	into STRICT	ds_retorno_w 
	from	diagnostico_status 
	where	ie_status	= ie_status_w;
	 
	if (ie_opcao_p	= 'C') then 
		ds_retorno_w	:= ie_status_w;
	end if;
	 
end if;
 
 
return ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_diag ( cd_pessoa_fisica_p text, cd_doenca_p text, ie_opcao_p text default null) FROM PUBLIC;

