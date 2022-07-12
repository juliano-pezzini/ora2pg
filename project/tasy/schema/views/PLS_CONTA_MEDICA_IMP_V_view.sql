-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_conta_medica_imp_v (ie_evento, cd_guia, cd_guia_referencia, nr_seq_tipo_acomodacao, nr_seq_protocolo, nr_seq_segurado, ie_tipo_guia, nr_seq_prestador, cd_medico_executor) AS select	'CC' ie_evento,
	cd_guia,
	cd_guia_referencia,
	nr_seq_tipo_acomodacao,
	nr_seq_protocolo,
	nr_seq_segurado,
	coalesce(ie_tipo_guia,'X') ie_tipo_guia,
	coalesce(nr_seq_prestador_exec,0) nr_seq_prestador,
	cd_medico_executor
FROM	pls_conta

union

select	'IA' ie_evento,
	cd_guia_imp,
	cd_guia_solic_imp,
	pls_obter_tipo_acomod_tiss(cd_tipo_acomodacao_imp) nr_seq_tipo_acomodacao,
	nr_seq_protocolo,
	(elimina_caracteres_especiais(cd_usuario_plano_imp))::numeric  nr_seq_segurado,
	coalesce(ie_tipo_guia,'X') ie_tipo_guia,
	(coalesce(nr_seq_prestador_exec_imp, coalesce(cd_cgc_executor_imp, cd_cpf_executor_imp)))::numeric  nr_seq_prestador,
	'' cd_medico_executor
from	pls_conta;

