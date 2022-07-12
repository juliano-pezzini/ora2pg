-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tipo_guia_lib_atend (nr_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE



retorno_w			bigint;


BEGIN

select	coalesce(max(nr_seq_tipo_lib_guia),0)
into STRICT	retorno_w
from	atend_categoria_convenio
where	nr_atendimento = nr_atendimento_p;

return	retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tipo_guia_lib_atend (nr_atendimento_p bigint) FROM PUBLIC;

