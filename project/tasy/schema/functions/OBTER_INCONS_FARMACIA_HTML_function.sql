-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_incons_farmacia_html ( nr_prescricao_p bigint, nr_seq_cpoe_p bigint, ie_acao_p text) RETURNS varchar AS $body$
DECLARE


ie_consiste_w		varchar(1) := 'N';
nr_seq_evento_w		bigint;
qt_registro_w		bigint;
ds_retorno_w		varchar(2000) := null;
ie_suspenso_w		varchar(1) := 'N';

nr_seq_material_w	prescr_material.nr_sequencia%type;

c01 CURSOR FOR
SELECT	nr_seq_evento
from	consiste_alter_farm_item a,
		regra_consiste_alter_farm b
where	b.nr_sequencia 			= a.nr_seq_regra
and		b.ie_acao 				= ie_acao_p
and		coalesce(b.ie_situacao,'A') 	= 'A';

c02 CURSOR FOR
SELECT	nr_sequencia,
		coalesce(ie_suspenso,'N')
from	prescr_material
where	nr_prescricao = nr_prescricao_p
and		nr_seq_mat_cpoe = nr_seq_cpoe_p;


BEGIN

open c01;
loop
fetch c01 into
	nr_seq_evento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	open c02;
	loop
	fetch c02 into	nr_seq_material_w,
					ie_suspenso_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin
		if (ie_suspenso_w = 'N') then
			select	count(*)
			into STRICT	qt_registro_w
			from	prescr_material_incon_farm a
			where	a.nr_seq_inconsistencia = nr_seq_evento_w
			and		a.nr_prescricao	  = nr_prescricao_p
			and		a.nr_seq_material = nr_seq_material_w
			and		coalesce(a.ie_situacao,'A')	= 'A'
			and		exists (	SELECT	1
								from 	prescr_material b
								where 	b.nr_prescricao = a.nr_prescricao
								and 	b.nr_sequencia = a.nr_seq_material
								and 	coalesce(b.ie_suspenso,'N') = 'N');

			if (qt_registro_w = 0) then
				if (coalesce(ds_retorno_w::text, '') = '') then
					ds_retorno_w := substr(obter_texto_tasy(417907, wheb_usuario_pck.get_nr_seq_idioma),1,255)||chr(10)||chr(13) || ---'É necessário registrar a(as) seguite(es) inconsistência(as): '
							substr(obter_dados_inconsist_farm(nr_seq_evento_w,'D'),1,255);
				else
					ds_retorno_w := ds_retorno_w ||chr(10)||chr(13) || substr(obter_dados_inconsist_farm(nr_seq_evento_w,'D'),1,255);
				end if;
			end if;
		end if;
		end;
	end loop;
	close c02;
end loop;
close c01;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_incons_farmacia_html ( nr_prescricao_p bigint, nr_seq_cpoe_p bigint, ie_acao_p text) FROM PUBLIC;
