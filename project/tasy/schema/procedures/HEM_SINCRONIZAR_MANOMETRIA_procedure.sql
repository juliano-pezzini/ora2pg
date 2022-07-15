-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hem_sincronizar_manometria ( ie_pasta_p text, nr_atendimento_p bigint, nr_seq_proc_p bigint, nm_usuario_p text, cd_pessoa_fisica_p text, nr_seq_mano_comple_p bigint, ie_classif_p text) AS $body$
DECLARE


ie_tipo_w					varchar(255);
ie_tipo_camara_w			varchar(40);
ie_classif_proc_w			varchar(255);
nr_seq_cal_w				bigint;
nr_seq_proc_w				bigint;
nr_pro_calc_w				bigint;
qt_pa_sistolica_w			bigint;
qt_pa_diastolica_ini_w		bigint;
qt_pa_diastolica_fim_w		bigint;
qt_pam_w					bigint;
qt_registros_mano_w			bigint;

C01 CURSOR FOR
		SELECT 	ie_tipo,
				qt_pa_sistolica,
				qt_pa_diastolica_ini,
				qt_pa_diastolica_fim,
				qt_pam
		from	hem_manometria_completa
		where	nr_seq_hem_calc = nr_seq_cal_w;

C02 CURSOR FOR
		SELECT 	ie_tipo,
				qt_pa_sistolica,
				qt_pa_diastolica_ini,
				qt_pa_diastolica_fim,
				qt_pam
		from 	hem_manometria_completa
		where 	nr_seq_proc = nr_seq_proc_w
		and (ie_momento = 'PR'
		or		coalesce(ie_momento::text, '') = '');

C03 CURSOR FOR
		SELECT	nr_sequencia
		from	hem_proc
		where (hem_obter_classif_proced(nr_seq_procedimento) = ie_classif_p
		or		ie_classif_p = 'TODOS')
		and		nr_atendimento = nr_atendimento_p
		and		coalesce(dt_liberacao::text, '') = ''
		and		coalesce(dt_inativacao::text, '') = '';

C04 CURSOR FOR
		SELECT	nr_sequencia
		from	hem_calc_hemodinamico
		where	nr_atendimento = nr_atendimento_p
		and		coalesce(dt_calculo_gerado::text, '') = '';

BEGIN

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (ie_pasta_p IS NOT NULL AND ie_pasta_p::text <> '') and (nr_seq_proc_p IS NOT NULL AND nr_seq_proc_p::text <> '') and (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	nr_pro_calc_w := nr_seq_proc_p;
	if (ie_pasta_p = 'L') or (ie_pasta_p = 'C') or (ie_pasta_p = 'H') then
		if (ie_pasta_p <> 'H') then
			select 	max(nr_sequencia)
			into STRICT	nr_seq_cal_w
			from	hem_calc_hemodinamico
			where	nr_atendimento = nr_atendimento_p;

			select	count(*)
			into STRICT	qt_registros_mano_w
			from	hem_manometria_completa
			where 	nr_seq_hem_calc = nr_seq_cal_w;

			if (coalesce(qt_registros_mano_w, 0) > 0) then
				open C01;
				loop
				fetch C01 into
					ie_tipo_w,
					qt_pa_sistolica_w,
					qt_pa_diastolica_ini_w,
					qt_pa_diastolica_fim_w,
					qt_pam_w;
				EXIT WHEN NOT FOUND; /* apply on C01 */
					begin
						insert into hem_manometria_completa(
							nr_sequencia,
							nr_seq_proc,
							nm_usuario,
							nm_usuario_nrec,
							dt_atualizacao,
							dt_atualizacao_nrec,
							ie_tipo,
							qt_pa_sistolica,
							qt_pa_diastolica_ini,
							qt_pa_diastolica_fim,
							qt_pam,
							ie_momento
						) values (
							nextval('hem_manometria_completa_seq'),
							nr_seq_proc_p,
							nm_usuario_p,
							nm_usuario_p,
							clock_timestamp(),
							clock_timestamp(),
							ie_tipo_w,
							qt_pa_sistolica_w,
							qt_pa_diastolica_ini_w,
							qt_pa_diastolica_fim_w,
							qt_pam_w,
							'PR'
						);
					end;
				end loop;
				close C01;
			end if;
		end if;
		if (ie_pasta_p = 'L') and (coalesce(qt_registros_mano_w, 0) = 0) then

			select	max(nr_sequencia)
			into STRICT	nr_seq_proc_w
			from	hem_proc
			where 	hem_obter_classif_proced(nr_seq_procedimento) = 'COD'
			and		nr_atendimento = nr_atendimento_p;

		end if;

		if (ie_pasta_p = 'C') and (coalesce(qt_registros_mano_w, 0) = 0) then

			select	max(nr_sequencia)
			into STRICT	nr_seq_proc_w
			from	hem_proc
			where 	hem_obter_classif_proced(nr_seq_procedimento) = 'CAT'
			and		nr_atendimento = nr_atendimento_p;

		end if;

		if (ie_pasta_p = 'H') then

			select	max(nr_sequencia)
			into STRICT	nr_seq_proc_w
			from	hem_proc
			where 	hem_obter_classif_proced(nr_seq_procedimento) = 'CAT'
			and		nr_atendimento = nr_atendimento_p;

			select	count(*)
			into STRICT	qt_registros_mano_w
			from	hem_manometria_completa
			where	nr_seq_proc = nr_seq_proc_w;

			if (coalesce(qt_registros_mano_w, 0) = 0) then

				select	max(nr_sequencia)
				into STRICT	nr_seq_proc_w
				from	hem_proc
				where 	hem_obter_classif_proced(nr_seq_procedimento) = 'COD'
				and		nr_atendimento = nr_atendimento_p;

			end if;

			select 	max(nr_sequencia)
			into STRICT	nr_seq_cal_w
			from	hem_calc_hemodinamico
			where	cd_pessoa_fisica = cd_pessoa_fisica_p;
			nr_pro_calc_w := null;
		end if;

		open C02;
			loop
			fetch C02 into
				ie_tipo_w,
				qt_pa_sistolica_w,
				qt_pa_diastolica_ini_w,
				qt_pa_diastolica_fim_w,
				qt_pam_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin
					insert into hem_manometria_completa(
						nr_sequencia,
						nr_seq_proc,
						nr_seq_hem_calc,
						nm_usuario,
						nm_usuario_nrec,
						dt_atualizacao,
						dt_atualizacao_nrec,
						ie_tipo,
						qt_pa_sistolica,
						qt_pa_diastolica_ini,
						qt_pa_diastolica_fim,
						qt_pam,
						ie_momento
					) values (
						nextval('hem_manometria_completa_seq'),
						nr_pro_calc_w,
						nr_seq_cal_w,
						nm_usuario_p,
						nm_usuario_p,
						clock_timestamp(),
						clock_timestamp(),
						ie_tipo_w,
						qt_pa_sistolica_w,
						qt_pa_diastolica_ini_w,
						qt_pa_diastolica_fim_w,
						qt_pam_w,
						'PR'
					);
				end;
			end loop;
			close C02;
	end if;

	if (ie_pasta_p = 'UC') or (ie_pasta_p = 'AD') or (ie_pasta_p = 'CH')then

		select	max(ie_tipo),
				max(qt_pa_sistolica),
				max(qt_pa_diastolica_ini),
				max(qt_pa_diastolica_fim),
				max(qt_pam)
		into STRICT	ie_tipo_w,
				qt_pa_sistolica_w,
				qt_pa_diastolica_ini_w,
				qt_pa_diastolica_fim_w,
				qt_pam_w
		from	hem_manometria_completa
		where	nr_sequencia = nr_seq_mano_comple_p;

		open C03;
		loop
		fetch C03 into
			nr_seq_proc_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin
				select	count(*)
				into STRICT	qt_registros_mano_w
				from	hem_manometria_completa
				where 	nr_seq_proc = nr_seq_proc_w
				and		ie_tipo = ie_tipo_w;

				select	hem_obter_classif_proced(nr_seq_procedimento)
				into STRICT	ie_classif_proc_w
				from	hem_proc
				where 	nr_sequencia = nr_seq_proc_w;

				if (coalesce(qt_registros_mano_w, 0) > 0) then

					update	hem_manometria_completa
					set		ie_tipo					= ie_tipo_w,
							qt_pa_sistolica			= qt_pa_sistolica_w,
							qt_pa_diastolica_ini	= qt_pa_diastolica_ini_w,
							qt_pa_diastolica_fim	= qt_pa_diastolica_fim_w,
							qt_pam					= qt_pam_w
					where	nr_seq_proc	= nr_seq_proc_w
					and		ie_tipo = ie_tipo_w;

				else
					if (ie_classif_proc_w = 'CAT') or (ie_classif_proc_w = 'COD') then
						insert into hem_manometria_completa(
							nr_sequencia,
							nr_seq_proc,
							nm_usuario,
							nm_usuario_nrec,
							dt_atualizacao,
							dt_atualizacao_nrec,
							ie_tipo,
							qt_pa_sistolica,
							qt_pa_diastolica_ini,
							qt_pa_diastolica_fim,
							qt_pam,
							ie_momento
						) values (
							nextval('hem_manometria_completa_seq'),
							nr_seq_proc_w,
							nm_usuario_p,
							nm_usuario_p,
							clock_timestamp(),
							clock_timestamp(),
							ie_tipo_w,
							qt_pa_sistolica_w,
							qt_pa_diastolica_ini_w,
							qt_pa_diastolica_fim_w,
							qt_pam_w,
							'PR'
						);
					end if;
				end if;
			end;
		end loop;
		close C03;
		if (ie_pasta_p <> 'CH') then

			open C04;
			loop
			fetch C04 into
				nr_seq_cal_w;
			EXIT WHEN NOT FOUND; /* apply on C04 */
				begin
					select	count(*)
					into STRICT	qt_registros_mano_w
					from	hem_manometria_completa
					where 	nr_seq_hem_calc = nr_seq_cal_w
					and		ie_tipo = ie_tipo_w;

					if (coalesce(qt_registros_mano_w, 0) > 0) then

						update	hem_manometria_completa
						set		ie_tipo					= ie_tipo_w,
								qt_pa_sistolica			= qt_pa_sistolica_w,
								qt_pa_diastolica_ini	= qt_pa_diastolica_ini_w,
								qt_pa_diastolica_fim	= qt_pa_diastolica_fim_w,
								qt_pam					= qt_pam_w
						where	nr_seq_hem_calc = nr_seq_cal_w
						and		ie_tipo = ie_tipo_w;

					else

						insert into hem_manometria_completa(
							nr_sequencia,
							nr_seq_hem_calc,
							nm_usuario,
							nm_usuario_nrec,
							dt_atualizacao,
							dt_atualizacao_nrec,
							ie_tipo,
							qt_pa_sistolica,
							qt_pa_diastolica_ini,
							qt_pa_diastolica_fim,
							qt_pam,
							ie_momento
						) values (
							nextval('hem_manometria_completa_seq'),
							nr_seq_cal_w,
							nm_usuario_p,
							nm_usuario_p,
							clock_timestamp(),
							clock_timestamp(),
							ie_tipo_w,
							qt_pa_sistolica_w,
							qt_pa_diastolica_ini_w,
							qt_pa_diastolica_fim_w,
							qt_pam_w,
							'PR'
						);
					end if;
				end;
			end loop;
			close C04;
		end if;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hem_sincronizar_manometria ( ie_pasta_p text, nr_atendimento_p bigint, nr_seq_proc_p bigint, nm_usuario_p text, cd_pessoa_fisica_p text, nr_seq_mano_comple_p bigint, ie_classif_p text) FROM PUBLIC;

