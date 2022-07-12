-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gel_obter_se_exame_envelope (nr_seq_prescricao_p bigint, nr_prescricao_p bigint, nr_seq_exame_p bigint) RETURNS varchar AS $body$
DECLARE


ie_envelope_w		varchar(1);
ie_anatomia_w		varchar(1) := 'N';


BEGIN

if (nr_seq_exame_p IS NOT NULL AND nr_seq_exame_p::text <> '') then

	select 	max(coalesce(ie_anatomia_patologica,'N'))
	into STRICT	ie_anatomia_w
	from	exame_laboratorio
	where 	nr_seq_exame = nr_seq_exame_p;
end if;

if (nr_seq_exame_p IS NOT NULL AND nr_seq_exame_p::text <> '') and (ie_anatomia_w <> 'S') then
	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_envelope_w
	from	envelope_laudo_item a,
		result_laboratorio c
	where	a.nr_seq_result_lab = c.nr_sequencia
	and	c.nr_seq_prescricao = nr_seq_prescricao_p
	and	c.nr_prescricao = nr_prescricao_p;
else
	/*
	select	decode(count(*),0,'N','S')
	into	ie_envelope_w
	from	envelope_laudo_item a,
		laudo_paciente c
	where	a.nr_seq_laudo = c.nr_sequencia
	and	c.nr_seq_prescricao = nr_seq_prescricao_p
	and	c.nr_prescricao = nr_prescricao_p;

	if	(ie_envelope_w = 'N') then
		begin
	*/
	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_envelope_w
	from	envelope_laudo_item a
	where	a.nr_prescricao = nr_prescricao_p
	and	a.nr_seq_prescr = nr_seq_prescricao_p
	and	(a.nr_seq_laudo IS NOT NULL AND a.nr_seq_laudo::text <> '')
	and	coalesce(a.nr_seq_result_lab::text, '') = '';

	/*
		end;
	end if;
	*/
end if;

return	ie_envelope_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gel_obter_se_exame_envelope (nr_seq_prescricao_p bigint, nr_prescricao_p bigint, nr_seq_exame_p bigint) FROM PUBLIC;
