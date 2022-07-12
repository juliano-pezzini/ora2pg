-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hd_obter_se_conc_maquina (nr_seq_maquina_p bigint, nr_seq_ponto_dialise_p bigint) RETURNS varchar AS $body$
DECLARE

ds_retorno_w	varchar(1);

BEGIN

--011,nr_seq_maquina_p || '-' || nr_seq_ponto_dialise_p || '#@#@');
select 	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT	ds_retorno_w
from	hd_dialise_concentrado
where	nr_seq_maquina 		= nr_seq_maquina_p
and	nr_seq_ponto_acesso	= nr_seq_ponto_dialise_p
and	coalesce(dt_retirada::text, '') = '';


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hd_obter_se_conc_maquina (nr_seq_maquina_p bigint, nr_seq_ponto_dialise_p bigint) FROM PUBLIC;
