-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sae_obter_valor_resultado ( nr_seq_prescr_p bigint, nr_seq_diag_p bigint, nr_seq_likert_p bigint) RETURNS bigint AS $body$
DECLARE


nr_sequencia_w	bigint;
ie_resultado_w	smallint;


BEGIN

	select	max(nr_sequencia)
	into STRICT	nr_sequencia_w
	from	pe_prescr_diag
	where	nr_seq_prescr = nr_seq_prescr_p
	and	nr_seq_diag = nr_seq_diag_p;

	select	coalesce(max(ie_resultado),5)
	into STRICT	ie_resultado_w
	from	pe_prescr_diag_likert
	where	nr_seq_diag = nr_sequencia_w
	and	nr_seq_likert = nr_seq_likert_p;

return	ie_resultado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sae_obter_valor_resultado ( nr_seq_prescr_p bigint, nr_seq_diag_p bigint, nr_seq_likert_p bigint) FROM PUBLIC;

