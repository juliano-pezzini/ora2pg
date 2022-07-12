-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_data_atualizacao_res (nr_prescricao_p bigint, nr_seq_prescricao_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_atualizacao_w	timestamp;


BEGIN

select	max(a.dt_atualizacao)
into STRICT	dt_atualizacao_w
from	result_laboratorio a
where	a.nr_prescricao = nr_prescricao_p
and		a.nr_seq_prescricao = nr_seq_prescricao_p
and		coalesce(a.ie_status,'A') = 'A';

return	dt_atualizacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_data_atualizacao_res (nr_prescricao_p bigint, nr_seq_prescricao_p bigint) FROM PUBLIC;
