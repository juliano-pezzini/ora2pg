-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_trans_financ_estab ( cd_estab_origem_p bigint, cd_estab_destino_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_empresa_destino_w			bigint;
nr_seq_transacao_w			bigint;

c01 CURSOR FOR
SELECT	a.nr_sequencia
from	transacao_financeira a
where	cd_estabelecimento	= cd_estab_origem_p;


BEGIN

cd_empresa_destino_w	:= obter_empresa_estab(cd_estab_destino_p);

open C01;
loop
fetch C01 into
	nr_seq_transacao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	CALL copiar_transacao_empresa(nr_seq_transacao_w, 	cd_empresa_destino_w,
				 cd_estab_destino_p,	cd_estab_origem_p, nm_usuario_p, 'S',
				null,'N');
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_trans_financ_estab ( cd_estab_origem_p bigint, cd_estab_destino_p bigint, nm_usuario_p text) FROM PUBLIC;

