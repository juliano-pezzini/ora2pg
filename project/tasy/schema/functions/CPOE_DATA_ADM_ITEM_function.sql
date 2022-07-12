-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_data_adm_item ( nr_seq_item_cpoe_p bigint, ie_tipo_item_p text, nr_seq_horario_p bigint, dt_horario_p timestamp) RETURNS timestamp AS $body$
DECLARE

					 
dt_evento_w		timestamp;
ie_evento_w		varchar(15);
dt_retorno_w	timestamp;

c01 CURSOR FOR 
SELECT	dt_evento, 
		ie_evento 
from	cpoe_eventos_adep_item_v 
where	nr_seq_item_cpoe = nr_seq_item_cpoe_p 
and		ie_tipo_item = ie_tipo_item_p 
and		((nr_seq_horario = nr_seq_horario_p) or 
		 (dt_horario_p IS NOT NULL AND dt_horario_p::text <> '' AND dt_horario = dt_horario_p)) 
order	by nr_seq_evento;

	function obter_se_evento_adm(ie_evento_p text) return text is 
	;
BEGIN
		if (ie_tipo_item_p in ('SOL','E')) and 
			((ie_evento_p = '2') or (ie_evento_p = '4')) then 
			 return 'S';
		elsif (ie_tipo_item_p in ('M','L','MA','S','O','R')) and (ie_evento_p = '3') then 
			return 'S';
		elsif (ie_tipo_item_p = 'P') and (ie_evento_p = '3') then 
			return 'S';
		elsif (ie_tipo_item_p = 'G') and 
				((ie_evento_p = 'T') or (ie_evento_p = 'TE') or (ie_evento_p = 'IN'))then 
			return 'S';
		end if;
		return 'N';
	end;
begin 
 
open c01;
loop 
fetch c01 into	dt_evento_w, 
				ie_evento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	if (obter_se_evento_adm(ie_evento_w) = 'S') then 
		dt_retorno_w := dt_evento_w;
	end if;
	end;
end loop;
close c01;
 
return dt_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_data_adm_item ( nr_seq_item_cpoe_p bigint, ie_tipo_item_p text, nr_seq_horario_p bigint, dt_horario_p timestamp) FROM PUBLIC;

