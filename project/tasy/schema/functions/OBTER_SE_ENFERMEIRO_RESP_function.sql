-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_enfermeiro_resp ( nr_atendimento_p bigint, cd_pessoa_fisica_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

 
qt_nao_responsavel_w	bigint := 0;
qt_responsavel_w	bigint := 0;
ds_retorno_w		varchar(1) := 'N';
cd_pessoa_fisica_w	varchar(10);

 
C01 CURSOR FOR 
	SELECT	cd_pessoa_fisica 
	from	atend_enfermagem_resp a 
	where	nr_atendimento	= nr_atendimento_p 
	order by DT_ATUALIZACAO_NREC;


BEGIN 
 
OPEN C01;
LOOP 
FETCH C01 into 
	cd_pessoa_fisica_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	ds_retorno_w	:= 'N';
	if	((ie_opcao_p = 'R') or (ie_opcao_p = 'RS')) and (cd_pessoa_fisica_w = cd_pessoa_fisica_p) then	 
		ds_retorno_w	:= 'S';
	end if;
	end;
END LOOP;
CLOSE C01;
 
if	((ie_opcao_p = 'RS') or (ie_opcao_p = 'S')) and (ds_retorno_w = 'N') then 
	select	count(*) 
	into STRICT	qt_nao_responsavel_w 
	from	atend_enfermagem_resp b, 
		atendimento_paciente a 
	where	a.nr_atendimento	= b.nr_atendimento 
	and	a.nr_atendimento	= nr_atendimento_p;
 
	if (qt_nao_responsavel_w = 0) then 
		ds_retorno_w	:= 'S';
	end if;
end if;
 
if (ie_opcao_p = 'T') then 
	ds_retorno_w	:= 'S';
end if;
 
RETURN ds_retorno_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_enfermeiro_resp ( nr_atendimento_p bigint, cd_pessoa_fisica_p text, ie_opcao_p text) FROM PUBLIC;
