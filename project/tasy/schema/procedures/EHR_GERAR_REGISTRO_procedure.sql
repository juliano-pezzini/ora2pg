-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ehr_gerar_registro ( cd_paciente_p text, nr_atendimento_p bigint, cd_profissional_p text, nr_seq_tipo_reg_p bigint, ds_lista_templates_p text, nm_usuario_p text, nr_seq_registro_p INOUT bigint) AS $body$
DECLARE


nr_seq_registro_w		bigint;
ds_lista_templates_w	varchar(2000);
tam_lista_w		bigint;
ie_pos_virgula_w		smallint;
nr_seq_template_w		bigint;
nr_seq_reg_template_w	bigint;


BEGIN
if (cd_paciente_p IS NOT NULL AND cd_paciente_p::text <> '') and (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (cd_profissional_p IS NOT NULL AND cd_profissional_p::text <> '') and (nr_seq_tipo_reg_p IS NOT NULL AND nr_seq_tipo_reg_p::text <> '') and (ds_lista_templates_p IS NOT NULL AND ds_lista_templates_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then

	select	nextval('ehr_registro_seq')
	into STRICT	nr_seq_registro_w
	;

	insert into ehr_registro(
		nr_sequencia,
		cd_paciente,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_tipo_reg,
		dt_registro,
		cd_profissional,
		nr_atendimento,
		dt_liberacao)
	values (
		nr_seq_registro_w,
		cd_paciente_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_tipo_reg_p,
		clock_timestamp(),
		cd_profissional_p,
		nr_atendimento_p,
		null);

	ds_lista_templates_w	:= ds_lista_templates_p;

	while	(ds_lista_templates_w IS NOT NULL AND ds_lista_templates_w::text <> '') loop
		begin
		tam_lista_w	:= length(ds_lista_templates_w);
		ie_pos_virgula_w	:= position(',' in ds_lista_templates_w);

		if (ie_pos_virgula_w <> 0) then
			nr_seq_template_w		:= (substr(ds_lista_templates_w, 1, (ie_pos_virgula_w - 1)))::numeric;
			ds_lista_templates_w	:= substr(ds_lista_templates_w, (ie_pos_virgula_w + 1), tam_lista_w);
		end if;

		if (nr_seq_template_w > 0) then

			select	nextval('ehr_reg_template_seq')
			into STRICT	nr_seq_reg_template_w
			;

			insert into ehr_reg_template(
				nr_sequencia,
				nr_seq_reg,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				dt_registro,
				nr_seq_template,
				dt_liberacao)
			values (
				nr_seq_reg_template_w,
				nr_seq_registro_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nr_seq_template_w,
				null);

		end if;
		end;
	end loop;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ehr_gerar_registro ( cd_paciente_p text, nr_atendimento_p bigint, cd_profissional_p text, nr_seq_tipo_reg_p bigint, ds_lista_templates_p text, nm_usuario_p text, nr_seq_registro_p INOUT bigint) FROM PUBLIC;
