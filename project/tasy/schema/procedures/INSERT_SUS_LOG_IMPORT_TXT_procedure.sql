-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insert_sus_log_import_txt (nm_usuario_p sus_log_import_txt.nm_usuario%type, ds_log_import_p sus_log_import_txt.ds_informacao_log%type, cd_expressao_log_p sus_log_import_txt.cd_expressao_log%type, nm_arquivo_imp_p sus_log_import_txt.nm_arquivo_imp%type) AS $body$
BEGIN

insert into sus_log_import_txt(nr_sequencia,
                               nm_usuario_nrec,
                               nm_usuario,
                               dt_atualizacao_nrec,
                               dt_atualizacao,
                               ds_informacao_log,
                               cd_expressao_log,
                               nm_arquivo_imp)
                        values (nextval('sus_log_import_txt_seq'),
                               nm_usuario_p,
                               nm_usuario_p,
                               clock_timestamp(),
                               clock_timestamp(),
                               ds_log_import_p,
                               cd_expressao_log_p,
                               nm_arquivo_imp_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insert_sus_log_import_txt (nm_usuario_p sus_log_import_txt.nm_usuario%type, ds_log_import_p sus_log_import_txt.ds_informacao_log%type, cd_expressao_log_p sus_log_import_txt.cd_expressao_log%type, nm_arquivo_imp_p sus_log_import_txt.nm_arquivo_imp%type) FROM PUBLIC;
