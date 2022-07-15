-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_fa_liberar_receita ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


dt_inicio_w						timestamp;
dt_validade_w					timestamp;


BEGIN

update	fa_receita_farmacia
set		dt_liberacao    = clock_timestamp(),
		nm_usuario_lib	= nm_usuario_p,
		nm_usuario		= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
where 	nr_sequencia 	= nr_sequencia_p;

select 	max(dt_inicio_receita),
		max(dt_validade_receita)
into STRICT	dt_inicio_w,
		dt_validade_w
from	fa_receita_farmacia
where	nr_sequencia = nr_sequencia_p;

if (dt_inicio_w IS NOT NULL AND dt_inicio_w::text <> '') and (dt_validade_w IS NOT NULL AND dt_validade_w::text <> '') then
	CALL preparar_medic_dias(nr_sequencia_p,nm_usuario_p);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_fa_liberar_receita ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

