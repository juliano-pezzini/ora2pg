-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE same_gerar_locais_armario ( cd_armario_p text, qt_prateleira_p bigint, qt_posicao_p bigint, ie_permite_util_pront_p text, ie_permite_util_caixa_p text, cd_estabelecimento_p bigint, nm_usuario_p text, ie_recalc_prat_pos_p text) AS $body$
DECLARE


cd_prateleira_w		varchar(5);
cd_posicao_w		varchar(5);
qt_registros_w		bigint;
BEGIN

if (cd_armario_p IS NOT NULL AND cd_armario_p::text <> '') and (qt_prateleira_p IS NOT NULL AND qt_prateleira_p::text <> '') and (qt_posicao_p IS NOT NULL AND qt_posicao_p::text <> '') then

	if (ie_recalc_prat_pos_p = 'S') then
		update 	same_local
		set	ie_situacao = 'I'
		where	cd_armario = cd_armario_p;
	end if;

	for i in 1..qt_prateleira_p loop
		begin

		if (length(qt_prateleira_p) > 1) then
			cd_prateleira_w := lpad(i,length(qt_prateleira_p),0);
		else
			cd_prateleira_w := lpad(i,2,0);
		end if;

		for j in 1..qt_posicao_p loop
			begin

			if (length(qt_posicao_p) > 1) then
				cd_posicao_w := lpad(j,length(qt_posicao_p),0);
			else
				cd_posicao_w := lpad(j,2,0);
			end if;

			select		count(*)
			into STRICT		qt_registros_w
			from		same_local
			where		cd_armario = cd_armario_p
			and		cd_prateleira = cd_prateleira_w
			and		cd_posicao = cd_posicao_w;

			if (Obter_Valor_Param_Usuario(941,197, Obter_perfil_Ativo, wheb_usuario_pck.get_nm_usuario, 0) = 'N') and (qt_registros_w > 0) and (ie_recalc_prat_pos_p = 'N') then
					CALL WHEB_MENSAGEM_PCK.exibir_mensagem_abort(210165);
			end if;

			if (ie_recalc_prat_pos_p = 'S') then

				if (qt_registros_w > 0) then
					update 	same_local
					set	ie_situacao = 'A'
					where	cd_armario = cd_armario_p
					and	cd_prateleira = cd_prateleira_w
					and	cd_posicao = cd_posicao_w;
				else
					insert into SAME_LOCAL(
						nr_sequencia,
						cd_estabelecimento,
						dt_atualizacao,
						nm_usuario,
						ds_local,
						ds_armario,
						ie_situacao,
						ie_local_base,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						ie_permite_util_pront,
						ie_permite_util_caixa,
						cd_armario,
						cd_prateleira,
						cd_posicao)
					values (	nextval('same_local_seq'),
						cd_estabelecimento_p,
						clock_timestamp(),
						nm_usuario_p,
						wheb_mensagem_pck.get_texto(455734) || ' ' || cd_prateleira_w || ' ' || wheb_mensagem_pck.get_texto(455735) || ' ' ||cd_posicao_w,
						wheb_mensagem_pck.get_texto(455736) || ' ' || cd_armario_p,
						'A',
						'N',
						clock_timestamp(),
						nm_usuario_p,
						ie_permite_util_pront_p,
						ie_permite_util_caixa_p,
						cd_armario_p,
						cd_prateleira_w,
						cd_posicao_w);
				end if;

			else

				insert into SAME_LOCAL(
					nr_sequencia,
					cd_estabelecimento,
					dt_atualizacao,
					nm_usuario,
					ds_local,
					ds_armario,
					ie_situacao,
					ie_local_base,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					ie_permite_util_pront,
					ie_permite_util_caixa,
					cd_armario,
					cd_prateleira,
					cd_posicao)
				values (	nextval('same_local_seq'),
					cd_estabelecimento_p,
					clock_timestamp(),
					nm_usuario_p,
					wheb_mensagem_pck.get_texto(455734) || ' ' || cd_prateleira_w || ' ' || wheb_mensagem_pck.get_texto(455735) || ' ' ||cd_posicao_w,
					wheb_mensagem_pck.get_texto(455736) || ' ' || cd_armario_p,
					'A',
					'N',
					clock_timestamp(),
					nm_usuario_p,
					ie_permite_util_pront_p,
					ie_permite_util_caixa_p,
					cd_armario_p,
					cd_prateleira_w,
					cd_posicao_w);
			end if;
			end;
		end loop;
		end;
	end loop;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE same_gerar_locais_armario ( cd_armario_p text, qt_prateleira_p bigint, qt_posicao_p bigint, ie_permite_util_pront_p text, ie_permite_util_caixa_p text, cd_estabelecimento_p bigint, nm_usuario_p text, ie_recalc_prat_pos_p text) FROM PUBLIC;

