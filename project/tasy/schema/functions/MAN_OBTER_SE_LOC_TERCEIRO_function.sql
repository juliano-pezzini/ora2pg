-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_se_loc_terceiro ( nr_seq_localizacao_p bigint ) RETURNS varchar AS $body$
DECLARE


ie_terceiro_w			man_localizacao.ie_terceiro%type;


BEGIN

select	coalesce(max(ie_terceiro), 'S')
into STRICT	ie_terceiro_w
from	man_localizacao
where	nr_sequencia = nr_seq_localizacao_p;

return	ie_terceiro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_se_loc_terceiro ( nr_seq_localizacao_p bigint ) FROM PUBLIC;

