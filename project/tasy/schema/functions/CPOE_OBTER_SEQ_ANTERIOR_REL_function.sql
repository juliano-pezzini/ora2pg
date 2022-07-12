-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_obter_seq_anterior_rel ( nr_atendimento_p bigint, ie_tipo_item_p text, ds_seq_cpoe_item_p text, ie_liberar_p text) RETURNS varchar AS $body$
DECLARE

						
nr_seq_cpoe_anterior_w	bigint;
ds_seq_retorno_w		varchar(4000);

c01 CURSOR FOR
SELECT	nr_seq_cpoe_anterior
from	cpoe_material
where	nr_atendimento = nr_atendimento_p
and		position(nr_sequencia  ds_seq_cpoe_item_p) > 0
and		coalesce(dt_lib_suspensao::text, '') = ''
and		(nr_seq_cpoe_anterior IS NOT NULL AND nr_seq_cpoe_anterior::text <> '')

union all

SELECT	nr_sequencia
from	cpoe_material
where	nr_atendimento = nr_atendimento_p
and		position(nr_seq_adicional in ds_seq_cpoe_item_p) > 0
and		coalesce(dt_lib_suspensao::text, '') = ''
and		(nr_seq_adicional IS NOT NULL AND nr_seq_adicional::text <> '')

union all

select	nr_sequencia
from	cpoe_material
where	nr_atendimento = nr_atendimento_p
and		position(nr_seq_ataque in ds_seq_cpoe_item_p) > 0
and		coalesce(dt_lib_suspensao::text, '') = ''
and		(nr_seq_ataque IS NOT NULL AND nr_seq_ataque::text <> '');

c02 CURSOR FOR
SELECT	nr_seq_cpoe_anterior
from	cpoe_procedimento
where	nr_atendimento = nr_atendimento_p
and		position(nr_sequencia  ds_seq_cpoe_item_p) > 0
and		coalesce(dt_lib_suspensao::text, '') = ''
and		(nr_seq_cpoe_anterior IS NOT NULL AND nr_seq_cpoe_anterior::text <> '');

c03 CURSOR FOR
SELECT	nr_seq_cpoe_anterior
from	cpoe_gasoterapia
where	nr_atendimento = nr_atendimento_p
and		position(nr_sequencia  ds_seq_cpoe_item_p) > 0
and		coalesce(dt_lib_suspensao::text, '') = ''
and		(nr_seq_cpoe_anterior IS NOT NULL AND nr_seq_cpoe_anterior::text <> '');

c04 CURSOR FOR
SELECT	nr_seq_cpoe_anterior
from	cpoe_dialise
where	nr_atendimento = nr_atendimento_p
and		position(nr_sequencia  ds_seq_cpoe_item_p) > 0
and		coalesce(dt_lib_suspensao::text, '') = ''
and		(nr_seq_cpoe_anterior IS NOT NULL AND nr_seq_cpoe_anterior::text <> '');

c05 CURSOR FOR
SELECT	nr_seq_cpoe_anterior
from	cpoe_recomendacao
where	nr_atendimento = nr_atendimento_p
and		position(nr_sequencia  ds_seq_cpoe_item_p) > 0
and		coalesce(dt_lib_suspensao::text, '') = ''
and		(nr_seq_cpoe_anterior IS NOT NULL AND nr_seq_cpoe_anterior::text <> '');

c06 CURSOR FOR
SELECT	nr_seq_cpoe_anterior
from	cpoe_dieta
where	nr_atendimento = nr_atendimento_p
and		position(nr_sequencia  ds_seq_cpoe_item_p) > 0
and		coalesce(dt_lib_suspensao::text, '') = ''
and		(nr_seq_cpoe_anterior IS NOT NULL AND nr_seq_cpoe_anterior::text <> '');

c07 CURSOR FOR
SELECT	nr_seq_cpoe_anterior
from	cpoe_hemoterapia
where	nr_atendimento = nr_atendimento_p
and		position(nr_sequencia  ds_seq_cpoe_item_p) > 0
and		coalesce(dt_lib_suspensao::text, '') = ''
and		(nr_seq_cpoe_anterior IS NOT NULL AND nr_seq_cpoe_anterior::text <> '');

c08 CURSOR FOR
SELECT	nr_seq_cpoe_anterior
from	cpoe_anatomia_patologica
where	nr_atendimento = nr_atendimento_p
and		position(nr_sequencia  ds_seq_cpoe_item_p) > 0
and		coalesce(dt_lib_suspensao::text, '') = ''
and		(nr_seq_cpoe_anterior IS NOT NULL AND nr_seq_cpoe_anterior::text <> '');


BEGIN

ds_seq_retorno_w := ds_seq_cpoe_item_p;
if (ie_liberar_p = 'S') then
	if (ie_tipo_item_p = 'M') then	
		open c01;
		loop
		fetch c01 into nr_seq_cpoe_anterior_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin
			ds_seq_retorno_w := ds_seq_retorno_w||', ' || nr_seq_cpoe_anterior_w;
			end;
		end loop;
		close c01;
	elsif (ie_tipo_item_p = 'P') then	
		open c02;
		loop
		fetch c02 into nr_seq_cpoe_anterior_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin
			ds_seq_retorno_w := ds_seq_retorno_w||', ' || nr_seq_cpoe_anterior_w;
			end;
		end loop;
		close c02;
	elsif (ie_tipo_item_p = 'G') then	
		open c03;
		loop
		fetch c03 into nr_seq_cpoe_anterior_w;
		EXIT WHEN NOT FOUND; /* apply on c03 */
			begin
			ds_seq_retorno_w := ds_seq_retorno_w||', ' || nr_seq_cpoe_anterior_w;
			end;
		end loop;
		close c03;
	elsif (ie_tipo_item_p = 'D') then	
		open c04;
		loop
		fetch c04 into nr_seq_cpoe_anterior_w;
		EXIT WHEN NOT FOUND; /* apply on c04 */
			begin
			ds_seq_retorno_w := ds_seq_retorno_w||', ' || nr_seq_cpoe_anterior_w;
			end;
		end loop;
		close c04;
	elsif (ie_tipo_item_p = 'R') then	
		open c05;
		loop
		fetch c05 into nr_seq_cpoe_anterior_w;
		EXIT WHEN NOT FOUND; /* apply on c05 */
			begin
			ds_seq_retorno_w := ds_seq_retorno_w||', ' || nr_seq_cpoe_anterior_w;
			end;
		end loop;
		close c05;
	elsif (ie_tipo_item_p = 'N') then	
		open c06;
		loop
		fetch c06 into nr_seq_cpoe_anterior_w;
		EXIT WHEN NOT FOUND; /* apply on c06 */
			begin
			ds_seq_retorno_w := ds_seq_retorno_w||', ' || nr_seq_cpoe_anterior_w;
			end;
		end loop;
		close c06;
	elsif (ie_tipo_item_p = 'H') then	
		open c07;
		loop
		fetch c07 into nr_seq_cpoe_anterior_w;
		EXIT WHEN NOT FOUND; /* apply on c07 */
			begin
			ds_seq_retorno_w := ds_seq_retorno_w||', ' || nr_seq_cpoe_anterior_w;
			end;
		end loop;
		close c07;
	elsif (ie_tipo_item_p = 'AP') then	
		open c08;
		loop
		fetch c08 into nr_seq_cpoe_anterior_w;
		EXIT WHEN NOT FOUND; /* apply on c08 */
			begin
			ds_seq_retorno_w := ds_seq_retorno_w||', ' || nr_seq_cpoe_anterior_w;
			end;
		end loop;
		close c08;
	end if;
end if;

return ds_seq_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_seq_anterior_rel ( nr_atendimento_p bigint, ie_tipo_item_p text, ds_seq_cpoe_item_p text, ie_liberar_p text) FROM PUBLIC;

