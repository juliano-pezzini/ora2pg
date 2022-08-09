-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_insert_proc_comp (cd_proc_principal_p bigint, cd_proc_secundario_p bigint, cd_reg_proc_sec_p bigint, cd_reg_proc_princ_p bigint, qt_proc_permitida_p bigint, ie_tipo_compatibilidade_p text, nm_usuario_p text) AS $body$
BEGIN

insert into sus_proc_compativel(
              nr_sequencia,
              cd_proc_principal,
              ie_origem_proc_princ,
              cd_reg_proc_princ,
              cd_proc_secundario,
              ie_origem_proc_sec,
              cd_reg_proc_sec,
              qt_proc_permitida,
              ie_tipo_compatibilidade,
              dt_atualizacao,
              nm_usuario,
              dt_atualizacao_nrec,
              nm_usuario_nrec)
     values (  nextval('sus_proc_compativel_seq'),
              cd_proc_principal_p,
              7,
              cd_reg_proc_princ_p,
              cd_proc_secundario_p,
              7,
              cd_reg_proc_sec_p,
              qt_proc_permitida_p,
              ie_tipo_compatibilidade_p,
              clock_timestamp(),
              nm_usuario_p,
              clock_timestamp(),
              nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_insert_proc_comp (cd_proc_principal_p bigint, cd_proc_secundario_p bigint, cd_reg_proc_sec_p bigint, cd_reg_proc_princ_p bigint, qt_proc_permitida_p bigint, ie_tipo_compatibilidade_p text, nm_usuario_p text) FROM PUBLIC;
