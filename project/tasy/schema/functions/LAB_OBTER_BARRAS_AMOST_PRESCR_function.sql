-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_barras_amost_prescr ( nr_prescricao_p bigint, nr_seq_prescr_p bigint ) RETURNS varchar AS $body$
DECLARE


cd_barras_w		varchar(255);
ie_padrao_amostra_w	varchar(5) := null;


BEGIN

select	max(l.ie_padrao_amostra)
into STRICT	ie_padrao_amostra_w
from	lab_parametro l,
	prescr_medica p
where	p.nr_prescricao		= nr_prescricao_p
and	p.cd_estabelecimento 	= l.cd_estabelecimento;


return	lab_obter_barras_amostra(nr_prescricao_p, nr_seq_prescr_p, null, ie_padrao_amostra_w);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_barras_amost_prescr ( nr_prescricao_p bigint, nr_seq_prescr_p bigint ) FROM PUBLIC;
