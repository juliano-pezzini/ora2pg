-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_encaixe_agencons_js ( nr_seq_origem_p bigint, dt_encaixe_p timestamp, ie_encaixe_transf_p text, hr_encaixe_p timestamp, cd_medico_p text, cd_pessoa_fisica_p text, dt_agenda_p timestamp, qt_duracao_p bigint, nm_pessoa_fisica_p text, cd_convenio_p bigint, ds_observacao_p text, nr_seq_agenda_rxt_p bigint, ds_aviso_p INOUT text, ds_erro_p INOUT text, cd_agenda_p INOUT bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_agenda_w 	bigint;
nr_seq_agenda_w         agenda_consulta.nr_sequencia%type;
ds_erro_w	varchar(255);

BEGIN
if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	select  max(cd_agenda)
	into STRICT 	cd_agenda_w
	from 	agenda
	where 	cd_pessoa_fisica = cd_medico_p
	and 	cd_tipo_agenda = 3;		

	SELECT * FROM consistir_encaixe_agecons(
		cd_agenda_w, nr_seq_origem_p, dt_encaixe_p, ie_encaixe_transf_p, nm_usuario_p, cd_estabelecimento_p, hr_encaixe_p, null, null, null, null, ds_aviso_p, ds_erro_w) INTO STRICT ds_aviso_p, ds_erro_w;
	
	if (coalesce(ds_erro_w::text, '') = '')
		and (coalesce(ds_aviso_p::text, '') = '') then
		begin
		nr_seq_agenda_w := gerar_encaixe_agecons(
			cd_estabelecimento_p, cd_agenda_w, dt_agenda_p, hr_encaixe_p, qt_duracao_p, cd_pessoa_fisica_p, nm_pessoa_fisica_p, cd_convenio_p, cd_medico_p, ds_observacao_p, nr_seq_agenda_rxt_p, null, '', nm_usuario_p, null, nr_seq_agenda_w, '', '');
		end;
	end if;
	end;	
end if;
ds_erro_p 	 := ds_erro_w;
cd_agenda_p 	 := cd_agenda_w;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_encaixe_agencons_js ( nr_seq_origem_p bigint, dt_encaixe_p timestamp, ie_encaixe_transf_p text, hr_encaixe_p timestamp, cd_medico_p text, cd_pessoa_fisica_p text, dt_agenda_p timestamp, qt_duracao_p bigint, nm_pessoa_fisica_p text, cd_convenio_p bigint, ds_observacao_p text, nr_seq_agenda_rxt_p bigint, ds_aviso_p INOUT text, ds_erro_p INOUT text, cd_agenda_p INOUT bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

