-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_flebite ( ie_opcao_p text, dt_inicio_p timestamp, dt_final_p timestamp) RETURNS bigint AS $body$
DECLARE

/*
Total de AVP-Dia		'TD'
Total de AVP-Inseridos	'TI'
Total de pacientes com flebite	'TF'
Total de Flebites		'TE'
*/
ds_retorno_w	bigint;


BEGIN

If (ie_opcao_p = 'TD') then

	if (coalesce(dt_final_p::text, '') = '') then
		select 	count(*)
		into STRICT	ds_retorno_w
		from   	atend_pac_dispositivo a,
			dispositivo b
		where  	a.nr_seq_dispositivo = b.nr_sequencia
		and    	b.ie_classif_disp_niss = 'CVC'
		and    	trunc(a.dt_instalacao) <= dt_inicio_p
		and    	coalesce(a.dt_retirada,dt_inicio_p) >= dt_inicio_p;
	else
		select 	count(*)
		into STRICT	ds_retorno_w
		from   	atend_pac_dispositivo a,
			dispositivo b
		where  	a.nr_seq_dispositivo = b.nr_sequencia
		and    	b.ie_classif_disp_niss = 'CVC'
		and    	trunc(a.dt_instalacao) <= dt_inicio_p
		and    	coalesce(a.dt_retirada,dt_final_p) >= dt_final_p;
	end if;

elsif (ie_opcao_p = 'TI') then

	select 	count(*)
	into STRICT	ds_retorno_w
	from   	atend_pac_dispositivo a,
		dispositivo b
	where  	a.nr_seq_dispositivo = b.nr_sequencia
	and    	b.ie_classif_disp_niss = 'CVC'
	and    	trunc(a.dt_instalacao) between dt_inicio_p and coalesce(dt_final_p,dt_inicio_p);


elsif (ie_opcao_p = 'TF') then

	select 	count(distinct a.nr_atendimento)
	into STRICT	ds_retorno_w
	from	qua_evento_paciente a,
 		qua_tipo_evento b,
		qua_evento c
	where  	b.ie_tipo_evento = 'AF'
	and	b.nr_sequencia = c.nr_seq_tipo
	and 	a.nr_seq_evento = c.nr_sequencia
	and	trunc(dt_evento) between dt_inicio_p and coalesce(dt_final_p,dt_inicio_p);

elsif (ie_opcao_p = 'TE') then

	select 	count(*)
	into STRICT	ds_retorno_w
	from	qua_evento_paciente b,
		qua_evento_flebite e
	where	e.nr_seq_evento = b.nr_sequencia
	and	coalesce(b.dt_inativacao::text, '') = ''
	and	e.ie_origem = '1'
	and    	trunc(b.dt_evento) between dt_inicio_p and coalesce(dt_final_p,dt_inicio_p);

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_flebite ( ie_opcao_p text, dt_inicio_p timestamp, dt_final_p timestamp) FROM PUBLIC;
