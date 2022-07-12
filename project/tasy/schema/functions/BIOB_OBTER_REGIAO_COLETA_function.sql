-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION biob_obter_regiao_coleta ( nr_seq_reg_coleta_p bigint) RETURNS varchar AS $body$
DECLARE


ds_regiao_coleta_w	varchar(255);


BEGIN
if (nr_seq_reg_coleta_p IS NOT NULL AND nr_seq_reg_coleta_p::text <> '') then

	SELECT max(a.ds_regiao_coleta)
	INTO STRICT ds_regiao_coleta_w
	FROM BIOB_REGIAO_COLETA a
	WHERE a.nr_sequencia = nr_seq_reg_coleta_p;

end if;

return ds_regiao_coleta_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION biob_obter_regiao_coleta ( nr_seq_reg_coleta_p bigint) FROM PUBLIC;
