-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_same_solic_pront (nr_seq_prontuario_p bigint) RETURNS bigint AS $body$
DECLARE


nr_solicitacao_w	bigint := 0;


BEGIN

select	coalesce(max(a.nr_sequencia),0) nr_solicitacao
into STRICT	nr_solicitacao_w
from	same_solic_pront a,
	same_solic_pront_envelope b
where	a.nr_sequencia = b.nr_seq_solic
and	a.ie_status = 'P'
and	coalesce(a.nr_seq_lote::text, '') = ''
and	b.nr_seq_prontuario = nr_seq_prontuario_p;

return nr_solicitacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_same_solic_pront (nr_seq_prontuario_p bigint) FROM PUBLIC;

