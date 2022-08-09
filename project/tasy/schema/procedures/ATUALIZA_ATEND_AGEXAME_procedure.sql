-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_atend_agexame (nr_atendimento_p bigint, ds_lista_agenda_cons_p text, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w			bigint;
nr_atendimento_w		bigint;
ds_lista_w				varchar(1000);
tam_lista_w				bigint;
ie_pos_virgula_w		smallint;
ie_gerar_oft_ag_ex_w	varchar(15);
ie_gerar_oft_eup_w	varchar(15);
nr_seq_oftalmo_w		agenda_paciente.nr_seq_oftalmo%type;
cd_medico_exec_w		agenda_paciente.cd_medico_exec%type;




BEGIN

ie_gerar_oft_ag_ex_w := obter_param_usuario(820, 369, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_gerar_oft_ag_ex_w);
ie_gerar_oft_eup_w := obter_param_usuario(916, 1091, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_gerar_oft_eup_w);


ds_lista_w := ds_lista_agenda_cons_p;

if (substr(ds_lista_w,length(ds_lista_w) - 1, length(ds_lista_w))	<> ',') then
	ds_lista_w	:= ds_lista_w ||',';
end if;

while(ds_lista_w IS NOT NULL AND ds_lista_w::text <> '') loop
	begin

	tam_lista_w		:= length(ds_lista_w);
	ie_pos_virgula_w	:= position(',' in ds_lista_w);

	if (ie_pos_virgula_w <> 0) then
		nr_sequencia_w		:= (substr(ds_lista_w,1,(ie_pos_virgula_w - 1)))::numeric;
		ds_lista_w		:= substr(ds_lista_w,(ie_pos_virgula_w + 1),tam_lista_w);
	end if;

	update	agenda_paciente
	set		nr_atendimento 	= nr_atendimento_p,
				dt_atualizacao		= clock_timestamp(),
				nm_usuario			= nm_usuario_p
	where		nr_sequencia		= nr_sequencia_w;

	select	max(nr_seq_oftalmo),
				max(cd_medico_exec)
	into STRICT		nr_seq_oftalmo_w,
				cd_medico_exec_w
	from		agenda_paciente
	where		nr_sequencia = nr_sequencia_w;

	if (ie_gerar_oft_eup_w = 'N') and (ie_gerar_oft_ag_ex_w = 'A') and (coalesce(nr_sequencia_w,0) > 0) and (coalesce(nr_atendimento_p,0) > 0) and (coalesce(nr_seq_oftalmo_w::text, '') = '') and (cd_medico_exec_w IS NOT NULL AND cd_medico_exec_w::text <> '') then
		CALL gerar_consulta_oft_agenda(null,nr_sequencia_w,nm_usuario_p,wheb_usuario_pck.get_cd_estabelecimento);
	end if;

	end;
end loop;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_atend_agexame (nr_atendimento_p bigint, ds_lista_agenda_cons_p text, nm_usuario_p text) FROM PUBLIC;
