-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cm_gera_retirada_sala_cirurgia ( nr_seq_expurgo_p bigint, nr_seq_sala_p bigint, cd_setor_retirada_p bigint, cd_local_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_conjunto_w	bigint;
nr_conjunto_cont_w	bigint;
cd_estabelecimento_w	integer;


BEGIN

select	nr_conjunto_cont
into STRICT	nr_conjunto_cont_w
from	cm_expurgo_retirada
where	nr_sequencia = nr_seq_expurgo_p;

update	cm_expurgo_retirada
set	dt_atualizacao = clock_timestamp(),
	nm_usuario = nm_usuario_p,
	cd_local_estoque = cd_local_p,
	dt_retirada = clock_timestamp(),
	nm_usuario_retirada = nm_usuario_p,
	nr_seq_interno = nr_seq_sala_p,
	cd_setor_retirada = cd_setor_retirada_p
where	nr_sequencia = nr_seq_expurgo_p;

update	cm_conjunto_cont
set	cd_local_estoque = cd_local_p
where	nr_sequencia = nr_conjunto_cont_w;

select	nr_seq_conjunto,
	cd_estabelecimento
into STRICT	nr_seq_conjunto_w,
	cd_estabelecimento_w
from	cm_expurgo_retirada
where	nr_sequencia = nr_seq_expurgo_p;

CALL cm_gera_expurgo_saldo(nr_seq_conjunto_w, cd_local_p, 'A', cd_estabelecimento_w, nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cm_gera_retirada_sala_cirurgia ( nr_seq_expurgo_p bigint, nr_seq_sala_p bigint, cd_setor_retirada_p bigint, cd_local_p bigint, nm_usuario_p text) FROM PUBLIC;

