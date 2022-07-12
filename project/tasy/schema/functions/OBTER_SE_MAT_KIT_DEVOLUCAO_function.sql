-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_mat_kit_devolucao (nr_prescricao_p bigint) RETURNS varchar AS $body$
DECLARE


/*Verifica quais os Kit estoque não tiveram nenhuma devolução */

ds_kit_estoque_w	varchar(255);
ds_lista_kit_estoque_w	varchar(4000);
nr_seq_kit_estoque_w	bigint;
qt_prescricao_w		bigint;
qt_sem_devolucao_w	bigint;


c01 CURSOR FOR
	SELECT	distinct b.nr_seq_kit_estoque
	from	prescr_material b
	where	b.nr_prescricao = nr_prescricao_p;


BEGIN

open c01;
loop
fetch c01 into
	nr_seq_kit_estoque_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

begin
if (nr_seq_kit_estoque_w IS NOT NULL AND nr_seq_kit_estoque_w::text <> '') then
	select	count(*)
	into STRICT	qt_sem_devolucao_w
	from	prescr_material b
	where	b.nr_prescricao = nr_prescricao_p
	and		b.nr_seq_kit_estoque = nr_seq_kit_estoque_w
	and		not exists (SELECT	1
						from	prescr_material_devolucao x
						where	x.nr_seq_prescricao = b.nr_sequencia
						and		x.nr_prescricao = b.nr_prescricao);

	select	count(*)
	into STRICT	qt_prescricao_w
	from	prescr_material b
	where	b.nr_prescricao = nr_prescricao_p
	and		b.nr_seq_kit_estoque = nr_seq_kit_estoque_w;

	if (qt_sem_devolucao_w = qt_prescricao_w) then

		select	substr(obter_nome_kit_estoque(nr_seq_kit_estoque_w),1,60)
		into STRICT	ds_kit_estoque_w
		;

		if (ds_lista_kit_estoque_w IS NOT NULL AND ds_lista_kit_estoque_w::text <> '') then
			ds_lista_kit_estoque_w := substr(ds_lista_kit_estoque_w || ' , ',1,4000);
		end if;

		ds_lista_kit_estoque_w	:= substr(ds_lista_kit_estoque_w || ds_kit_estoque_w,1,4000);

	end if;
end if;

end;

end loop;
close c01;

return	ds_lista_kit_estoque_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_mat_kit_devolucao (nr_prescricao_p bigint) FROM PUBLIC;
