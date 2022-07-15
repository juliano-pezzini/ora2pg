-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ajustar_vol_equipo_solucao ( qt_volume_solucao_p bigint, nr_prescricao_p bigint, nr_sequencia_p bigint, ie_bomba_infusao_p text, ie_correcao_p text, nr_etapas_p bigint, qt_volume_corrigido_p INOUT bigint) AS $body$
DECLARE


qt_equipo_w			double precision;
qt_vol_total_w		double precision;
qt_vol_cor_w		double precision;
qt_distribuir_w		double precision;


BEGIN

qt_volume_corrigido_p	:= 0;

if (ie_correcao_p = 'S') and (coalesce(ie_bomba_infusao_p,'N') <> 'N') then

	qt_equipo_w	:=	Obter_vol_Dispositivo_solucao(ie_bomba_infusao_p);

	if (qt_equipo_w > 0) then

		select	coalesce(max(qt_solucao),0)
		into STRICT	qt_vol_total_w
		from	prescr_material
		where	nr_sequencia	= nr_sequencia_p
		and		nr_prescricao	= nr_prescricao_p;

		if (qt_vol_total_w > 0) then

			qt_distribuir_w	:= (qt_equipo_w + qt_volume_solucao_p);

			if (qt_distribuir_w >= 0) then
				qt_vol_cor_w	:= dividir(qt_distribuir_w, qt_volume_solucao_p) * qt_vol_total_w;

				update	prescr_material
				set		qt_volume_corrigido	= coalesce(qt_vol_cor_w,0)
				where	nr_sequencia	= nr_sequencia_p
				and		nr_prescricao	= nr_prescricao_p;

				qt_volume_corrigido_p	:= coalesce(qt_vol_cor_w,0);

			else
				update	prescr_material
				set	qt_volume_corrigido	= qt_solucao
				where	nr_sequencia		= nr_sequencia_p
				and	nr_prescricao		= nr_prescricao_p;

				qt_volume_corrigido_p	:= coalesce(qt_vol_total_w,0);

			end if;
			if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
		end if;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ajustar_vol_equipo_solucao ( qt_volume_solucao_p bigint, nr_prescricao_p bigint, nr_sequencia_p bigint, ie_bomba_infusao_p text, ie_correcao_p text, nr_etapas_p bigint, qt_volume_corrigido_p INOUT bigint) FROM PUBLIC;

