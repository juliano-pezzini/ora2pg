-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION plt_obter_erro_npt ( nr_prescricao_p bigint, nr_seq_nut_pac_p bigint, ie_npt_p text) RETURNS bigint AS $body$
DECLARE


ie_retorno_w		integer;

BEGIN
if (ie_npt_p = 'P') then
	select	max(c.ie_erro)
	into STRICT	ie_retorno_w
	from	nut_pac a,
			nut_pac_elemento b,
			nut_pac_elem_mat c
	where	a.nr_sequencia  = b.nr_seq_nut_pac
	and		b.nr_sequencia  = c.nr_seq_pac_elem
	and		coalesce(a.ie_npt_adulta,'S') = 'P'
	and		a.nr_prescricao = nr_prescricao_p
	and		a.nr_sequencia  = nr_seq_nut_pac_p;
elsif (ie_npt_p = 'N') then
	select	max(c.ie_erro)
	into STRICT	ie_retorno_w
	from	nut_pac a,
			nut_pac_elemento b,
			nut_pac_elem_mat c
	where	a.nr_sequencia  = b.nr_seq_nut_pac
	and		b.nr_sequencia  = c.nr_seq_pac_elem
	and		coalesce(a.ie_npt_adulta,'S') = 'N'
	and		a.nr_prescricao = nr_prescricao_p
	and		a.nr_sequencia  = nr_seq_nut_pac_p;
elsif (ie_npt_p = 'S') then
	select	max(c.ie_erro)
	into STRICT	ie_retorno_w
	from	nut_pac a,
			nut_pac_elem_mat c
	where	a.nr_sequencia = c.nr_seq_nut_pac
	and		coalesce(a.ie_npt_adulta,'S') = 'S'
	and		a.nr_prescricao = nr_prescricao_p
	and		a.nr_sequencia = nr_seq_nut_pac_p;
end if;

return ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION plt_obter_erro_npt ( nr_prescricao_p bigint, nr_seq_nut_pac_p bigint, ie_npt_p text) FROM PUBLIC;

