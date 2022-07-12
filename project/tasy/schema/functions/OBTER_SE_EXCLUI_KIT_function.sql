-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_exclui_kit ( nr_prescricao_p bigint, nr_seq_kit_estoque_p bigint ) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(2);


BEGIN

select	CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END
into STRICT	ds_retorno_w
from	prescr_material
where	nr_prescricao 	= nr_prescricao_p
and		nr_seq_kit_estoque	= nr_seq_kit_estoque_p
and		cd_motivo_baixa <> 0;

return	ds_retorno_w;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_exclui_kit ( nr_prescricao_p bigint, nr_seq_kit_estoque_p bigint ) FROM PUBLIC;
