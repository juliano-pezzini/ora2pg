-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pat_atualizar_imob_equip ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_imobilizado_w	varchar(20);
cd_bem_w		varchar(20);
nr_seq_equipamento_w	varchar(20);


BEGIN

select	max(b.nr_sequencia)
into STRICT	nr_seq_equipamento_w
from	man_equipamento b
where	b.nr_seq_bem = nr_sequencia_p;

if (nr_seq_equipamento_w IS NOT NULL AND nr_seq_equipamento_w::text <> '') then

	select	max(a.cd_bem)
	into STRICT	cd_bem_w
	from	pat_bem a
	where	a.nr_sequencia	= nr_sequencia_p;

	select	max(b.cd_imobilizado)
	into STRICT	cd_imobilizado_w
	from	man_equipamento b
	where	b.nr_sequencia = nr_seq_equipamento_w;


	if (cd_imobilizado_w <> cd_bem_w) then
		update	man_equipamento
		set	cd_imobilizado	= cd_bem_w,
			dt_atualizacao	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where	nr_sequencia 	= nr_seq_equipamento_w;
	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pat_atualizar_imob_equip ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
