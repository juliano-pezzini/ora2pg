-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_weekday_name (nr_cpoe_week_seq_p bigint) RETURNS varchar AS $body$
DECLARE

					
ie_segunda_w		varchar(1);
ie_terca_w			varchar(1);
ie_quarta_w			varchar(1);
ie_quinta_w			varchar(1);
ie_sexta_w			varchar(1);
ie_sabado_w			varchar(1);
ie_domingo_w		varchar(1);
ds_day_name_w		varchar(30);


BEGIN

select 	coalesce(a.ie_segunda, 'N'),
		coalesce(a.ie_terca, 'N'),
		coalesce(a.ie_quarta, 'N'),
		coalesce(a.ie_quinta, 'N'),
		coalesce(a.ie_sexta, 'N'),
		coalesce(a.ie_sabado, 'N'),
		coalesce(a.ie_domingo, 'N')
into STRICT	ie_segunda_w,
        ie_terca_w,	
        ie_quarta_w,
        ie_quinta_w,	
        ie_sexta_w,
        ie_sabado_w,
        ie_domingo_w
from 	cpoe_weekday_proc a
where	nr_sequencia = nr_cpoe_week_seq_p;

	if (ie_segunda_w	='S') then
		ds_day_name_w	:= obter_desc_expressao(298104); -- Monday
	elsif (ie_terca_w	='S') then
		ds_day_name_w	:= obter_desc_expressao(299301);--Tuesday
	elsif (ie_quarta_w	='S') then
		ds_day_name_w	:= obter_desc_expressao(297137);-- Wednesday
	elsif (ie_quinta_w	='S') then
		ds_day_name_w	:= obter_desc_expressao(297213);-- Thursday
	elsif (ie_sexta_w	='S') then
		ds_day_name_w	:= obter_desc_expressao(298487); --Friday
	elsif (ie_sabado_w	='S') then
		ds_day_name_w	:= obter_desc_expressao(297960); --Saturday
	elsif (ie_domingo_w	='S') then
		ds_day_name_w	:= obter_desc_expressao(288200); --Sunday
	end if;

return trim(both ds_day_name_w);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_weekday_name (nr_cpoe_week_seq_p bigint) FROM PUBLIC;

