-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_frac_fora_estab ( nr_seq_etiqueta_p bigint, nr_sequencia_p bigint, nr_seq_estagio_armaz_p bigint) RETURNS varchar AS $body$
DECLARE


ie_fora_estab_w	varchar(1);
hr_validade_w	bigint;
dt_validade_w	timestamp;
dt_horario_w	timestamp;


BEGIN

select 	min(obter_estab_mat_frac(cd_material,nr_seq_estagio_armaz_p))
into STRICT 	hr_validade_w
from   	prescr_mat_hor
where  	nr_sequencia = nr_sequencia_p;

dt_validade_w := clock_timestamp() + hr_validade_w / 24;


select 	max(dt_horario)
into STRICT	dt_horario_w
from	prescr_mat_hor
where 	nr_sequencia = nr_sequencia_p;


if (dt_horario_w > dt_validade_w) then
	ie_fora_estab_w 	:= 'S';
else
	ie_fora_estab_w  	:=	'N';
end if;

return	ie_fora_estab_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_frac_fora_estab ( nr_seq_etiqueta_p bigint, nr_sequencia_p bigint, nr_seq_estagio_armaz_p bigint) FROM PUBLIC;
