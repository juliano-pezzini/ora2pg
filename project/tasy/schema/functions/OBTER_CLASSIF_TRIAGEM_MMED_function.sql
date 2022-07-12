-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_classif_triagem_mmed ( nr_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_classif_w	bigint;


BEGIN

select	max(a.nr_seq_classif)
into STRICT	nr_seq_classif_w
from	triagem_pronto_atend a
where	a.nr_atendimento = nr_atendimento_p
and	a.ie_status_paciente <> 'C'
and	a.dt_atualizacao = (	SELECT	max(b.dt_atualizacao)
				from	triagem_pronto_atend b
				where	b.nr_sequencia = a.nr_sequencia
				and	b.ie_status_paciente <> 'C');

return	nr_seq_classif_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_classif_triagem_mmed ( nr_atendimento_p bigint) FROM PUBLIC;

