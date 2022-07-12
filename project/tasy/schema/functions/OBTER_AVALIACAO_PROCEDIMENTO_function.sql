-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_avaliacao_procedimento ( cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_avaliacao_w	med_tipo_avaliacao.nr_sequencia%type;


BEGIN

if (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') and (ie_origem_proced_p IS NOT NULL AND ie_origem_proced_p::text <> '') then
	select	max(nr_seq_avaliacao)
	into STRICT	nr_seq_avaliacao_w
	from	procedimento_prescricao
	where	cd_procedimento  = cd_procedimento_p
	and		ie_origem_proced = ie_origem_proced_p;
end if;

if (coalesce(nr_seq_avaliacao_w::text, '') = '') then
	select	max(nr_seq_avaliacao)
	into STRICT	nr_seq_avaliacao_w
	from	proc_interno
	where	nr_sequencia = nr_seq_proc_interno_p;
end if;

return	nr_seq_avaliacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_avaliacao_procedimento ( cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint) FROM PUBLIC;
