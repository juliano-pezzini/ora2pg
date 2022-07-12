-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fagf_obter_vl_fat_espec (dt_referencia_p text, ie_status_protocolo_p bigint, ie_complexidade_p text, ie_identificacao_aih_p text, cd_especialidade_p bigint) RETURNS bigint AS $body$
DECLARE

 
vl_retorno_w	double precision := 0;

BEGIN
 
select	sum(coalesce(y.vl_sadt,0)) + 
	sum(coalesce(w.vl_medico,0)) + 
	sum(coalesce(y.vl_matmed,0)) + 
	sum(coalesce(Obter_Valor_Participante(w.nr_sequencia),0)) 
into STRICT	vl_retorno_w 
FROM sus_valor_proc_paciente y, procedimento_paciente w, protocolo_convenio l, conta_paciente c
LEFT OUTER JOIN sus_aih_unif s ON (c.nr_interno_conta = s.nr_interno_conta)
WHERE w.nr_interno_conta = c.nr_interno_conta and w.nr_sequencia = y.nr_sequencia and coalesce(w.cd_motivo_exc_conta::text, '') = ''  and l.ie_status_protocolo = ie_status_protocolo_p and s.ie_complexidade = ie_complexidade_p and s.ie_identificacao_aih = ie_identificacao_aih_p and l.nr_seq_protocolo = c.nr_seq_protocolo and s.cd_especialidade_aih = cd_especialidade_p and to_char(l.dt_mesano_referencia, 'yyyymm') = dt_referencia_p;
 
return	coalesce(vl_retorno_w,0);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fagf_obter_vl_fat_espec (dt_referencia_p text, ie_status_protocolo_p bigint, ie_complexidade_p text, ie_identificacao_aih_p text, cd_especialidade_p bigint) FROM PUBLIC;
