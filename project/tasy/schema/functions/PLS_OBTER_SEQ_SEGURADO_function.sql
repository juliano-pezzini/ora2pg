-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_seq_segurado ( nr_seq_plano_p bigint, nr_seq_contrato_p bigint) RETURNS varchar AS $body$
DECLARE


nr_sequencia_w 		bigint;


BEGIN

select	coalesce(max(nr_sequencia),0)
into STRICT	nr_sequencia_w
from	pls_segurado
where	nr_seq_plano = nr_seq_plano_p
and	nr_seq_contrato = nr_seq_contrato_p;

return	nr_sequencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_seq_segurado ( nr_seq_plano_p bigint, nr_seq_contrato_p bigint) FROM PUBLIC;

