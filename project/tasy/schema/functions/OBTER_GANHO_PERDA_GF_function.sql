-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ganho_perda_gf (nr_cirurgia_p bigint, data_p timestamp) RETURNS bigint AS $body$
DECLARE



qt_total_w	double precision;


BEGIN

select	sum(CASE WHEN ie_perda_ganho='G' THEN CASE WHEN coalesce(ie_volume_ocorrencia,'V')='O' THEN  qt_ocorrencia  ELSE qt_volume END   ELSE CASE WHEN coalesce(ie_volume_ocorrencia,'V')='O' THEN  qt_ocorrencia  ELSE qt_volume END  * -1 END ) y
into STRICT	qt_total_w
from   	grupo_perda_ganho c,
	tipo_perda_ganho b,
	atendimento_perda_ganho a
where	c.nr_sequencia = b.nr_seq_grupo
and	coalesce(a.ie_situacao,'A') = 'A'
and    	b.nr_sequencia = a.nr_seq_tipo
and    	ie_exibir_grafico = 'S'
and	nr_cirurgia = nr_cirurgia_p
and	dt_medida <= data_p;


return	qt_total_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ganho_perda_gf (nr_cirurgia_p bigint, data_p timestamp) FROM PUBLIC;
