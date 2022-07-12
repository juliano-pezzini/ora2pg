-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pfcs_get_order_telemetry ( cd_estabelecimento_p bigint, nr_seq_indicator_p bigint ) RETURNS bigint AS $body$
DECLARE


nr_rownum_w			bigint := 0;

cur_get_order_telemetry CURSOR FOR
SELECT	row_number() OVER () AS nr_rownum,
		indicator_sequencia,
		nr_seq_ord,
		ie_disabled
from (	select	indicator_sequencia,
				(pfcs_get_indicator_rule(indicator_sequencia, 0, cd_estabelecimento_p, 'ORDER'))::numeric  nr_seq_ord,
				case when indicator_sequencia in (44, 132, 51, 127, 144) then 'N' else 'S' end ie_disabled
		  from (select	indicator_sequencia
				  from	pfcs_telemetry_v
				 where	indicator_sequencia not in (select	indicator_sequencia
													  from	pfcs_telemetry_v
													 where	cd_estabelecimento = cd_estabelecimento_p
													   and	indicator_sequencia in (144,44,41,129,127,160,51,128,132)
													group by indicator_sequencia)
				group by indicator_sequencia
				
union all

				SELECT	indicator_sequencia
				  from	pfcs_telemetry_v
				 where	cd_estabelecimento = cd_estabelecimento_p
				   and	indicator_sequencia in (144,44,129,127,160,51,132)
				group by indicator_sequencia
				
union

				select	indicator_sequencia
				  from	pfcs_telemetry_v
				 where	cd_estabelecimento = cd_estabelecimento_p
				   and	indicator_sequencia in (41, 128)
				   and	vl_indicator > 0
				group by indicator_sequencia) alias7
		where	indicator_sequencia in (144,44,41,129,127,160,51,128,132)
		group by indicator_sequencia
		
union all

        select	indi.nr_sequencia,
				(pfcs_get_indicator_rule(indi.nr_sequencia, 0, cd_estabelecimento_p, 'ORDER'))::numeric  nr_seq_ord,
				'S' ie_disabled
		  from	pfcs_indicator indi,
				pfcs_indicator_rule pfr
		where indi.nr_sequencia = pfr.nr_seq_indicator
			and indi.ie_classification = 'TL'
			and pfcs_get_indicator_rule(indi.nr_sequencia, 0, cd_estabelecimento_p, 'SPACE') = 'S'
		order by nr_seq_ord asc, 1) alias12;

BEGIN
	for c01 in cur_get_order_telemetry
	loop
		if (c01.indicator_sequencia = nr_seq_indicator_p and c01.ie_disabled = 'N') then
			nr_rownum_w := c01.nr_rownum - 1;
			exit;		
		end if;	
	end loop;

	return nr_rownum_w;
	
	exception
		-- If there are no records found
		when no_data_found then
		  return 0;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pfcs_get_order_telemetry ( cd_estabelecimento_p bigint, nr_seq_indicator_p bigint ) FROM PUBLIC;
