-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_tc_ev_item ( nr_seq_ect_p bigint, ie_tipo_retorno_p text ) RETURNS varchar AS $body$
DECLARE


ie_result_w		varchar(1);
ds_result_w		varchar(4000);
qt_registro_w		bigint;
nr_current_cycle_w	reg_tc_evidence_item.nr_seq_ciclo%type;


BEGIN

select	max(nr_seq_ciclo)
into STRICT	nr_current_cycle_w
from	reg_tc_evidence_item
where	nr_seq_ect = nr_seq_ect_p;

if (nr_seq_ect_p IS NOT NULL AND nr_seq_ect_p::text <> '') then

	select	substr(ie_status, 1, 1)
	into STRICT	ie_result_w
	from	reg_tc_pendencies
	where	nr_sequencia = nr_seq_ect_p;

	if (ie_result_w <> 'E') then

		select	coalesce(count(*),0)
		into STRICT	qt_registro_w
		from	reg_tc_evidence_item
		where	nr_seq_ect = nr_seq_ect_p
		and	nr_seq_ciclo = nr_current_cycle_w;

		if (qt_registro_w = 0) then
			begin
			ie_result_w := 'P';
			end;
		else
			begin
			select	coalesce(count(*),0)
			into STRICT	qt_registro_w
			from	reg_tc_evidence_item
			where	nr_seq_ect = nr_seq_ect_p
			and	coalesce(ie_result,'P') = 'B'
			and	nr_seq_ciclo = nr_current_cycle_w;

			if (qt_registro_w > 0) then
				begin
				ie_result_w := 'B';
				end;
			else
				begin
				select	coalesce(count(*),0)
				into STRICT	qt_registro_w
				from	reg_tc_evidence_item
				where	nr_seq_ect = nr_seq_ect_p
				and	coalesce(ie_result,'P') = 'F'
				and	nr_seq_ciclo = nr_current_cycle_w;

				if (qt_registro_w > 0) then
					begin
					ie_result_w := 'F';
					end;
				else
					begin
					select	coalesce(count(*),0)
					into STRICT	qt_registro_w
					from	reg_tc_evidence_item
					where	nr_seq_ect = nr_seq_ect_p
					and	coalesce(ie_result::text, '') = ''
					and	nr_seq_ciclo = nr_current_cycle_w;

					if (qt_registro_w = 0) then
						begin
						ie_result_w := 'C';
						end;
					else
						ie_result_w := 'P';
					end if;
					end;
				end if;
				end;
			end if;
			end;
		end if;
	end if;
end if;

if (ie_tipo_retorno_p = 'C') then
	begin
	ds_result_w := ie_result_w;
	end;
else
	begin
	if (ie_result_w = 'B') then
		ds_result_w := obter_texto_tasy(834402, null);
	elsif (ie_result_w = 'F') then
		ds_result_w := obter_texto_tasy(834401, null);
	elsif (ie_result_w = 'C') then
		ds_result_w := obter_texto_tasy(834404, null);
	elsif (ie_result_w = 'E') then
		ds_result_w := obter_texto_tasy(1030005, null); -- Excluído
	else
		ds_result_w := obter_texto_tasy(834400, null);
	end if;
	end;
end if;
return	ds_result_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_tc_ev_item ( nr_seq_ect_p bigint, ie_tipo_retorno_p text ) FROM PUBLIC;
