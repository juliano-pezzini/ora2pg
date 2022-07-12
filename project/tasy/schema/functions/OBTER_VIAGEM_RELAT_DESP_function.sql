-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_viagem_relat_desp (nr_seq_relat_desp_p bigint) RETURNS bigint AS $body$
DECLARE



nr_seq_viagem_w	bigint;


BEGIN

select 	max(nr_seq_viagem)
into STRICT	nr_seq_viagem_w
from 	via_relat_desp
where 	nr_sequencia = nr_seq_relat_desp_p;

return nr_seq_viagem_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_viagem_relat_desp (nr_seq_relat_desp_p bigint) FROM PUBLIC;
