-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_diagnostico_def ( nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(2000);
ds_doenca_w		varchar(240);
ds_separador_w	varchar(20);

C01 CURSOR FOR
	SELECT		b.ds_doenca_cid
	from		cid_doenca b,
			diagnostico_doenca a
	where		a.nr_atendimento	= nr_atendimento_p
	and		a.cd_doenca		= b.cd_doenca_cid
	and		ie_classificacao_doenca	= 'P'
	order by	dt_diagnostico;



BEGIN


ds_separador_w	:= '';


OPEN C01;
LOOP
FETCH C01 into
	ds_doenca_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	BEGIN
	if (length(ds_retorno_w || ds_separador_w || ds_doenca_w) < 1999) then
		ds_retorno_w := ds_retorno_w || ds_separador_w || ds_doenca_w;
		ds_separador_w	:= ', ';
	end if;
	END;
END LOOP;
CLOSE C01;

RETURN ds_retorno_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_diagnostico_def ( nr_atendimento_p bigint) FROM PUBLIC;
