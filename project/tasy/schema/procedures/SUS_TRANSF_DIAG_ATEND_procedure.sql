-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_transf_diag_atend ( nr_atend_novo_p bigint, nr_atend_anterior_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_atendimento_ant_w	atendimento_paciente.nr_atendimento%type;

qt_registros_w		bigint;

--diagnostico medico
dt_diag_medico_w	timestamp;
ie_tipo_diag_medico_w	smallint;
cd_medico_w		varchar(10);
ds_diagnostico_w	varchar(2000);
ie_tipo_doenca_med_w	varchar(2);
ie_unidade_tempo_med_w	varchar(2);
qt_tempo_med_w		bigint;
ie_tipo_atendimento_w	smallint;

--diagnostico doença
dt_diag_doenca_w		timestamp;
cd_doenca_w			varchar(10);
ds_diagnostico_doenca_w		varchar(2000);
ie_classificacao_doenca_w	varchar(1);
ie_tipo_doenca_w		varchar(2);
ie_unidade_tempo_w		varchar(2);
qt_tempo_w			bigint;
ie_lado_w			varchar(1);
dt_manifestacao_w		timestamp;
nr_seq_diag_interno_w		numeric(20);
nr_seq_grupo_diag_w		bigint;
dt_inicio_w			timestamp;
dt_fim_w			timestamp;
dt_liberacao_w			timestamp;
cd_perfil_ativo_w		integer;
ie_gera_somente_pa_w		varchar(1);
ie_tipo_diag_doenca_w		smallint;
ie_situacao_c02_w		varchar(1);



C01 CURSOR FOR
	SELECT	dt_diagnostico,
		ie_tipo_diagnostico,
		cd_medico,
		ds_diagnostico,
		ie_tipo_doenca,
		ie_unidade_tempo,
		qt_tempo,
		ie_tipo_atendimento
	from	diagnostico_medico
	where	nr_atendimento = nr_atendimento_ant_w;

C02 CURSOR FOR
	SELECT	dt_diagnostico,
		ie_tipo_diagnostico,
		cd_doenca,
		ds_diagnostico,
		ie_classificacao_doenca,
		ie_tipo_doenca,
		ie_unidade_tempo,
		qt_tempo,
		ie_lado,
		dt_manifestacao,
		nr_seq_diag_interno,
		nr_seq_grupo_diag,
		dt_inicio,
		dt_fim,
		dt_liberacao,
		cd_perfil_ativo,
		ie_situacao
	from	diagnostico_doenca
	where	nr_atendimento 	= nr_atendimento_ant_w
	and	dt_diagnostico = dt_diag_medico_w;


BEGIN

nr_atendimento_ant_w := nr_atend_anterior_p;

select	count(1)
into STRICT	qt_registros_w
from	diagnostico_doenca z
where	z.nr_atendimento	= nr_atendimento_ant_w;

if (qt_registros_w = 0)	then
	begin

	select	count(*)
	into STRICT	qt_registros_w
	from	diagnostico_medico
	where	nr_atendimento = nr_atendimento_ant_w;

	if (qt_registros_w = 0) then

		open C01;
		loop
		fetch C01 into
			dt_diag_medico_w,
			ie_tipo_diag_medico_w,
			cd_medico_w,
			ds_diagnostico_w,
			ie_tipo_doenca_med_w,
			ie_unidade_tempo_med_w,
			qt_tempo_med_w,
			ie_tipo_atendimento_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin

			insert into	diagnostico_medico(
					nr_atendimento,
					dt_diagnostico,
					ie_tipo_diagnostico,
					cd_medico,
					dt_atualizacao,
					nm_usuario,
					ds_diagnostico,
					ie_tipo_doenca,
					ie_unidade_tempo,
					qt_tempo,
					ie_tipo_atendimento
					)
				values (
					nr_atend_novo_p,
					dt_diag_medico_w,
					ie_tipo_diag_medico_w,
					cd_medico_w,
					clock_timestamp(),
					nm_usuario_p,
					ds_diagnostico_w,
					ie_tipo_doenca_med_w,
					ie_unidade_tempo_med_w,
					qt_tempo_med_w,
					ie_tipo_atendimento_w);

			open C02;
			loop
			fetch C02 into
				dt_diag_doenca_w,
				ie_tipo_diag_doenca_w,
				cd_doenca_w,
				ds_diagnostico_doenca_w,
				ie_classificacao_doenca_w,
				ie_tipo_doenca_w,
				ie_unidade_tempo_w,
				qt_tempo_w,
				ie_lado_w,
				dt_manifestacao_w,
				nr_seq_diag_interno_w,
				nr_seq_grupo_diag_w,
				dt_inicio_w,
				dt_fim_w,
				dt_liberacao_w,
				cd_perfil_ativo_w,
				ie_situacao_c02_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin

				insert into 	diagnostico_doenca(
						nr_atendimento,
						dt_diagnostico,
						cd_doenca,
						dt_atualizacao,
						nm_usuario,
						ds_diagnostico,
						ie_classificacao_doenca,
						ie_tipo_doenca,
						ie_unidade_tempo,
						qt_tempo,
						ie_lado,
						dt_manifestacao,
						nr_seq_diag_interno,
						nr_seq_grupo_diag,
						dt_inicio,
						dt_fim,
						dt_liberacao,
						cd_perfil_ativo,
						ie_tipo_diagnostico,
						ie_situacao
						)
					values (
						nr_atend_novo_p,
						dt_diag_doenca_w,
						cd_doenca_w,
						clock_timestamp(),
						nm_usuario_p,
						ds_diagnostico_doenca_w,
						ie_classificacao_doenca_w,
						ie_tipo_doenca_w,
						ie_unidade_tempo_w,
						qt_tempo_w,
						ie_lado_w,
						dt_manifestacao_w,
						nr_seq_diag_interno_w,
						nr_seq_grupo_diag_w,
						dt_inicio_w,
						dt_fim_w,
						dt_liberacao_w,
						cd_perfil_ativo_w,
						coalesce(ie_tipo_diag_doenca_w,2),
						coalesce(ie_situacao_c02_w,'A'));
				end;
			end loop;
			close C02;

			end;
		end loop;
		close C01;
	end if;

	commit;

	end;
end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_transf_diag_atend ( nr_atend_novo_p bigint, nr_atend_anterior_p bigint, nm_usuario_p text) FROM PUBLIC;
