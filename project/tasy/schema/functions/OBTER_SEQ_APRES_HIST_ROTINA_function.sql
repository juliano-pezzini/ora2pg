-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_seq_apres_hist_rotina (nr_seq_hist_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_apres_w	integer;


BEGIN

select	max(nr_seq_apres)
into STRICT	nr_seq_apres_w
from	tipo_historico_saude_regra
where	nr_seq_tipo_hist = nr_seq_hist_p;


return	nr_seq_apres_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_seq_apres_hist_rotina (nr_seq_hist_p bigint) FROM PUBLIC;

