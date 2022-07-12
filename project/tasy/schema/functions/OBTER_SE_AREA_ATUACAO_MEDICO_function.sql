-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_area_atuacao_medico ( cd_medico_p text, nr_seq_area_atuacao_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w		varchar(1) := 'N';
cd_especialidade_w	integer;
qt_reg_area_w		bigint;

C01 CURSOR FOR 
	SELECT	cd_especialidade 
	from	medico_especialidade 
	where	cd_pessoa_fisica = cd_medico_p 
	order by cd_especialidade;


BEGIN 
 
open C01;
loop 
fetch C01 into 
	cd_especialidade_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
 
	select	count(*) 
	into STRICT	qt_reg_area_w 
	from	especialidade_area_atuacao 
	where	cd_especialidade = cd_especialidade_w 
	and	nr_seq_area_atuacao = nr_seq_area_atuacao_p;
	 
	if (qt_reg_area_w > 0) then 
		ds_retorno_w := 'S';
	end if;
 
	end;
end loop;
close C01;
 
return ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_area_atuacao_medico ( cd_medico_p text, nr_seq_area_atuacao_p bigint) FROM PUBLIC;
