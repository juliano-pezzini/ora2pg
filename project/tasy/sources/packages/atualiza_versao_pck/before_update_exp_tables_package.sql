-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE atualiza_versao_pck.before_update_exp_tables () AS $body$
DECLARE

    v_qt_ops bigint;

BEGIN
  
    begin
      EXECUTE 'select count(*) from pls_outorgante'
        into STRICT v_qt_ops;
    exception
      when others then
        v_qt_ops := 0;
    end;

    if v_qt_ops > 0 then
    
      CALL atualiza_versao_pck.insert_cmd(p_operacao    => 'BEFORE UPDATE DICTIONARY TABLES',
                 p_cmd         => 'delete from pls_glosa_evento a where not exists (select 1 from tiss_motivo_glosa x where x.nr_sequencia = a.nr_seq_motivo_glosa)',
                 p_object_name => 'PLS_GLOSA_EVENTO');

      CALL atualiza_versao_pck.insert_cmd(p_operacao    => 'BEFORE UPDATE DICTIONARY TABLES',
                 p_cmd         => 'update  pls_glosa_evento a ' ||
                                  'set  cd_motivo_tiss =  (select  max(x.cd_motivo_tiss) ' ||
                                  '        from  tiss_motivo_glosa x ' ||
                                  '        where  x.nr_sequencia = a.nr_seq_motivo_glosa) ' ||
                                  'where  a.cd_motivo_tiss is null',
                 p_object_name => 'PLS_GLOSA_EVENTO');

      CALL atualiza_versao_pck.insert_cmd(p_operacao    => 'BEFORE UPDATE DICTIONARY TABLES',
                 p_cmd         => 'alter table pls_glosa_evento disable constraint PLSGLEV_TISSMGL_FK',
                 p_object_name => 'PLS_GLOSA_EVENTO');

      CALL atualiza_versao_pck.insert_cmd(p_operacao    => 'BEFORE UPDATE DICTIONARY TABLES',
                 p_cmd         => 'update  pls_glosa_evento a ' ||
                                  'set  nr_seq_motivo_glosa =  (select  min(x.nr_sequencia) ' ||
                                  '        from  tiss_motivo_glosa x ' ||
                                  '        where  x.cd_motivo_tiss = a.cd_motivo_tiss) ' ||
                                  'where  a.cd_motivo_tiss is not null ' ||
                                  'and  not exists (select 1 from tiss_motivo_glosa x where x.nr_sequencia = a.nr_seq_motivo_glosa)',
                 p_object_name => 'PLS_GLOSA_EVENTO');
    end if;

  end;

  --------------------------------------------------------------------------------------
  --
  --
  --
  --------------------------------------------------------------------------------------
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_versao_pck.before_update_exp_tables () FROM PUBLIC;