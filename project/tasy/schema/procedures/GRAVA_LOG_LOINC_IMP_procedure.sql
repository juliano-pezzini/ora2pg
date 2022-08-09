-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE grava_log_loinc_imp (ds_log_p text, nm_usuario_p text, cd_versao_release_p text, cd_versao_ult_alt_p text, ie_tipo_importacao_p text, nr_seq_loinc_dados_p bigint) AS $body$
BEGIN
  insert into LAB_LOINC_LOG_IMPORTACAO(nr_sequencia,
                                        nr_seq_loinc_dados,
                                        cd_versao_release,
                                        cd_versao_ult_alt,
                                        ie_tipo_importacao,
                                        ds_log,
                                        dt_atualizacao,
                                        dt_atualizacao_nrec,
                                        nm_usuario,
                                        nm_usuario_nrec)
                                values (nextval('lab_loinc_log_importacao_seq'),
                                        nr_seq_loinc_dados_p,
                                        cd_versao_release_p,
                                        cd_versao_ult_alt_p,
                                        ie_tipo_importacao_p,
                                        ds_log_p,
                                        clock_timestamp(),
                                        clock_timestamp(),
                                        nm_usuario_p,
                                        nm_usuario_p);
  commit;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE grava_log_loinc_imp (ds_log_p text, nm_usuario_p text, cd_versao_release_p text, cd_versao_ult_alt_p text, ie_tipo_importacao_p text, nr_seq_loinc_dados_p bigint) FROM PUBLIC;
