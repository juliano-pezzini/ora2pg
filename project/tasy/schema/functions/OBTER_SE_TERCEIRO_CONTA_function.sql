-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_terceiro_conta (nr_interno_conta_p bigint, nr_seq_terceiro_p bigint) RETURNS varchar AS $body$
DECLARE


/*
Verifica se existe algum item na conta com repasse para o terceiro.
Opção 'Gerar item no repasse', do retorno convênio (itens glosados)
*/
ds_retorno_w		varchar(2) := 'N';
nr_seq_terceiro_w	bigint;

c01 CURSOR FOR
SELECT	a.nr_seq_terceiro
from 	procedimento_repasse a,
	procedimento_paciente b
where	a.nr_seq_procedimento	= b.nr_sequencia
and 	b.nr_interno_conta 	= nr_interno_conta_p
and	a.nr_seq_terceiro	= nr_seq_terceiro_p

union

select	a.nr_seq_terceiro
from 	material_repasse a,
	material_atend_paciente b
where	a.nr_seq_material	= b.nr_sequencia
and 	b.nr_interno_conta 	= nr_interno_conta_p
and	a.nr_seq_terceiro	= nr_seq_terceiro_p;


BEGIN

ds_retorno_w	:= 'N';

if (nr_interno_conta_p IS NOT NULL AND nr_interno_conta_p::text <> '') then

	open c01;
	loop
	fetch c01 into
		nr_seq_terceiro_w;
	EXIT WHEN NOT FOUND or ds_retorno_w = 'S';  /* apply on c01 */
			ds_retorno_w	:= 'S';
	end loop;
	close c01;

else
	ds_retorno_w	:= 'S';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_terceiro_conta (nr_interno_conta_p bigint, nr_seq_terceiro_p bigint) FROM PUBLIC;
