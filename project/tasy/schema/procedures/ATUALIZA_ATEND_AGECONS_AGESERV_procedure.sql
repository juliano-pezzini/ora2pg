-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_atend_agecons_ageserv (nr_atendimento_p bigint, ds_lista_agenda_cons_p text, ds_lista_Agenda_Serv_p text, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w		bigint;
nr_atendimento_w	bigint;
ds_lista_w		varchar(1000);
tam_lista_w		bigint;
ie_pos_virgula_w	smallint;


BEGIN

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

	update	agenda_consulta
	set	nr_atendimento 	= nr_atendimento_p,
		dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_sequencia	= nr_sequencia_w;

    update autorizacao_convenio
    set nr_atendimento  = nr_atendimento_p,
        dt_atualizacao  = clock_timestamp(),
        nm_usuario     = nm_usuario_p
    where nr_seq_agenda_consulta = nr_sequencia_w;

	end;
end loop;

ds_lista_w := ds_lista_agenda_serv_p;

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

	update	agenda_consulta
	set	nr_atendimento 	= nr_atendimento_p,
		dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_sequencia	= nr_sequencia_w;

    update autorizacao_convenio
    set nr_atendimento  = nr_atendimento_p,
        dt_atualizacao = clock_timestamp(),
        nm_usuario     = nm_usuario_p
    where nr_seq_agenda_consulta = nr_sequencia_w;

	end;
end loop;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_atend_agecons_ageserv (nr_atendimento_p bigint, ds_lista_agenda_cons_p text, ds_lista_Agenda_Serv_p text, nm_usuario_p text) FROM PUBLIC;

