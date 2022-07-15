-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_dados_paciente_setor (nr_seq_paciente_p bigint, nr_seq_sinal_vital_p bigint) AS $body$
DECLARE


qt_peso_w		real;
qt_altura_cm_w		real;
qt_imc_w		real;
qt_superf_corporia_w	double precision;

cd_pessoa_fisica_w	varchar(10);
qt_creatinina_w		double precision;
ie_l_dl_creatinina_w	smallint;
qt_auc_w		real;
qt_clearance_creatinina_w	double precision := 0;
qt_redutor_clcr_w	double precision;
qt_carboplatina_w	double precision := 0;


BEGIN

if (nr_seq_sinal_vital_p > 0) and (nr_seq_paciente_p > 0)	then

	select	qt_peso,
		qt_altura_cm,
		qt_imc,
		qt_superf_corporia
	into STRICT	qt_peso_w,
		qt_altura_cm_w,
		qt_imc_w,
		qt_superf_corporia_w
	from    atendimento_sinal_vital
	where   nr_sequencia = nr_seq_sinal_vital_p;

	update 	paciente_setor
	set	qt_peso = qt_peso_w,
		qt_altura = qt_altura_cm_w
	where 	nr_seq_paciente = nr_seq_paciente_p;


	select	cd_pessoa_fisica,
		qt_creatinina,
		ie_l_dl_creatinina,
		qt_auc,
		qt_redutor_clcr
	into STRICT	cd_pessoa_fisica_w,
		qt_creatinina_w,
		ie_l_dl_creatinina_w,
		qt_auc_w,
		qt_redutor_clcr_w
	from	paciente_setor
	where	nr_seq_paciente = nr_seq_paciente_p;


	SELECT * FROM Calcular_caboplanina_loco_reg(	cd_pessoa_fisica_w, qt_peso_w, qt_creatinina_w, ie_l_dl_creatinina_w, qt_auc_w, qt_clearance_creatinina_w, qt_carboplatina_w, qt_redutor_clcr_w) INTO STRICT qt_clearance_creatinina_w, qt_carboplatina_w;

	if (qt_clearance_creatinina_w > 0) then

		update	paciente_setor
		set	qt_clearance_creatinina = qt_clearance_creatinina_w
		where	nr_seq_paciente = nr_seq_paciente_p;

	end if;

	if (qt_carboplatina_w > 0) then

		update	paciente_setor
		set	qt_mg_carboplatina = qt_carboplatina_w
		where	nr_seq_paciente = nr_seq_paciente_p;

	end if;

end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_dados_paciente_setor (nr_seq_paciente_p bigint, nr_seq_sinal_vital_p bigint) FROM PUBLIC;

