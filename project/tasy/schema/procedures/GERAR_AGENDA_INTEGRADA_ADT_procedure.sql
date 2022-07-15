-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_agenda_integrada_adt (cd_agenda_p bigint, dt_agenda_p timestamp, cd_pessoa_fisica_p text, ie_classif_agenda_p text, nr_seq_agenda_exame_p bigint, ie_tipo_agendamento_p text, nm_usuario_p text, ds_observacao_p text, cd_convenio_p bigint, cd_categoria_p text, nr_seq_classif_agenda_p bigint, cd_estabelecimento_p bigint, nr_seq_ageint_p INOUT bigint) AS $body$
DECLARE


nr_seq_integracao_w		agenda_integrada.nr_sequencia%type;
nr_seq_item_w			bigint;
dt_inicio_dia_w			timestamp;
dt_fim_dia_w			timestamp;
nr_seq_status_w			bigint;
ie_tipo_agendamento_w		varchar(2);


BEGIN

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') and (dt_agenda_p IS NOT NULL AND dt_agenda_p::text <> '')  and (cd_agenda_p IS NOT NULL AND cd_agenda_p::text <> '')  then
	begin

	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_seq_integracao_w
	from	agenda_integrada
	where	cd_agenda_externa	= cd_agenda_p
	and	cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	trunc(dt_inicio_agendamento,'dd') = trunc(dt_agenda_p,'dd');

	if (nr_seq_integracao_w = 0) then

		select	nextval('agenda_integrada_seq')
		into STRICT	nr_seq_integracao_w
		;

		select	min(nr_sequencia)
		into STRICT	nr_seq_status_w
		from	agenda_integrada_status;

		insert 	into agenda_integrada(nr_sequencia          ,
			dt_atualizacao         ,
			nm_usuario             ,
			dt_atualizacao_nrec    ,
			nm_usuario_nrec        ,
			dt_inicio_agendamento  ,
			dt_fim_agendamento     ,
			nr_seq_status          ,
			cd_pessoa_fisica       ,
			cd_estabelecimento     ,
			cd_profissional        ,
			cd_convenio	       ,
			cd_categoria	       ,
			ds_observacao	       ,
			cd_agenda_externa)
		values (nr_seq_integracao_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			dt_agenda_p,
			null,
			nr_seq_status_w,
			cd_pessoa_fisica_p,
			cd_estabelecimento_p,
			obter_codigo_usuario(nm_usuario_p),
			cd_convenio_p,
			cd_categoria_p,
			ds_observacao_p,
			cd_agenda_p);

		commit;

	end if;

	if (ie_tipo_agendamento_p = 2 ) then
	      ie_tipo_agendamento_w := 'E';
	elsif (ie_tipo_agendamento_p in (3,4)) then
	      ie_tipo_agendamento_w := 'C';
	elsif (ie_tipo_agendamento_p = 5) then
	      ie_tipo_agendamento_w := 'S';
	end if;

	select	nextval('agenda_integrada_item_seq')
	into STRICT	nr_seq_item_w
	;

	insert 	into agenda_integrada_item(nr_sequencia       ,
		nr_seq_agenda_int   ,
		dt_atualizacao      ,
		nm_usuario          ,
		dt_atualizacao_nrec ,
		nm_usuario_nrec     ,
		ie_tipo_agendamento ,
		cd_medico           ,
		cd_especialidade    ,
		vl_item             ,
		ie_regra            ,
		ie_classif_agenda   ,
		nr_seq_proc_interno ,
		nr_seq_classif_agenda)
	values (nr_seq_item_w,
		nr_seq_integracao_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		ie_tipo_agendamento_w,
		null,
		null,
		null,
		null,
		ie_classif_agenda_p,
		nr_seq_agenda_exame_p,
		nr_seq_classif_agenda_p);

	commit;

	nr_seq_ageint_p	:= nr_seq_integracao_w;

	end;
end if;



end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_agenda_integrada_adt (cd_agenda_p bigint, dt_agenda_p timestamp, cd_pessoa_fisica_p text, ie_classif_agenda_p text, nr_seq_agenda_exame_p bigint, ie_tipo_agendamento_p text, nm_usuario_p text, ds_observacao_p text, cd_convenio_p bigint, cd_categoria_p text, nr_seq_classif_agenda_p bigint, cd_estabelecimento_p bigint, nr_seq_ageint_p INOUT bigint) FROM PUBLIC;

