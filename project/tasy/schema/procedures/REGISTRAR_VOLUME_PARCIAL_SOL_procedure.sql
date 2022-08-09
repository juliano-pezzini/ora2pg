-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE registrar_volume_parcial_sol (nr_atendimento_p bigint, nr_prescricao_p bigint, nr_seq_solucao_p bigint, ie_tipo_solucao_p bigint, qt_volume_p bigint, dt_volume_p timestamp, ds_justificativa_p text, nm_usuario_p text, qt_volume_fase_p prescr_solucao_evento.qt_volume_fase%type, seq_bomba_infusao_p prescr_solucao_evento.nr_seq_bomba_event%type default null) AS $body$
DECLARE


nr_seq_evento_w	bigint;


BEGIN
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_solucao_p IS NOT NULL AND nr_seq_solucao_p::text <> '') and (ie_tipo_solucao_p IS NOT NULL AND ie_tipo_solucao_p::text <> '') and (qt_volume_p IS NOT NULL AND qt_volume_p::text <> '') and (dt_volume_p IS NOT NULL AND dt_volume_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then

	if (ie_tipo_solucao_p = 1) then

		select	nextval('prescr_solucao_evento_seq')
		into STRICT	nr_seq_evento_w
		;

		insert into prescr_solucao_evento(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_prescricao,
			nr_seq_solucao,
			qt_dosagem,
			cd_pessoa_fisica,
			ie_alteracao,
			dt_alteracao,
			ds_observacao,
			ie_tipo_dosagem,
			qt_vol_infundido,
			qt_vol_desprezado,
			ie_evento_valido,
			nr_seq_motivo,
			nr_seq_material,
			ie_tipo_solucao,
			nr_seq_procedimento,
			nr_seq_nut,
			nr_seq_nut_neo,
			ie_forma_infusao,
			ds_duracao,
			dt_prev_termino,
			qt_vol_parcial,
			qt_volume_fase,
			nr_atendimento,
			qt_volume_parcial,
			ds_justificativa,
			nr_seq_bomba_event)
		values (
			nr_seq_evento_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_prescricao_p,
			nr_seq_solucao_p,
			null,
			obter_dados_usuario_opcao(nm_usuario_p,'C'),
			14,
			--sysdate,
			dt_volume_p,
			null,
			null,
			null,
			null,
			'S',
			null,
			null,
			ie_tipo_solucao_p,
			null,
			null,
			null,
			null,
			null,
			null,
			null,
			qt_volume_fase_p,--OS125857
			nr_atendimento_p,
			qt_volume_p,
			ds_justificativa_p,
			seq_bomba_infusao_p);

	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE registrar_volume_parcial_sol (nr_atendimento_p bigint, nr_prescricao_p bigint, nr_seq_solucao_p bigint, ie_tipo_solucao_p bigint, qt_volume_p bigint, dt_volume_p timestamp, ds_justificativa_p text, nm_usuario_p text, qt_volume_fase_p prescr_solucao_evento.qt_volume_fase%type, seq_bomba_infusao_p prescr_solucao_evento.nr_seq_bomba_event%type default null) FROM PUBLIC;
