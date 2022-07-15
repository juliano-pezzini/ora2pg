-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE oft_insere_ultrassonografia ( nr_seq_consulta_p bigint, nr_seq_consulta_form_p bigint, nr_seq_consulta_form_ant_p bigint, vListaUltrassonografia strRecTypeFormOft) AS $body$
DECLARE


nr_sequencia_w				oft_ultrassonografia.nr_sequencia%TYPE;
dt_exame_w					oft_ultrassonografia.dt_registro%TYPE;
ds_observacao_od_w		oft_ultrassonografia.ds_observacao_od%TYPE;
ds_observacao_oe_w		oft_ultrassonografia.ds_observacao_oe%TYPE;
ds_observacao_w			oft_ultrassonografia.ds_observacao%TYPE;
cd_profissional_w			oft_ultrassonografia.cd_profissional%TYPE;
nm_usuario_w				usuario.nm_usuario%TYPE := wheb_usuario_pck.get_nm_usuario;
ie_registrado_w			varchar(1) := 'N';
ds_erro_w					varchar(4000);

BEGIN
begin

IF (coalesce(nr_seq_consulta_p,0) > 0) AND (vListaUltrassonografia.COUNT > 0) THEN
	FOR i IN 1..vListaUltrassonografia.COUNT LOOP
		BEGIN
		IF (vListaUltrassonografia[i](.ds_valor IS NOT NULL AND .ds_valor::text <> '')) THEN
			CASE UPPER(vListaUltrassonografia[i].nm_campo)
				WHEN 'DT_REGISTRO' THEN
					dt_exame_w 						:= pkg_date_utils.get_DateTime(vListaUltrassonografia[i].ds_valor);
				WHEN 'CD_PROFISSIONAL' THEN
					cd_profissional_w				:= vListaUltrassonografia[i].ds_valor;
				WHEN 'DS_OBSERVACAO_OD' THEN
					ds_observacao_od_w			:= vListaUltrassonografia[i].ds_valor;
					ie_registrado_w				:= 'S';
				WHEN 'DS_OBSERVACAO_OE' THEN
					ds_observacao_oe_w			:= vListaUltrassonografia[i].ds_valor;
					ie_registrado_w				:= 'S';
				WHEN 'DS_OBSERVACAO' THEN
					ds_observacao_w				:= vListaUltrassonografia[i].ds_valor;
					ie_registrado_w				:= 'S';
				else
					null;
			END CASE;
		END IF;
	END;
	END LOOP;

	select	max(nr_sequencia)
	into STRICT		nr_sequencia_w
	from		oft_ultrassonografia
	where		nr_seq_consulta_form = nr_seq_consulta_form_p
	and		nr_seq_consulta		= nr_seq_consulta_p
	and		coalesce(dt_liberacao::text, '') = ''
	and		nm_usuario				= nm_usuario_w;

	if (nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '') then
		update	oft_ultrassonografia
		set		dt_atualizacao		=	clock_timestamp(),
					nm_usuario			=	nm_usuario_w,
					dt_registro			=	coalesce(dt_exame_w,clock_timestamp()),
					cd_profissional	=	coalesce(cd_profissional_w,cd_profissional),
					ds_observacao_od	=	ds_observacao_od_w,
					ds_observacao_oe	=	ds_observacao_oe_w,
					ds_observacao		=	ds_observacao_w
		where		nr_sequencia		=	nr_sequencia_w;
		CALL wheb_usuario_pck.set_ie_commit('S');
	else
		if (ie_registrado_w = 'S') then
			CALL wheb_usuario_pck.set_ie_commit('S');
			SELECT	nextval('oft_ultrassonografia_seq')
			INTO STRICT		nr_sequencia_w
			;

			INSERT	INTO oft_ultrassonografia(	nr_sequencia,
														dt_atualizacao,
														nm_usuario,
														dt_atualizacao_nrec,
														nm_usuario_nrec,
														cd_profissional,
														dt_registro,
														nr_seq_consulta,
														ie_situacao,
														ds_observacao_od,
														ds_observacao_oe,
														ds_observacao,
														nr_seq_consulta_form
														)
			VALUES (	nr_sequencia_w,
														clock_timestamp(),
														nm_usuario_w,
														clock_timestamp(),
														nm_usuario_w,
														coalesce(cd_profissional_w,obter_pf_usuario(nm_usuario_w,'C')),
														coalesce(dt_exame_w,clock_timestamp()),
														nr_seq_consulta_p,
														'A',
														ds_observacao_od_w,
														ds_observacao_oe_w,
														ds_observacao_w,
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
																nr_seq_ultrassonografia)
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
																			oft_ultrassonografia b
																where		a.nr_seq_ultrassonografia	= 	b.nr_sequencia
																and		b.nr_seq_consulta_form		= 	nr_seq_consulta_form_ant_p
																and		b.nr_seq_consulta				=	nr_seq_consulta_p;

				insert	into oft_imagem_exame(	nr_sequencia,
																dt_atualizacao,
																nm_usuario,
																dt_atualizacao_nrec,
																nm_usuario_nrec,
																ds_titulo,
																ds_arquivo,
																nr_seq_consulta,
																ie_lado,
																nr_seq_ultrassonografia,
																ie_situacao,
																cd_profissional)
													SELECT	nextval('oft_imagem_exame_seq'),
																clock_timestamp(),
																nm_usuario_w,
																clock_timestamp(),
																nm_usuario_w,
																ds_titulo,
																ds_arquivo,
																nr_seq_consulta_p,
																ie_lado,
																nr_sequencia_w,
																'A',
																coalesce(cd_profissional_w,obter_pf_usuario(nm_usuario_w,'C'))
													from		oft_imagem_exame a,
																oft_ultrassonografia b
													where		a.nr_seq_ultrassonografia	= 	b.nr_sequencia
													and		b.nr_seq_consulta_form		= 	nr_seq_consulta_form_ant_p
													and		b.nr_seq_consulta				=	nr_seq_consulta_p;
			end if;
		end if;
	end if;
END IF;

exception
when others then
	ds_erro_w	:= substr(sqlerrm,1,4000);
	update	OFT_CONSULTA_FORMULARIO
	set		ds_stack			=	substr(dbms_utility.format_call_stack||ds_erro_w,1,4000)
	where		nr_sequencia	= 	nr_seq_consulta_form_p;
end;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE oft_insere_ultrassonografia ( nr_seq_consulta_p bigint, nr_seq_consulta_form_p bigint, nr_seq_consulta_form_ant_p bigint, vListaUltrassonografia strRecTypeFormOft) FROM PUBLIC;

