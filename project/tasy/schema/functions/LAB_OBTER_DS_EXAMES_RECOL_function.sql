-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_ds_exames_recol (nr_prescricao_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
ie_opcao_p			N 	- 	nome
				C	- 	código
*/
C01 CURSOR FOR
	SELECT	a.nm_exame,
			a.cd_exame
	from	exame_laboratorio a,
			prescr_procedimento b,
			prescr_proc_recoleta c
	where	a.nr_seq_exame = b.nr_seq_exame
	and		b.nr_prescricao = c.nr_prescricao
	and		b.nr_sequencia  = c.nr_seq_prescr
	and		b.nr_prescricao = nr_prescricao_p
	order by a.nm_exame;

c01_w		C01%rowtype;

ds_retorno_w		varchar(4000);


BEGIN

open C01;
loop
fetch C01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	if (ie_opcao_p = 'N') then
		ds_retorno_w  := c01_w.nm_exame ||'-'||ds_retorno_w;
	elsif (ie_opcao_p = 'C') then
		ds_retorno_w  := c01_w.cd_exame ||'-'||ds_retorno_w;
	end if;

	end;
end loop;
close C01;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_ds_exames_recol (nr_prescricao_p bigint, ie_opcao_p text) FROM PUBLIC;
