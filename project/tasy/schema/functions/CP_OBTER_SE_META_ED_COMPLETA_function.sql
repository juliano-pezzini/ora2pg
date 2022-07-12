-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cp_obter_se_meta_ed_completa ( nr_seq_pat_cp_goal_p bigint) RETURNS varchar AS $body$
DECLARE


qt_registros_w	bigint;
ds_retorno_w	varchar(1) := 'N';


BEGIN

if (nr_seq_pat_cp_goal_p IS NOT NULL AND nr_seq_pat_cp_goal_p::text <> '') then

	select	count(1)
	into STRICT	qt_registros_w
	from	pat_cp_ind_measure_eg
	where	nr_seq_pat_cp_goal = nr_seq_pat_cp_goal_p;
	
	if (qt_registros_w > 0) then
		select 	CASE WHEN count(1)=0 THEN  'S'  ELSE 'N' END
		into STRICT	ds_retorno_w
		from 	pat_cp_ind_measure_eg a
		where 	a.nr_seq_pat_cp_goal = nr_seq_pat_cp_goal_p
		and 	coalesce(a.dt_liberacao::text, '') = '';
	end if;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cp_obter_se_meta_ed_completa ( nr_seq_pat_cp_goal_p bigint) FROM PUBLIC;

