-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_valor_susp_solucao (ie_tipo_solucao_p bigint, nr_prescricao_p bigint, nr_seq_solucao_p bigint, qt_volume_p bigint, ie_suspender_p text, nm_usuario_p text) AS $body$
DECLARE


ie_acm_sn_w	varchar(1);
ie_status_w	varchar(15);


BEGIN
if (ie_tipo_solucao_p IS NOT NULL AND ie_tipo_solucao_p::text <> '') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_solucao_p IS NOT NULL AND nr_seq_solucao_p::text <> '') and (qt_volume_p IS NOT NULL AND qt_volume_p::text <> '') and (qt_volume_p > 0) and (ie_suspender_p IS NOT NULL AND ie_suspender_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then

	if (ie_tipo_solucao_p = 1) then -- solucoes
		select	obter_se_acm_sn(ie_acm,ie_se_necessario),
			ie_status
		into STRICT	ie_acm_sn_w,
			ie_status_w
		from	prescr_solucao
		where	nr_prescricao = nr_prescricao_p
		and	nr_seq_solucao = nr_seq_solucao_p;


		if (ie_acm_sn_w <> 'S') or (ie_status_w <> 'N') then
			begin
			if (ie_suspender_p = 'S') then
				update	prescr_solucao
				set	qt_volume_suspenso	= coalesce(qt_volume_suspenso,0) + qt_volume_p,
					nr_etapas_suspensa	= coalesce(nr_etapas_suspensa,0) + 1
				where	nr_prescricao		= nr_prescricao_p
				and	nr_seq_solucao	= nr_seq_solucao_p;
			elsif (ie_suspender_p = 'N') then
				update	prescr_solucao
				set	qt_volume_suspenso	= CASE WHEN qt_volume_suspenso - qt_volume_p=0 THEN  null  ELSE qt_volume_suspenso - qt_volume_p END ,
					nr_etapas_suspensa	= CASE WHEN nr_etapas_suspensa - 1=0 THEN  null  ELSE nr_etapas_suspensa - 1 END
				where	nr_prescricao		= nr_prescricao_p
				and	nr_seq_solucao	= nr_seq_solucao_p;
			end if;
			end;
		elsif (ie_acm_sn_w = 'S') and (ie_status_w = 'N') then
			begin
			update	prescr_solucao
			set	dt_status  = NULL
			where	nr_prescricao		= nr_prescricao_p
			and	nr_seq_solucao	= nr_seq_solucao_p;
			end;
		end if;

	elsif (ie_tipo_solucao_p = 3) then -- hemoterapia
		if (ie_suspender_p = 'S') then
			update	prescr_procedimento
			set	qt_volume_suspenso	= coalesce(qt_volume_suspenso,0) + qt_volume_p,
				nr_etapas_suspensa	= coalesce(nr_etapas_suspensa,0) + 1
			where	nr_prescricao		= nr_prescricao_p
			and	nr_sequencia		= nr_seq_solucao_p
			and	(nr_seq_solic_sangue IS NOT NULL AND nr_seq_solic_sangue::text <> '')
			and	(nr_seq_derivado IS NOT NULL AND nr_seq_derivado::text <> '');

		elsif (ie_suspender_p = 'N') then
			update	prescr_procedimento
			set	qt_volume_suspenso	= CASE WHEN qt_volume_suspenso - qt_volume_p=0 THEN  null  ELSE qt_volume_suspenso - qt_volume_p END ,
				nr_etapas_suspensa	= CASE WHEN nr_etapas_suspensa - 1=0 THEN  null  ELSE nr_etapas_suspensa - 1 END
			where	nr_prescricao		= nr_prescricao_p
			and	nr_sequencia		= nr_seq_solucao_p
			and	(nr_seq_solic_sangue IS NOT NULL AND nr_seq_solic_sangue::text <> '')
			and	(nr_seq_derivado IS NOT NULL AND nr_seq_derivado::text <> '');
		end if;

	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_valor_susp_solucao (ie_tipo_solucao_p bigint, nr_prescricao_p bigint, nr_seq_solucao_p bigint, qt_volume_p bigint, ie_suspender_p text, nm_usuario_p text) FROM PUBLIC;
