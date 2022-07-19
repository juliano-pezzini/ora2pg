-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_copiar_conta_solv ( nr_seq_diops_p bigint, nr_seq_diops_ant_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_diops_saldo_w		bigint;
nr_seq_diops_saldo_ant_w	bigint;
qt_registro_w			bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	diops_trans_conta_solv
	where	nr_seq_trans_conta	= nr_seq_diops_ant_p;


BEGIN
open C01;
loop
fetch C01 into
	nr_seq_diops_saldo_ant_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	nextval('diops_conta_idade_saldo_seq')
	into STRICT	nr_seq_diops_saldo_w
	;

	select	count(*)
	into STRICT	qt_registro_w
	from	diops_trans_conta_solv
	where	nr_seq_anterior		= nr_seq_diops_saldo_ant_w;

	if (qt_registro_w	= 0) then
		insert into  diops_trans_conta_solv(nr_sequencia, nr_seq_trans_conta, cd_conta_contabil,
			dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
			nm_usuario_nrec, nr_seq_anterior)
		SELECT	nr_seq_diops_saldo_w, nr_seq_diops_p, cd_conta_contabil,
			clock_timestamp(), nm_usuario_p, clock_timestamp(),
			nm_usuario_p, nr_seq_diops_saldo_ant_w
		from	diops_trans_conta_solv
		where	nr_sequencia	= nr_seq_diops_saldo_ant_w;
	end if;

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_copiar_conta_solv ( nr_seq_diops_p bigint, nr_seq_diops_ant_p bigint, nm_usuario_p text) FROM PUBLIC;

