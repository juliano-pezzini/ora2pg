-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_se_atual_micro (nr_seq_exame_p bigint, cd_micro_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(1);
nr_seq_grupo_micro_w	exame_lab_dependente.nr_seq_grupo_micro%type;
nr_seq_grupo_micro_ww	exame_lab_dependente.nr_seq_grupo_micro%type;
cd_microorganismo_w		cih_microorganismo.cd_microorganismo%type;


BEGIN

ds_retorno_w	:= 'S';

select  MAX(nr_seq_grupo_micro)
into STRICT	nr_seq_grupo_micro_w
from	exame_lab_dependente
where 	nr_seq_exame = nr_seq_exame_p
and		coalesce(ie_gera_antibiograma,'N') = 'S';

if (nr_seq_grupo_micro_w IS NOT NULL AND nr_seq_grupo_micro_w::text <> '') then

	select 	MAX(nr_seq_grupo)
	into STRICT	nr_seq_grupo_micro_ww
	from	cih_microorganismo
	where 	cd_microorganismo = cd_micro_p;

	if (nr_seq_grupo_micro_w <> nr_seq_grupo_micro_ww) then
		ds_retorno_w := 'N';
	end if;

end if;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_se_atual_micro (nr_seq_exame_p bigint, cd_micro_p bigint) FROM PUBLIC;

