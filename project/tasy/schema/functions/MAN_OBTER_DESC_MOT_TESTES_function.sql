-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_desc_mot_testes (nr_seq_motivo_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);


BEGIN

if (nr_seq_motivo_p IS NOT NULL AND nr_seq_motivo_p::text <> '') then
	select	ds_motivo
	into STRICT	ds_retorno_w
	from	des_motivo_erro_teste
	where	nr_sequencia = nr_seq_motivo_p;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_desc_mot_testes (nr_seq_motivo_p bigint) FROM PUBLIC;

