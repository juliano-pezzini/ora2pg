-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_historico_cobranca (nr_seq_historico_p bigint) RETURNS varchar AS $body$
DECLARE


ds_historico_w		varchar(255);


BEGIN
	select	max(substr(ds_historico,1,255))
	into STRICT	ds_historico_w
	from	tipo_hist_cob
	where	nr_sequencia = nr_seq_historico_p;

return	ds_historico_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_historico_cobranca (nr_seq_historico_p bigint) FROM PUBLIC;

