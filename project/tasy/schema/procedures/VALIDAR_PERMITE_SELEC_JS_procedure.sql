-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE validar_permite_selec_js ( nr_seq_item_grupo_p bigint, nr_seq_agenda_p text, cd_estabelecimento_p bigint, cd_tipo_agenda_p bigint, ds_erro_p INOUT text, ie_agenda_p INOUT text) AS $body$
DECLARE


ie_regra_exame_conv_w		varchar(5);
cd_agenda_w			agenda.cd_agenda%type;
nr_seq_proc_interno_w		proc_interno. nr_sequencia %type;
cd_procedimento_w		procedimento. cd_procedimento %type;
ie_origem_proced_w		procedimento. ie_origem_proced %type;
dt_agenda_w			timestamp;
ds_mensagem_w			varchar(4000);


BEGIN

if (cd_tipo_agenda_p in (2,3,4,5)) then
	if (cd_tipo_agenda_p = 2) then
		select 	max(cd_agenda),
			max(hr_inicio)
		into STRICT	cd_agenda_w,
			dt_agenda_w
		from 	agenda_paciente
		where 	nr_sequencia = nr_seq_agenda_p;
	elsif (cd_tipo_agenda_p in (3,4,5)) then
		select 	max(cd_agenda),
			max(dt_agenda)
		into STRICT	cd_agenda_w,
			dt_agenda_w
		from 	agenda_consulta
		where 	nr_sequencia = nr_seq_agenda_p;
	end if;
	select	max(cd_procedimento),
		max(nr_seq_proc_interno),
		max(ie_origem_proced)
	into STRICT	cd_procedimento_w,
		nr_seq_proc_interno_w,
		ie_origem_proced_w
	from	agenda_cons_grupo_item
	where	nr_sequencia = nr_seq_item_grupo_p;
	ds_mensagem_w := obter_msg_bloq_geral_agenda_js(cd_estabelecimento_p,
					cd_agenda_w,
					nr_seq_agenda_p,
					0,
					dt_agenda_w,
					'N',
					'N',
					nr_seq_proc_interno_w,
					cd_procedimento_w,
					ie_origem_proced_w);
	if (ds_mensagem_w IS NOT NULL AND ds_mensagem_w::text <> '') then
		ds_erro_p := ds_mensagem_w;
		ie_agenda_p := 'H';
	elsif (cd_tipo_agenda_p = 2) then
		ie_regra_exame_conv_w := obter_param_usuario(820, 398, obter_perfil_ativo, obter_usuario_ativo, cd_estabelecimento_p, ie_regra_exame_conv_w);
		if (ie_regra_exame_conv_w = 'S') then
			SELECT * FROM Consistir_proc_conv_rotina(nr_seq_item_grupo_p, nr_seq_agenda_p, cd_estabelecimento_p, ds_erro_p, ie_agenda_p) INTO STRICT ds_erro_p, ie_agenda_p;
		end if;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE validar_permite_selec_js ( nr_seq_item_grupo_p bigint, nr_seq_agenda_p text, cd_estabelecimento_p bigint, cd_tipo_agenda_p bigint, ds_erro_p INOUT text, ie_agenda_p INOUT text) FROM PUBLIC;

