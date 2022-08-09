-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_mapa_js ( dt_dieta_p timestamp, cd_setor_atendimento_p bigint, qt_horas_p bigint, cd_dieta_acomp_p bigint, cd_refeicao_p text, ie_copiar_dieta_acomp_p text, ie_permite_rec_nasc_p text, cd_estabelecimento_p bigint default null, nm_usuario_p text DEFAULT NULL) AS $body$
DECLARE

 
ie_bloqueia_mapa_refeicao_w	varchar(1);
ds_horario_w			varchar(19);
qt_regra_mapa_w			bigint;

 

BEGIN 
	if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then 
		begin 
		select	consistir_regra_mapa_refeicao(dt_dieta_p,cd_refeicao_p)  
		into STRICT 	qt_regra_mapa_w 
		;
		 
		if (qt_regra_mapa_w > 0) then 
			begin 
			ie_bloqueia_mapa_refeicao_w := 'S';
			end;
		else 
			begin 
			ie_bloqueia_mapa_refeicao_w := 'N';
			end;
		end if;
		 
			if (ie_bloqueia_mapa_refeicao_w = 'N') then 
				begin 
				if	(ie_permite_rec_nasc_p = 'S' AND cd_setor_atendimento_p = 9) or 
					((cd_setor_atendimento_p = 3) or (cd_setor_atendimento_p = 4) or (cd_setor_atendimento_p = 8)) or (obter_regra_geracao_mapa_setor(cd_setor_atendimento_P) = 'A') then 
					begin 
					CALL gerar_mapa_dieta(cd_setor_atendimento_p, 
							nm_usuario_p, 
							dt_dieta_p, 
							cd_refeicao_p, 
							qt_horas_p, 
							cd_estabelecimento_p);
					end;
				end if;
				 
				if (ie_copiar_dieta_acomp_p = 'S') then 
					begin 
					CALL gerar_dieta_acompanhantes(cd_setor_atendimento_p, 
									dt_dieta_p, 
									cd_refeicao_p, 
									cd_dieta_acomp_p, 
									nm_usuario_p);
					end;
				end if;
				end;
			 
			else 
				begin 
				select	ds_horario 
				into STRICT	ds_horario_w 
				from	mapa_regra_horario 
				where	cd_refeicao = cd_refeicao_p;
				 
				CALL Wheb_mensagem_pck.exibir_mensagem_abort(60433);
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
-- REVOKE ALL ON PROCEDURE gerar_mapa_js ( dt_dieta_p timestamp, cd_setor_atendimento_p bigint, qt_horas_p bigint, cd_dieta_acomp_p bigint, cd_refeicao_p text, ie_copiar_dieta_acomp_p text, ie_permite_rec_nasc_p text, cd_estabelecimento_p bigint default null, nm_usuario_p text DEFAULT NULL) FROM PUBLIC;
