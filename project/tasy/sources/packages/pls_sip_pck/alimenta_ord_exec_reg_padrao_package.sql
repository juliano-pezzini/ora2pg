-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_sip_pck.alimenta_ord_exec_reg_padrao () AS $body$
DECLARE


nr_ordem_aplic_regra_w	sip_item_assist_regra_nv.nr_ordem_aplic_regra%type;

c01 CURSOR(	nr_seq_item_p		sip_item_assistencial.nr_sequencia%type) FOR
	-- dar prioridade para procedimento, grupo, especialidade, area e tipo de guia

	-- tras todas as regras dos itens filhos do pai principal

	SELECT	a.cd_area_procedimento, a.cd_especialidade, a.cd_grupo_proc,
		a.ie_origem_proced, a.cd_procedimento, a.nr_seq_grupo_servico,
		a.ie_tipo_guia, a.nr_seq_prestador_exec, a.cd_cbo, a.nr_seq_cbo_saude,
		a.cd_doenca_cid, a.cd_categoria_cid, a.nr_seq_tipo_atendimento,
		a.nr_seq_clinica, a.ie_regime_internacao, a.ie_sexo,
		a.qt_idade_inicial, a.qt_idade_final, a.ie_unid_tempo_idade,
		a.ie_nascido_vivo, a.nr_sequencia seq_regra, a.ie_materiais,
		a.ie_considerar_conta, b.nr_sequencia sequ_item,  a.qt_tempo_atend_inicial,
		a.qt_tempo_atend_final,	a.ie_unid_tempo_atend, a.ie_regime_atendimento,
		a.ie_saude_ocupacional
	from 	sip_item_assistencial b,
		sip_item_assist_regra_nv a
	where 	b.nr_sequencia		in (WITH RECURSIVE cte AS (
	SELECT nr_sequencia
						from  sip_item_assistencial WHERE nr_sequencia =  nr_seq_item_p
  UNION ALL
	SELECT nr_sequencia
						from  sip_item_assistencial JOIN cte c ON (c.prior nr_sequencia = nr_seq_superior)

) SELECT * FROM cte WHERE (coalesce(ie_permite_regra::text, '') = '' or ie_permite_regra = 'S');
)
	-- so busca as regras dos itens em que a mesma for permitida

	and (coalesce(b.ie_permite_regra::text, '') = '' or b.ie_permite_regra = 'S')
	and	a.nr_seq_item_assist	= b.nr_sequencia
	and 	a.ie_situacao 		= 'A'
	-- A ordenacao dos campos e feita respeitando a sequencia dos campos informados e a prioridade restritiva dos mesmos,

	-- Por exemplo, se uma regra tiver o tipo de guia informado, ela e mais restritiva que outra regra que tenha qualquer campo informado mais nao tenha o tipo de guia informado, pois ela esta sendo valida para todos

	-- os tipo de guia e nao apenas para um tipo especifico, Se os dois tipos de guia informados forem iguais, ai serao respeitados os campos por procedimento e os demais campos das caracterisiticas do atendimento.

	order	by coalesce(a.ie_tipo_guia, '99'),
		coalesce(a.ie_origem_proced, 9999999999),
		coalesce(a.cd_procedimento, 999999999999999),
		coalesce(a.cd_grupo_proc, 999999999999999),
		coalesce(a.cd_especialidade, 999999999999999),
		coalesce(a.cd_area_procedimento, 999999999999999),
		coalesce(a.nr_seq_grupo_servico, 9999999999),
		coalesce(a.nr_seq_clinica, 9999999999),
		coalesce(a.ie_regime_internacao, '9'),
		coalesce(a.nr_seq_tipo_atendimento, 9999999999),
		coalesce(a.nr_seq_prestador_exec, 9999999999),
		coalesce(a.cd_cbo, '999999999999999'),
		coalesce(a.nr_seq_cbo_saude, 9999999999),
		coalesce(a.cd_doenca_cid, '9999999999'),
		coalesce(a.cd_categoria_cid, '9999999999'),
		coalesce(a.ie_sexo, '9'),
		coalesce(a.qt_idade_inicial, 999),
		coalesce(a.qt_idade_final, 999),
		coalesce(a.ie_nascido_vivo, '9'),
		coalesce(a.ie_materiais, 'N') desc,
		coalesce(a.ie_unid_tempo_atend, '9'),
		coalesce(a.qt_tempo_atend_final, 999),
		coalesce(a.qt_tempo_atend_inicial, 999),
		coalesce(a.ie_regime_atendimento, '99'),
		coalesce(a.ie_saude_ocupacional, '9');

BEGIN
-- retorna todos os itens pais respeitando a ordenacao selecionada pelo cliente (sip_item_assistencial.ie_ordem_aplicacao_regra)

for r_c_item_pai_w in c_item_pai loop
	-- zera para cada item pai

	nr_ordem_aplic_regra_w := 1;

	-- retorna todas as regras dos itens filhos de acordo com a ordenacao sugerida pelo sistema

	for r_c01_w in c01(r_c_item_pai_w.nr_sequencia) loop
		
		update	sip_item_assist_regra_nv set
			nr_ordem_aplic_regra = nr_ordem_aplic_regra_w
		where	nr_sequencia = r_c01_w.seq_regra;
		commit;
		
		nr_ordem_aplic_regra_w := nr_ordem_aplic_regra_w + 1;
	end loop;
end loop;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_sip_pck.alimenta_ord_exec_reg_padrao () FROM PUBLIC;
