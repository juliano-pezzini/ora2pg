-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_inf_adic_apae ( nr_aval_pre_anest_p bigint, nr_atendimento_p bigint, cd_profissional_p text, cd_pessoa_fisica_p text, nr_seq_template_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_ehr_w		bigint;
ie_apae_template_w		varchar(5);

ds_doenca_w		varchar(255);
ds_cirurgia_w		varchar(255);
ds_anestesia_w		varchar(255);
ds_medicamento_uso_w	varchar(255);
ds_habito_w		varchar(255);
ds_alergia_w		varchar(255);


BEGIN

if (nr_aval_pre_anest_p IS NOT NULL AND nr_aval_pre_anest_p::text <> '') then
--	Adicionar Informacao Adicional EHR
	ie_apae_template_w := Obter_Param_Usuario(874, 28, wheb_usuario_pck.get_cd_perfil, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_apae_template_w);

        if ((nr_seq_template_p IS NOT NULL AND nr_seq_template_p::text <> '') and nr_seq_template_p > 0) then
                if (ie_apae_template_w = 'S') then
                        select	nextval('ehr_registro_seq')
                        into STRICT	nr_seq_ehr_w
;

                        insert into ehr_registro(
                                nr_sequencia,
                                cd_paciente,
                                dt_atualizacao,
                                nm_usuario,
                                dt_atualizacao_nrec,
                                nm_usuario_nrec,
                                dt_registro,
                                cd_profissional,
                                nr_atendimento,
                                nr_seq_aval_pre,
                                cd_perfil_ativo)
                        values (	nr_seq_ehr_w,
                                cd_pessoa_fisica_p,
                                clock_timestamp(),
                                nm_usuario_p,
                                clock_timestamp(),
                                nm_usuario_p,
                                clock_timestamp(),
                                cd_profissional_p,
                                nr_atendimento_p,
                                nr_aval_pre_anest_p,
                                wheb_usuario_pck.get_cd_perfil);

                        insert into ehr_reg_template(
                                nr_sequencia,
                                nr_seq_reg,
                                dt_atualizacao,
                                nm_usuario,
                                dt_atualizacao_nrec,
                                nm_usuario_nrec,
                                dt_registro,
                                nr_seq_template)
                        values (	nextval('ehr_reg_template_seq'),
                                nr_seq_ehr_w,
                                clock_timestamp(),
                                nm_usuario_p,
                                clock_timestamp(),
                                nm_usuario_p,
                                clock_timestamp(),
                                nr_seq_template_p);
                end if;
	end if;

--	Adicionar Informacao Adicional Anamnese
	if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
		select	substr(obter_inf_hist_saude(cd_pessoa_fisica_p,'D'),1,255),
			substr(obter_inf_hist_saude(cd_pessoa_fisica_p,'C'),1,255),
			substr(obter_inf_hist_saude(cd_pessoa_fisica_p,'A'),1,255),
			substr(obter_inf_hist_saude(cd_pessoa_fisica_p,'M'),1,255),
			substr(obter_inf_hist_saude(cd_pessoa_fisica_p,'H'),1,255),
			substr(obter_inf_hist_saude(cd_pessoa_fisica_p,'AL'),1,255)
		into STRICT	ds_doenca_w,
			ds_cirurgia_w,
			ds_anestesia_w,
			ds_medicamento_uso_w,
			ds_habito_w,
			ds_alergia_w
		;

		insert into anamnese_apae(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_aval_pre,
			ds_doenca,
			ds_cirurgia,
			ds_anestesia,
			ds_medicamento_uso,
			ds_habito,
			ds_alergia)
		values (	nextval('anamnese_apae_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_aval_pre_anest_p,
			ds_doenca_w,
			ds_cirurgia_w,
			ds_anestesia_w,
			ds_medicamento_uso_w,
			ds_habito_w,
			ds_alergia_w);
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_inf_adic_apae ( nr_aval_pre_anest_p bigint, nr_atendimento_p bigint, cd_profissional_p text, cd_pessoa_fisica_p text, nr_seq_template_p bigint, nm_usuario_p text) FROM PUBLIC;

