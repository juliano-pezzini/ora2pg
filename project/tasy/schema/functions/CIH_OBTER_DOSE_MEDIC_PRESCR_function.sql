-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cih_obter_dose_medic_prescr ( nr_ficha_ocorrencia_p bigint, nr_seq_medicamento_p bigint) RETURNS bigint AS $body$
DECLARE


ie_tipo_inf_medic_w	varchar(1);
qt_dose_w		double precision;


BEGIN

select 	coalesce(max(ie_tipo_inf_medic),'C')
into STRICT	ie_tipo_inf_medic_w
from	cih_parametros
where (cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento
or (coalesce(cd_estabelecimento::text, '') = ''
and not exists (SELECT	1
		from	cih_parametros
		where	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento)));

if (nr_ficha_ocorrencia_p IS NOT NULL AND nr_ficha_ocorrencia_p::text <> '') and (nr_seq_medicamento_p IS NOT NULL AND nr_seq_medicamento_p::text <> '') then
	if (ie_tipo_inf_medic_w = 'C') then

		select	sum(c.qt_dose)
		into STRICT	qt_dose_w
		from	material_atend_paciente a,
			cih_medic_utilizado_paciente b,
			prescr_material c
		where	a.nr_sequencia 		= b.nr_seq_matpaci
		and	a.nr_prescricao		= c.nr_prescricao
		and	a.nr_sequencia_prescricao = c.nr_sequencia
		and	nr_ficha_ocorrencia	= nr_ficha_ocorrencia_p
		and	nr_seq_medic_utilizado	= nr_seq_medicamento_p;

	elsif (ie_tipo_inf_medic_w = 'A') then

		select	sum(c.qt_dose)
		into STRICT	qt_dose_w
		from	cih_medic_utilizado_paciente b,
			prescr_material c
		where	c.nr_seq_interno	= b.nr_seq_interno_prescr
		and	nr_ficha_ocorrencia	= nr_ficha_ocorrencia_p
		and	nr_seq_medic_utilizado	= nr_seq_medicamento_p;

	end if;
end if;

return	qt_dose_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cih_obter_dose_medic_prescr ( nr_ficha_ocorrencia_p bigint, nr_seq_medicamento_p bigint) FROM PUBLIC;
