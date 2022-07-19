-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_liberar_reajuste_benef ( nr_seq_reajuste_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_segurado_w		bigint;

C01 CURSOR FOR
	SELECT	nr_seq_segurado
	from	pls_segurado_preco
	where	nr_seq_lote_reajuste	= nr_seq_reajuste_p;


BEGIN

update	pls_segurado_preco
set	dt_liberacao		= clock_timestamp(),
	nm_usuario_liberacao	= nm_usuario_p
where	nr_seq_lote_reajuste	= nr_seq_reajuste_p;

update	pls_segurado_preco_origem
set	dt_liberacao		= clock_timestamp(),
	nm_usuario_liberacao	= nm_usuario_p
where	nr_seq_reajuste		= nr_seq_reajuste_p;

open C01;
loop
fetch C01 into
	nr_seq_segurado_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	update	pls_segurado
	set	ie_tipo_valor	= 'A'
	where	nr_sequencia	= nr_seq_segurado_w;
	end;
end loop;
close C01;

update	pls_reajuste
set	ie_status_benef	= '2'
where	nr_sequencia	= nr_seq_reajuste_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_liberar_reajuste_benef ( nr_seq_reajuste_p bigint, nm_usuario_p text) FROM PUBLIC;

