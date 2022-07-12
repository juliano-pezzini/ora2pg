-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_ger_envio_anexos_ans_pck.atualizar_anexo_glosas ( nr_sequencia_p pls_anexo_imp.nr_sequencia%type, cd_motivo_glosa_p pls_anexo_imp.cd_motivo_glosa%type, ds_motivo_glosa_p pls_anexo_imp.ds_motivo_glosa%type) AS $body$
BEGIN
  update 	pls_anexo_imp
  set  		cd_motivo_glosa = cd_motivo_glosa_p,
			ds_motivo_glosa = ds_motivo_glosa_p
  where  	nr_sequencia 	= nr_sequencia_p;
  commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ger_envio_anexos_ans_pck.atualizar_anexo_glosas ( nr_sequencia_p pls_anexo_imp.nr_sequencia%type, cd_motivo_glosa_p pls_anexo_imp.cd_motivo_glosa%type, ds_motivo_glosa_p pls_anexo_imp.ds_motivo_glosa%type) FROM PUBLIC;