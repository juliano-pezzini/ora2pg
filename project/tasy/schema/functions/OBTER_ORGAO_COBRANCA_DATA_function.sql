-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_orgao_cobranca_data (nr_seq_cobranca_p bigint, dt_referencia_p timestamp) RETURNS bigint AS $body$
DECLARE


nr_seq_orgao_w	bigint;


BEGIN

select 	max(nr_seq_orgao)
into STRICT	nr_seq_orgao_w
from	cobranca_orgao
where	nr_seq_cobranca	= nr_seq_cobranca_p
and	dt_inclusao	<= dt_referencia_p;

return	nr_seq_orgao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_orgao_cobranca_data (nr_seq_cobranca_p bigint, dt_referencia_p timestamp) FROM PUBLIC;
