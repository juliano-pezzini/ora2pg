-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_setor_exclusivo_item (cd_estabelecimento_p bigint, nr_prescricao_p bigint, cd_material_p bigint, ie_setor_regra_p INOUT text) AS $body$
DECLARE


cd_setor_prescr_w	integer;
qt_regra_w		bigint;
qt_setor_regra_w	bigint;
ie_setor_regra_w	varchar(1) := 'S';
ie_permite_w		varchar(1) := 'N';
cd_setor_atendimento_w	bigint;
nr_seq_agrupamento_w	bigint;
ie_setor_w		varchar(1) := 'N';

c01 CURSOR FOR
	SELECT	cd_setor_atendimento,
		ie_permite
	from	material_setor_exclusivo
	where	cd_estabelecimento = cd_estabelecimento_p
	and	cd_material = cd_material_p
	and	((coalesce(nr_seq_agrupamento::text, '') = '') or (nr_seq_agrupamento	= nr_seq_agrupamento_w));


BEGIN
if (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then
	/* obter setor prescricao */

	select	coalesce(max(cd_setor_atendimento),0)
	into STRICT	cd_setor_prescr_w
	from	prescr_medica
	where	nr_prescricao = nr_prescricao_p;

	select	max(nr_seq_agrupamento)
	into STRICT	nr_seq_agrupamento_w
	from	setor_Atendimento
	where	cd_setor_Atendimento	= cd_setor_prescr_w;

	/* obter se regra */

	if (cd_setor_prescr_w > 0) then
		open c01;
		loop
		fetch c01 into
			cd_setor_atendimento_w,
			ie_permite_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */

		if (cd_setor_atendimento_w = cd_setor_prescr_w) or (coalesce(cd_setor_atendimento_w::text, '') = '') then
			ie_setor_w := 'S';
			exit;
		end if;

		end loop;
		close c01;

		if (ie_setor_w = 'S') then
			ie_setor_regra_w:= ie_permite_w;
		elsif (ie_setor_w = 'N') and (ie_permite_w = 'N') then
			ie_setor_regra_w:= 'S';
		elsif (ie_setor_w = 'N') and (ie_permite_w = 'S') then
			ie_setor_regra_w:= 'N';
		end if;
	end if;
end if;

ie_setor_regra_p := ie_setor_regra_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_setor_exclusivo_item (cd_estabelecimento_p bigint, nr_prescricao_p bigint, cd_material_p bigint, ie_setor_regra_p INOUT text) FROM PUBLIC;

