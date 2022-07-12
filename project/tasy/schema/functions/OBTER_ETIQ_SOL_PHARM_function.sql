-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_etiq_sol_pharm ( nr_prescricao_p bigint, nr_seq_solucao_p bigint, nr_seq_processo_p bigint, nr_seq_material_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(14);


BEGIN

select	substr(obter_codigo_barras_ordem_frac(nr_seq_etiqueta),1,14)
into STRICT	ds_retorno_w
from	prescr_mat_hor
where	nr_seq_processo = nr_seq_processo_p
and		nr_seq_material = nr_seq_material_p;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_etiq_sol_pharm ( nr_prescricao_p bigint, nr_seq_solucao_p bigint, nr_seq_processo_p bigint, nr_seq_material_p bigint) FROM PUBLIC;

