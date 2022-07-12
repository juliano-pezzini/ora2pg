-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gn_obter_se_leite_deriv_susp (nr_seq_leite_deriv_p bigint) RETURNS varchar AS $body$
DECLARE


ie_susp_w	varchar(1)	:= 'N';
qt_susp_w	bigint;


BEGIN
ie_susp_w	:= 'N';
if (nr_seq_leite_deriv_p IS NOT NULL AND nr_seq_leite_deriv_p::text <> '') then

	select	count(*)
	into STRICT	qt_susp_w
	from (SELECT	1
		from	prescr_material a
		where	a.nr_seq_leite_deriv = nr_seq_leite_deriv_p
		and	a.ie_agrupador = 16
		
union all

		SELECT	1
		from	prescr_material a,
			prescr_material b
		where	a.nr_prescricao 	= b.nr_prescricao
		and	a.nr_seq_leite_deriv 	= nr_seq_leite_deriv_p
		and	b.nr_sequencia_diluicao = a.nr_seq_material
		and	a.ie_agrupador = 16
		and	b.ie_agrupador = 17) alias2;

	if (qt_susp_w > 0) then
		select	CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END
		into STRICT	ie_susp_w
		from (SELECT	1
			from	prescr_material a
			where	a.nr_seq_leite_deriv = nr_seq_leite_deriv_p
			and	coalesce(a.ie_suspenso,'N') <> 'S'
			and	a.ie_agrupador = 16
			
union all

			SELECT	1
			from	prescr_material a,
				prescr_material b
			where	a.nr_prescricao 	= b.nr_prescricao
			and	a.nr_seq_leite_deriv 	= nr_seq_leite_deriv_p
			and	b.nr_sequencia_diluicao = a.nr_seq_material
			and	a.ie_agrupador = 16
			and	b.ie_agrupador = 17
			and	coalesce(a.ie_suspenso,'N') <> 'S') alias4;
	end if;

end if;

return	ie_susp_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gn_obter_se_leite_deriv_susp (nr_seq_leite_deriv_p bigint) FROM PUBLIC;

