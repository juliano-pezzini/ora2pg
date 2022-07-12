-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_atrib_unid_med ( nm_tabela_p text, nm_atributo_p text, dt_referencia_p timestamp) RETURNS bigint AS $body$
DECLARE


nr_sequencia_w	bigint;


BEGIN

select	max(nr_sequencia)
into STRICT	nr_sequencia_w
from	tab_atrib_regra_unid_med
where nm_tabela = nm_tabela_p
   and nm_atributo = nm_atributo_p
   and dt_referencia_p between dt_inicio_vigencia and fim_dia(coalesce(dt_final_vigencia,dt_referencia_p));

return nr_Sequencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_atrib_unid_med ( nm_tabela_p text, nm_atributo_p text, dt_referencia_p timestamp) FROM PUBLIC;
