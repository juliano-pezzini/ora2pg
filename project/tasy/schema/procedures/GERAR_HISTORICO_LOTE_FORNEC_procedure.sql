-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_historico_lote_fornec ( nm_usuario_p text, nr_seq_lote_fornec_p bigint, ds_titulo_p text, ds_historico_p text) AS $body$
DECLARE


nr_sequencia_w		bigint;


BEGIN

select	nextval('material_lote_fornec_hist_seq')
into STRICT	nr_sequencia_w
;

insert into material_lote_fornec_hist(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_lote_fornec,
			ds_titulo,
			ds_historico,
			ie_tipo,
			dt_liberacao,
			nm_usuario_lib)
				values (
			nr_sequencia_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_lote_fornec_p,
			ds_titulo_p,
			ds_historico_p,
			'U',
			clock_timestamp(),
			nm_usuario_p);
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_historico_lote_fornec ( nm_usuario_p text, nr_seq_lote_fornec_p bigint, ds_titulo_p text, ds_historico_p text) FROM PUBLIC;
