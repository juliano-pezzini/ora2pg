-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE conciliar_integracao_ret_pck.popular_conta_guia () AS $body$
DECLARE


i 			integer;
j 			integer;

nr_seq_guia_w		integer;
conta_anterior_w	bigint;

current_setting('conciliar_integracao_ret_pck.nr_seq_dem_ret_prot_w')::imp_dem_retorno_prot.nr_sequencia%type	imp_dem_retorno_prot.nr_sequencia%type;
current_setting('conciliar_integracao_ret_pck.nr_seq_protocolo_w')::imp_dem_retorno_prot.nr_seq_protocolo%type	protocolo_convenio.nr_seq_protocolo%type;

ccontas CURSOR FOR
SELECT	c.nr_interno_conta,
	g.cd_autorizacao,
	g.vl_guia,
	cg.cd_senha,
	cg.nr_doc_convenio,
	obter_saldo_conpaci(g.nr_interno_conta, g.cd_autorizacao)vl_saldo,
	g.vl_participante
from	conta_paciente c,
	conta_paciente_guia g,
	atendimento_paciente a,
	atend_categoria_convenio cg
where	c.nr_interno_conta = g.nr_interno_conta
and	a.nr_atendimento   = c.nr_atendimento
and	cg.nr_seq_interno  = obter_atecaco_atendimento(a.nr_atendimento)
and	c.nr_seq_protocolo = current_setting('conciliar_integracao_ret_pck.nr_seq_protocolo_w')::imp_dem_retorno_prot.nr_seq_protocolo%type
order by c.nr_interno_conta;

cconta_guia_w ccontas%rowtype;


BEGIN
j := 0;
i := 0;

if current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v.count > 0 then
	for i in current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v.first .. current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v.last loop

		PERFORM set_config('conciliar_integracao_ret_pck.nr_seq_dem_ret_prot_w', current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].nr_sequencia, false);
		PERFORM set_config('conciliar_integracao_ret_pck.nr_seq_protocolo_w', current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].nr_seq_protocolo, false);	

		nr_seq_guia_w := 1;
		conta_anterior_w := 0;

		for cconta_guia_w in ccontas loop

			if (conta_anterior_w = cconta_guia_w.nr_interno_conta) then
				nr_seq_guia_w := nr_seq_guia_w + 1;
			else
				nr_seq_guia_w := 1;
			end if;

			current_setting('conciliar_integracao_ret_pck.campos_conta_w')::campos_conta_v[j].nr_interno_conta		:= cconta_guia_w.nr_interno_conta;
			current_setting('conciliar_integracao_ret_pck.campos_conta_w')::campos_conta_v[j].cd_autorizacao		:= cconta_guia_w.cd_autorizacao;
			current_setting('conciliar_integracao_ret_pck.campos_conta_w')::campos_conta_v[j].vl_guia			:= cconta_guia_w.vl_guia;
			current_setting('conciliar_integracao_ret_pck.campos_conta_w')::campos_conta_v[j].vl_participante		:= cconta_guia_w.vl_participante;
			current_setting('conciliar_integracao_ret_pck.campos_conta_w')::campos_conta_v[j].nr_seq_ret_item		:= 0;
			current_setting('conciliar_integracao_ret_pck.campos_conta_w')::campos_conta_v[j].vl_saldo			:= cconta_guia_w.vl_saldo;
			current_setting('conciliar_integracao_ret_pck.campos_conta_w')::campos_conta_v[j].cd_senha			:= cconta_guia_w.cd_senha;
			current_setting('conciliar_integracao_ret_pck.campos_conta_w')::campos_conta_v[j].nr_doc_convenio		:= cconta_guia_w.nr_doc_convenio;
			current_setting('conciliar_integracao_ret_pck.campos_conta_w')::campos_conta_v[j].seq_guia			:= nr_seq_guia_w;
			current_setting('conciliar_integracao_ret_pck.campos_conta_w')::campos_conta_v[j].ie_conciliado			:= 'N';

			conta_anterior_w				:= cconta_guia_w.nr_interno_conta;

			j := j + 1;

		end loop;

	end loop;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE conciliar_integracao_ret_pck.popular_conta_guia () FROM PUBLIC;
