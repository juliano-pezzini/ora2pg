-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ramal_unidade ( cd_unidade_basica_p text, cd_unidade_compl_p text) RETURNS bigint AS $body$
DECLARE



nr_ramal_w			integer;


BEGIN

select max(nr_ramal)
into STRICT	nr_ramal_w
from	Unidade_atendimento
where	cd_unidade_basica	= cd_unidade_basica_p
and	cd_unidade_compl	= cd_unidade_compl_p;

return nr_ramal_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ramal_unidade ( cd_unidade_basica_p text, cd_unidade_compl_p text) FROM PUBLIC;

