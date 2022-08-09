-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_duplicar_grupo_servico ( nr_seq_grupo_p integer) AS $body$
DECLARE


nr_sequencia_w		bigint;


BEGIN
select 	nextval('pls_preco_grupo_servico_seq')
into STRICT 	nr_sequencia_w
;

insert into pls_preco_grupo_servico(nr_sequencia,
	cd_estabelecimento,
	ds_grupo,
	dt_atualizacao,
	dt_atualizacao_nrec,
	ie_cad_prestador,
	ie_criterio_horario,
	ie_lib_valor_conta,
	ie_oc_conta_medica,
	ie_oc_conta_medica_web,
	ie_qtd_execucao,
	ie_regra_preco,
	ie_situacao,
	ie_tipo_guia,
	ie_via_acesso_obrig,
	nm_usuario,
	nm_usuario_nrec,
	dt_referencia,
	ie_autogerado,
	ie_cobertura_contrato,
	ie_complemento_guia,
	ie_item_assistencial_sip,
	ie_regra_coleta,
	ie_taxa_adm,
	ie_via_acesso_procedimento)
SELECT	nr_sequencia_w,
	cd_estabelecimento,
	obter_desc_expressao(303214) ||' '||ds_grupo,
	dt_atualizacao,
	dt_atualizacao_nrec,
	ie_cad_prestador,
	ie_criterio_horario,
	ie_lib_valor_conta,
	ie_oc_conta_medica,
	ie_oc_conta_medica_web,
	ie_qtd_execucao,
	ie_regra_preco,
	ie_situacao,
	ie_tipo_guia,
	ie_via_acesso_obrig,
	nm_usuario,
	nm_usuario_nrec,
	dt_referencia,
	ie_autogerado,
	ie_cobertura_contrato,
	ie_complemento_guia,
	ie_item_assistencial_sip,
	ie_regra_coleta,
	ie_taxa_adm,
	ie_via_acesso_procedimento
from 	pls_preco_grupo_servico
where 	nr_sequencia	= nr_seq_grupo_p;

insert into pls_preco_servico(cd_area_procedimento,
	cd_especialidade,
	cd_grupo_proc,
	cd_procedimento,
	dt_atualizacao,
	dt_atualizacao_nrec,
	ie_estrutura,
	ie_origem_proced,
	nm_usuario,
	nm_usuario_nrec,
	nr_seq_grupo,
	nr_sequencia)
SELECT 	cd_area_procedimento,
	cd_especialidade,
	cd_grupo_proc,
	cd_procedimento,
	dt_atualizacao,
	dt_atualizacao_nrec,
	ie_estrutura,
	ie_origem_proced,
	nm_usuario,
	nm_usuario_nrec,
	nr_sequencia_w,
	nextval('pls_preco_servico_seq')
from	pls_preco_servico
where	nr_seq_grupo	= nr_seq_grupo_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_duplicar_grupo_servico ( nr_seq_grupo_p integer) FROM PUBLIC;
