-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION same_obter_se_pertence_unid (nr_seq_motivo_p bigint) RETURNS varchar AS $body$
DECLARE

ie_retorno_w	varchar(1);

BEGIN
if (nr_seq_motivo_p IS NOT NULL AND nr_seq_motivo_p::text <> '') then

	SELECT	CASE WHEN COUNT(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_retorno_w
	FROM	same_solic_motivo
	WHERE	nr_sequencia = nr_seq_motivo_p
	AND	coalesce(ie_unidade_espec,'N') = 'S';

end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION same_obter_se_pertence_unid (nr_seq_motivo_p bigint) FROM PUBLIC;

