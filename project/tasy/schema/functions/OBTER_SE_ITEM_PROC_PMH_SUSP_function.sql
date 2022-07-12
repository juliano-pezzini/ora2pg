-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_item_proc_pmh_susp ( nr_seq_hor_p bigint) RETURNS varchar AS $body$
DECLARE


ie_suspenso_w	varchar(1) := 'N';


BEGIN
if (coalesce(nr_seq_hor_p,0) > 0) then
	begin
	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_suspenso_w
	from	prescr_mat_hor
	where	nr_sequencia	= nr_seq_hor_p
	and	(dt_suspensao IS NOT NULL AND dt_suspensao::text <> '')
	and	Obter_se_horario_liberado(dt_lib_horario, dt_horario) = 'S';
	end;
end if;
return ie_suspenso_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_item_proc_pmh_susp ( nr_seq_hor_p bigint) FROM PUBLIC;
