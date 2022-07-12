-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_solucao (ie_tipo_solucao_p bigint, nr_prescricao_p bigint, nr_seq_solucao_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


nr_sequencia_w	bigint;
vl_retorno_w		double precision;
qt_dosagem_w		double precision;
qt_vol_infundido_w	double precision;
qt_vol_desprezado_w	double precision;
qt_volume_total_w	double precision;
qt_vol_desprezado_etapa_w prescr_solucao_evento.qt_vol_desprezado%type;

/*
VA - Velocidade de infusão atual
VI - Volume infundido atual
VD - Volume desprezado atual
VR - Volume restante
VID - Volume infundido atual + Volume desprezado atual
*/
BEGIN
if (ie_tipo_solucao_p IS NOT NULL AND ie_tipo_solucao_p::text <> '') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_solucao_p IS NOT NULL AND nr_seq_solucao_p::text <> '') and (ie_opcao_p IS NOT NULL AND ie_opcao_p::text <> '') then
	if (ie_tipo_solucao_p = 1) then --solucao
		if (ie_opcao_p in ('VA')) then
			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_sequencia_w
			from	prescr_solucao_evento
			where	nr_prescricao		= nr_prescricao_p
			and	nr_seq_solucao	= nr_seq_solucao_p
			and	ie_tipo_solucao	= 1
			and	ie_alteracao		in (1,3,5)
			and	ie_evento_valido	= 'S';

			if (nr_sequencia_w > 0) then
				select	qt_dosagem
				into STRICT	qt_dosagem_w
				from	prescr_solucao_evento
				where	nr_sequencia = nr_sequencia_w;

				if (ie_opcao_p = 'VA') then
					vl_retorno_w := qt_dosagem_w;
				end if;
			end if;

		elsif (ie_opcao_p in ('VI','VD','VR')) then
			select	sum(qt_vol_infundido),
				sum(qt_vol_desprezado)
			into STRICT	qt_vol_infundido_w,
				qt_vol_desprezado_w
			from	prescr_solucao_evento
			where	nr_prescricao		= nr_prescricao_p
			and	nr_seq_solucao	= nr_seq_solucao_p
			and	ie_tipo_solucao	= 1
			and	((ie_alteracao	<> 2) or (obter_se_evento_troca_frasco(nr_sequencia) = 'S'))
			and	ie_alteracao		in (2,4)
			and	ie_evento_valido	= 'S';

			if (ie_opcao_p = 'VI') then
				vl_retorno_w	:= qt_vol_infundido_w;
			elsif (ie_opcao_p = 'VD') then
				vl_retorno_w	:= qt_vol_desprezado_w;
			elsif (ie_opcao_p = 'VR') then
				--select	nvl(qt_solucao_total,0)
				select	coalesce(qt_solucao_total,qt_vol_infundido_w + qt_vol_desprezado_w)
				into STRICT	qt_volume_total_w
				from	prescr_solucao
				where	nr_prescricao	= nr_prescricao_p
				and	nr_seq_solucao = nr_seq_solucao_p;

 			vl_retorno_w	:= qt_volume_total_w - coalesce(qt_vol_infundido_w,0) - coalesce(qt_vol_desprezado_w,0);
			elsif (ie_opcao_p = 'VID') then
				vl_retorno_w	:= qt_vol_infundido_w + qt_vol_desprezado_w;
			end if;
		end if;

	elsif (ie_tipo_solucao_p = 2) then --suporte nutricional enteral
		if (ie_opcao_p in ('VA')) then
			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_sequencia_w
			from	prescr_solucao_evento
			where	nr_prescricao		= nr_prescricao_p
			and	nr_seq_material	= nr_seq_solucao_p
			and	ie_tipo_solucao	= 2
			and	ie_alteracao		in (1,3,5)
			and	ie_evento_valido	= 'S';

			if (nr_sequencia_w > 0) then
				select	qt_dosagem
				into STRICT	qt_dosagem_w
				from	prescr_solucao_evento
				where	nr_sequencia = nr_sequencia_w;

				if (ie_opcao_p = 'VA') then
					vl_retorno_w := qt_dosagem_w;
				end if;
			end if;

		elsif (ie_opcao_p in ('VI','VD','VR')) then
			select 	sum(qt_vol_infundido)
			into STRICT	qt_vol_infundido_w
			from	prescr_solucao_evento
			where 	nr_prescricao	 = nr_prescricao_p
			and		nr_seq_material	 = nr_seq_solucao_p
			and		ie_tipo_solucao	 = 2
			and		((ie_alteracao	<> 2) or (obter_se_evento_troca_frasco(nr_sequencia) = 'S'))
			and		ie_alteracao	 in (2,4)
			and		ie_evento_valido = 'S';
				
			select 	coalesce(max(qt_vol_desprezado), 0)
			into STRICT 	qt_vol_desprezado_etapa_w
			from 	prescr_solucao_evento	a
			where 	a.nr_prescricao 	= nr_prescricao_p
			and		a.nr_seq_material 	= nr_seq_solucao_p
			and 	a.ie_tipo_solucao 	= 2
			and		obter_se_evento_troca_frasco(a.nr_sequencia) = 'N'
			and		a.nr_sequencia = (	SELECT 	max(nr_sequencia)
										from 	prescr_solucao_evento x
										where	x.nr_prescricao 	= nr_prescricao_p
										and		x.nr_seq_material	= nr_seq_solucao_p
										and		x.ie_tipo_solucao	= 2);

			if (ie_opcao_p = 'VI') then
				vl_retorno_w	:= qt_vol_infundido_w;
			elsif (ie_opcao_p = 'VD') then
				vl_retorno_w	:= qt_vol_desprezado_etapa_w;
			elsif (ie_opcao_p = 'VR') then
				select	coalesce(qt_dose,0)
				into STRICT	qt_volume_total_w
				from	prescr_material
				where	nr_prescricao	= nr_prescricao_p
				and	nr_sequencia	= nr_seq_solucao_p
				and	ie_agrupador	= 8;

 			--vl_retorno_w	:= qt_volume_total_w - qt_vol_infundido_w;
 			vl_retorno_w	:= qt_volume_total_w - coalesce(qt_vol_infundido_w,0) - coalesce(qt_vol_desprezado_w,0);
			elsif (ie_opcao_p = 'VID') then
				vl_retorno_w	:= qt_vol_infundido_w + qt_vol_desprezado_w;			
			end if;
		end if;

	elsif (ie_tipo_solucao_p = 3) then --hemocomponente
		if (ie_opcao_p in ('VA')) then
			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_sequencia_w
			from	prescr_solucao_evento
			where	nr_prescricao		= nr_prescricao_p
			and	nr_seq_procedimento	= nr_seq_solucao_p
			and	ie_tipo_solucao	= 3
			and	ie_alteracao		in (1,3,5)
			and	ie_evento_valido	= 'S';

			if (nr_sequencia_w > 0) then
				select	qt_dosagem
				into STRICT	qt_dosagem_w
				from	prescr_solucao_evento
				where	nr_sequencia = nr_sequencia_w;

				if (ie_opcao_p = 'VA') then
					vl_retorno_w := qt_dosagem_w;
				end if;
			end if;

		elsif (ie_opcao_p in ('VI','VD','VR')) then
			select	sum(qt_vol_infundido),
				sum(qt_vol_desprezado)
			into STRICT	qt_vol_infundido_w,
				qt_vol_desprezado_w
			from	prescr_solucao_evento
			where	nr_prescricao		= nr_prescricao_p
			and	nr_seq_procedimento	= nr_seq_solucao_p
			and	ie_tipo_solucao	= 3
			and	ie_alteracao		in (2,4)
			and	ie_evento_valido	= 'S';

			if (ie_opcao_p = 'VI') then
				vl_retorno_w	:= qt_vol_infundido_w;
			elsif (ie_opcao_p = 'VD') then
				vl_retorno_w	:= qt_vol_desprezado_w;
			elsif (ie_opcao_p = 'VR') then
				select	coalesce(qt_vol_hemocomp,(obter_volume_hemocomponente(nr_seq_derivado,'V'))::numeric )
				into STRICT	qt_volume_total_w
				from	prescr_procedimento
				where	nr_prescricao		= nr_prescricao_p
				and	nr_sequencia		= nr_seq_solucao_p
				and	(nr_seq_solic_sangue IS NOT NULL AND nr_seq_solic_sangue::text <> '')
				and	(nr_seq_derivado IS NOT NULL AND nr_seq_derivado::text <> '');

 			--vl_retorno_w	:= qt_volume_total_w - qt_vol_infundido_w;
 			vl_retorno_w	:= qt_volume_total_w - coalesce(qt_vol_infundido_w,0) - coalesce(qt_vol_desprezado_w,0);
			elsif (ie_opcao_p = 'VID') then
				vl_retorno_w	:= qt_vol_infundido_w + qt_vol_desprezado_w;			
			end if;
		end if;

	elsif (ie_tipo_solucao_p = 4) then --npt adulto
		if (ie_opcao_p in ('VA')) then
			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_sequencia_w
			from	prescr_solucao_evento
			where	nr_prescricao		= nr_prescricao_p
			and	nr_seq_nut		= nr_seq_solucao_p
			and	ie_tipo_solucao	= 4
			and	ie_alteracao		in (1,3,5)
			and	ie_evento_valido	= 'S';

			if (nr_sequencia_w > 0) then
				select	qt_dosagem
				into STRICT	qt_dosagem_w
				from	prescr_solucao_evento
				where	nr_sequencia = nr_sequencia_w;

				if (ie_opcao_p = 'VA') then
					vl_retorno_w := qt_dosagem_w;
				end if;
			end if;

		elsif (ie_opcao_p in ('VI','VD','VR')) then
			select	sum(qt_vol_infundido),
				sum(qt_vol_desprezado)
			into STRICT	qt_vol_infundido_w,
				qt_vol_desprezado_w
			from	prescr_solucao_evento
			where	nr_prescricao		= nr_prescricao_p
			and	nr_seq_nut		= nr_seq_solucao_p
			and	ie_tipo_solucao	= 4
			and	ie_alteracao		in (2,4)
			and	ie_evento_valido	= 'S';

			if (ie_opcao_p = 'VI') then
				vl_retorno_w	:= qt_vol_infundido_w;
			elsif (ie_opcao_p = 'VD') then
				vl_retorno_w	:= qt_vol_desprezado_w;
			elsif (ie_opcao_p = 'VR') then
				--select	obter_volume_nut_pac(nr_sequencia)
				select	obter_vol_nut_pac_fase(nr_sequencia,0)
				into STRICT	qt_volume_total_w
				from	nut_paciente
				where	nr_prescricao		= nr_prescricao_p
				and	nr_sequencia		= nr_seq_solucao_p;

 			--vl_retorno_w	:= qt_volume_total_w - qt_vol_infundido_w;
 			vl_retorno_w	:= qt_volume_total_w - coalesce(qt_vol_infundido_w,0) - coalesce(qt_vol_desprezado_w,0);
			elsif (ie_opcao_p = 'VID') then
				vl_retorno_w	:= qt_vol_infundido_w + qt_vol_desprezado_w;			
			end if;
		end if;

	elsif (ie_tipo_solucao_p = 5) then --npt neo
		if (ie_opcao_p in ('VA')) then
			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_sequencia_w
			from	prescr_solucao_evento
			where	nr_prescricao		= nr_prescricao_p
			and	nr_seq_nut_neo	= nr_seq_solucao_p
			and	ie_tipo_solucao	= 5
			and	ie_alteracao		in (1,3,5)
			and	ie_evento_valido	= 'S';

			if (nr_sequencia_w > 0) then
				select	qt_dosagem
				into STRICT	qt_dosagem_w
				from	prescr_solucao_evento
				where	nr_sequencia = nr_sequencia_w;

				if (ie_opcao_p = 'VA') then
					vl_retorno_w := qt_dosagem_w;
				end if;
			end if;

		elsif (ie_opcao_p in ('VI','VD','VR')) then
			select	sum(qt_vol_infundido),
				sum(qt_vol_desprezado)
			into STRICT	qt_vol_infundido_w,
				qt_vol_desprezado_w
			from	prescr_solucao_evento
			where	nr_prescricao		= nr_prescricao_p
			and	nr_seq_nut_neo	= nr_seq_solucao_p
			and	ie_tipo_solucao	= 5
			and	ie_alteracao		in (2,4)
			and	ie_evento_valido	= 'S';

			if (ie_opcao_p = 'VI') then
				vl_retorno_w	:= qt_vol_infundido_w;
			elsif (ie_opcao_p = 'VD') then
				vl_retorno_w	:= qt_vol_desprezado_w;
			elsif (ie_opcao_p = 'VR') then
				select	obter_volume_nut_pac_neo(nr_sequencia)
				into STRICT	qt_volume_total_w
				from	nut_pac
				where	nr_prescricao		= nr_prescricao_p
				and	nr_sequencia		= nr_seq_solucao_p;

 			--vl_retorno_w	:= qt_volume_total_w - qt_vol_infundido_w;
 			vl_retorno_w	:= qt_volume_total_w - coalesce(qt_vol_infundido_w,0) - coalesce(qt_vol_desprezado_w,0);
			elsif (ie_opcao_p = 'VID') then
				vl_retorno_w	:= qt_vol_infundido_w + qt_vol_desprezado_w;			
			end if;
		end if;
	elsif (ie_tipo_solucao_p = 6) then --npt Adulta2
		if (ie_opcao_p in ('VA')) then
			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_sequencia_w
			from	prescr_solucao_evento
			where	nr_prescricao		= nr_prescricao_p
			and	nr_seq_nut_neo		= nr_seq_solucao_p
			and	ie_tipo_solucao		= 6
			and	ie_alteracao		in (1,3,5)
			and	ie_evento_valido		= 'S';

			if (nr_sequencia_w > 0) then
				select	qt_dosagem
				into STRICT	qt_dosagem_w
				from	prescr_solucao_evento
				where	nr_sequencia = nr_sequencia_w;

				if (ie_opcao_p = 'VA') then
					vl_retorno_w := qt_dosagem_w;
				end if;
			end if;

		elsif (ie_opcao_p in ('VI','VD','VR')) then
			select	sum(qt_vol_infundido),
				sum(qt_vol_desprezado)
			into STRICT	qt_vol_infundido_w,
				qt_vol_desprezado_w
			from	prescr_solucao_evento
			where	nr_prescricao		= nr_prescricao_p
			and	nr_seq_nut_neo		= nr_seq_solucao_p
			and	ie_tipo_solucao		= 6
			and	ie_alteracao		in (2,4)
			and	ie_evento_valido		= 'S';

			if (ie_opcao_p = 'VI') then
				vl_retorno_w	:= qt_vol_infundido_w;
			elsif (ie_opcao_p = 'VD') then
				vl_retorno_w	:= qt_vol_desprezado_w;
			elsif (ie_opcao_p = 'VR') then
				--select	obter_volume_nut_pac(nr_sequencia)
				select	obter_vol_nut_pac_fase(nr_sequencia,0)
				into STRICT	qt_volume_total_w
				from	nut_paciente
				where	nr_prescricao		= nr_prescricao_p
				and	nr_sequencia		= nr_seq_solucao_p;

 			--vl_retorno_w	:= qt_volume_total_w - qt_vol_infundido_w;
 			vl_retorno_w	:= qt_volume_total_w - coalesce(qt_vol_infundido_w,0) - coalesce(qt_vol_desprezado_w,0);
			elsif (ie_opcao_p = 'VID') then
				vl_retorno_w	:= qt_vol_infundido_w + qt_vol_desprezado_w;			
			end if;
		end if;
	end if;
end if;

if (ie_opcao_p <> 'VA') then
	return coalesce(vl_retorno_w,0);
else
	return vl_retorno_w;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_solucao (ie_tipo_solucao_p bigint, nr_prescricao_p bigint, nr_seq_solucao_p bigint, ie_opcao_p text) FROM PUBLIC;

