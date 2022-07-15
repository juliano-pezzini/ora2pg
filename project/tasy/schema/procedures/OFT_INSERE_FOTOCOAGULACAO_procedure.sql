-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE oft_insere_fotocoagulacao ( nr_seq_consulta_p bigint, nr_seq_consulta_form_p bigint, nr_seq_consulta_form_ant_p bigint, vListaFotocoagulacao strRecTypeFormOft) AS $body$
DECLARE


nr_sequencia_w					oft_fotocoagulacao_laser.nr_sequencia%type;
dt_exame_w						oft_fotocoagulacao_laser.dt_registro%type;
ds_observacao_w				oft_fotocoagulacao_laser.ds_observacao%type;
ie_olho_w						oft_fotocoagulacao_laser.ie_olho%type;
ie_laser_w						oft_fotocoagulacao_laser.ie_laser%type;
nr_disparo_posterior_w		oft_fotocoagulacao_laser.nr_disparo_posterior%type;
nr_disparo_superior_w		oft_fotocoagulacao_laser.nr_disparo_superior%type;
nr_disparo_inferior_w		oft_fotocoagulacao_laser.nr_disparo_inferior%type;
nr_disparo_nasal_w			oft_fotocoagulacao_laser.nr_disparo_nasal%type;
nr_disparo_temporal_w		oft_fotocoagulacao_laser.nr_disparo_temporal%type;
nr_disparo_inf_nasal_w		oft_fotocoagulacao_laser.nr_disparo_inf_nasal%type;
nr_disparo_sup_nasal_w		oft_fotocoagulacao_laser.nr_disparo_sup_nasal%type;
nr_disparo_inf_temporal_w	oft_fotocoagulacao_laser.nr_disparo_inf_temporal%type;
nr_disparo_sup_temporal_w	oft_fotocoagulacao_laser.nr_disparo_sup_temporal%type;
nr_disparo_macula_w			oft_fotocoagulacao_laser.nr_disparo_macula%type;
nr_mira_w						oft_fotocoagulacao_laser.nr_mira%type;
qt_intervalo_w					oft_fotocoagulacao_laser.qt_intervalo%type;
qt_potencia_posterior_w		oft_fotocoagulacao_laser.qt_potencia_posterior%type;
qt_potencia_superior_w		oft_fotocoagulacao_laser.qt_potencia_superior%type;
qt_potencia_inferior_w		oft_fotocoagulacao_laser.qt_potencia_inferior%type;
qt_potencia_nasal_w			oft_fotocoagulacao_laser.qt_potencia_nasal%type;
qt_potencia_temporal_w		oft_fotocoagulacao_laser.qt_potencia_temporal%type;
qt_potencia_inf_nasal_w		oft_fotocoagulacao_laser.qt_potencia_inf_nasal%type;
qt_potencia_sup_nasal_w		oft_fotocoagulacao_laser.qt_potencia_sup_nasal%type;
qt_potencia_inf_temporal_w	oft_fotocoagulacao_laser.qt_potencia_inf_temporal%type;
qt_potencia_sup_temporal_w	oft_fotocoagulacao_laser.qt_potencia_sup_temporal%type;
qt_potencia_macula_w			oft_fotocoagulacao_laser.qt_potencia_macula%type;
cd_profissional_w				oft_fotocoagulacao_laser.cd_profissional%type;
nm_usuario_w					usuario.nm_usuario%type := wheb_usuario_pck.get_nm_usuario;
ie_registrado_w				varchar(1) := 'N';
ds_erro_w						varchar(4000);

BEGIN
begin

if (coalesce(nr_seq_consulta_p,0) > 0) and (vListaFotocoagulacao.count > 0) then
	for i in 1..vListaFotocoagulacao.count loop
		begin
		if (vListaFotocoagulacao[i](.ds_valor IS NOT NULL AND .ds_valor::text <> '')) or (vListaFotocoagulacao[i](.nr_valor IS NOT NULL AND .nr_valor::text <> '')) then
			case upper(vListaFotocoagulacao[i].nm_campo)
				when 'CD_PROFISSIONAL' then
					cd_profissional_w						:= vListaFotocoagulacao[i].ds_valor;
				when 'DT_REGISTRO' then
					dt_exame_w 								:= pkg_date_utils.get_DateTime(vListaFotocoagulacao[i].ds_valor);
				when 'DS_OBSERVACAO' then
					ds_observacao_w						:= vListaFotocoagulacao[i].ds_valor;
					ie_registrado_w						:= 'S';
				when 'IE_OLHO' then
					ie_olho_w								:= vListaFotocoagulacao[i].ds_valor;
				when 'IE_LASER' then
					ie_laser_w								:= vListaFotocoagulacao[i].ds_valor;
				when 'NR_DISPARO_POSTERIOR' then
					nr_disparo_posterior_w				:= vListaFotocoagulacao[i].nr_valor;
					ie_registrado_w						:= 'S';
				when 'NR_DISPARO_SUPERIOR' then
					nr_disparo_superior_w				:= vListaFotocoagulacao[i].nr_valor;
					ie_registrado_w						:= 'S';
				when 'NR_DISPARO_INFERIOR' then
					nr_disparo_inferior_w				:= vListaFotocoagulacao[i].nr_valor;
					ie_registrado_w						:= 'S';
				when 'NR_DISPARO_NASAL' then
					nr_disparo_nasal_w					:= vListaFotocoagulacao[i].nr_valor;
					ie_registrado_w						:= 'S';
				when 'NR_DISPARO_TEMPORAL' then
					nr_disparo_temporal_w				:= vListaFotocoagulacao[i].nr_valor;
					ie_registrado_w						:= 'S';
				when 'NR_DISPARO_INF_NASAL' then
					nr_disparo_inf_nasal_w				:= vListaFotocoagulacao[i].nr_valor;
					ie_registrado_w						:= 'S';
				when 'NR_DISPARO_SUP_NASAL' then
					nr_disparo_sup_nasal_w				:= vListaFotocoagulacao[i].nr_valor;
					ie_registrado_w						:= 'S';
				when 'NR_DISPARO_INF_TEMPORAL' then
					nr_disparo_inf_temporal_w			:= vListaFotocoagulacao[i].nr_valor;
					ie_registrado_w						:= 'S';
				when 'NR_DISPARO_SUP_TEMPORAL' then
					nr_disparo_sup_temporal_w			:= vListaFotocoagulacao[i].nr_valor;
					ie_registrado_w						:= 'S';
				when 'NR_DISPARO_MACULA' then
					nr_disparo_macula_w					:= vListaFotocoagulacao[i].nr_valor;
					ie_registrado_w						:= 'S';
				when 'NR_MIRA' then
					nr_mira_w								:= vListaFotocoagulacao[i].nr_valor;
					ie_registrado_w						:= 'S';
				when 'QT_INTERVALO' then
					qt_intervalo_w							:= vListaFotocoagulacao[i].nr_valor;
					ie_registrado_w						:= 'S';
				when 'QT_POTENCIA_POSTERIOR' then
					qt_potencia_posterior_w				:= vListaFotocoagulacao[i].nr_valor;
					ie_registrado_w						:= 'S';
				when 'QT_POTENCIA_SUPERIOR' then
					qt_potencia_superior_w				:= vListaFotocoagulacao[i].nr_valor;
					ie_registrado_w						:= 'S';
				when 'QT_POTENCIA_INFERIOR' then
					qt_potencia_inferior_w				:= vListaFotocoagulacao[i].nr_valor;
					ie_registrado_w						:= 'S';
				when 'QT_POTENCIA_NASAL' then
					qt_potencia_nasal_w					:= vListaFotocoagulacao[i].nr_valor;
					ie_registrado_w						:= 'S';
				when 'QT_POTENCIA_TEMPORAL' then
					qt_potencia_temporal_w				:= vListaFotocoagulacao[i].nr_valor;
					ie_registrado_w						:= 'S';
				when 'QT_POTENCIA_INF_NASAL' then
					qt_potencia_inf_nasal_w				:= vListaFotocoagulacao[i].nr_valor;
					ie_registrado_w						:= 'S';
				when 'QT_POTENCIA_SUP_NASAL' then
					qt_potencia_sup_nasal_w				:= vListaFotocoagulacao[i].nr_valor;
					ie_registrado_w						:= 'S';
				when 'QT_POTENCIA_INF_TEMPORAL' then
					qt_potencia_inf_temporal_w			:= vListaFotocoagulacao[i].nr_valor;
					ie_registrado_w						:= 'S';
				when 'QT_POTENCIA_SUP_TEMPORAL' then
					qt_potencia_sup_temporal_w			:= vListaFotocoagulacao[i].nr_valor;
					ie_registrado_w						:= 'S';
				when 'QT_POTENCIA_MACULA' then
					qt_potencia_macula_w					:= vListaFotocoagulacao[i].nr_valor;
					ie_registrado_w						:= 'S';
				else
					null;
			end case;
		end if;
	end;
	end loop;


	select	max(nr_sequencia)
	into STRICT		nr_sequencia_w
	from		oft_fotocoagulacao_laser
	where		nr_seq_consulta_form = nr_seq_consulta_form_p
	and		nr_seq_consulta		= nr_seq_consulta_p
	and		coalesce(dt_liberacao::text, '') = ''
	and		nm_usuario				= nm_usuario_w;

	if (nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '') then
		update	oft_fotocoagulacao_laser
		set		dt_atualizacao				=	clock_timestamp(),
					nm_usuario					=	nm_usuario_w,
					cd_profissional			= coalesce(cd_profissional_w,cd_profissional),
					dt_registro					=	coalesce(dt_exame_w,dt_registro),
					ds_observacao				=	ds_observacao_w,
					ie_olho						=	ie_olho_w,
					ie_laser						=	ie_laser_w,
					nr_disparo_posterior		=	nr_disparo_posterior_w,
					nr_disparo_superior		=	nr_disparo_superior_w,
					nr_disparo_inferior		=	nr_disparo_inferior_w,
					nr_disparo_nasal			=	nr_disparo_nasal_w,
					nr_disparo_temporal		=	nr_disparo_temporal_w,
					nr_disparo_inf_nasal		=	nr_disparo_inf_nasal_w,
					nr_disparo_sup_nasal		=	nr_disparo_sup_nasal_w,
					nr_disparo_inf_temporal	=	nr_disparo_inf_temporal_w,
					nr_disparo_sup_temporal	=	nr_disparo_sup_temporal_w,
					nr_disparo_macula			=	nr_disparo_macula_w,
					nr_mira						=	nr_mira_w,
					qt_intervalo				=	qt_intervalo_w,
					qt_potencia_posterior	=	qt_potencia_posterior_w,
					qt_potencia_superior		=	qt_potencia_superior_w,
					qt_potencia_inferior		=	qt_potencia_inferior_w,
					qt_potencia_nasal			=	qt_potencia_nasal_w,
					qt_potencia_temporal		=	qt_potencia_temporal_w,
					qt_potencia_inf_nasal	=	qt_potencia_inf_nasal_w,
					qt_potencia_sup_nasal	=	qt_potencia_sup_nasal_w,
					qt_potencia_inf_temporal=	qt_potencia_inf_temporal_w,
					qt_potencia_sup_temporal=	qt_potencia_sup_temporal_w,
					qt_potencia_macula		=	qt_potencia_macula_w
		where		nr_sequencia				=	nr_sequencia_w;
		CALL wheb_usuario_pck.set_ie_commit('S');
	else
		if (ie_registrado_w = 'S') then
			CALL wheb_usuario_pck.set_ie_commit('S');
			select	nextval('oft_fotocoagulacao_laser_seq')
			into STRICT		nr_sequencia_w
			;

			insert	into oft_fotocoagulacao_laser(	nr_sequencia,
														dt_atualizacao,
														nm_usuario,
														dt_atualizacao_nrec,
														nm_usuario_nrec,
														cd_profissional,
														dt_registro,
														nr_seq_consulta,
														ie_situacao,
														ds_observacao,
														ie_olho,
														ie_laser,
														nr_disparo_posterior,
														nr_disparo_superior,
														nr_disparo_inferior,
														nr_disparo_nasal,
														nr_disparo_temporal,
														nr_disparo_inf_nasal,
														nr_disparo_sup_nasal,
														nr_disparo_inf_temporal,
														nr_disparo_sup_temporal,
														nr_disparo_macula,
														nr_mira,
														qt_intervalo,
														qt_potencia_posterior,
														qt_potencia_superior,
														qt_potencia_inferior,
														qt_potencia_nasal,
														qt_potencia_temporal,
														qt_potencia_inf_nasal,
														qt_potencia_sup_nasal,
														qt_potencia_inf_temporal,
														qt_potencia_sup_temporal,
														qt_potencia_macula,
														nr_seq_consulta_form
														)
			values (	nr_sequencia_w,
														clock_timestamp(),
														nm_usuario_w,
														clock_timestamp(),
														nm_usuario_w,
														coalesce(cd_profissional_w,obter_pf_usuario(nm_usuario_w,'C')),
														coalesce(dt_exame_w,clock_timestamp()),
														nr_seq_consulta_p,
														'A',
														ds_observacao_w,
														ie_olho_w,
														ie_laser_w,
														nr_disparo_posterior_w,
														nr_disparo_superior_w,
														nr_disparo_inferior_w,
														nr_disparo_nasal_w,
														nr_disparo_temporal_w,
														nr_disparo_inf_nasal_w,
														nr_disparo_sup_nasal_w,
														nr_disparo_inf_temporal_w,
														nr_disparo_sup_temporal_w,
														nr_disparo_macula_w,
														nr_mira_w,
														qt_intervalo_w,
														qt_potencia_posterior_w,
														qt_potencia_superior_w,
														qt_potencia_inferior_w,
														qt_potencia_nasal_w,
														qt_potencia_temporal_w,
														qt_potencia_inf_nasal_w,
														qt_potencia_sup_nasal_w,
														qt_potencia_inf_temporal_w,
														qt_potencia_sup_temporal_w,
														qt_potencia_macula_w,
														nr_seq_consulta_form_p);

			if (coalesce(nr_seq_consulta_form_ant_p,0) > 0) then
				insert	into oft_consulta_imagem(	nr_sequencia,
																dt_atualizacao,
																nm_usuario,
																dt_atualizacao_nrec,
																nm_usuario_nrec,
																ds_titulo,
																ds_arquivo,
																ds_arquivo_backup,
																nr_seq_fot_laser)
																SELECT	nextval('oft_consulta_imagem_seq'),
																			clock_timestamp(),
																			nm_usuario_w,
																			clock_timestamp(),
																			nm_usuario_w,
																			ds_titulo,
																			ds_arquivo,
																			ds_arquivo_backup,
																			nr_sequencia_w
																from		oft_consulta_imagem a,
																			oft_fotocoagulacao_laser b
																where		a.nr_seq_fot_laser 		= 	b.nr_sequencia
																and		b.nr_seq_consulta_form	= 	nr_seq_consulta_form_ant_p
																and		b.nr_seq_consulta			=	nr_seq_consulta_p;
			end if;
		end if;
	end if;
end if;

exception
when others then
	ds_erro_w	:= substr(sqlerrm,1,4000);
	update	OFT_CONSULTA_FORMULARIO
	set		ds_stack			=	substr(dbms_utility.format_call_stack||ds_erro_w,1,4000)
	where		nr_sequencia	= 	nr_seq_consulta_form_p;
end;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE oft_insere_fotocoagulacao ( nr_seq_consulta_p bigint, nr_seq_consulta_form_p bigint, nr_seq_consulta_form_ant_p bigint, vListaFotocoagulacao strRecTypeFormOft) FROM PUBLIC;

