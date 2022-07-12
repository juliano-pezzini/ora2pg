-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_dados_exame (nr_seq_exame_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
N - Nome Exame;
C - Código Exame;
P - Código do procedimento
*/
nm_exame_w		varchar(80);
cd_exame_w		varchar(20);
cd_procedimento_w	bigint;
ds_retorno_w		varchar(255);
nr_seq_apresent_w	bigint;


BEGIN
if (nr_seq_exame_p IS NOT NULL AND nr_seq_exame_p::text <> '') then
	select	nm_exame,
		cd_exame,
		cd_procedimento,
		coalesce(nr_seq_apresent,0)
	into STRICT	nm_exame_w,
		cd_exame_w,
		cd_procedimento_w,
		nr_seq_apresent_w
	from	exame_laboratorio
	where	nr_seq_exame	= nr_seq_exame_p;

	if (coalesce(ie_opcao_p, 'N') = 'N') then
		ds_retorno_w	:= nm_exame_w;
	elsif (coalesce(ie_opcao_p, 'N') = 'C') then
		ds_retorno_w	:= cd_exame_w;
	elsif (coalesce(ie_opcao_p, 'N') = 'P') then
		ds_retorno_w	:= cd_procedimento_w;
	elsif (ie_opcao_p = 'SA') then
		ds_retorno_w	:= nr_seq_apresent_w;
	end if;
end if;

RETURN	ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_dados_exame (nr_seq_exame_p bigint, ie_opcao_p text) FROM PUBLIC;
