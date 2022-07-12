-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_total_exames_pac (nr_codigo_p bigint, ie_codigo_p text, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


qt_total_w				bigint;
qt_pendentes_w			bigint;
qt_liberados_w			bigint;

/*
ie_opcao
P - Pendentes
T - Todos
L - Liberados
*/
BEGIN

if (upper(ie_opcao_p) = 'T') then
	select sum(qt)
	into STRICT	qt_total_w
	from (SELECT	count(*) qt
	from    valor_dominio f,
		exame_laboratorio e,
		prescr_procedimento d,
		prescr_medica a
	where   d.nr_prescricao      = a.nr_prescricao
	and    	(d.nr_seq_exame IS NOT NULL AND d.nr_seq_exame::text <> '')
	and    	d.nr_seq_exame       = e.nr_seq_exame
	and    	d.ie_status_atend    = f.vl_dominio
	and    	f.cd_dominio = 1030
	and	((a.nr_prescricao = nr_codigo_p and ie_codigo_p = 'P') or (a.nr_atendimento = nr_codigo_p and ie_codigo_p = 'A'))
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	
union

	SELECT	count(*)
	from  	valor_dominio f,
		laudo_paciente e,
		procedimento_paciente d,
		prescr_procedimento a,
		prescr_medica p
	where   d.nr_prescricao      = e.nr_prescricao
	and	d.nr_prescricao      = a.nr_prescricao
	and	d.nr_sequencia_prescricao = a.nr_sequencia
	and    	d.nr_sequencia       = e.nr_seq_proc
	and    	a.ie_status_execucao = f.vl_dominio
	and 	d.nr_laudo	         = e.nr_sequencia
	and	a.nr_prescricao		= p.nr_prescricao
	and    	f.cd_dominio         = 1226
	and	((d.nr_prescricao = nr_codigo_p and ie_codigo_p = 'P') or (d.nr_atendimento = nr_codigo_p and ie_codigo_p = 'A'))
	and	(p.dt_liberacao IS NOT NULL AND p.dt_liberacao::text <> '')
	and	coalesce(a.nr_seq_exame::text, '') = '') alias15;
	return	qt_total_w;
elsif (upper(ie_opcao_p) = 'P') then

	select sum(qt)
	into STRICT	qt_pendentes_w
	from (SELECT	count(*) qt
	from    valor_dominio f,
		exame_laboratorio e,
		prescr_procedimento d,
		prescr_medica a
	where   d.nr_prescricao      = a.nr_prescricao
	and   	(d.nr_seq_exame IS NOT NULL AND d.nr_seq_exame::text <> '')
	and   	d.nr_seq_exame       = e.nr_seq_exame
	and    	d.ie_status_atend    = f.vl_dominio
	and    	f.cd_dominio = 1030
	and	f.vl_dominio = '40'
	and	((a.nr_prescricao = nr_codigo_p and ie_codigo_p = 'P') or (a.nr_atendimento = nr_codigo_p and ie_codigo_p = 'A'))
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	
union

	SELECT	count(*)
	from  	valor_dominio f,
		laudo_paciente e,
		procedimento_paciente d,
		prescr_procedimento a,
		prescr_medica p
	where   d.nr_prescricao      = e.nr_prescricao
	and	d.nr_prescricao      = a.nr_prescricao
	and	d.nr_sequencia_prescricao = a.nr_sequencia
	and    	d.nr_sequencia       = e.nr_seq_proc
	and    	a.ie_status_execucao = f.vl_dominio
	and 	d.nr_laudo	         = e.nr_sequencia
	and	a.nr_prescricao		= p.nr_prescricao
	and    	f.cd_dominio         = 1226
	and	coalesce(somente_numero(f.vl_dominio),0) >=40
	and	((d.nr_prescricao = nr_codigo_p and ie_codigo_p = 'P') or (d.nr_atendimento = nr_codigo_p and ie_codigo_p = 'A'))
	and	(p.dt_liberacao IS NOT NULL AND p.dt_liberacao::text <> '')
	and	coalesce(a.nr_seq_exame::text, '') = '') alias17;


	return qt_pendentes_w;
elsif (upper(ie_opcao_p) = 'L') then

	select sum(qt)
	into STRICT	qt_liberados_w
	from (SELECT	count(*) qt
	from    valor_dominio f,
		exame_laboratorio e,
		prescr_procedimento d,
		prescr_medica a
	where   d.nr_prescricao      = a.nr_prescricao
	and    	(d.nr_seq_exame IS NOT NULL AND d.nr_seq_exame::text <> '')
	and    	d.nr_seq_exame       = e.nr_seq_exame
	and    	d.ie_status_atend    = f.vl_dominio
	and    	f.cd_dominio = 1030
	and	f.vl_dominio <> '40'
	and	((a.nr_prescricao = nr_codigo_p and ie_codigo_p = 'P') or (a.nr_atendimento = nr_codigo_p and ie_codigo_p = 'A'))
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	
union

	SELECT	count(*)
	from  	valor_dominio f,
		laudo_paciente e,
		procedimento_paciente d,
		prescr_procedimento a,
		prescr_medica p
	where   d.nr_prescricao      = e.nr_prescricao
	and	d.nr_prescricao      = a.nr_prescricao
	and	d.nr_sequencia_prescricao = a.nr_sequencia
	and    	d.nr_sequencia       = e.nr_seq_proc
	and    	a.ie_status_execucao = f.vl_dominio
	and 	d.nr_laudo	         = e.nr_sequencia
	and	a.nr_prescricao		= p.nr_prescricao
	and    	f.cd_dominio         = 1226
	and	coalesce(somente_numero(f.vl_dominio),0) < 40
	and	((d.nr_prescricao = nr_codigo_p and ie_codigo_p = 'P') or (d.nr_atendimento = nr_codigo_p and ie_codigo_p = 'A'))
	and	(p.dt_liberacao IS NOT NULL AND p.dt_liberacao::text <> '')
	and	coalesce(a.nr_seq_exame::text, '') = '') alias17;

	return qt_liberados_w;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_total_exames_pac (nr_codigo_p bigint, ie_codigo_p text, ie_opcao_p text) FROM PUBLIC;

