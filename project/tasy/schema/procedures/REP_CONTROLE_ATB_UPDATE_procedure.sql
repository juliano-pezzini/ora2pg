-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE rep_controle_atb_update (nr_atendimento_p bigint, cd_material_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w	bigint;


BEGIN

select	max(nr_sequencia)
into STRICT	nr_sequencia_w
from	rep_controle_atb
where	nr_atendimento	= nr_atendimento_p
and	cd_material	= cd_material_p;

if (nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '') then
	update	rep_controle_atb
	set	ie_continuou	= 'S',
		nm_usuario	= nm_usuario_p
	where	nr_sequencia	= nr_sequencia_w;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE rep_controle_atb_update (nr_atendimento_p bigint, cd_material_p bigint, nm_usuario_p text) FROM PUBLIC;
