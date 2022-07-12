-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_san_doacao_log (nr_seq_doacao_p bigint) RETURNS varchar AS $body$
DECLARE


ie_status_log_w			varchar(10);
			

BEGIN

select  CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT	ie_status_log_w
from    tasy_log_alteracao
where   nm_tabela = 'SAN_DOACAO'
and     ((nr_seq_doacao_p IS NOT NULL AND nr_seq_doacao_p::text <> '' AND ds_chave_simples like '%' || nr_seq_doacao_p || '%') or (coalesce(nr_seq_doacao_p::text, '') = ''));

return	ie_status_log_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_san_doacao_log (nr_seq_doacao_p bigint) FROM PUBLIC;

