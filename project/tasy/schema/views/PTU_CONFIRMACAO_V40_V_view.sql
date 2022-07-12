-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW ptu_confirmacao_v40_v (cd_transacao, ie_tipo_registro, nr_sequencia, nr_seq_requisicao, nr_seq_guia, ie_tipo_cliente, cd_unimed_executora, cd_unimed_beneficiario, nr_seq_execucao, nr_seq_origem, ie_tipo_identificador, ie_tipo_resposta, ds_fim) AS select	00309				cd_transacao,
	1				ie_tipo_registro,
	nr_sequencia			nr_sequencia,
	nr_seq_requisicao		nr_seq_requisicao,
	nr_seq_guia			nr_seq_guia,
	CASE WHEN ie_tipo_cliente='U' THEN 'UNIMED' WHEN ie_tipo_cliente='P' THEN 'PORTAL' WHEN ie_tipo_cliente='R' THEN 'PRESTADOR' END  ie_tipo_cliente,
	cd_unimed_executora 		cd_unimed_executora,
	cd_unimed_beneficiario		cd_unimed_beneficiario,
	nr_seq_execucao   		nr_seq_execucao,
	nr_seq_origem    		nr_seq_origem,
	ie_tipo_identificador		ie_tipo_identificador,
	ie_tipo_resposta		ie_tipo_resposta,
	null				ds_fim
FROM	ptu_confirmacao
where	ie_enviado	= 'N'

union

select	null				cd_transacao,
	2				ie_tipo_registro,
	nr_sequencia			nr_sequencia,
	nr_seq_requisicao		nr_seq_requisicao,
	nr_seq_guia			nr_seq_guia,
	null     	   		ie_tipo_cliente,
	null 				cd_unimed_executora,
	cd_unimed_beneficiario		cd_unimed_beneficiario,
	nr_seq_execucao	   		nr_seq_execucao,
	nr_seq_origem	 		nr_seq_origem,
	null				ie_tipo_identificador,
	ie_tipo_resposta		ie_tipo_resposta,
	'FIM$'				ds_fim
from	ptu_confirmacao
where	ie_enviado	= 'N';

