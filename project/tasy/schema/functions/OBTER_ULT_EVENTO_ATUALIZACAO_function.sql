-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ult_evento_atualizacao (nr_seq_atualizacao_p bigint) RETURNS varchar AS $body$
DECLARE


ie_evento_w	varchar(15);

BEGIN

select coalesce(max(ie_evento),'210')
into STRICT	ie_evento_w
from 	log_atualizacao
where	nr_seq_atualizacao = nr_seq_atualizacao_p
and 	ie_evento < 230;


return	ie_evento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ult_evento_atualizacao (nr_seq_atualizacao_p bigint) FROM PUBLIC;

