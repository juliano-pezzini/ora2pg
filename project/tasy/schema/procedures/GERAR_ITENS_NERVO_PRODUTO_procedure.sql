-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_itens_nervo_produto ( nr_seq_atend_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w	bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	nervo
	where	ie_situacao = 'A';


BEGIN
open C01;
loop
fetch C01 into
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	insert into atend_nervo_prod_item(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		nr_seq_nervo,
		nr_seq_atend)
	values (	nextval('atend_nervo_prod_item_seq'),
		clock_timestamp(),
		nm_usuario_p,
		nr_sequencia_w,
		nr_seq_atend_p);
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_itens_nervo_produto ( nr_seq_atend_p bigint, nm_usuario_p text) FROM PUBLIC;
