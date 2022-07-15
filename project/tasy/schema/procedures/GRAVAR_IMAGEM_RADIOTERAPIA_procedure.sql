-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_imagem_radioterapia (nr_seq_fase_p bigint, ds_titulo_p text, ds_arquivo_backup text, ds_arquivo_p text, nm_usuario_p text, ds_extensao_p text, ds_arquivo_backup_p text) AS $body$
DECLARE


nr_sequencia_w		bigint;


BEGIN

select	nextval('rxt_trat_fase_imagem_seq')
into STRICT	nr_sequencia_w
;

insert into rxt_trat_fase_imagem(nr_sequencia,
		nr_seq_fase,
		ds_titulo,
		ds_arquivo,
		ds_arquivo_backup,
		dt_atualizacao,
		nm_usuario)
	values (nr_sequencia_w,
		nr_seq_fase_p,
		ds_titulo_p,
		ds_arquivo_p || to_char(nr_sequencia_w) || ds_extensao_p,
		ds_arquivo_backup_p,
		clock_timestamp(),
		nm_usuario_p);

commit;
end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_imagem_radioterapia (nr_seq_fase_p bigint, ds_titulo_p text, ds_arquivo_backup text, ds_arquivo_p text, nm_usuario_p text, ds_extensao_p text, ds_arquivo_backup_p text) FROM PUBLIC;

