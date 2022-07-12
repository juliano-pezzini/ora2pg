-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fa_obter_se_entrega_pmc (nr_seq_entrega_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w	varchar(1);

BEGIN

ie_retorno_w := 'N';

if (nr_seq_entrega_p IS NOT NULL AND nr_seq_entrega_p::text <> '') then

	SELECT 	CASE WHEN coalesce(nr_seq_paciente_pmc::text, '') = '' THEN 'N'  ELSE 'S' END
	into STRICT	ie_retorno_w
	FROM 	fa_paciente_entrega b,
		FA_ENTREGA_MEDICACAO a
	WHERE 	b.nr_sequencia = a.NR_SEQ_PACIENTE_ENTREGA
	AND	a.nr_sequencia = nr_seq_entrega_p;
end if;


return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fa_obter_se_entrega_pmc (nr_seq_entrega_p bigint) FROM PUBLIC;

