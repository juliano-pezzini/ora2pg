-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW emprestimo_v (nr_emprestimo, cd_estabelecimento, cd_local_estoque, ie_tipo, dt_emprestimo, dt_atualizacao, nm_usuario, cd_pessoa_juridica, cd_pessoa_fisica, nr_documento, nm_usuario_resp, dt_prev_retorno, ie_situacao, ds_observacao, dt_liberacao, nr_seq_motivo, nr_emprestimo_ref, dt_aprovacao, nm_usuario_aprov, dt_reprovacao, nm_usuario_reprov, ie_origem, nm_pessoa, ds_tipo, ds_situacao) AS select e.NR_EMPRESTIMO,e.CD_ESTABELECIMENTO,e.CD_LOCAL_ESTOQUE,e.IE_TIPO,e.DT_EMPRESTIMO,e.DT_ATUALIZACAO,e.NM_USUARIO,e.CD_PESSOA_JURIDICA,e.CD_PESSOA_FISICA,e.NR_DOCUMENTO,e.NM_USUARIO_RESP,e.DT_PREV_RETORNO,e.IE_SITUACAO,e.DS_OBSERVACAO,e.DT_LIBERACAO,e.NR_SEQ_MOTIVO,e.NR_EMPRESTIMO_REF,e.DT_APROVACAO,e.NM_USUARIO_APROV,e.DT_REPROVACAO,e.NM_USUARIO_REPROV,e.IE_ORIGEM,
	 coalesce(j.ds_razao_social, f.nm_pessoa_fisica) nm_pessoa,
       obter_valor_dominio(115, e.ie_tipo) ds_tipo,
	 CASE WHEN e.ie_situacao='A' THEN  'Aberto' WHEN e.ie_situacao='B' THEN  'Baixado' WHEN e.ie_situacao='I' THEN 'Inativo' END  ds_situacao
FROM emprestimo e
LEFT OUTER JOIN pessoa_fisica f ON (e.cd_pessoa_fisica = f.cd_pessoa_fisica)
LEFT OUTER JOIN pessoa_juridica j ON (e.cd_pessoa_juridica = j.cd_cgc);

