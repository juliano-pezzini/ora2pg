-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_exame_externo_lab ( nr_seq_pedido_p bigint, nr_seq_protocolo_p bigint, nm_usuario_p text) AS $body$
DECLARE


C01 CURSOR FOR
	SELECT	nr_seq_exame,
		nr_seq_apresent
	from	lab_protocolo_ext_item
	where	nr_seq_protocolo = nr_seq_protocolo_p;
c01_w	c01%rowtype;


BEGIN

open C01;
loop
fetch C01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

		insert into pedido_exame_externo_item(
						nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						nr_seq_pedido,
						qt_exame,
						nr_seq_apresent,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_seq_exame_lab)
			values (	nextval('pedido_exame_externo_item_seq'),
						clock_timestamp(),
						nm_usuario_p,
						nr_seq_pedido_p,
						1,
						coalesce(c01_w.nr_seq_apresent,1),
						clock_timestamp(),
						nm_usuario_p,
						c01_w.nr_seq_exame);

	end;
end loop;
close C01;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_exame_externo_lab ( nr_seq_pedido_p bigint, nr_seq_protocolo_p bigint, nm_usuario_p text) FROM PUBLIC;
