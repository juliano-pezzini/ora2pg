-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE agecir_gerar_cobertura (nr_seq_agenda_item_p bigint default 0, nr_seq_agenda_p bigint DEFAULT NULL, nm_usuario_p text DEFAULT NULL) AS $body$
DECLARE



cd_estab_w				estabelecimento.cd_estabelecimento%type;
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;
cd_convenio_w			agenda_paciente.cd_convenio%type;
cd_categoria_w			agenda_paciente.cd_categoria%type;
cd_plano_w				agenda_paciente.cd_plano%type;
ie_tipo_Atendimento_w	agenda_paciente.ie_tipo_Atendimento%type;
cd_usuario_convenio_w	agenda_paciente.cd_usuario_convenio%type;
ie_Sexo_w				pessoa_fisica.ie_sexo%type;
qt_idade_w				integer;
dt_nascimento_w			timestamp;
cd_pessoa_fisica_w		pessoa_fisica.cd_pessoa_fisica%type;
cd_procedimento_w		agenda_paciente_proc.cd_procedimento%type;
ie_origem_proced_w		agenda_paciente_proc.ie_origem_proced%type;
nr_seq_proc_interno_w	agenda_paciente_proc.nr_seq_proc_interno%type;
cd_conv_item_w			agenda_paciente_proc.cd_convenio%type;
cd_categ_item_w			agenda_paciente_proc.cd_categoria%type;
cd_plano_item_w			agenda_paciente_proc.cd_plano%type;

vl_aux_w				double precision;
ds_aux_w				varchar(10);
nr_seq_regra_w			bigint;
ie_regra_w				integer;
ie_glosa_w				varchar(1);


C01 CURSOR FOR
	SELECT	cd_estabelecimento
	from	estabelecimento
	where	ie_situacao = 'A';


BEGIN

delete	FROM w_agecir_cobertura_item
where	nr_seq_agecir_item	= nr_seq_agenda_p
and		nm_usuario		= nm_usuario_p;

select	max(obter_estab_agenda(cd_agenda)),
		max(cd_convenio),
		max(cd_categoria),
		max(cd_plano),
		max(ie_tipo_Atendimento),
		max(cd_usuario_convenio),
		max(cd_pessoa_fisica),
		max(cd_procedimento),
		max(nr_seq_proc_interno),
		max(ie_origem_proced)
into STRICT	cd_estabelecimento_w,
		cd_convenio_w,
		cd_categoria_w,
		cd_plano_w,
		ie_tipo_atendimento_w,
		cd_usuario_convenio_w,
		cd_pessoa_fisica_w,
		cd_procedimento_w,
		nr_seq_proc_interno_w,
		ie_origem_proced_w
from	agenda_paciente
where	nr_sequencia	= nr_seq_agenda_p;

cd_conv_item_w := 0;

if (coalesce(nr_seq_agenda_item_p, 0) > 0) then
	select	max(cd_procedimento),
			max(nr_seq_proc_interno),
			max(ie_origem_proced),
			max(cd_convenio),
			max(cd_categoria),
			max(cd_plano)
	into STRICT	cd_procedimento_w,
			nr_seq_proc_interno_w,
			ie_origem_proced_w,
			cd_conv_item_w,
			cd_categ_item_w,
			cd_plano_item_w
	from	agenda_paciente_proc
	where	nr_sequencia = nr_seq_agenda_p
	and		nr_seq_agenda = nr_seq_agenda_item_p;
end if;

select	max(ie_sexo),
		max(dt_nascimento)
into STRICT	ie_Sexo_w,
		dt_nascimento_w
from	pessoa_fisica
where	cd_pessoa_fisica	= cd_pessoa_fisica_w;

if (coalesce(cd_conv_item_w, 0) > 0) then
	cd_convenio_w	:= cd_conv_item_w;
	cd_categoria_w	:= cd_categ_item_w;
	cd_plano_w	:= cd_plano_item_w;
end if;


qt_idade_w	:= obter_idade(dt_nascimento_w, clock_timestamp(), 'A');

if	((coalesce(cd_procedimento_w::text, '') = '') or (coalesce(ie_origem_proced_w::text, '') = '')) then

	SELECT * FROM obter_proc_tab_interno_conv(nr_seq_proc_interno_w, cd_estabelecimento_w, cd_convenio_w, cd_categoria_w, cd_plano_w, null, cd_procedimento_w, ie_origem_proced_w, null, clock_timestamp(), null, null, null, null, null, null, null, null) INTO STRICT cd_procedimento_w, ie_origem_proced_w;

end if;


open C01;
loop
fetch C01 into
	cd_estab_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin


	SELECT * FROM Consiste_Plano_mat_proc(cd_estab_w, cd_convenio_w, cd_categoria_w, cd_plano_w, null, cd_procedimento_w, ie_origem_proced_w, null, coalesce(ie_tipo_Atendimento_w,0), 0, 0, null, nr_seq_proc_interno_w, ds_aux_w, ds_aux_w, ie_regra_w, nr_seq_regra_w) INTO STRICT ds_aux_w, ds_aux_w, ie_regra_w, nr_seq_regra_w;

	SELECT * FROM obter_regra_Ajuste_proc(
				cd_estab_w, cd_convenio_w, cd_categoria_w, cd_procedimento_w, ie_origem_proced_w, null, clock_timestamp(), null, coalesce(ie_tipo_Atendimento_w,0), null, null, null, qt_idade_w, NULL, nr_seq_proc_interno_w, cd_usuario_convenio_w, cd_plano_w, null, null, ie_sexo_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, ds_aux_w, ie_glosa_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, null, null, ds_aux_w, vl_aux_w, ds_aux_w, vl_aux_w, null, null, null, null, null, null, null, null, vl_aux_w, null, null, null, null, null, null, null, null, null, null) INTO STRICT vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, ds_aux_w, ie_glosa_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, vl_aux_w, ds_aux_w, vl_aux_w, ds_aux_w, vl_aux_w, vl_aux_w;

	insert into w_agecir_cobertura_item(ie_glosa,
										ie_regra,
										cd_estabelecimento,
										nr_seq_agecir_item,
										nm_usuario)
									values (
										ie_glosa_w,
										ie_regra_w,
										cd_estab_w,
										nr_seq_agenda_p,
										nm_usuario_p);

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE agecir_gerar_cobertura (nr_seq_agenda_item_p bigint default 0, nr_seq_agenda_p bigint DEFAULT NULL, nm_usuario_p text DEFAULT NULL) FROM PUBLIC;

