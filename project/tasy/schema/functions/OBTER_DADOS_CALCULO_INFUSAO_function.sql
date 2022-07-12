-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_calculo_infusao ( ie_tipo_solucao_p bigint, nr_prescricao_p bigint, nr_seq_solucao_p bigint, nr_seq_acao_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


qt_volume_parcial_w	double precision;
qt_veloc_anterior_w	double precision;
nr_seq_evento_w		bigint;
dt_veloc_anterior_w	timestamp;

vl_retorno_w		varchar(240);


BEGIN
if (ie_tipo_solucao_p IS NOT NULL AND ie_tipo_solucao_p::text <> '') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_solucao_p IS NOT NULL AND nr_seq_solucao_p::text <> '') and (nr_seq_acao_p IS NOT NULL AND nr_seq_acao_p::text <> '') and (ie_opcao_p IS NOT NULL AND ie_opcao_p::text <> '') then
	begin
	if (ie_tipo_solucao_p = 1) then
		begin
		if (ie_opcao_p = 'VP') then
			begin
			select	coalesce(sum(coalesce(qt_vol_parcial,0)),0)
			into STRICT	qt_volume_parcial_w
			from	prescr_solucao_evento
			where	ie_tipo_solucao		= ie_tipo_solucao_p
			and	nr_prescricao		= nr_prescricao_p
			and	nr_seq_solucao		= nr_seq_solucao_p
			and	ie_evento_valido	= 'S'
			and	nr_sequencia		< nr_seq_acao_p;

			vl_retorno_w	:= qt_volume_parcial_w;
			end;
		elsif (ie_opcao_p = 'VA') then
			begin
			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_evento_w
			from	prescr_solucao_evento
			where	ie_tipo_solucao		= ie_tipo_solucao_p
			and	nr_prescricao		= nr_prescricao_p
			and	nr_seq_solucao		= nr_seq_solucao_p
			and	ie_evento_valido	= 'S'
			and	ie_alteracao		in (1,3,5)
			and	nr_sequencia		< nr_seq_acao_p;

			if (nr_seq_evento_w > 0) then
				begin
				select	max(qt_dosagem)
				into STRICT	qt_veloc_anterior_w
				from	prescr_solucao_evento
				where	nr_sequencia = nr_seq_evento_w;

				vl_retorno_w	:= qt_veloc_anterior_w;
				end;
			end if;
			end;
		elsif (ie_opcao_p = 'DVA') then
			begin
			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_evento_w
			from	prescr_solucao_evento
			where	ie_tipo_solucao		= ie_tipo_solucao_p
			and	nr_prescricao		= nr_prescricao_p
			and	nr_seq_solucao		= nr_seq_solucao_p
			and	ie_evento_valido	= 'S'
			and	ie_alteracao		in (1,3,5)
			and	nr_sequencia		< nr_seq_acao_p;

			if (nr_seq_evento_w > 0) then
				begin
				select	max(dt_alteracao)
				into STRICT	dt_veloc_anterior_w
				from	prescr_solucao_evento
				where	nr_sequencia = nr_seq_evento_w;

				vl_retorno_w	:= to_char(dt_veloc_anterior_w,'dd/mm/yyyy hh24:mi:ss');
				end;
			end if;
			end;
		elsif (ie_opcao_p = 'VAS') then
			begin
			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_evento_w
			from	prescr_solucao_evento
			where	ie_tipo_solucao		= ie_tipo_solucao_p
			and	nr_prescricao		= nr_prescricao_p
			and	nr_seq_solucao		= nr_seq_solucao_p
			and	ie_evento_valido	= 'S'
			and	ie_alteracao		in (1,3,5)
			and	nr_sequencia		<= nr_seq_acao_p;

			if (nr_seq_evento_w > 0) then
				begin
				select	max(qt_dosagem)
				into STRICT	qt_veloc_anterior_w
				from	prescr_solucao_evento
				where	nr_sequencia = nr_seq_evento_w;

				vl_retorno_w	:= qt_veloc_anterior_w;
				end;
			end if;
			end;
		end if;
		end;
	elsif (ie_tipo_solucao_p = 2) then
		if (ie_opcao_p = 'VP') then
			begin
			select	coalesce(sum(coalesce(qt_vol_parcial,0)),0)
			into STRICT	qt_volume_parcial_w
			from	prescr_solucao_evento
			where	ie_tipo_solucao		= ie_tipo_solucao_p
			and	nr_prescricao		= nr_prescricao_p
			and	nr_seq_material		= nr_seq_solucao_p
			and	ie_evento_valido	= 'S'
			and	nr_sequencia		< nr_seq_acao_p;

			vl_retorno_w	:= qt_volume_parcial_w;
			end;
		elsif (ie_opcao_p = 'VA') then
			begin
			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_evento_w
			from	prescr_solucao_evento
			where	ie_tipo_solucao		= ie_tipo_solucao_p
			and	nr_prescricao		= nr_prescricao_p
			and	nr_seq_material		= nr_seq_solucao_p
			and	ie_evento_valido	= 'S'
			and	ie_alteracao		in (1,3,5)
			and	nr_sequencia		< nr_seq_acao_p;

			if (nr_seq_evento_w > 0) then
				begin
				select	max(qt_dosagem)
				into STRICT	qt_veloc_anterior_w
				from	prescr_solucao_evento
				where	nr_sequencia = nr_seq_evento_w;

				vl_retorno_w	:= qt_veloc_anterior_w;
				end;
			end if;
			end;
		elsif (ie_opcao_p = 'DVA') then
			begin
			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_evento_w
			from	prescr_solucao_evento
			where	ie_tipo_solucao		= ie_tipo_solucao_p
			and	nr_prescricao		= nr_prescricao_p
			and	nr_seq_material		= nr_seq_solucao_p
			and	ie_evento_valido	= 'S'
			and	ie_alteracao		in (1,3,5)
			and	nr_sequencia		< nr_seq_acao_p;

			if (nr_seq_evento_w > 0) then
				begin
				select	max(dt_alteracao)
				into STRICT	dt_veloc_anterior_w
				from	prescr_solucao_evento
				where	nr_sequencia = nr_seq_evento_w;

				vl_retorno_w	:= to_char(dt_veloc_anterior_w,'dd/mm/yyyy hh24:mi:ss');
				end;
			end if;
			end;
		elsif (ie_opcao_p = 'VAS') then
			begin
			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_evento_w
			from	prescr_solucao_evento
			where	ie_tipo_solucao		= ie_tipo_solucao_p
			and	nr_prescricao		= nr_prescricao_p
			and	nr_seq_material		= nr_seq_solucao_p
			and	ie_evento_valido	= 'S'
			and	ie_alteracao		in (1,3,5)
			and	nr_sequencia		<= nr_seq_acao_p;

			if (nr_seq_evento_w > 0) then
				begin
				select	max(qt_dosagem)
				into STRICT	qt_veloc_anterior_w
				from	prescr_solucao_evento
				where	nr_sequencia = nr_seq_evento_w;

				vl_retorno_w	:= qt_veloc_anterior_w;
				end;
			end if;
			end;
		end if;
	end if;
	end;
end if;
return vl_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_calculo_infusao ( ie_tipo_solucao_p bigint, nr_prescricao_p bigint, nr_seq_solucao_p bigint, nr_seq_acao_p bigint, ie_opcao_p text) FROM PUBLIC;
