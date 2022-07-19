-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_aplicar_reajuste_tab_a800 ( nr_seq_tabela_p bigint, tx_reajuste_p bigint, dt_reajuste_p timestamp, nm_usuario_p text) AS $body$
DECLARE


nr_seq_preco_w		bigint;
vl_preco_atual_w	double precision;
vl_reajuste_w		double precision;


C01 CURSOR FOR
	SELECT	nr_sequencia,
		VL_PRECO_ATUAL
	from	PTU_TABELA_PRECO_A800
	where	nr_seq_tabela	= nr_seq_tabela_p;


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_preco_w,
	vl_preco_atual_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	vl_reajuste_w	:= vl_preco_atual_w + dividir_sem_round((vl_preco_atual_w * tx_reajuste_p)::numeric,100);

	insert into PTU_TABELA_A800_REAJUSTE(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
			NR_SEQ_PRECO,DT_REAJUSTE,TX_REAJUSTE,VL_BASE,VL_REAJUSTE)
	values (	nextval('ptu_tabela_a800_reajuste_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
			nr_seq_preco_w,dt_reajuste_p,tx_reajuste_p,vl_preco_atual_w,vl_reajuste_w);

	update	PTU_TABELA_PRECO_A800
	set	vl_preco_atual		= vl_reajuste_w,
		nm_usuario		= nm_usuario_p
	where	nr_sequencia		= nr_seq_preco_w;

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_aplicar_reajuste_tab_a800 ( nr_seq_tabela_p bigint, tx_reajuste_p bigint, dt_reajuste_p timestamp, nm_usuario_p text) FROM PUBLIC;

