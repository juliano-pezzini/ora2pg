-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION reg_get_stat_val_pen_item ( nr_seq_pend_tc_p bigint, ie_tipo_retorno_p text) RETURNS varchar AS $body$
DECLARE


ie_result_w varchar(1);
ds_result_w varchar(4000);
qt_registro_w bigint;
nr_current_cycle_w reg_validation_pend_item.nr_seq_cycle%type;


BEGIN

select	max(nr_seq_cycle)
into STRICT	nr_current_cycle_w
from	reg_validation_pend_item
where	nr_seq_pend_tc = nr_seq_pend_tc_p;

if (nr_seq_pend_tc_p IS NOT NULL AND nr_seq_pend_tc_p::text <> '') then
	begin
	
	select	substr(ie_status, 1, 1)
	into STRICT	ie_result_w
	from	reg_validation_pendencies
	where	nr_sequencia = nr_seq_pend_tc_p;
	
	if (coalesce(ie_result_w, 'P') <> 'E') then
		select	coalesce(count(*),0)
		into STRICT	qt_registro_w
		from	reg_validation_pend_item
		where	nr_seq_pend_tc = nr_seq_pend_tc_p
		and	nr_seq_cycle = nr_current_cycle_w;

		if (qt_registro_w = 0) then
			begin
			ie_result_w := 'P';
			end;
		else
			begin
			select	coalesce(count(*),0)
			into STRICT	qt_registro_w
			from	reg_validation_pend_item
			where	nr_seq_pend_tc = nr_seq_pend_tc_p
			and	coalesce(ie_result,'P') = 'B'
			and	nr_seq_cycle = nr_current_cycle_w;
			
			if (qt_registro_w > 0) then	
				begin
				ie_result_w := 'B';
				end;
			else
				begin
				select	coalesce(count(*),0)
				into STRICT	qt_registro_w
				from	reg_validation_pend_item
				where	nr_seq_pend_tc = nr_seq_pend_tc_p
				and	coalesce(ie_result,'P') = 'F'
				and	nr_seq_cycle = nr_current_cycle_w;
				
				if (qt_registro_w > 0) then	
					begin
					ie_result_w := 'F';
					end;
				else
					begin
					select	coalesce(count(*),0)
					into STRICT	qt_registro_w
					from	reg_validation_pend_item
					where	nr_seq_pend_tc = nr_seq_pend_tc_p
					and	coalesce(ie_result::text, '') = ''
					and	nr_seq_cycle = nr_current_cycle_w;
					
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
	exception
		when no_data_found then return null;
		when too_many_rows then raise;
	end;
end if;

if (ie_tipo_retorno_p = 'C') then
	begin
	ds_result_w := ie_result_w;
	end;
else
	begin
	if (ie_result_w = 'B') then
		begin
		ds_result_w := obter_texto_tasy(834402, null);
		end;	
	elsif (ie_result_w = 'F') then
		begin
		ds_result_w := obter_texto_tasy(834401, null);
		end;
	elsif (ie_result_w = 'C') then
		begin
		ds_result_w := obter_texto_tasy(834404,null);
		end;
    elsif (ie_result_w = 'E') then
        begin
		ds_result_w := obter_texto_tasy(1030005, null);
        end;
	else
		begin
		ds_result_w := obter_texto_tasy(834400, null);
		end;
	end if;
	end;
end if;
return	ds_result_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION reg_get_stat_val_pen_item ( nr_seq_pend_tc_p bigint, ie_tipo_retorno_p text) FROM PUBLIC;

