-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE esquema_insert_imagem_cirurgia ( nm_usuario_p text, nr_seq_prot_p bigint, ds_titulo_p text, nr_seq_banco_img_p bigint) AS $body$
BEGIN

INSERT INTO imagem_cirurgia(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	nr_seq_prot_cirurgia,
	ds_titulo,
	nr_seq_banco_img)
VALUES (nextval('imagem_cirurgia_seq'),
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_prot_p,
	substr(ds_titulo_p,1,100),
	nr_seq_banco_img_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE esquema_insert_imagem_cirurgia ( nm_usuario_p text, nr_seq_prot_p bigint, ds_titulo_p text, nr_seq_banco_img_p bigint) FROM PUBLIC;
