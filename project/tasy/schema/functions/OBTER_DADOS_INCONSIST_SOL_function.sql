-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_inconsist_sol ( nr_prescricao_p bigint, nr_seq_material_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(4000);
ds_inconsistencia_w		varchar(4000);
ds_inconsistencia_farm_w	varchar(255);

C01 CURSOR FOR
	SELECT	SUBSTR(obter_dados_inconsist_farm(nr_seq_inconsistencia,'D'),1,255) ds_inconsistencia
	FROM   	prescr_material_incon_farm
	WHERE  	nr_prescricao 	= nr_prescricao_p
	AND	nr_seq_material	= nr_seq_material_p
	and	coalesce(ie_situacao, 'A') = 'A'
	ORDER  BY  ds_inconsistencia;


BEGIN


if   (nr_seq_material_p > 0 AND nr_prescricao_p > 0) then
	open c01;
	loop
	fetch c01 into
		ds_inconsistencia_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		ds_retorno_w	:= ds_retorno_w||' - '||ds_inconsistencia_w;
		end;
	end loop;
	close c01;
end if;

begin

	select	substr(obter_dados_inconsist_farm(max(a.nr_seq_inconsistencia),'D'),1,255)
	into STRICT	ds_inconsistencia_farm_w
	from 	prescr_material a
	where 	nr_prescricao = nr_prescricao_p
	and	nr_sequencia = nr_seq_material_p
	and 	ie_agrupador = 4;


exception
when others then
	ds_inconsistencia_farm_w	:= null;
end;

if (ds_inconsistencia_farm_w IS NOT NULL AND ds_inconsistencia_farm_w::text <> '') then
	ds_retorno_w	:= ds_retorno_w||' '||ds_inconsistencia_farm_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_inconsist_sol ( nr_prescricao_p bigint, nr_seq_material_p bigint) FROM PUBLIC;
