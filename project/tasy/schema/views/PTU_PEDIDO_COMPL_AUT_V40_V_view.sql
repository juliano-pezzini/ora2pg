-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW ptu_pedido_compl_aut_v40_v (cd_transacao, ie_tipo_registro, nr_sequencia, nr_seq_requisicao, nr_seq_guia, ie_tipo_cliente, cd_unimed_executora, cd_unimed_beneficiario, nr_seq_execucao, nr_seq_origem, cd_unimed, cd_usuario_plano, cd_unimed_prestador_req, nr_seq_prestador_req, nr_seq_prestador, cd_unimed_prestador, cd_especialidade, ds_observacao, ds_biometria, ie_tipo_tabela, cd_servico, qt_servico, ds_opme, vl_servico, ds_fim) AS select	00605				cd_transacao,
	1				ie_tipo_registro,
	nr_sequencia			nr_sequencia,
	nr_seq_requisicao		nr_seq_requisicao,
	nr_seq_guia			nr_seq_guia,
	CASE WHEN ie_tipo_cliente='U' THEN 'UNIMED' WHEN ie_tipo_cliente='P' THEN 'PORTAL' WHEN ie_tipo_cliente='R' THEN 'PRESTADOR' END  ie_tipo_cliente,
	cd_unimed_executora		cd_unimed_executora,
	cd_unimed_beneficiario 		cd_unimed_beneficiario,
	nr_seq_execucao			nr_seq_execucao,
	nr_seq_origem			nr_seq_origem,
	cd_unimed			cd_unimed,
	cd_usuario_plano		cd_usuario_plano,
	cd_unimed_prestador_req		cd_unimed_prestador_req,
	nr_seq_prestador_req		nr_seq_prestador_req,
	nr_seq_prestador		nr_seq_prestador,
	cd_unimed_prestador		cd_unimed_prestador,
	cd_especialidade		cd_especialidade,
	null				ds_observacao,
	null				ds_biometria,
	null				ie_tipo_tabela,
	null     			cd_servico,
	null   				qt_servico,
	null    			ds_opme,
	null	   			vl_servico,
	null				ds_fim
FROM	ptu_pedido_compl_aut

union

select	null				cd_transacao,
	2				ie_tipo_registro,
	nr_sequencia			nr_sequencia,
	nr_seq_requisicao		nr_seq_requisicao,
	nr_seq_guia			nr_seq_guia,
	null				ie_tipo_cliente,
	null				cd_unimed_executora,
	null 				cd_unimed_beneficiario,
	null				nr_seq_execucao,
	null				nr_seq_origem,
	null				cd_unimed,
	null				cd_usuario_plano,
	null				cd_unimed_prestador_req,
	null				nr_seq_prestador_req,
	null				nr_seq_prestador,
	null				cd_unimed_prestador,
	null				cd_especialidade,
	Elimina_Acentuacao(substr(replace(replace(ds_observacao,chr(13),''),chr(10),''),1,4000)) ds_observacao,
	Elimina_Acentuacao(ds_biometria) ds_biometria,
	null				ie_tipo_tabela,
	null     			cd_servico,
	null   				qt_servico,
	null    			ds_opme,
	null	   			vl_servico,
	null				ds_fim
from	ptu_pedido_compl_aut

union

select	null				cd_transacao,
	4				ie_tipo_registro,
	nr_seq_pedido			nr_sequencia,
	nr_seq_requisicao		nr_seq_requisicao,
	nr_seq_guia			nr_seq_guia,
	null				ie_tipo_cliente,
	null				cd_unimed_executora,
	null 				cd_unimed_beneficiario,
	null				nr_seq_execucao,
	null				nr_seq_origem,
	null				cd_unimed,
	null				cd_usuario_plano,
	null				cd_unimed_prestador_req,
	null				nr_seq_prestador_req,
	null				nr_seq_prestador,
	null				cd_unimed_prestador,
	null				cd_especialidade,
	null				ds_observacao,
	null				ds_biometria,
	ie_tipo_tabela			ie_tipo_tabela,
	coalesce(cd_servico_conversao,cd_servico) cd_servico,
	qt_servico   			qt_servico,
	Elimina_Acentuacao(ds_opme)	ds_opme,
	ptu_obter_valor_env_itens_scs(vl_servico) vl_servico,
	null				ds_fim
from	ptu_pedido_compl_aut_serv	b,
	ptu_pedido_compl_aut		a
where	b.nr_seq_pedido			= a.nr_sequencia

union

select	null				cd_transacao,
	5				ie_tipo_registro,
	nr_sequencia			nr_sequencia,
	nr_seq_requisicao		nr_seq_requisicao,
	nr_seq_guia			nr_seq_guia,
	null				ie_tipo_cliente,
	null				cd_unimed_executora,
	null 				cd_unimed_beneficiario,
	null				nr_seq_execucao,
	null				nr_seq_origem,
	null				cd_unimed,
	null				cd_usuario_plano,
	null				cd_unimed_prestador_req,
	null				nr_seq_prestador_req,
	null				nr_seq_prestador,
	null				cd_unimed_prestador,
	null				cd_especialidade,
	null				ds_observacao,
	null				ds_biometria,
	null				ie_tipo_tabela,
	null     			cd_servico,
	null   				qt_servico,
	null    			ds_opme,
	null	   			vl_servico,
	'FIM$'				ds_fim
from	ptu_pedido_compl_aut;

