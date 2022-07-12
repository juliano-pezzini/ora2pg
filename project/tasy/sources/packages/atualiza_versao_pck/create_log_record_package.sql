-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

 /*+ NO_PARALLEL */     /*+ NO_PARALLEL */      /* + NO_PARALLEL */
     /*+ NO_PARALLEL */      /*+ NO_PARALLEL */     /*+ NO_PARALLEL */      /*+ NO_PARALLEL */     /*+ NO_PARALLEL */     /*+ NO_PARALLEL */      /*+ NO_PARALLEL */      /*+ NO_PARALLEL */      /*+ NO_PARALLEL */     /*+ NO_PARALLEL */      /*+ NO_PARALLEL */     /*+ NO_PARALLEL */      /*+ NO_PARALLEL */      /*+ NO_PARALLEL */      /*+ NO_PARALLEL */     

  /**************************************************************************************************************/

  /**************************************************************************************************************/

  /**************************************************************************************************************/

  /**************************************************************************************************************/

  /**************************************************************************************************************/

  /**************************************************************************************************************/

  /**************************************************************************************************************/

  /**************************************************************************************************************/

  /**************************************************************************************************************/

  /**************************************************************************************************************/

  /**************************************************************************************************************/

CREATE OR REPLACE PROCEDURE atualiza_versao_pck.create_log_record (p_nr_seq bigint, p_msg text) AS $body$
DECLARE

    v_msg_log varchar(1000);

BEGIN
    v_msg_log := null;
    update atualiza_versao_cmd a
       set a.ds_log = a.ds_log || chr(10) || v_msg_log
     where a.nr_seq = p_nr_seq;
  end;

  --------------------------------------------------------------------------------------
  --                                                                                 
  -- Salva as configurações de objeto informadas na tela Object Configuration 
  --                                                                                 
  --------------------------------------------------------------------------------------
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_versao_pck.create_log_record (p_nr_seq bigint, p_msg text) FROM PUBLIC;