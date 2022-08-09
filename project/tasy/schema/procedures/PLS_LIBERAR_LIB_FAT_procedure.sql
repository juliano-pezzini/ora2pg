-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_liberar_lib_fat (nr_seq_lib_fat_p bigint, nm_usuario_p text) AS $body$
DECLARE


cont_w		bigint;


BEGIN

select	count(*)
into STRICT	cont_w
from	pls_lib_fat_conta
where	nr_seq_lib_fat	= nr_seq_lib_fat_p
and	ie_status	= 'AC';

if (cont_w > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(281773);
end if;

update	pls_lib_faturamento
set	dt_liberacao	= clock_timestamp(),
	nm_usuario	= nm_usuario_p
where	nr_sequencia	= nr_seq_lib_fat_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_liberar_lib_fat (nr_seq_lib_fat_p bigint, nm_usuario_p text) FROM PUBLIC;
