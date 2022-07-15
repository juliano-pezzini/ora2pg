-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cp_create_care_plan ( ds_unique_value_p care_plan.ds_unique_value%type, ds_version_p care_plan.ds_version%type, ds_long_name_p care_plan.ds_long_name%type, ds_display_name_p care_plan.ds_display_name%type, ds_description_p care_plan.ds_description%type, cd_estabelecimento_p care_plan.cd_estabelecimento%type, ie_language_p care_plan.ie_language%type, ie_active_p care_plan.ie_active%type, nm_usuario_p care_plan.nm_usuario%type, nr_sequencia_p INOUT care_plan.nr_sequencia%type ) AS $body$
DECLARE


ds_version_w			care_plan.ds_version%type;
ds_display_name_w		care_plan.ds_display_name%type;
si_record_changed_w		care_plan.si_record_changed%type;


BEGIN

begin
	select	nr_sequencia,
			ds_version,
			ds_display_name
	into STRICT	nr_sequencia_p,
			ds_version_w,
			ds_display_name_w
	from	care_plan
	where	nr_sequencia = (
		SELECT	max(nr_sequencia)
		from	care_plan
		where	ds_unique_value = ds_unique_value_p
	);
exception
	when no_data_found then
	begin
		nr_sequencia_p		:= null;
		ds_version_w		:= null;
		ds_display_name_w 	:= null;
	end;
end;

select	CASE WHEN count(1)=0 THEN  'N'  ELSE 'Y' END
into STRICT	si_record_changed_w
from	care_plan
where	(ds_version IS NOT NULL AND ds_version::text <> '')
and		ds_version <> ds_version_p;

if (ds_version_w IS NOT NULL AND ds_version_w::text <> '') and (si_record_changed_w = 'Y') then

	select	CASE WHEN count(1)=0 THEN  'Y'  ELSE 'N' END
	into STRICT	si_record_changed_w
	from	care_plan
	where	ds_unique_value = ds_unique_value_p;
	
	if (si_record_changed_w = 'N') then
		select	CASE WHEN ds_display_name_p=coalesce(ds_display_name_w, ds_display_name_p) THEN  'N'  ELSE 'Y' END
		into STRICT	si_record_changed_w
		;
	end if;

end if;

if (coalesce(nr_sequencia_p::text, '') = '' or ds_version_w <> ds_version_p) then
	select	nextval('care_plan_seq')
	into STRICT	nr_sequencia_p
	;

	insert into care_plan(
		nr_sequencia,
		ds_unique_value,
		ds_version,
		cd_estabelecimento,
		ds_long_name,
		ds_display_name,
		ds_description,
		ie_language,
		ie_origin,
		ie_active,
		si_import_status,
		ie_situacao,
		nm_usuario,
		dt_atualizacao,
		nm_usuario_nrec,
		dt_atualizacao_nrec,
		si_record_changed
	) values (
		nr_sequencia_p,
		ds_unique_value_p,
		ds_version_p,
		cd_estabelecimento_p,
		ds_long_name_p,
		ds_display_name_p,
		ds_description_p,
		ie_language_p,
		'E', -- From Elsevier
		ie_active_p,
		'SP',
		'I',
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		coalesce(si_record_changed_w, 'N')
	);
	
	update	care_plan
	set		si_record_changed = 'N'
	where 	ds_version = ds_version_w;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cp_create_care_plan ( ds_unique_value_p care_plan.ds_unique_value%type, ds_version_p care_plan.ds_version%type, ds_long_name_p care_plan.ds_long_name%type, ds_display_name_p care_plan.ds_display_name%type, ds_description_p care_plan.ds_description%type, cd_estabelecimento_p care_plan.cd_estabelecimento%type, ie_language_p care_plan.ie_language%type, ie_active_p care_plan.ie_active%type, nm_usuario_p care_plan.nm_usuario%type, nr_sequencia_p INOUT care_plan.nr_sequencia%type ) FROM PUBLIC;

