-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW ptu_pedido_status_v50_v (cd_transacao, ie_tipo_registro, nr_sequencia, nr_seq_guia, nr_seq_requisicao, ie_tipo_cliente, cd_unimed_executora, cd_unimed_beneficiario, nr_transacao_uni_exec, nr_versao, ds_fim) AS select	00360				cd_transacao,
	1				ie_tipo_registro,
	nr_sequencia			nr_sequencia,
	nr_seq_guia			nr_seq_guia,
	nr_seq_requisicao		nr_seq_requisicao,
	CASE WHEN ie_tipo_cliente='U' THEN 'UNIMED' WHEN ie_tipo_cliente='P' THEN 'PORTAL' WHEN ie_tipo_cliente='R' THEN 'PRESTADOR' END  ie_tipo_cliente,
	cd_unimed_executora		cd_unimed_executora,
	cd_unimed_beneficiario		cd_unimed_beneficiario,
	nr_transacao_uni_exec		nr_transacao_uni_exec,
	pls_obter_versao_scs		nr_versao,
	null				ds_fim
FROM	ptu_pedido_status

union

select	null				cd_transacao,
	2				ie_tipo_registro,
	null				nr_sequencia,
	nr_seq_guia			nr_seq_guia,
	nr_seq_requisicao		nr_seq_requisicao,
	null				ie_tipo_cliente,
	null				cd_unimed_executora,
	null				cd_unimed_beneficiario,
	nr_transacao_uni_exec		nr_transacao_uni_exec,
	null				nr_versao,
	'FIM$'				ds_fim
from	ptu_pedido_status;

