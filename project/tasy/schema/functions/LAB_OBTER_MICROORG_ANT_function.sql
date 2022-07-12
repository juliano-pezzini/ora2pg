-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_microorg_ant (nr_prescricao_p bigint, nr_seq_prescr_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(4000);
nr_seq_resultado_w	exame_lab_resultado.nr_seq_resultado%type;
qt_microorganismo_w	w_exame_lab_result_antib.qt_microorganismo%type;
ds_microorganismo_w	cih_microorganismo.ds_microorganismo%type;

c01 CURSOR FOR
	SELECT	distinct
		a.qt_microorganismo,
		b.ds_microorganismo
	from	w_exame_lab_result_antib a,
		cih_microorganismo b
	where	a.cd_microorganismo = b.cd_microorganismo
	  and	a.nr_seq_resultado = nr_seq_resultado_w
	  and	a.nr_seq_prescr = nr_seq_prescr_p
	  order by 2;
BEGIN
ds_retorno_w := '';

select	coalesce(max(nr_seq_resultado), 0)
into STRICT	nr_seq_resultado_w
from	exame_lab_resultado
where	nr_prescricao = nr_prescricao_p;

if coalesce(ie_opcao_p, 'A') = 'D' then
	for r_c01 in c01 loop
		ds_retorno_w := ds_retorno_w || r_c01.ds_microorganismo  || chr(13) || chr(10);
	end loop;
elsif coalesce(ie_opcao_p, 'A') = 'Q' then
	for r_c01 in c01 loop
		ds_retorno_w := ds_retorno_w || r_c01.qt_microorganismo  || chr(13) || chr(10);
	end loop;
elsif coalesce(ie_opcao_p, 'A') = 'A' then
	for r_c01 in c01 loop
		ds_retorno_w := ds_retorno_w || rpad(r_c01.ds_microorganismo, 50, ' ') || ' ' || r_c01.qt_microorganismo || chr(13) || chr(10);
	end loop;
end if;

return trim(both ds_retorno_w);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_microorg_ant (nr_prescricao_p bigint, nr_seq_prescr_p bigint, ie_opcao_p text) FROM PUBLIC;

