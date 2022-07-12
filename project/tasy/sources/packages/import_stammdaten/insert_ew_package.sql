-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE import_stammdaten.insert_ew ( import_p w_xdok_ew.nr_seq_import%type, code_p w_xdok_ew.code%type, bereich_p w_xdok_ew.bereich%type, typ_p w_xdok_ew.typ%type, codealt_p w_xdok_ew.codealt%type, kommen_p w_xdok_ew.kommentar%type, akzep_p w_xdok_ew.akzeptierbar%type, abtpos_p w_xdok_ew.abtpos%type, nm_usuario_p w_xdok_ew.nm_usuario%type) AS $body$
BEGIN
	

		PERFORM set_config('import_stammdaten.dt_atual_w', clock_timestamp(), false);
	
		begin
			insert into w_xdok_ew(
				nr_sequencia,
				nr_seq_import,
				code,
				bereich,
				typ,
				codealt,
				kommentar,
				akzeptierbar,
				abtpos,
				nm_usuario,
				nm_usuario_nrec,
				dt_atualizacao,
				dt_atualizacao_nrec
			) values (
				nextval('w_xdok_ew_seq'),
				import_p,
				code_p,
				bereich_p,
				typ_p,
				codealt_p,
				kommen_p,
				akzep_p,
				abtpos_p,
				nm_usuario_p,
				nm_usuario_p,
				current_setting('import_stammdaten.dt_atual_w')::timestamp,
				current_setting('import_stammdaten.dt_atual_w')::timestamp
			);
		exception when others then
			rollback;
			CALL wheb_mensagem_pck.exibir_mensagem_abort(1023582);
		end;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE import_stammdaten.insert_ew ( import_p w_xdok_ew.nr_seq_import%type, code_p w_xdok_ew.code%type, bereich_p w_xdok_ew.bereich%type, typ_p w_xdok_ew.typ%type, codealt_p w_xdok_ew.codealt%type, kommen_p w_xdok_ew.kommentar%type, akzep_p w_xdok_ew.akzeptierbar%type, abtpos_p w_xdok_ew.abtpos%type, nm_usuario_p w_xdok_ew.nm_usuario%type) FROM PUBLIC;