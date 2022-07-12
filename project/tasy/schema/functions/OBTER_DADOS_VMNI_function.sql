-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_vmni ( dt_inicio_p timestamp, dt_final_p timestamp, cd_setor_Atendimento_p bigint, nr_seq_turno_p bigint, ds_unidade_p text) RETURNS bigint AS $body$
DECLARE

 
Qt_reg_w		double precision;
dt_monitorizacao_w	timestamp;
	

BEGIN 
 
if (dt_final_p IS NOT NULL AND dt_final_p::text <> '') then 
 
	Select 	count(*) 
	into STRICT	Qt_reg_w 
	from	qua_evento_paciente a, 
		qua_tipo_evento b, 
		qua_evento c 
	where 	b.ie_tipo_evento = 'LPF' 
	and	b.nr_sequencia = c.nr_Seq_tipo 
	and 	a.nr_Seq_evento = c.nr_sequencia 
	and	trunc(a.dt_evento) between trunc(dt_inicio_p) and trunc(dt_final_p) 
	and	a.cd_setor_atendimento = coalesce(cd_setor_Atendimento_p,a.cd_setor_atendimento) 
	and	Obter_Turno_Atendimento(a.dt_evento,obter_dados_Atendimento(a.nr_atendimento, 'EST'),'C') = coalesce(nr_seq_turno_p,Obter_Turno_Atendimento(a.dt_evento,obter_dados_Atendimento(a.nr_atendimento, 'EST'),'C')) 
	and	obter_unidade_atendimento(a.nr_atendimento,'A','U') = coalesce(ds_unidade_p,obter_unidade_atendimento(a.nr_atendimento,'A','U')) 
	and	exists (	SELECT 	1				 
				from	atendimento_monit_resp x 
				where	coalesce(x.dt_inativacao::text, '') = '' 
				and	x.ie_respiracao = 'VMNI' 
				and	x.nr_atendimento = a.nr_atendimento 
				and	trunc(dt_monitorizacao) between trunc(dt_inicio_p) and trunc(dt_final_p));
				 
else 
	 
	Select 	count(*) 
	into STRICT	Qt_reg_w 
	from	qua_evento_paciente a, 
		qua_tipo_evento b, 
		qua_evento c 
	where 	b.ie_tipo_evento = 'LPF' 
	and	b.nr_sequencia = c.nr_Seq_tipo 
	and 	a.nr_Seq_evento = c.nr_sequencia 
	and	trunc(a.dt_evento) =(dt_inicio_p) 
	and	a.cd_setor_atendimento = coalesce(cd_setor_Atendimento_p,a.cd_setor_atendimento) 
	and	Obter_Turno_Atendimento(a.dt_evento,obter_dados_Atendimento(a.nr_atendimento, 'EST'),'C') = coalesce(nr_seq_turno_p,Obter_Turno_Atendimento(a.dt_evento,obter_dados_Atendimento(a.nr_atendimento, 'EST'),'C')) 
	and	obter_unidade_atendimento(a.nr_atendimento,'A','U') = coalesce(ds_unidade_p,obter_unidade_atendimento(a.nr_atendimento,'A','U')) 
	and	exists (	SELECT 	1				 
				from	atendimento_monit_resp x 
				where	coalesce(x.dt_inativacao::text, '') = '' 
				and	x.ie_respiracao = 'VMNI' 
				and	x.nr_atendimento = a.nr_atendimento 
				and	trunc(dt_monitorizacao) = trunc(dt_inicio_p));
 
end if;	
 
return	Qt_reg_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_vmni ( dt_inicio_p timestamp, dt_final_p timestamp, cd_setor_Atendimento_p bigint, nr_seq_turno_p bigint, ds_unidade_p text) FROM PUBLIC;
