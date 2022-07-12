-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION consistir_via_aplicacao ( nr_prescricao_p bigint, nr_seq_material_p bigint) RETURNS varchar AS $body$
DECLARE


ie_consiste_w			varchar(1) := 'N';
nr_atendimento_w		bigint;
ie_via_aplicacao_w		varchar(5);
ie_via_em_uso_w			varchar(5);
cd_material_w			integer;

C01 CURSOR FOR
SELECT	b.ie_via_aplicacao
from	atend_pac_dispositivo a,
	dispositivo_via b
where	a.nr_seq_dispositivo = b.nr_seq_dispositivo
and	coalesce(a.dt_retirada::text, '') = ''
and	a.nr_atendimento = nr_atendimento_w;


BEGIN

select	max(nr_atendimento)
into STRICT	nr_atendimento_w
from	prescr_medica
where	nr_prescricao = nr_prescricao_p;

if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then

	select	max(ie_via_aplicacao),
		max(cd_material)
	into STRICT	ie_via_aplicacao_w,
		cd_material_w
	from	prescr_material
	where	nr_prescricao = nr_prescricao_p
	and	nr_sequencia = nr_seq_material_p;

	open C01;
	loop
	fetch C01 into
		ie_via_em_uso_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_consiste_w
		from	mat_via_aplic c
		where	c.cd_material = cd_material_w
		and	c.ie_via_aplicacao = ie_via_em_uso_w
		and	c.ie_via_aplicacao <> ie_via_aplicacao_w
		and	not exists (	SELECT	1
					from	atend_pac_dispositivo a,
						dispositivo_via b
					where	a.nr_seq_dispositivo = b.nr_seq_dispositivo
					and	coalesce(a.dt_retirada::text, '') = ''
					and	a.nr_atendimento = nr_atendimento_w
					and	b.ie_via_aplicacao = ie_via_aplicacao_w);

		if (ie_consiste_w = 'S') then
			exit;
		end if;

		end;
	end loop;
	close C01;
end if;

return	ie_consiste_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION consistir_via_aplicacao ( nr_prescricao_p bigint, nr_seq_material_p bigint) FROM PUBLIC;
