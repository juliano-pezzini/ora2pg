-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_proc_conv_rotina ( nr_seq_item_grupo_p bigint, nr_seq_agenda_p text, cd_estabelecimento_p bigint, ds_erro_p INOUT text, ie_agenda_p INOUT text) AS $body$
DECLARE


cd_agenda_w		bigint;
cd_profissional_w	varchar(10);
cd_pessoa_fisica_w	varchar(10);
cd_convenio_w		integer;
cd_categoria_w		varchar(10);
cd_plano_w		varchar(10);
dt_agenda_w		timestamp;
cd_empresa_ref_w		bigint;

cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
nr_seq_proc_interno_w		bigint;


ie_consistencia_w		varchar(255);
ie_agenda_w			varchar(1);
nr_seq_regra_w			bigint;
ie_consist_js_w			varchar(400);
ie_anestesia_w		varchar(1);


BEGIN

if (nr_seq_agenda_p <> 0) and (nr_seq_item_grupo_p <> 0) then

	select	max(cd_procedimento),
		max(nr_seq_proc_interno),
		max(ie_origem_proced)
	into STRICT	cd_procedimento_w,
		nr_seq_proc_interno_w,
		ie_origem_proced_w
	from	agenda_cons_grupo_item
	where	nr_sequencia = nr_seq_item_grupo_p;


	select	max(a.cd_convenio),
		max(a.cd_categoria),
		max(a.cd_agenda),
		max(a.cd_medico_exec),
		max(a.cd_pessoa_fisica),
		max(a.cd_plano),
		max(a.hr_inicio),
		max(a.cd_empresa_ref),
		max(coalesce(ie_anestesia,'N'))
	into STRICT	cd_convenio_w,
		cd_categoria_w,
		cd_agenda_w,
		cd_profissional_w,
		cd_pessoa_fisica_w,
		cd_plano_w,
		dt_agenda_w,
		cd_empresa_ref_w,
		ie_anestesia_w
	from	agenda_paciente a,
		agenda b
	where	a.cd_agenda = b.cd_agenda
	and	a.nr_sequencia  = nr_seq_agenda_p;

	SELECT * FROM consistir_proc_conv_agenda(
				cd_estabelecimento_p, cd_pessoa_fisica_w, dt_agenda_w, cd_agenda_w, cd_convenio_w, cd_categoria_w, cd_procedimento_w, ie_origem_proced_w, nr_seq_proc_interno_w, cd_profissional_w, 'E', cd_plano_w, null, null, null, cd_empresa_ref_w, ie_anestesia_w, null, null) INTO STRICT ie_consistencia_w, ie_agenda_w, nr_seq_regra_w, ie_consist_js_w;

	if	((ie_agenda_w = 'N') or (ie_agenda_w = 'Q') or (ie_agenda_w = 'H')) then
		ds_erro_p := ie_consistencia_w;
	end if;

	if (coalesce(ds_erro_p::text, '') = '') then
		SELECT * FROM consistir_proc_conv_agenda(
				cd_estabelecimento_p, cd_pessoa_fisica_w, dt_agenda_w, cd_agenda_w, cd_convenio_w, cd_categoria_w, cd_procedimento_w, ie_origem_proced_w, nr_seq_proc_interno_w, cd_profissional_w, 'R', cd_plano_w, null, null, null, cd_empresa_ref_w, ie_anestesia_w, null, null) INTO STRICT ie_consistencia_w, ie_agenda_w, nr_seq_regra_w, ie_consist_js_w;
	end if;

	if	((ie_agenda_w = 'N') or (ie_agenda_w = 'Q') or (ie_agenda_w = 'H')) then
		ds_erro_p := ie_consistencia_w;
	end if;

	ie_agenda_p := ie_agenda_w;

end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_proc_conv_rotina ( nr_seq_item_grupo_p bigint, nr_seq_agenda_p text, cd_estabelecimento_p bigint, ds_erro_p INOUT text, ie_agenda_p INOUT text) FROM PUBLIC;
