-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION proj_obter_se_posic_aprov ( nr_seq_proj_p bigint, dt_referencia_p timestamp) RETURNS varchar AS $body$
DECLARE


ie_aprovado_w	varchar(1);


BEGIN

select CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END
into STRICT	ie_aprovado_w
from	proj_posicao_coordenacao x
where	x.nr_seq_proj = nr_seq_proj_p
and	trunc(dt_posicao) = trunc(dt_referencia_p)
and	coalesce(x.dt_aprovacao::text, '') = '';


return	ie_aprovado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION proj_obter_se_posic_aprov ( nr_seq_proj_p bigint, dt_referencia_p timestamp) FROM PUBLIC;
