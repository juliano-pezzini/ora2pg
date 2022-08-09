-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_banco_escrit (nr_seq_pagto_p bigint, nm_usuario_lib_p text, ie_acao_p text ) AS $body$
DECLARE


cd_estabelecimento_w	smallint;


BEGIN

if (ie_acao_p = 'L') then
	update	banco_escritural a
	set	a.dt_liberacao	= clock_timestamp(),
		a.nm_usuario_lib	= nm_usuario_lib_p
	where	a.nr_sequencia	= nr_seq_pagto_p;

	select	max(cd_estabelecimento)
	into STRICT	cd_estabelecimento_w
	from	banco_escritural
	where	nr_sequencia	= nr_seq_pagto_p;

	CALL envia_comunic_lib_pag(nm_usuario_lib_p, cd_estabelecimento_w);
elsif (ie_acao_p = 'D') then
	update	banco_escritural a
	set	a.dt_liberacao	 = NULL,
		a.nm_usuario_lib	 = NULL
	where	a.nr_sequencia	= nr_seq_pagto_p;
end if;

commit;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_banco_escrit (nr_seq_pagto_p bigint, nm_usuario_lib_p text, ie_acao_p text ) FROM PUBLIC;
