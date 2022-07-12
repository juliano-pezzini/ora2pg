-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW qua_pamec_v (ds_arquivo, nr_sequencia) AS select  cd_endereco_catalogo || '|' ||
        dt_inicial || '|' ||
        dt_final || '|' ||
        qt_acao_programada || '|' ||
        qt_acao_executada || '|' ||
        qt_audit_programada || '|' ||
        qt_audit_executada || '|' ||
        qt_documentos_suporte || '|' ||
        ds_processo_padronizado || '|' ||
        ds_usuario || '|' ||
        ds_email || '|' ||
        nr_telefone_celular || '|' ||
        ds_usuario_qua || '|' ||
        ds_email_qua || '|' ||
        nr_telefone_celular_qua || '|' ||
        ds_funcao_qua ds_arquivo,
        nr_sequencia
FROM (
                select  a.nr_sequencia,
                        to_char(a.dt_inicial, 'dd-mm-yyyy') dt_inicial,
                        to_char(a.dt_final, 'dd-mm-yyyy') dt_final,
                        coalesce(a.qt_acao_programada, 0) qt_acao_programada,
                        coalesce(a.qt_acao_executada, 0) qt_acao_executada,
                        coalesce(a.qt_audit_programada, 0) qt_audit_programada,
                        coalesce(a.qt_audit_executada, 0) qt_audit_executada,
                        coalesce(a.qt_documentos_suporte, 0) qt_documentos_suporte,
                        a.ds_processo_padronizado,
                        e.cd_endereco_catalogo,
                        f.nm_pessoa_fisica ds_usuario,
                        g.ds_email ds_email,
                        f.nr_telefone_celular,
                        h.nm_pessoa_fisica ds_usuario_qua,
                        g.ds_email ds_email_qua,
                        h.nr_telefone_celular nr_telefone_celular_qua,
                        j.ds_funcao ds_funcao_qua
                FROM end_endereco e, pessoa_endereco_item d, pessoa_juridica b, (
                                select  nr_sequencia,
                                        obter_dados_pf_pj(null, obter_cgc_estabelecimento(cd_estabelecimento), 'RFC') cd_rfc,
                                        dt_inicial,
                                        dt_final,
                                        qt_acao_programada,
                                        qt_acao_executada,
                                        qt_audit_programada,
                                        qt_audit_executada,
                                        qt_documentos_suporte,
                                        ds_processo_padronizado,
                                        cd_pessoa_resp,
                                        cd_pessoa_resp_qua,
                                        obter_usuario_pf(cd_pessoa_resp) nm_usuario,
                                        obter_usuario_pf(cd_pessoa_resp_qua) nm_usuario_qua
                                from    qua_pamec
                        ) a
LEFT OUTER JOIN pessoa_fisica h ON (a.cd_pessoa_resp_qua = h.cd_pessoa_fisica)
LEFT OUTER JOIN compl_pessoa_fisica i ON (h.cd_pessoa_fisica = i.cd_pessoa_fisica AND 1 = i.ie_tipo_complemento)
LEFT OUTER JOIN funcao_pessoa_fisica j ON (h.nr_seq_funcao_pf = j.nr_sequencia)
, pessoa_fisica f
LEFT OUTER JOIN compl_pessoa_fisica g ON (f.cd_pessoa_fisica = g.cd_pessoa_fisica AND 1 = g.ie_tipo_complemento)
WHERE a.cd_rfc = b.cd_rfc and b.nr_seq_pessoa_endereco = d.nr_seq_pessoa_endereco and d.nr_seq_end_endereco = e.nr_sequencia and d.ie_informacao = 'MUNICIPIO' and a.cd_pessoa_resp = f.cd_pessoa_fisica       ) alias12;
