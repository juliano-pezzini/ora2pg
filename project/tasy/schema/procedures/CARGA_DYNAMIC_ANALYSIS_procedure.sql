-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE carga_dynamic_analysis () AS $body$
DECLARE


nome_instancia_w varchar(100) := sys_context('USERENV','DB_NAME');
ds_versao_w varchar(15);

BEGIN

  select cd_versao_atual into STRICT ds_versao_w from aplicacao_tasy where cd_aplicacao_tasy = 'Tasy';

  MERGE INTO funcao_performance_item@PDBDEC b
    USING funcao_performance_item a
    ON (a.NR_SEQUENCIA = b.NR_SEQUENCIA and b.instancia = nome_instancia_w)
  WHEN NOT MATCHED THEN
    INSERT(instancia, nr_sequencia, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, cd_funcao, nr_seq_padrao, nr_seq_obj_schematic, nr_seq_dic_obj, qt_tempo_round1, qt_tempo_round2, ds_observacao, ie_situacao, ds_tag, qt_tolerancia, ie_impacto)
    VALUES (nome_instancia_w, a.nr_sequencia, a.dt_atualizacao, a.nm_usuario, a.dt_atualizacao_nrec, a.nm_usuario_nrec, a.cd_funcao, a.nr_seq_padrao, a.nr_seq_obj_schematic, a.nr_seq_dic_obj, a.qt_tempo_round1, a.qt_tempo_round2, a.ds_observacao, a.ie_situacao, a.ds_tag, a.qt_tolerancia, a.ie_impacto);

  MERGE INTO funcao_perform_item_result@PDBDEC b
    USING (SELECT  /*+parallel*/            a.dt_end,
            a.ds_tag,
            a.nr_sequencia,
            a.dt_start,
            a.nm_usuario,
            a.qt_duration,
            CASE WHEN coalesce(a.cd_funcao::text, '') = '' THEN coalesce(            (                SELECT                    x.cd_funcao                FROM                    objeto_schematic x                WHERE                    x.nr_sequencia = (substr(a.ds_tag,instr(a.ds_tag,':',1,regexp_count(a.ds_tag,':',1,'i'))+ 1))::numeric             ),substr(a.ds_tag,instr(a.ds_tag,':',1,regexp_count(a.ds_tag,':',1,'i'))+ 1)            )  ELSE a.cd_funcao END cd_funcao,
            a.nr_seq_padrao,
            a.ds_base,
            CASE WHEN coalesce(a.ds_versao::text, '') = '' THEN ds_versao_w  ELSE a.ds_versao END ds_versao,
            a.nr_ordem_servico,
            a.dt_atualizacao
        FROM
            funcao_perform_item_result a
        WHERE
            REGEXP_COUNT(A.DS_TAG, '((\[|.*)BARS((\]\:)|(\:)))((\[|.*)ONSTEP((\]\:)|(\:)))+',1,'i') <= 0
            AND NOT upper(a.ds_tag) LIKE '%POLICYTAB'
            AND NOT upper(a.ds_tag) LIKE '%TERMSTAB'
            AND NOT upper(a.ds_tag) LIKE '%UNDEFINED'
            AND REGEXP_REPLACE(A.DS_TAG, '[^0-9]','0') > 0) a
    ON (a.NR_SEQUENCIA = b.NR_SEQUENCIA and b.instancia = nome_instancia_w)
  WHEN NOT MATCHED THEN
    INSERT(instancia, dt_end,ds_tag,nr_sequencia,dt_start,nm_usuario,qt_duration,cd_funcao,nr_seq_padrao,ds_base,ds_versao,nr_ordem_servico,dt_atualizacao)
    VALUES (nome_instancia_w, a.dt_end,a.ds_tag,a.nr_sequencia,a.dt_start,a.nm_usuario,a.qt_duration,a.cd_funcao,a.nr_seq_padrao,a.ds_base, a.ds_versao,a.nr_ordem_servico,a.dt_atualizacao);

    commit;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE carga_dynamic_analysis () FROM PUBLIC;

