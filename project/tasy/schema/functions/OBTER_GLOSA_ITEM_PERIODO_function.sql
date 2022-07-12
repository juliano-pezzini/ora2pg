-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_glosa_item_periodo ( nr_seq_propaci_p bigint, nr_seq_matpaci_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, ie_opcao_p bigint) RETURNS bigint AS $body$
DECLARE

vl_glosa_w	double precision	:= 0;
vl_glosado_w	double precision	:= 0;


BEGIN

if (ie_opcao_p = 1) then
	if (nr_seq_propaci_p IS NOT NULL AND nr_seq_propaci_p::text <> '') then
		SELECT	coalesce(SUM(a.vl_glosa),0)
		INTO STRICT	vl_glosado_w
		FROM	motivo_glosa c,
			convenio_retorno_glosa a,
			convenio_retorno d,
			convenio_retorno_item b
		WHERE	b.nr_sequencia		= a.nr_seq_ret_item
		and	d.nr_sequencia		= b.nr_seq_retorno
		AND	a.cd_motivo_glosa	= c.cd_motivo_glosa
		AND	a.nr_seq_propaci	= nr_seq_propaci_p
		AND	coalesce(a.ie_acao_glosa,c.ie_acao_glosa) = 'A'
		and	d.dt_retorno BETWEEN dt_inicial_p AND dt_final_p;
	else
		select	coalesce(SUM(a.vl_glosa),0)
		into STRICT	vl_glosado_w
		from	motivo_glosa c,
			convenio_retorno_glosa a,
			convenio_retorno d,
			convenio_retorno_item b
		where	b.nr_sequencia		= a.nr_seq_ret_item
		and	d.nr_sequencia		= b.nr_seq_retorno
		and	a.cd_motivo_glosa	= c.cd_motivo_glosa
		and	a.nr_seq_matpaci	= nr_seq_matpaci_p
		and	coalesce(a.ie_acao_glosa,c.ie_acao_glosa) = 'A'
		and	d.dt_retorno BETWEEN dt_inicial_p AND dt_final_p;
	end if;
end if;

if (ie_opcao_p = 2) then
	if (nr_seq_propaci_p IS NOT NULL AND nr_seq_propaci_p::text <> '') then
		SELECT	coalesce(SUM(a.vl_glosa),0)
		INTO STRICT	vl_glosado_w
		FROM	motivo_glosa c,
			convenio_retorno_glosa a,
			convenio_retorno d,
			procedimento_paciente x,
			convenio_retorno_item b
		WHERE	b.nr_sequencia		= a.nr_seq_ret_item
		and	d.nr_sequencia		= b.nr_seq_retorno
		AND	a.cd_motivo_glosa	= c.cd_motivo_glosa
		and	x.nr_sequencia		= a.nr_seq_propaci
		AND	a.nr_seq_propaci	= nr_seq_propaci_p
		AND	coalesce(a.ie_acao_glosa,c.ie_acao_glosa) = 'A'
		and	x.dt_procedimento BETWEEN dt_inicial_p AND dt_final_p;
	else
		select	coalesce(SUM(a.vl_glosa),0)
		into STRICT	vl_glosado_w
		from	motivo_glosa c,
			convenio_retorno_glosa a,
			convenio_retorno d,
			convenio_retorno_item b
		where	b.nr_sequencia		= a.nr_seq_ret_item
		and	d.nr_sequencia		= b.nr_seq_retorno
		and	a.cd_motivo_glosa	= c.cd_motivo_glosa
		and	a.nr_seq_matpaci	= nr_seq_matpaci_p
		and	coalesce(a.ie_acao_glosa,c.ie_acao_glosa) = 'A'
		and	d.dt_retorno BETWEEN dt_inicial_p AND dt_final_p;
	end if;
end if;

if (ie_opcao_p = 3) then
	if (nr_seq_propaci_p IS NOT NULL AND nr_seq_propaci_p::text <> '') THEN
		select	coalesce(SUM(a.vl_glosa),0)
		into STRICT	vl_glosado_w
		from	convenio_retorno_glosa a,
			convenio_retorno d,
			convenio_retorno_item b
		where	b.nr_sequencia		= a.nr_seq_ret_item
		and	d.nr_sequencia		= b.nr_seq_retorno
		and	a.nr_seq_propaci	= nr_seq_propaci_p
		and	d.dt_retorno BETWEEN dt_inicial_p AND dt_final_p;
	else
		select	coalesce(SUM(a.vl_glosa),0)
		into STRICT	vl_glosado_w
		from	convenio_retorno_glosa a,
			convenio_retorno d,
			convenio_retorno_item b
		where	b.nr_sequencia		= a.nr_seq_ret_item
		and	d.nr_sequencia		= b.nr_seq_retorno
		and	a.nr_seq_matpaci	= nr_seq_matpaci_p
		and	d.dt_retorno BETWEEN dt_inicial_p AND dt_final_p;
	end if;
end if;

if (ie_opcao_p = 4) then
	if (nr_seq_propaci_p IS NOT NULL AND nr_seq_propaci_p::text <> '') then
		SELECT	coalesce(SUM(a.vl_glosa),0)
		INTO STRICT	vl_glosado_w
		FROM	motivo_glosa c,
			convenio_retorno_glosa a,
			convenio_retorno d,
			convenio_retorno_item b
		WHERE	b.nr_sequencia		= a.nr_seq_ret_item
		and	d.nr_sequencia		= b.nr_seq_retorno
		AND	a.cd_motivo_glosa	= c.cd_motivo_glosa
		AND	a.nr_seq_propaci	= nr_seq_propaci_p
		AND	coalesce(a.ie_acao_glosa,c.ie_acao_glosa) = 'R'
		and	d.dt_retorno BETWEEN dt_inicial_p AND dt_final_p;
	else
		select	coalesce(SUM(a.vl_glosa),0)
		into STRICT	vl_glosado_w
		from	motivo_glosa c,
			convenio_retorno_glosa a,
			convenio_retorno d,
			convenio_retorno_item b
		where	b.nr_sequencia		= a.nr_seq_ret_item
		and	d.nr_sequencia		= b.nr_seq_retorno
		and	a.cd_motivo_glosa	= c.cd_motivo_glosa
		and	a.nr_seq_matpaci	= nr_seq_matpaci_p
		and	coalesce(a.ie_acao_glosa,c.ie_acao_glosa) = 'R'
		and	d.dt_retorno BETWEEN dt_inicial_p AND dt_final_p;
	end if;
end if;


return	coalesce(vl_glosado_w,0);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_glosa_item_periodo ( nr_seq_propaci_p bigint, nr_seq_matpaci_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, ie_opcao_p bigint) FROM PUBLIC;
