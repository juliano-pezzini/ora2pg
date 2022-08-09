-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qua_nao_conform_causa_update ( nm_usuario_p text, nr_seq_nao_conform_p bigint, dt_prevista_p timestamp, ie_abrangencia_p text, nr_sequencia_p bigint) AS $body$
DECLARE


nm_user_w			varchar(50);
old_value_dt_prevista_w			timestamp;


BEGIN

select	username
into STRICT	nm_user_w
from	user_users;

select	max(dt_conclusao_desejada)
into STRICT	old_value_dt_prevista_w
from	man_ordem_servico
where 	nr_seq_causa_rnc	= nr_sequencia_p
and		nr_seq_nao_conform = nr_seq_nao_conform_p;


if (nm_user_w = 'CORP') then

	if (coalesce(nr_seq_nao_conform_p, '0') > '0') then
		begin
			if (coalesce(ie_abrangencia_p, 'N') = 'S') then
				if (dt_prevista_p <> old_value_dt_prevista_w) then
					update	man_ordem_servico
					set		dt_conclusao_desejada 	= dt_prevista_p,
							dt_atualizacao	= clock_timestamp(),
							nm_usuario	= nm_usuario_p
					where	nr_seq_causa_rnc	= nr_sequencia_p
					and		nr_seq_nao_conform = nr_seq_nao_conform_p;
				end if;
			end if;
		end;
	end if;
end if;



commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qua_nao_conform_causa_update ( nm_usuario_p text, nr_seq_nao_conform_p bigint, dt_prevista_p timestamp, ie_abrangencia_p text, nr_sequencia_p bigint) FROM PUBLIC;
