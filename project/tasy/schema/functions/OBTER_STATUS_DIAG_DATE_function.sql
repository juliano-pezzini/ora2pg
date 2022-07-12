-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_diag_date ( cd_pessoa_fisica_p text, cd_doenca_p text, nr_seq_interno_p text default null) RETURNS timestamp AS $body$
DECLARE



dt_diagnostico_w  timestamp := null;

dt_retorno_w		timestamp := null;

dt_status_w  timestamp := null;


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

and	a.dt_diagnostico	= b.dt_diagnostico

and (a.nr_seq_interno  =nr_seq_interno_p or coalesce(nr_seq_interno_p::text, '') = '');

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

and	ie_status not in ('P','S')
and (nr_seq_interno  =nr_seq_interno_p or coalesce(nr_seq_interno_p::text, '') = '');

exception

	when others then

	dt_status_w	:= to_date('01/01/1800','DD/MM/YYYY');

end;

if (dt_status_w IS NOT NULL AND dt_status_w::text <> '') and (dt_status_w < dt_diagnostico_w) then

	dt_retorno_w	:= null;

elsif (dt_status_w IS NOT NULL AND dt_status_w::text <> '') and (dt_status_w <> to_date('01/01/1800','DD/MM/YYYY')) then

	select	DT_DISEASE_END

	into STRICT	dt_retorno_w

	from	diagnostico_doenca_hist

	where	cd_pessoa_fisica	= cd_pessoa_fisica_p

	and	cd_doenca		= cd_doenca_p

	and	dt_atualizacao		= dt_status_w
	and (nr_seq_interno  = nr_seq_interno_p or coalesce(nr_seq_interno_p::text, '') = '');

end if;

return dt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_diag_date ( cd_pessoa_fisica_p text, cd_doenca_p text, nr_seq_interno_p text default null) FROM PUBLIC;

