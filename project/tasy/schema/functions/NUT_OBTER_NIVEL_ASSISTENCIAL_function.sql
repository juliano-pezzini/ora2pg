-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION nut_obter_nivel_assistencial (nr_atendimento_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
C - Código
D - Descrição
*/
nr_seq_nivel_assist_w	bigint;

ds_retorno_w		varchar(255);


BEGIN

select	max(nr_seq_nivel_assistencial)
into STRICT	nr_seq_nivel_assist_w
from	nut_dados_paciente
where	nr_atendimento = nr_atendimento_p;

if (ie_opcao_p = 'C') then
	ds_retorno_w := nr_seq_nivel_assist_w;

elsif (ie_opcao_p = 'D') then
	select	max(ds_nivel_assistencial)
	into STRICT	ds_retorno_w
	from	nut_nivel_assistencial
	where	nr_sequencia = nr_seq_nivel_assist_w;
end if;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION nut_obter_nivel_assistencial (nr_atendimento_p bigint, ie_opcao_p text) FROM PUBLIC;

