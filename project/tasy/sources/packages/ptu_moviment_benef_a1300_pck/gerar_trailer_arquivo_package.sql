-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ptu_moviment_benef_a1300_pck.gerar_trailer_arquivo ( nr_seq_lote_p bigint) AS $body$
DECLARE

	
	qt_total_r302_w		ptu_mov_benef_trailer.qt_total_r302%type;
	qt_total_r303_w		ptu_mov_benef_trailer.qt_total_r303%type;
	qt_total_r304_w		ptu_mov_benef_trailer.qt_total_r304%type;
	
	
BEGIN
	
	select	count(1)
	into STRICT	qt_total_r302_w
	from	ptu_mov_benef_empresa
	where	nr_seq_lote	= nr_seq_lote_p;
	
	select	count(1)
	into STRICT	qt_total_r303_w
	from	ptu_mov_benef_pf_lote
	where	nr_seq_lote	= nr_seq_lote_p;
	
	qt_total_r304_w	:= 0;
	
	insert into ptu_mov_benef_trailer(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
			qt_total_r302,qt_total_r303,qt_total_r304,qt_total_r305,qt_total_r306,
			qt_total_r307,qt_total_r308,qt_total_r309,qt_total_r310,nr_seq_lote, qt_total_r311,
			qt_total_r317)
	values (	nextval('ptu_mov_benef_trailer_seq'),clock_timestamp(),get_nm_usuario,clock_timestamp(),get_nm_usuario,
			qt_total_r302_w,qt_total_r303_w,qt_total_r304_w,current_setting('ptu_moviment_benef_a1300_pck.qt_total_r305_w')::ptu_mov_benef_trailer.qt_total_r305%type,current_setting('ptu_moviment_benef_a1300_pck.qt_total_r306_w')::ptu_mov_benef_trailer.qt_total_r306%type,
			current_setting('ptu_moviment_benef_a1300_pck.qt_total_r307_w')::ptu_mov_benef_trailer.qt_total_r307%type,current_setting('ptu_moviment_benef_a1300_pck.qt_total_r308_w')::ptu_mov_benef_trailer.qt_total_r308%type,current_setting('ptu_moviment_benef_a1300_pck.qt_total_r309_w')::ptu_mov_benef_trailer.qt_total_r309%type,current_setting('ptu_moviment_benef_a1300_pck.qt_total_r310_w')::ptu_mov_benef_trailer.qt_total_r310%type,nr_seq_lote_p, current_setting('ptu_moviment_benef_a1300_pck.qt_total_r311_w')::ptu_mov_benef_trailer.qt_total_r311%type,
			current_setting('ptu_moviment_benef_a1300_pck.qt_total_r317_w')::ptu_mov_benef_trailer.qt_total_r317%type);
	
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_moviment_benef_a1300_pck.gerar_trailer_arquivo ( nr_seq_lote_p bigint) FROM PUBLIC;
