-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_usuario_prim_dig_res (nr_prescricao_p bigint, nr_seq_prescr_p bigint, nr_seq_exame_p bigint) RETURNS varchar AS $body$
DECLARE


nm_usuario_prim_dig_w		usuario.nm_usuario%type;


BEGIN

select 	MAX(b.nm_usuario_prim_dig)
into STRICT	nm_usuario_prim_dig_w
from	exame_lab_resultado a,
		exame_lab_result_item b
where 	a.nr_seq_resultado = b.nr_seq_resultado
and		a.nr_prescricao = nr_prescricao_p
and		b.nr_seq_prescr = nr_seq_prescr_p
and		b.nr_seq_exame	= nr_seq_exame_p;


return	nm_usuario_prim_dig_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_usuario_prim_dig_res (nr_prescricao_p bigint, nr_seq_prescr_p bigint, nr_seq_exame_p bigint) FROM PUBLIC;

