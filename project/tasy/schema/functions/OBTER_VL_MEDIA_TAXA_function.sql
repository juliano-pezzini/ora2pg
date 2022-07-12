-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_vl_media_taxa ( nr_sequencia_p bigint, qt_meses bigint) RETURNS bigint AS $body$
DECLARE


vl_mes01_w			double precision;
vl_mes02_w			double precision;
vl_mes03_w			double precision;
vl_mes04_w			double precision;
vl_mes05_w			double precision;
vl_mes06_w			double precision;
vl_mes07_w			double precision;
vl_mes08_w			double precision;
vl_mes09_w			double precision;
vl_mes10_w			double precision;
vl_mes11_w			double precision;
vl_mes12_w			double precision;
vl_media_w			double precision;
vl_soma_w			double precision;
qt_w				smallint;


BEGIN

select  CASE WHEN cus_rel_menor_que((qt_meses)::numeric -1,0)='S' THEN (null)::numeric   ELSE a.vl_mes01 END  vl_mes01,
	CASE WHEN cus_rel_menor_que((qt_meses)::numeric -2,0)='S' THEN (null)::numeric   ELSE a.vl_mes02 END  vl_mes02,
	CASE WHEN cus_rel_menor_que((qt_meses)::numeric -3,0)='S' THEN (null)::numeric   ELSE a.vl_mes03 END  vl_mes03,
	CASE WHEN cus_rel_menor_que((qt_meses)::numeric -4,0)='S' THEN (null)::numeric   ELSE a.vl_mes04 END  vl_mes04,
	CASE WHEN cus_rel_menor_que((qt_meses)::numeric -5,0)='S' THEN (null)::numeric   ELSE a.vl_mes05 END  vl_mes05,
	CASE WHEN cus_rel_menor_que((qt_meses)::numeric -6,0)='S' THEN (null)::numeric   ELSE a.vl_mes06 END  vl_mes06,
	CASE WHEN cus_rel_menor_que((qt_meses)::numeric -7,0)='S' THEN (null)::numeric   ELSE a.vl_mes07 END  vl_mes07,
	CASE WHEN cus_rel_menor_que((qt_meses)::numeric -8,0)='S' THEN (null)::numeric   ELSE a.vl_mes08 END  vl_mes08,
	CASE WHEN cus_rel_menor_que((qt_meses)::numeric -9,0)='S' THEN (null)::numeric   ELSE a.vl_mes09 END  vl_mes09,
	CASE WHEN cus_rel_menor_que((qt_meses)::numeric -10,0)='S' THEN (null)::numeric   ELSE a.vl_mes10 END  vl_mes10,
	CASE WHEN cus_rel_menor_que((qt_meses)::numeric -11,0)='S' THEN (null)::numeric   ELSE a.vl_mes11 END  vl_mes11,
	CASE WHEN cus_rel_menor_que((qt_meses)::numeric -12,0)='S' THEN (null)::numeric   ELSE a.vl_mes12 END  vl_mes12
into STRICT	vl_mes01_w,
	vl_mes02_w,
	vl_mes03_w,
	vl_mes04_w,
	vl_mes05_w,
	vl_mes06_w,
	vl_mes07_w,
	vl_mes08_w,
	vl_mes09_w,
	vl_mes10_w,
	vl_mes11_w,
	vl_mes12_w
from	w_result_centro_controle a
where	a.nr_sequencia = nr_sequencia_p;

vl_soma_w 	:= 0;
qt_w		:= 0;

if (coalesce(vl_mes01_w,0) <> 0) then
	vl_soma_w := vl_soma_w + vl_mes01_w;
	qt_w 	  := qt_w + 1;
end if;
if (coalesce(vl_mes02_w,0) <> 0) then
	vl_soma_w := vl_soma_w + vl_mes02_w;
	qt_w 	  := qt_w + 1;
end if;
if (coalesce(vl_mes03_w,0) <> 0) then
	vl_soma_w := vl_soma_w + vl_mes03_w;
	qt_w 	  := qt_w + 1;
end if;
if (coalesce(vl_mes04_w,0) <> 0) then
	vl_soma_w := vl_soma_w + vl_mes04_w;
	qt_w 	  := qt_w + 1;
end if;
if (coalesce(vl_mes05_w,0) <> 0) then
	vl_soma_w := vl_soma_w + vl_mes05_w;
	qt_w 	  := qt_w + 1;
end if;
if (coalesce(vl_mes06_w,0) <> 0) then
	vl_soma_w := vl_soma_w + vl_mes06_w;
	qt_w 	  := qt_w + 1;
end if;
if (coalesce(vl_mes07_w,0) <> 0) then
	vl_soma_w := vl_soma_w + vl_mes07_w;
	qt_w 	  := qt_w + 1;
end if;
if (coalesce(vl_mes08_w,0) <> 0) then
	vl_soma_w := vl_soma_w + vl_mes08_w;
	qt_w 	  := qt_w + 1;
end if;
if (coalesce(vl_mes09_w,0) <> 0) then
	vl_soma_w := vl_soma_w + vl_mes09_w;
	qt_w 	  := qt_w + 1;
end if;
if (coalesce(vl_mes10_w,0) <> 0) then
	vl_soma_w := vl_soma_w + vl_mes10_w;
	qt_w 	  := qt_w + 1;
end if;
if (coalesce(vl_mes11_w,0) <> 0) then
	vl_soma_w := vl_soma_w + vl_mes11_w;
	qt_w 	  := qt_w + 1;
end if;
if (coalesce(vl_mes12_w,0) <> 0) then
	vl_soma_w := vl_soma_w + vl_mes12_w;
	qt_w 	  := qt_w + 1;
end if;

vl_media_w := Dividir(vl_soma_w,qt_w);

return	vl_media_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_vl_media_taxa ( nr_sequencia_p bigint, qt_meses bigint) FROM PUBLIC;
