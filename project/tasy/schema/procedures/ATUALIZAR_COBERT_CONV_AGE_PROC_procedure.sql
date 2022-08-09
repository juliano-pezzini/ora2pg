-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_cobert_conv_age_proc (nr_seq_agenda_p bigint) AS $body$
DECLARE


cd_estabelecimento_w		smallint;
cd_convenio_w			integer;
cd_convenio_ww			integer;
cd_categoria_w			varchar(10);
cd_categoria_ww			varchar(10);
ie_tipo_atendimento_w		smallint;
nr_seq_proc_interno_w		varchar(10);
cd_agenda_w			bigint;
nr_atendimento_w		bigint;
cd_setor_atendimento_w		integer;
cd_pessoa_fisica_w		varchar(10);
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
cd_plano_w			varchar(10);
cd_plano_ww			varchar(10);
ie_cobertura_conv_w		varchar(15);
ie_regra_w			integer;
nr_seq_agenda_w			integer;
cd_medico_w			varchar(10);
cd_tipo_acomodacao_w	agenda_paciente.cd_tipo_acomodacao%type;
cd_usuario_convenio_w	agenda_paciente.cd_usuario_convenio%type;
ie_carater_cirurgia_w	agenda_paciente.ie_carater_cirurgia%type;
ds_erro_w		varchar(255);

C01 CURSOR FOR
SELECT cd_convenio,
       cd_procedimento,
       ie_origem_proced,
       nr_seq_proc_interno,						
       cd_categoria,
       nr_seq_agenda,
       cd_plano
FROM   agenda_paciente_proc
WHERE  nr_sequencia = nr_seq_agenda_p;


BEGIN
begin
	open C01;
	loop
	fetch C01 into
		cd_convenio_ww,
		cd_procedimento_w,
		ie_origem_proced_w,
		nr_seq_proc_interno_w,
		cd_categoria_ww,
		nr_seq_agenda_w,
		cd_plano_ww;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		
		select	max(b.cd_estabelecimento),
			max(a.cd_convenio),
			max(a.cd_categoria),
			max(a.ie_tipo_atendimento),
			max(a.nr_atendimento),
			max(a.cd_setor_atendimento),
			max(a.cd_pessoa_fisica),
			max(a.cd_plano),
			max(a.cd_tipo_acomodacao),
			max(a.cd_usuario_convenio),
			max(a.ie_carater_cirurgia)
		into STRICT	cd_estabelecimento_w,
			cd_convenio_w,
			cd_categoria_w,
			ie_tipo_atendimento_w,
			nr_atendimento_w,
			cd_setor_atendimento_w,
			cd_pessoa_fisica_w,
			cd_plano_w,
			cd_tipo_acomodacao_w,
			cd_usuario_convenio_w,
			ie_carater_cirurgia_w
		from	agenda_paciente a,
			agenda b
		where	a.cd_agenda = b.cd_agenda
		and	a.nr_sequencia = nr_seq_agenda_p;
	
		
		SELECT * FROM verif_autorizacao_conv_age_pac(nr_atendimento_w, coalesce(cd_convenio_ww,cd_convenio_w), cd_procedimento_w, ie_origem_proced_w, nr_seq_proc_interno_w, ie_tipo_atendimento_w, coalesce(cd_plano_ww,cd_plano_w), cd_setor_atendimento_w, coalesce(cd_categoria_ww,cd_categoria_w), cd_estabelecimento_w, nr_seq_agenda_p, cd_medico_w, cd_pessoa_fisica_w, ie_cobertura_conv_w, ie_regra_w, ds_erro_w, cd_tipo_acomodacao_w, cd_usuario_convenio_w, ie_carater_cirurgia_w) INTO STRICT ie_cobertura_conv_w, ie_regra_w, ds_erro_w;

						
		update agenda_paciente_proc
		set    ie_cobertura_conv = ie_cobertura_conv_w
		where  nr_sequencia      = nr_seq_agenda_p
		and    nr_seq_agenda     = nr_seq_agenda_w;
		commit;				
		
	end loop;
	close C01;
	
exception
	when others then
	null;
end;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_cobert_conv_age_proc (nr_seq_agenda_p bigint) FROM PUBLIC;
