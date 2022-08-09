-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tx_inserir_dados_cirurgia ( nr_cirurgia_p bigint, nm_usuario_p text) AS $body$
DECLARE


dt_inicio_real_w	timestamp;
dt_termino_w		timestamp;
nr_min_duracao_real_w	bigint;
cd_procedimento_princ_w	bigint;
nr_seq_proc_interno_w	bigint;
nr_seq_receptor_w	bigint;
ie_origem_proced_w	bigint;

dt_atendimento_w	timestamp;
cd_material_w		integer;
qt_material_w		double precision;
cd_unidade_medida_w	varchar(30);
ie_erro_w		varchar(1);

C01 CURSOR FOR
	SELECT	dt_atendimento,
		cd_material,
		coalesce(qt_estoque,qt_material),
		cd_unidade_medida
	from	material_atend_paciente
	where	nr_cirurgia = nr_cirurgia_p;

BEGIN
if (nr_cirurgia_p IS NOT NULL AND nr_cirurgia_p::text <> '') then
	select	max(dt_inicio_real),
		max(dt_termino),
		max(nr_min_duracao_real),
		max(cd_procedimento_princ),
		max(nr_seq_proc_interno),
		max(nr_seq_transplante),
		max(ie_origem_proced)
	into STRICT	dt_inicio_real_w,
		dt_termino_w,
		nr_min_duracao_real_w,
		cd_procedimento_princ_w,
		nr_seq_proc_interno_w,
		nr_seq_receptor_w,
		ie_origem_proced_w
	from	cirurgia
	where	nr_cirurgia = nr_cirurgia_p;



	if (nr_seq_receptor_w IS NOT NULL AND nr_seq_receptor_w::text <> '') then

		insert into tx_dados_cir_receptor(
			nr_sequencia,
			dt_cirurgia,
			dt_inicio,
			dt_termino,
			nr_min_duracao,
			cd_procedimento,
			nr_seq_proc_interno,
			nm_usuario,
			dt_atualizacao,
			nr_seq_receptor,
			ie_origem_proced)
		values (	nextval('tx_dados_cir_receptor_seq'),
			clock_timestamp(),
			dt_inicio_real_w,
			dt_termino_w,
			nr_min_duracao_real_w,
			cd_procedimento_princ_w,
			nr_seq_proc_interno_w,
			nm_usuario_p,
			clock_timestamp(),
			nr_seq_receptor_w,
			ie_origem_proced_w);



		open C01;
		loop
		fetch C01 into
			dt_atendimento_w,
			cd_material_w,
			qt_material_w,
			cd_unidade_medida_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin

			insert into tx_medicamento(
				nr_sequencia,
				dt_inicio,
				cd_material,
				qt_dose,
				cd_unidade_medida,
				dt_atualizacao,
				nm_usuario,
				nr_seq_receptor,
				ie_medic_imunosupressao)
			values (	nextval('tx_medicamento_seq'),
				dt_atendimento_w,
				cd_material_w,
				qt_material_w,
				cd_unidade_medida_w,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_receptor_w,
				'C'); --C de cirurgia
			exception
				when others then
				ie_erro_w := 'S';
			end;
		end loop;
		close C01;


	end if;
end if;




commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tx_inserir_dados_cirurgia ( nr_cirurgia_p bigint, nm_usuario_p text) FROM PUBLIC;
