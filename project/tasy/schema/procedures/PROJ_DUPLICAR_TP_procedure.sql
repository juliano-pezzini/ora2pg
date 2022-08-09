-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_duplicar_tp ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w		bigint;
nr_seq_roteiro_w		bigint;
nr_seq_rot_cli_w		bigint;
nr_seq_item_w		bigint;

c01 CURSOR FOR
	SELECT	a.nr_seq_roteiro
	from	proj_tp_cli_rot a
	where	a.nr_seq_cliente = nr_sequencia_p;


BEGIN

select	nextval('proj_tp_cliente_seq')
into STRICT	nr_sequencia_w
;

insert into proj_tp_cliente(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	nr_seq_cliente,
	dt_prev_inic,
	dt_prev_fim,
	dt_real_inic,
	dt_real_fim,
	nr_seq_proj)
SELECT	nr_sequencia_w,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_cliente,
	dt_prev_inic,
	dt_prev_fim,
	dt_real_inic,
	dt_real_fim,
	nr_seq_proj
from	proj_tp_cliente
where	nr_sequencia = nr_sequencia_p;

open c01;
loop
fetch c01 into
	nr_seq_roteiro_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	select	nextval('proj_tp_cli_rot_seq')
	into STRICT	nr_seq_rot_cli_w
	;

	insert into proj_tp_cli_rot(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		nr_seq_roteiro,
		nr_seq_cliente)
	values (	nr_seq_rot_cli_w,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_roteiro_w,
		nr_sequencia_w);

	CALL proj_gerar_rot_item(nr_seq_rot_cli_w, nr_seq_roteiro_w, nm_usuario_p);
	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_duplicar_tp ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
