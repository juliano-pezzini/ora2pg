-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW ptu_resp_consulta_benef_v40_v (ie_tipo_registro, cd_transacao, nr_sequencia, nr_seq_execucao, nr_seq_origem, ie_tipo_cliente, cd_unimed_executora, cd_unimed_beneficiario, cd_mens_erro, ie_confirmacao, nm_beneficiario, dt_nascimento, nm_empresa_abrev, cd_unimed, cd_usuario_plano, nm_compl_benef, nm_plano, nm_tipo_acomodacao, ie_abrangencia, cd_local_cobranca, dt_validade_carteira, dt_inclusao_benef, dt_exclusao_benef, ie_sexo, nr_via_cartao, ds_fim) AS select	1				ie_tipo_registro,
	00413				cd_transacao,
	nr_sequencia			nr_sequencia,
	nr_seq_execucao 		nr_seq_execucao,
	nr_seq_origem 			nr_seq_origem,
	CASE WHEN ie_tipo_cliente='U' THEN 'UNIMED' WHEN ie_tipo_cliente='P' THEN 'PORTAL' WHEN ie_tipo_cliente='R' THEN 'PRESTADOR' END  ie_tipo_cliente,
	cd_unimed_executora 		cd_unimed_executora,
	cd_unimed_beneficiario 		cd_unimed_beneficiario,
	ptu_obter_inconsist_trans_v40(null,null,nr_seq_origem,'00413',1,null,null) cd_mens_erro,
	ie_confirmacao 			ie_confirmacao,
	null		 		nm_beneficiario,
	null 				dt_nascimento,
	null				nm_empresa_abrev,
	null	 			cd_unimed,
	null		 		cd_usuario_plano,
	null 				nm_compl_benef,
	null 				nm_plano,
	null 				nm_tipo_acomodacao,
	null 				ie_abrangencia,
	null				cd_local_cobranca,
	null 				dt_validade_carteira,
	null 				dt_inclusao_benef,
	null 				dt_exclusao_benef,
	null 				ie_sexo,
	null 				nr_via_cartao,
	null				ds_fim
FROM	ptu_resp_consulta_benef

union

select	2				ie_tipo_registro,
	null				cd_transacao,
	nr_seq_resp_benef		nr_sequencia,
	nr_seq_execucao 		nr_seq_execucao,
	nr_seq_origem 			nr_seq_origem,
	null 				ie_tipo_cliente,
	null 				cd_unimed_executora,
	null 				cd_unimed_beneficiario,
	null 				ie_confirmacao,
	null				cd_mens_erro,
	Elimina_Acentuacao(nm_beneficiario) nm_beneficiario,
	dt_nascimento 			dt_nascimento,
	Elimina_Acentuacao(nm_empresa_abrev) nm_empresa_abrev,
	cd_unimed 			cd_unimed,
	cd_usuario_plano 		cd_usuario_plano,
	Elimina_Acentuacao(nm_compl_benef) nm_compl_benef,
	Elimina_Acentuacao(nm_plano)	nm_plano,
	Elimina_Acentuacao(nm_tipo_acomodacao) nm_tipo_acomodacao,
	ie_abrangencia 			ie_abrangencia,
	cd_local_cobranca		cd_local_cobranca,
	dt_validade_carteira 		dt_validade_carteira,
	dt_inclusao_benef 		dt_inclusao_benef,
	dt_exclusao_benef 		dt_exclusao_benef,
	ie_sexo 			ie_sexo,
	nr_via_cartao 			nr_via_cartao,
	null				ds_fim
from	ptu_resp_nomes_benef		b,
	ptu_resp_consulta_benef		a
where	a.nr_sequencia	= b.nr_seq_resp_benef

union

select	3				ie_tipo_registro,
	null				cd_transacao,
	null				nr_sequencia,
	null 				nr_seq_execucao,
	nr_seq_origem			nr_seq_origem,
	null 				ie_tipo_cliente,
	null 				cd_unimed_executora,
	null 				cd_unimed_beneficiario,
	null 				ie_confirmacao,
	null				cd_mens_erro,
	null		 		nm_beneficiario,
	null 				dt_nascimento,
	null				nm_empresa_abrev,
	null	 			cd_unimed,
	null		 		cd_usuario_plano,
	null 				nm_compl_benef,
	null 				nm_plano,
	null 				nm_tipo_acomodacao,
	null 				ie_abrangencia,
	null				cd_local_cobranca,
	null 				dt_validade_carteira,
	null 				dt_inclusao_benef,
	null 				dt_exclusao_benef,
	null 				ie_sexo,
	null 				nr_via_cartao,
	'FIM$'				ds_fim
from	ptu_resp_consulta_benef;
