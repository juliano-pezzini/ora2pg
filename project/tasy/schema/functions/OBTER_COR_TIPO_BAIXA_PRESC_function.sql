-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cor_tipo_baixa_presc ( cd_motivo_baixa_p bigint) RETURNS varchar AS $body$
DECLARE


ds_cor_w		varchar(255);


BEGIN

if (cd_motivo_baixa_p IS NOT NULL AND cd_motivo_baixa_p::text <> '') then
	SELECT	max(ds_cor)
	INTO STRICT	ds_cor_w
	FROM	tipo_baixa_prescricao
	WHERE	cd_tipo_baixa		= cd_motivo_baixa_p
	AND	ie_prescricao_devolucao	= 'P';
end if;


RETURN ds_cor_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cor_tipo_baixa_presc ( cd_motivo_baixa_p bigint) FROM PUBLIC;

