-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_result_exame ( nr_prescricao_p bigint, nr_seq_prescricao_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_aprovacao_w		timestamp;


BEGIN

begin
select	max(a.dt_resultado) dt_resultado
into STRICT	dt_aprovacao_w
from	exame_lab_result_item b,
	exame_lab_resultado a
where	a.nr_prescricao		= nr_prescricao_p
and	a.nr_seq_resultado	= b.nr_seq_resultado
and	b.nr_seq_prescr		= nr_seq_prescricao_p;
exception
	when others then
	dt_aprovacao_w	:= null;
end;

RETURN dt_aprovacao_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_result_exame ( nr_prescricao_p bigint, nr_seq_prescricao_p bigint) FROM PUBLIC;
