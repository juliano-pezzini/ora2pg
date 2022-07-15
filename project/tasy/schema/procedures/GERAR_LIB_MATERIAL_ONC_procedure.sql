-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_lib_material_onc ( nr_seq_paciente_p bigint, nr_atendimento_p bigint, ie_opcao_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


/*Opção
Regra Quimioterapia Protocolo			P
*/
cd_pessoa_fisica_w	varchar(10);
cd_material_w		integer;
nr_prescricao_w		bigint;
nr_seq_material_w	integer;
nr_sequencia_w		bigint;
nr_atendimento_w	bigint;
nr_seq_paciente_w	bigint;
qt_lib_w			bigint;
qt_dose_prescr_w		bigint;

C01 CURSOR FOR
	SELECT	nr_seq_material
	from	paciente_atendimento_erro
	where	nr_seq_paciente = nr_seq_paciente_p
	and		nr_seq_regra = 10
	and		nm_usuario = nm_usuario_p
	and		(nr_seq_material IS NOT NULL AND nr_seq_material::text <> '');

C02 CURSOR FOR
	SELECT	nr_seq_material
	from	paciente_atendimento_erro
	where	nr_seq_atendimento = nr_seq_paciente_p
	and		nr_seq_regra = 10
	and		nm_usuario = nm_usuario_p
	and		(nr_seq_material IS NOT NULL AND nr_seq_material::text <> '');


BEGIN

If (coalesce(ie_opcao_p,'P') = 'P') then



	select 	max(cd_pessoa_fisica)
	into STRICT	cd_pessoa_fisica_w
	from 	paciente_setor
	where	nr_seq_paciente = nr_seq_paciente_p;

	nr_seq_paciente_w := nr_seq_paciente_p;


	open c01;
		loop
		fetch c01 into
				nr_seq_material_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin


			Select 	coalesce(max(cd_material),0),
				coalesce(max(qt_dose_prescr),0)
			into STRICT	cd_material_w,
				qt_dose_prescr_w
			from	paciente_protocolo_medic
			where	nr_seq_paciente = nr_seq_paciente_p
			and		nr_seq_material = nr_seq_material_w;


			if (cd_material_w > 0) then


				select	count(*)
				into STRICT	qt_lib_w
				from	lib_material_paciente
				where	cd_material	 = cd_material_w
				and		cd_pessoa_fisica = cd_pessoa_fisica_w
				and		coalesce(dt_suspenso::text, '') = ''
				and		clock_timestamp() between trunc(dt_inicio_validade,'dd') and fim_dia(coalesce(dt_suspenso,clock_timestamp()));

				if (qt_lib_w = 0) then

					select	nextval('lib_material_paciente_seq')
					into STRICT	nr_sequencia_w
					;

					insert	into lib_material_paciente(nr_sequencia,
						cd_pessoa_fisica,
						cd_material,
						dt_atualizacao,
						nm_usuario,
						dt_inicio_validade,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_seq_material,
						nr_seq_paciente,
						nr_atendimento,
						qt_dose_diaria)
					values (nr_sequencia_w,
						cd_pessoa_fisica_w,
						cd_material_w,
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						clock_timestamp(),
						nm_usuario_p,
						nr_seq_material_w,
						nr_seq_paciente_w,
						nr_atendimento_p,
						qt_dose_prescr_w);

					commit;

				end if;

			end if;

			end;
		end loop;
	close c01;


else


	select  max(nr_seq_paciente)
	into STRICT	nr_seq_paciente_w
	from	paciente_atendimento
	where	nr_seq_atendimento = nr_seq_paciente_p;


	select 	max(cd_pessoa_fisica)
	into STRICT	cd_pessoa_fisica_w
	from 	paciente_setor
	where	nr_seq_paciente = nr_seq_paciente_w;

	open c02;
		loop
		fetch c02 into
				nr_seq_material_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin

			Select 	coalesce(max(cd_material),0)
			into STRICT	cd_material_w
			from	PACIENTE_ATEND_MEDIC
			where	nr_seq_atendimento = nr_seq_paciente_p
			and		nr_seq_material = nr_seq_material_w;


			if (cd_material_w > 0) then

				select	count(*)
				into STRICT	qt_lib_w
				from	lib_material_paciente
				where	cd_material	 = cd_material_w
				and		cd_pessoa_fisica = cd_pessoa_fisica_w
				and		coalesce(dt_suspenso::text, '') = ''
				and		clock_timestamp() between trunc(dt_inicio_validade,'dd') and fim_dia(coalesce(dt_suspenso,clock_timestamp()));

				if (qt_lib_w = 0) then

					select	nextval('lib_material_paciente_seq')
					into STRICT	nr_sequencia_w
					;

					insert	into lib_material_paciente(nr_sequencia,
						cd_pessoa_fisica,
						cd_material,
						dt_atualizacao,
						nm_usuario,
						dt_inicio_validade,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_seq_material,
						nr_seq_paciente,
						nr_atendimento)
					values (nr_sequencia_w,
						cd_pessoa_fisica_w,
						cd_material_w,
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						clock_timestamp(),
						nm_usuario_p,
						nr_seq_material_w,
						nr_seq_paciente_w,
						nr_atendimento_p);

					commit;
				end if;
			end if;

			end;
		end loop;
	close c02;


end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_lib_material_onc ( nr_seq_paciente_p bigint, nr_atendimento_p bigint, ie_opcao_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

