-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/*Gravação dos registro 0150 e 0175*/

CREATE OR REPLACE PROCEDURE fis_sef_edoc_reg_geral_pck.fis_gravar_reg_0150_0175_edoc () AS $body$
BEGIN
/*Grava o registro 0150 para depois o 0175, pois precisa do nr_sequencia gravado para poder inserir o nr_Seq_superior do 0175*/

forall i in current_setting('fis_sef_edoc_reg_geral_pck.fis_registros_0150_w')::registro_0150.first .. current_setting('fis_sef_edoc_reg_geral_pck.fis_registros_0150_w')::registro_0150.last
	insert into fis_sef_edoc_0150 values current_setting('fis_sef_edoc_reg_geral_pck.fis_registros_0150_w')::registro_0150(i);

/*Limpa o array*/

current_setting('fis_sef_edoc_reg_geral_pck.fis_registros_0150_w')::registro_0150.delete;

/*Grava o 0175*/

forall i in current_setting('fis_sef_edoc_reg_geral_pck.fis_registros_0175_w')::registro_0175.first .. current_setting('fis_sef_edoc_reg_geral_pck.fis_registros_0175_w')::registro_0175.last
	insert into fis_sef_edoc_0175 values current_setting('fis_sef_edoc_reg_geral_pck.fis_registros_0175_w')::registro_0175(i);

/*Limpa o array*/

current_setting('fis_sef_edoc_reg_geral_pck.fis_registros_0175_w')::registro_0175.delete;

commit;

PERFORM set_config('fis_sef_edoc_reg_geral_pck.qt_cursor_0150_w', 0, false);
PERFORM set_config('fis_sef_edoc_reg_geral_pck.qt_cursor_0175_w', 0, false);

/*Libera memoria*/

dbms_session.free_unused_user_memory;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_sef_edoc_reg_geral_pck.fis_gravar_reg_0150_0175_edoc () FROM PUBLIC;
