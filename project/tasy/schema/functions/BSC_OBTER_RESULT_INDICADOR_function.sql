-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION bsc_obter_result_indicador ( nr_seq_indicador_p bigint, qt_limite_p bigint, qt_real_p bigint, qt_meta_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_result_w			bigint;
ie_resultado_w			varchar(15);
ie_regra_result_w			varchar(15);
ie_regra_intervalo_w		varchar(15);
ie_forma_calc_w			varchar(15);


BEGIN

select	coalesce(max(ie_regra_result), 'N'),
	coalesce(max(ie_regra_intervalo),''),
	coalesce(max(ie_forma_calc),'')
into STRICT	ie_regra_result_w,
	ie_regra_intervalo_w,
	ie_forma_calc_w
from	bsc_indicador
where	nr_sequencia	= nr_seq_indicador_p;

if (ie_regra_result_w = 'N') then
	ie_resultado_w	:= 'B';
elsif (ie_regra_result_w = 'IM') then
	begin
	ie_resultado_w	:= 'M';

	if (qt_real_p <= qt_meta_p) and (qt_real_p >= qt_limite_p) then
		ie_resultado_w		:= 'B';
	elsif (qt_real_p < qt_limite_p) and (ie_regra_intervalo_w = 'LP') then
		ie_resultado_w	:= 'R';
	elsif (qt_real_p > qt_meta_p) and (ie_regra_intervalo_w = 'MP') then
		ie_resultado_w	:= 'R';
	end if;

	end;
elsif (ie_regra_result_w = 'MA') then
	begin
	/*(qt_limite_p < qt_meta_p) then*/

	if (qt_real_p >= qt_meta_p) then
		ie_resultado_w		:= 'B';
	elsif (qt_real_p < qt_limite_p) then
		ie_resultado_w		:= 'R';
	else
		ie_resultado_w		:= 'M';
	end if;

	if (ie_forma_calc_w = 'L') then
		if (qt_real_p >= qt_meta_p) then
			ie_resultado_w	:= 'B';
		elsif (qt_real_p < qt_limite_p) then
			ie_resultado_w	:= 'R';
		else
			ie_resultado_w	:= 'M';
		end if;

	end if;

	end;
else
	begin
	if (qt_real_p <= qt_meta_p) then
		ie_resultado_w		:= 'B';
	elsif (qt_real_p > qt_limite_p) then
		ie_resultado_w		:= 'R';
	else
		ie_resultado_w		:= 'M';
	end if;

	if (ie_forma_calc_w = 'L') then

		if (qt_real_p <= qt_meta_p) then
			ie_resultado_w	:= 'B';
		elsif (qt_real_p > qt_limite_p) then
			ie_resultado_w	:= 'R';
		else
			ie_resultado_w	:= 'M';
		end if;

	end if;

	end;
end if;

select	min(nr_sequencia)
into STRICT	nr_seq_result_w
from	bsc_classif_result
where	ie_situacao	= 'A'
and	ie_resultado	= ie_resultado_w;

return	nr_seq_result_w;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION bsc_obter_result_indicador ( nr_seq_indicador_p bigint, qt_limite_p bigint, qt_real_p bigint, qt_meta_p bigint) FROM PUBLIC;

