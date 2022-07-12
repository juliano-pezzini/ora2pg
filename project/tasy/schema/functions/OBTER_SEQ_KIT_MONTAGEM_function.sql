-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_seq_kit_montagem (nr_seq_kit_p bigint) RETURNS bigint AS $body$
DECLARE


nr_sequencia_w	bigint;


BEGIN
select	max(nr_seq_reg_kit)
into STRICT	nr_sequencia_w
from 	kit_estoque
where 	nr_seq_reg_kit_basico = nr_seq_kit_p;

return	nr_sequencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_seq_kit_montagem (nr_seq_kit_p bigint) FROM PUBLIC;
