-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION med_permite_gerar_encaixe ( cd_agenda_p bigint, dt_encaixe_p timestamp, ie_perm_encaixe_param_p text) RETURNS varchar AS $body$
DECLARE


ie_perm_encaixe_turno_w		varchar(1);
nr_seq_turno_w			bigint;


BEGIN

select	obter_turno_encaixe_agecons(cd_agenda_p,dt_encaixe_p)
into STRICT	nr_seq_turno_w
;

SELECT	coalesce(max(ie_encaixe),'S')
into STRICT	ie_perm_encaixe_turno_w
from	agenda_turno
where	nr_sequencia = nr_seq_turno_w;


if (ie_perm_encaixe_param_p = 'N') and (coalesce(nr_seq_turno_w::text, '') = '') then
	ie_perm_encaixe_turno_w := 'P';
end if;

return	ie_perm_encaixe_turno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION med_permite_gerar_encaixe ( cd_agenda_p bigint, dt_encaixe_p timestamp, ie_perm_encaixe_param_p text) FROM PUBLIC;
