-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/*Gravação dos registro c020 e c300*/

CREATE OR REPLACE PROCEDURE fis_sef_edoc_reg_extrato_pck.fis_gravar_reg_c020_c300_edoc () AS $body$
BEGIN
/*Grava o registro c020 para depois o c300, pois precisa do nr_sequencia gravado para poder inserir o nr_Seq_superior do c300*/

forall i in current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020.first .. current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020.last
	insert into fis_sef_edoc_c020 values current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020(i);

/*Limpa o array*/

current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c020_w')::registro_c020.delete;

/*Grava o c300*/

forall i in current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c300_w')::registro_c300.first .. current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c300_w')::registro_c300.last
	insert into fis_sef_edoc_c300 values current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c300_w')::registro_c300(i);

/*Limpa o array*/

current_setting('fis_sef_edoc_reg_extrato_pck.fis_registros_c300_w')::registro_c300.delete;

commit;

PERFORM set_config('fis_sef_edoc_reg_extrato_pck.qt_cursor_c020_w', 0, false);
PERFORM set_config('fis_sef_edoc_reg_extrato_pck.qt_cursor_c300_w', 0, false);

/*Libera memoria*/

dbms_session.free_unused_user_memory;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_sef_edoc_reg_extrato_pck.fis_gravar_reg_c020_c300_edoc () FROM PUBLIC;