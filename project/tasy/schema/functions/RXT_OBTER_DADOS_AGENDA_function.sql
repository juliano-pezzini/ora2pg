-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rxt_obter_dados_agenda ( nr_sequencia_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(15);
nr_seq_dia_w		bigint;
nr_seq_dia_fase_w		bigint;

/*
DT - Dia Tratamento
DF - Dia Fase

*/
BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	begin

	select	nr_seq_dia,
		nr_seq_dia_fase
	into STRICT	nr_seq_dia_w,
		nr_seq_dia_fase_w
	from	rxt_agenda
	where	nr_sequencia = nr_sequencia_p;

	if (ie_opcao_p = 'DT') then
		ds_retorno_w	:= nr_seq_dia_w;
	elsif (ie_opcao_p = 'DF') then
		ds_retorno_w	:= nr_seq_dia_fase_w;
	end if;

	end;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rxt_obter_dados_agenda ( nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;

