-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ptu_aviso_pck.gera_sql_arq_a520_select ( dados_a520_p dados_lote_a520_t, alias_p alias_a520_t, dados_gerais_a520_p dados_gerais_a520_t, dados_bind_p INOUT sql_pck.t_dado_bind) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Gera o SQL, parte do select (campos + from + joins), para a carga inicial do A520.

		Neste caso e feito um agrupamento conforme o processo da geracao (manual ou webservice).
		
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

ds_sql_arquivo_w	varchar(32000);

-- variaveis para facilitar a leitura do sql dinamico

prot_w		alias_t%type;
cta_w		alias_t%type;
benef_w		alias_t%type;
cong_w		alias_t%type;

BEGIN


prot_w	:= alias_p.protocolo;
cta_w	:= alias_p.conta;
benef_w	:= alias_p.beneficiario;
cong_w	:= alias_p.congenere;


ds_sql_arquivo_w :=			'select	'||prot_w||'.nr_sequencia nr_seq_protocolo, ' 								|| pls_util_pck.enter_w||
					case	dados_a520_p.ie_processo
						when 'M' then '	null nr_seq_conta, '
						when 'W' then '	'||cta_w||'.nr_sequencia nr_seq_conta, '
					end 														|| pls_util_pck.enter_w||
					case	dados_a520_p.ie_processo
						when 'M' then '	null cd_guia_referencia, '
						when 'W' then '	'||cta_w||'.cd_guia cd_guia_referencia, '
					end														|| pls_util_pck.enter_w||
					'	'||benef_w||'.nr_seq_congenere nr_seq_congenere, '							|| pls_util_pck.enter_w ||
					'	pls_obter_versao_tiss ds_versao_tiss, '									|| pls_util_pck.enter_w ||
					'	nvl('||prot_w||'.dt_mes_competencia,'||prot_w||'.dt_recebimento) dt_transacao, '			|| pls_util_pck.enter_w ||
					'	pls_obter_dados_outorgante(:cd_estabelecimento,''C'') cd_cnpj_origem, '					|| pls_util_pck.enter_w ||
					'	lpad((select	max(c.cd_cooperativa) '									|| pls_util_pck.enter_w ||
					'	from	pls_outorgante	o, '										|| pls_util_pck.enter_w ||
					'		pls_congenere	c '										|| pls_util_pck.enter_w ||
					'	where	c.cd_cgc		= o.cd_cgc_outorgante '							|| pls_util_pck.enter_w ||
					'	and	o.cd_estabelecimento	= :cd_estabelecimento),4,''0'') cd_unimed_origem, '			|| pls_util_pck.enter_w ||
					'	pls_obter_dados_outorgante(:cd_estabelecimento,''ANS'') cd_registro_ans_orig, '				|| pls_util_pck.enter_w ||
					'	'||cong_w||'.cd_cgc cd_cnpj_destino, '									|| pls_util_pck.enter_w ||
					'	lpad('||cong_w||'.cd_cooperativa,4,''0'') cd_unimed_destino, '						|| pls_util_pck.enter_w ||
					'	'||cong_w||'.cd_ans cd_registro_ans_dest, '								|| pls_util_pck.enter_w ||
					'	substr(nvl('||prot_w||'.nr_protocolo_prestador,to_char('||prot_w||'.nr_sequencia)),1,12) nr_lote, '	|| pls_util_pck.enter_w ||
					'	'||prot_w||'.nr_seq_prestador, '									|| pls_util_pck.enter_w ||
					'	null nr_seq_segurado, '											|| pls_util_pck.enter_w ||
					'	'||prot_w||'.dt_mes_competencia '									|| pls_util_pck.enter_w ||
					'from	pls_protocolo_conta '||prot_w||', '									|| pls_util_pck.enter_w ||
					case	dados_a520_p.ie_geracao_aviso_cobr
						when 'PO' then '	pls_conta_pos_cab_v '
						when 'PP' then '	pls_conta '
						when 'PA' then '	pls_conta '
					end ||cta_w||',' 												|| pls_util_pck.enter_w ||
					'	pls_segurado '||benef_w||', '										|| pls_util_pck.enter_w ||
					'	pls_congenere '||cong_w||' '										|| pls_util_pck.enter_w ||
					'where	'||prot_w||'.nr_sequencia	= '||cta_w||'.nr_seq_protocolo '					|| pls_util_pck.enter_w ||
					'and	'||benef_w||'.nr_sequencia	= '||cta_w||'.nr_seq_segurado '						|| pls_util_pck.enter_w ||
					'and	'||cong_w||'.nr_sequencia	= '||benef_w||'.nr_seq_congenere '					|| pls_util_pck.enter_w ||
					'and	'||cong_w||'.ie_tipo_congenere = ''CO'' '								|| pls_util_pck.enter_w ||
					'and	nvl('||cong_w||'.ie_tipo_exportacao,''TXT'') = ''TXT'' ' 						|| pls_util_pck.enter_w ||
					'and	not exists	(select	1 '										|| pls_util_pck.enter_w ||
					'			from	ptu_aviso_conta ac '								|| pls_util_pck.enter_w ||
					'			where	ac.nr_seq_conta	= '||cta_w||'.nr_sequencia) '					|| pls_util_pck.enter_w ||
					'and	not exists	(select 1 '										|| pls_util_pck.enter_w ||
					'			from	pls_congenere oc '								|| pls_util_pck.enter_w ||
					'			where	oc.nr_sequencia = '||benef_w||'.nr_seq_ops_congenere '				|| pls_util_pck.enter_w ||
					'			and	oc.ie_tipo_congenere != ''CO'') '						|| pls_util_pck.enter_w;
					dados_bind_p := sql_pck.bind_variable(':cd_estabelecimento', dados_a520_p.cd_estabelecimento, dados_bind_p);

		
-- carrega os filtros oriundos das regras

ds_sql_arquivo_w||dados_bind_p := ptu_aviso_pck.gera_sql_a520_where(dados_a520_p, alias_p, 'N', 'N', dados_gerais_a520_p, dados_bind_p);
			
-- monta o agrupamento 

ds_sql_arquivo_w := ds_sql_arquivo_w||		'group by '												|| pls_util_pck.enter_w ||
						'	'||prot_w||'.dt_recebimento, '									|| pls_util_pck.enter_w ||
						'	'||prot_w||'.nr_sequencia, '									|| pls_util_pck.enter_w ||
						'	'||prot_w||'.cd_versao_tiss, '									|| pls_util_pck.enter_w ||
						'	'||benef_w||'.nr_seq_congenere, '								|| pls_util_pck.enter_w ||
						'	'||cong_w||'.cd_cooperativa, '									|| pls_util_pck.enter_w ||
						'	'||cong_w||'.cd_ans, '										|| pls_util_pck.enter_w ||
						'	'||cong_w||'.cd_cgc, '										|| pls_util_pck.enter_w ||
						'	'||prot_w||'.nr_protocolo_prestador, '								|| pls_util_pck.enter_w;
if (dados_a520_p.ie_processo = 'W') then

	ds_sql_arquivo_w := ds_sql_arquivo_w||	'	'||cta_w||'.nr_sequencia, '									|| pls_util_pck.enter_w ||
						'	'||cta_w||'.cd_guia, '										|| pls_util_pck.enter_w;						
end if;


ds_sql_arquivo_w := ds_sql_arquivo_w||		'	'||prot_w||'.nr_seq_prestador, '								|| pls_util_pck.enter_w;


if (dados_a520_p.ie_processo = 'W') then

	ds_sql_arquivo_w := ds_sql_arquivo_w||	'	'||benef_w||'.nr_sequencia, '									|| pls_util_pck.enter_w;
end if;

ds_sql_arquivo_w := ds_sql_arquivo_w||		'	'||prot_w||'.dt_mes_competencia ';


return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ptu_aviso_pck.gera_sql_arq_a520_select ( dados_a520_p dados_lote_a520_t, alias_p alias_a520_t, dados_gerais_a520_p dados_gerais_a520_t, dados_bind_p INOUT sql_pck.t_dado_bind) FROM PUBLIC;