-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fa_obter_se_receita_pmc ( nr_seq_receita_paciente_p bigint ) RETURNS varchar AS $body$
DECLARE


ie_retorno_w	varchar(1);

BEGIN

if (nr_seq_receita_paciente_p IS NOT NULL AND nr_seq_receita_paciente_p::text <> '') then

	select 	CASE WHEN coalesce(nr_seq_paciente_pmc::text, '') = '' THEN  'N'  ELSE 'S' END
	into STRICT	ie_retorno_w
	from	fa_paciente_entrega
	where	nr_sequencia = nr_seq_receita_paciente_p;

end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fa_obter_se_receita_pmc ( nr_seq_receita_paciente_p bigint ) FROM PUBLIC;
