-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qua_gravar_leitura_nao_conform ( nr_seq_nao_conform_p bigint, nm_usuario_p text) AS $body$
DECLARE


dt_acesso_w		timestamp;
nr_sequencia_w	bigint;


BEGIN

select	max(nr_sequencia)
into STRICT	nr_sequencia_w
from	qua_nao_conform_leitura
where	nr_seq_nao_conform	= nr_seq_nao_conform_p
and	nm_usuario_acesso	= nm_usuario_p
and	coalesce(dt_acesso::text, '') = '';

if (coalesce(nr_sequencia_w::text, '') = '') then
	insert into qua_nao_conform_leitura(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		nr_seq_nao_conform,
		nm_usuario_acesso,
		dt_acesso)
	values (nextval('qua_nao_conform_leitura_seq'),
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_nao_conform_p,
		nm_usuario_p,
		clock_timestamp());
elsif (nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '') then
	begin
	update	qua_nao_conform_leitura
	set	dt_atualizacao	= clock_timestamp(),
		dt_acesso		= clock_timestamp()
	where	nr_sequencia		= nr_sequencia_w;
	end;
end if;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qua_gravar_leitura_nao_conform ( nr_seq_nao_conform_p bigint, nm_usuario_p text) FROM PUBLIC;
