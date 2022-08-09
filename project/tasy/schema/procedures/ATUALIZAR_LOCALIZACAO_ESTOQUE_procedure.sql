-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_localizacao_estoque (nr_sequencia_p bigint, nr_seq_local_p bigint) AS $body$
DECLARE


ds_localizacao_w	varchar(80);

BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '')	and (nr_seq_local_p IS NOT NULL AND nr_seq_local_p::text <> '')	then
	begin
	select	ds_local
	into STRICT	ds_localizacao_w
	from	material_local
	where	nr_sequencia = nr_seq_local_p;

	if (ds_localizacao_w IS NOT NULL AND ds_localizacao_w::text <> '') then
		begin
		update	localizacao_estoque_local
		set	ds_localizacao	= ds_localizacao_w
		where	nr_sequencia	= nr_sequencia_p;
		end;
	end if;
	commit;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_localizacao_estoque (nr_sequencia_p bigint, nr_seq_local_p bigint) FROM PUBLIC;
