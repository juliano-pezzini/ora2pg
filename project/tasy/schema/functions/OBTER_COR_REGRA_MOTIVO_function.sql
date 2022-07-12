-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cor_regra_motivo (ie_motivo_prescricao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(50);

BEGIN

select	max(ds_cor)
into STRICT		ds_retorno_w
from		regra_cor_motivo_rep
where	ie_motivo_prescricao = ie_motivo_prescricao_p;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cor_regra_motivo (ie_motivo_prescricao_p text) FROM PUBLIC;

