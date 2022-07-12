-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_situacao_proced_prescr (cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint) RETURNS varchar AS $body$
DECLARE


ie_situacao_prescr_w	varchar(1);
ie_situacao_proced_w	varchar(1);
ie_situacao_proc_interno_w	varchar(1);


BEGIN
if (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') and (ie_origem_proced_p IS NOT NULL AND ie_origem_proced_p::text <> '') then

	select	coalesce(max(ie_situacao),'A')
	into STRICT	ie_situacao_proced_w
	from	procedimento
	where	cd_procedimento 	= cd_procedimento_p
	and	ie_origem_proced	= ie_origem_proced_p;

	if (ie_situacao_proced_w = 'A') and (nr_seq_proc_interno_p IS NOT NULL AND nr_seq_proc_interno_p::text <> '') then

		select	coalesce(max(ie_situacao),'A')
		into STRICT	ie_situacao_proc_interno_w
		from	proc_interno
		where	nr_sequencia	= nr_seq_proc_interno_p;

		ie_situacao_prescr_w	:= ie_situacao_proc_interno_w;

	else

		ie_situacao_prescr_w	:= ie_situacao_proced_w;

	end if;


end if;

return	ie_situacao_prescr_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_situacao_proced_prescr (cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint) FROM PUBLIC;

