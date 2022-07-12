-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_motivo_reprov_prop (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_motivo_w	varchar(255);


BEGIN

select	ds_motivo
into STRICT	ds_motivo_w
from	motivos_reprov_proposta_sc
where	nr_Sequencia = nr_sequencia_p;

return	ds_motivo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_motivo_reprov_prop (nr_sequencia_p bigint) FROM PUBLIC;

