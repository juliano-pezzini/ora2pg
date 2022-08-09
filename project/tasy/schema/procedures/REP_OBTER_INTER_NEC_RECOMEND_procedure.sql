-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE rep_obter_inter_nec_recomend ( cd_intervalo_p INOUT text, cd_estabelecimento_p bigint ) AS $body$
DECLARE


ie_interv_sn_w	varchar(1) := 'N';
cd_intervalo_w	varchar(7);


BEGIN

if (cd_intervalo_p IS NOT NULL AND cd_intervalo_p::text <> '') then
	begin

	select	ie_se_necessario
	into STRICT	ie_interv_sn_w
	from	intervalo_prescricao
	where	ie_se_necessario = 'S'
	and	ie_situacao = 'A'
	--and	nvl(ie_se_farmacia_amb,'N') = 'N'
	and	cd_intervalo = cd_intervalo_p
	and     obter_se_intervalo(cd_intervalo, 'R') = 'S'
	and	((coalesce(cd_estabelecimento::text, '') = '') or (cd_estabelecimento = cd_estabelecimento_p));
	end;

end if;

if (ie_interv_sn_w <> 'S') then
	begin

	select	max(cd_intervalo)
	into STRICT	cd_intervalo_w
	from	intervalo_prescricao
	where	ie_se_necessario = 'S'
	and	ie_situacao = 'A'
	--and     nvl(ie_se_farmacia_amb,'N') = 'N'
	and	obter_se_intervalo(cd_intervalo, 'R') = 'S'
	and	((coalesce(cd_estabelecimento::text, '') = '') or (cd_estabelecimento = cd_estabelecimento_p));

	end;
end if;

cd_intervalo_p := cd_intervalo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE rep_obter_inter_nec_recomend ( cd_intervalo_p INOUT text, cd_estabelecimento_p bigint ) FROM PUBLIC;
