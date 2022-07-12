-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_se_os_priorizada ( nr_seq_ordem_serv_p bigint ) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(1);


BEGIN

select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END
into STRICT	ds_retorno_w
from	man_ordem_serv_tecnico st,
		man_tipo_hist ti
where	st.nr_seq_ordem_serv = nr_seq_ordem_serv_p
and		nr_seq_tipo = ti.nr_sequencia
and		ti.ie_classificacao = 'P'
and		(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_se_os_priorizada ( nr_seq_ordem_serv_p bigint ) FROM PUBLIC;
