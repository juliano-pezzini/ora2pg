-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_reap_hist ( nr_sequencia_p bigint) RETURNS timestamp AS $body$
DECLARE

 
qt_dias_reapresentacao_w	smallint;
cd_convenio_w			integer;
dt_historico_w			timestamp;
dt_resultado_w			timestamp;
cd_estabelecimento_w		bigint;
qt_dias_reap_estab_w		bigint;


BEGIN 
 
cd_estabelecimento_w	:= wheb_usuario_pck.get_cd_estabelecimento;
 
select	b.dt_historico 
into STRICT	dt_historico_w 
from	hist_audit_conta_paciente a, 
	conta_paciente_ret_hist b 
where	a.nr_sequencia		= b.nr_seq_hist_audit 
and	a.ie_acao		= 1 
and	b.nr_sequencia		= nr_sequencia_p;
 
dt_resultado_w	:= null;
 
if (dt_historico_w IS NOT NULL AND dt_historico_w::text <> '') then 
 
	select	a.cd_convenio 
	into STRICT	cd_convenio_w 
	from	conta_paciente_retorno a, 
		conta_paciente_ret_hist b 
	where	a.nr_sequencia	= b.nr_seq_conpaci_ret 
	and	b.nr_sequencia	= nr_sequencia_p;
	 
	select	coalesce(max(a.qt_dias_reapre),0) 
	into STRICT	qt_dias_reap_estab_w 
	from	convenio_estabelecimento a 
	where	a.cd_convenio		= cd_convenio_w 
	and	a.cd_estabelecimento	= cd_estabelecimento_w;
 
	select	coalesce(coalesce(qt_dias_reap_estab_w,qt_dias_reapresentacao),0) 
	into STRICT	qt_dias_reapresentacao_w 
	from	convenio 
	where	cd_convenio	= cd_convenio_w;
 
	dt_resultado_w	:= dt_historico_w + qt_dias_reapresentacao_w;
end if;
 
return	dt_resultado_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_reap_hist ( nr_sequencia_p bigint) FROM PUBLIC;
