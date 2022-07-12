-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_grupo_trab_projeto (nr_seq_estrutura_grupo bigint) RETURNS varchar AS $body$
DECLARE


nr_seq_grupo_w	bigint;

BEGIN

select 	nr_seq_grupo
into STRICT 	nr_seq_grupo_w
from	gpi_estrutura_grupo
where	nr_sequencia = nr_seq_estrutura_grupo;

return	substr(Obter_desc_grupo_trab(nr_seq_grupo_w),1,255);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_grupo_trab_projeto (nr_seq_estrutura_grupo bigint) FROM PUBLIC;
