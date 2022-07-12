-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW ptu_consulta_prestador_v40_v (ie_tipo_registro, cd_transacao, nr_sequencia, nr_seq_guia, nr_seq_requisicao, ie_tipo_cliente, cd_unimed_executora, cd_unimed_beneficiario, nr_seq_execucao, nm_prestador, cd_cgc_cpf, sg_cons_profissional, nr_cons_profissional, uf_cons_profissional, ds_fim) AS select	1				ie_tipo_registro,
	00418				cd_transacao,
	nr_sequencia			nr_sequencia,
	nr_seq_guia			nr_seq_guia,
	nr_seq_requisicao		nr_seq_requisicao,
	CASE WHEN ie_tipo_cliente='U' THEN 'UNIMED' WHEN ie_tipo_cliente='P' THEN 'PORTAL' WHEN ie_tipo_cliente='R' THEN 'PRESTADOR' END  ie_tipo_cliente,
	cd_unimed_executora 		cd_unimed_executora,
	cd_unimed_beneficiario		cd_unimed_beneficiario,
	nr_seq_execucao			nr_seq_execucao,
	Elimina_Acentuacao(nm_prestador) nm_prestador,
	cd_cgc_cpf			cd_cgc_cpf,
	sg_cons_profissional		sg_cons_profissional,
	nr_cons_profissional		nr_cons_profissional,
	uf_cons_profissional		uf_cons_profissional,
	null				ds_fim
FROM	ptu_consulta_prestador

union

select	2				ie_tipo_registro,
	null				cd_transacao,
	nr_sequencia			nr_sequencia,
	nr_seq_guia			nr_seq_guia,
	nr_seq_requisicao		nr_seq_requisicao,
	null 				ie_tipo_cliente,
	null 				cd_unimed_executora,
	null				cd_unimed_beneficiario,
	null				nr_seq_execucao,
	null				nm_prestador,
	null				cd_cgc_cpf,
	null				sg_cons_profissional,
	null				nr_cons_profissional,
	null				uf_cons_profissional,
	'FIM$'				ds_fim
from	ptu_consulta_prestador;

