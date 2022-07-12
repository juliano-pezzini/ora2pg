-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-- Verifica a regra v_lida a ser aplicada na importacao



CREATE OR REPLACE FUNCTION pls_conv_xml_cta_pck.obter_regra_profissional ( ie_tipo_guia_p pls_protocolo_conta_imp.ie_tipo_guia%type, nr_seq_tipo_atendimento_p pls_conta_imp.nr_seq_tipo_atend_conv%type, ie_tipo_profissional_p text, ie_tipo_consistencia_p out pls_regra_medico_imp.ie_tipo_consistencia%type, ie_zero_esquerda_p out pls_regra_medico_imp.ie_zero_esquerda%type, ie_vincula_cbo_xml_p out pls_regra_medico_imp.ie_vincula_cbo_xml%type, ie_consiste_nome_p out pls_regra_medico_imp.ie_consiste_nome%type, ie_regime_atendimento_p pls_conta.ie_regime_atendimento%type, ie_saude_ocupacional_p pls_conta.ie_saude_ocupacional%type) AS $body$
DECLARE


nr_seq_regra_w			pls_regra_medico_imp.nr_sequencia%type;
tb_nr_seq_regra_w		pls_util_cta_pck.t_number_table;
tb_ie_tipo_consistencia_w	pls_util_cta_pck.t_number_table;
tb_ie_zero_esquerda_w		pls_util_cta_pck.t_varchar2_table_10;
tb_ie_vincula_cbo_xml_w		pls_util_cta_pck.t_varchar2_table_10;
tb_consiste_nome_w		pls_util_cta_pck.t_varchar2_table_10;
nr_ultimo_indice_w		integer;

C01 CURSOR(	ie_tipo_guia_pc			pls_regra_medico_imp.ie_tipo_guia%type,
		nr_seq_tipo_atendimento_pc 	pls_regra_medico_imp.nr_seq_tipo_atendimento%type,
		ie_tipo_profissional_pc 	pls_regra_medico_imp.ie_tipo_medico%type,
		ie_regime_atendimento_pc  	pls_regra_medico_imp.ie_regime_atendimento%type,
		ie_saude_ocupacional_pc   	pls_regra_medico_imp.ie_saude_ocupacional%type) FOR
	SELECT	a.nr_sequencia,
		a.ie_tipo_consistencia,
		coalesce(a.ie_zero_esquerda, 'N') ie_zero_esquerda,
		coalesce(a.ie_vincula_cbo_xml, 'N') ie_vincula_cbo_xml,
		coalesce(a.ie_consiste_nome,'N') ie_consiste_nome
	from 	pls_regra_medico_imp a
	where	((a.ie_tipo_guia = ie_tipo_guia_pc) or (coalesce(a.ie_tipo_guia::text, '') = ''))
	and	((a.nr_seq_tipo_atendimento = nr_seq_tipo_atendimento_pc) or (coalesce(a.nr_seq_tipo_atendimento::text, '') = ''))
	and	((a.ie_regime_atendimento = ie_regime_atendimento_pc) or (coalesce(a.ie_regime_atendimento::text, '') = ''))
	and	((a.ie_saude_ocupacional = ie_saude_ocupacional_pc) or (coalesce(a.ie_saude_ocupacional::text, '') = ''))
	and	a.ie_tipo_medico = ie_tipo_profissional_pc
	and	a.ie_situacao = 'A'
	order by coalesce(a.nr_seq_tipo_atendimento, 0),
		 coalesce(a.ie_tipo_guia, 0);


BEGIN
nr_seq_regra_w := null;

open C01(ie_tipo_guia_p, nr_seq_tipo_atendimento_p, ie_tipo_profissional_p,
			ie_regime_atendimento_p, ie_saude_ocupacional_p);
loop
	fetch C01 bulk collect into 	tb_nr_seq_regra_w, tb_ie_tipo_consistencia_w,
					tb_ie_zero_esquerda_w, tb_ie_vincula_cbo_xml_w,
					tb_consiste_nome_w
	limit pls_util_pck.qt_registro_transacao_w;
	exit when tb_nr_seq_regra_w.count = 0;
	
	-- retorna sempre o _ltimo registro do select

	-- ele _ o registro mais espec_fico

	-- retira um porque a indexacao inicia com zero

	nr_ultimo_indice_w := (tb_nr_seq_regra_w.count);
	
	nr_seq_regra_w := tb_nr_seq_regra_w(nr_ultimo_indice_w);
	ie_tipo_consistencia_p := tb_ie_tipo_consistencia_w(nr_ultimo_indice_w);
	ie_zero_esquerda_p := tb_ie_zero_esquerda_w(nr_ultimo_indice_w);	
	ie_vincula_cbo_xml_p := tb_ie_vincula_cbo_xml_w(nr_ultimo_indice_w);
	ie_consiste_nome_p   := tb_consiste_nome_w(nr_ultimo_indice_w);
end loop;
close C01;

return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_conv_xml_cta_pck.obter_regra_profissional ( ie_tipo_guia_p pls_protocolo_conta_imp.ie_tipo_guia%type, nr_seq_tipo_atendimento_p pls_conta_imp.nr_seq_tipo_atend_conv%type, ie_tipo_profissional_p text, ie_tipo_consistencia_p out pls_regra_medico_imp.ie_tipo_consistencia%type, ie_zero_esquerda_p out pls_regra_medico_imp.ie_zero_esquerda%type, ie_vincula_cbo_xml_p out pls_regra_medico_imp.ie_vincula_cbo_xml%type, ie_consiste_nome_p out pls_regra_medico_imp.ie_consiste_nome%type, ie_regime_atendimento_p pls_conta.ie_regime_atendimento%type, ie_saude_ocupacional_p pls_conta.ie_saude_ocupacional%type) FROM PUBLIC;
