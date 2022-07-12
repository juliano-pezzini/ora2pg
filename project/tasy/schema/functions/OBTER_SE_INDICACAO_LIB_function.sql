-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_indicacao_lib (nr_sequencia_p bigint, ie_tipo_atend_p bigint, cd_perfil_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w varchar(2) := 'S';
qt_registros_w bigint;


BEGIN

Select count(*)
into STRICT qt_registros_w
from tipo_indicacao_regra
where nr_seq_regra = nr_sequencia_p;

if (qt_registros_w > 0) then

  Select coalesce(max('S'),'N')
  into STRICT ds_retorno_w
  from tipo_indicacao_regra
  where nr_seq_regra = nr_sequencia_p
  and coalesce(cd_perfil, cd_perfil_p) = cd_perfil_p
  and coalesce(ie_tipo_atendimento, coalesce(ie_tipo_atend_p,-1)) = coalesce(ie_tipo_atend_p,-1);

end if;


return  ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_indicacao_lib (nr_sequencia_p bigint, ie_tipo_atend_p bigint, cd_perfil_p bigint) FROM PUBLIC;
