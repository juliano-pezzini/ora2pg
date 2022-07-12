-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_ret_hist_periodo (cd_convenio_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, ie_acao_p bigint, nr_seq_hist_p bigint, cd_estabelecimento_p bigint) RETURNS bigint AS $body$
DECLARE

 
/* 
 0 - Não Auditado 
 1 - Recebimento 
 2 - Reapresentação 
 3 - Glosa Devida 
 4 - Glosa Indevida 
 5 - Adequação a menor 
 6 - Adequação a maior 
*/
 
 
vl_retorno_w	double precision;


BEGIN 
 
select	coalesce(sum(a.vl_historico),0) 
into STRICT	vl_retorno_w 
from	conta_paciente d, 
	hist_audit_conta_paciente c, 
	conta_paciente_ret_hist a, 
	conta_paciente_retorno b 
where	b.cd_convenio		= cd_convenio_p 
and	b.nr_sequencia		= a.nr_seq_conpaci_ret 
and	a.dt_historico		between dt_inicial_p and trunc(dt_final_p) + 89399/89400 
and	a.nr_seq_hist_audit	= c.nr_sequencia 
and (coalesce(ie_acao_p,0) = 0 or c.ie_acao = ie_acao_p) 
and (coalesce(nr_seq_hist_p,0) = 0 or c.nr_sequencia = nr_seq_hist_p) 
and	b.nr_interno_conta		= d.nr_interno_conta 
and	d.cd_estabelecimento	= cd_estabelecimento_p;
 
return	vl_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_ret_hist_periodo (cd_convenio_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, ie_acao_p bigint, nr_seq_hist_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
