-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_dil_proced ( nr_prescricao_p bigint, nr_sequencia_p bigint, ie_alter_medico_p text, cd_material_p bigint, qt_dose_p bigint, qt_solucao_p bigint, cd_um_dose_p text, ie_excluir_rediluicao_p text, nm_usuario_P text) AS $body$
BEGIN
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	delete	FROM prescr_material
	where	nr_prescricao		= nr_prescricao_p
	and	nr_sequencia_diluicao	= nr_sequencia_p
	and	ie_agrupador		= 3;

	update	prescr_material
	set	qt_hora_aplicacao	 = NULL,
		qt_min_aplicacao	 = NULL,
		qt_solucao		 = NULL,
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp()
	where	nr_prescricao		= nr_prescricao_p
	and	nr_sequencia		= nr_sequencia_p;

	if (ie_alter_medico_p = 'S') then
		begin
		CALL gerar_historico_dil_red_rec(
			'N',
			3,
			3,
			nr_prescricao_p,
			nr_sequencia_p,
			cd_material_p,
			0,
			qt_dose_p,
			0,
			qt_solucao_p,
			0,
			cd_um_dose_p,
			null,
			wheb_usuario_pck.get_cd_estabelecimento,
			nm_usuario_p);
		end;
	end if;

	if (ie_excluir_rediluicao_p = 'S') then
		begin
		CALL excluir_rediluicao(
			nr_prescricao_p,
			nr_sequencia_p,
			wheb_usuario_pck.get_cd_perfil,
			wheb_usuario_pck.get_cd_estabelecimento,
			nm_usuario_P);

		end;
	elsif (ie_excluir_rediluicao_p = 'P') then
		begin
		delete	FROM prescr_material
		where	nr_prescricao		= nr_prescricao_p
		and	nr_sequencia_diluicao   = nr_sequencia_p
		and	ie_agrupador		= 7;
		end;
	end if;
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_dil_proced ( nr_prescricao_p bigint, nr_sequencia_p bigint, ie_alter_medico_p text, cd_material_p bigint, qt_dose_p bigint, qt_solucao_p bigint, cd_um_dose_p text, ie_excluir_rediluicao_p text, nm_usuario_P text) FROM PUBLIC;

