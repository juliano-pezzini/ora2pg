-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_sexo_proc_rotina ( nr_seq_item_grupo_p bigint, nr_seq_agenda_p text, cd_estabelecimento_p bigint, ds_erro_p INOUT text, ie_agenda_p INOUT text) AS $body$
DECLARE


cd_pessoa_fisica_w	varchar(10);

cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
nr_seq_proc_interno_w		bigint;

ie_valida_sexo_w	varchar(1);
ie_agenda_w			varchar(1);


BEGIN

ie_agenda_w := '';

if (nr_seq_agenda_p <> 0) and (nr_seq_item_grupo_p <> 0) then

	select	max(cd_procedimento),
		max(nr_seq_proc_interno),
		max(ie_origem_proced)
	into STRICT	cd_procedimento_w,
		nr_seq_proc_interno_w,
		ie_origem_proced_w
	from	agenda_cons_grupo_item
	where	nr_sequencia = nr_seq_item_grupo_p;

	select max(a.cd_pessoa_fisica)
	into STRICT cd_pessoa_fisica_w
	from	agenda_paciente a,
		agenda b
	where	a.cd_agenda = b.cd_agenda
	and	a.nr_sequencia  = nr_seq_agenda_p;

	ie_valida_sexo_w := substr(consistir_sexo_exclusivo_proc(cd_pessoa_fisica_w, nr_seq_proc_interno_w, cd_procedimento_w, ie_origem_proced_w),1,1);

    	if (ie_valida_sexo_w = 'N') then
		ds_erro_p := substr(obter_texto_tasy(32712, wheb_usuario_pck.get_nr_seq_idioma),1,255);
		ie_agenda_w := 'S';
	end if;

	ie_agenda_p := ie_agenda_w;

end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_sexo_proc_rotina ( nr_seq_item_grupo_p bigint, nr_seq_agenda_p text, cd_estabelecimento_p bigint, ds_erro_p INOUT text, ie_agenda_p INOUT text) FROM PUBLIC;

