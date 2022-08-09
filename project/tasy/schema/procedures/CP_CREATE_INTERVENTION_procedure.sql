-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cp_create_intervention ( ds_unique_value_p cp_intervention.ds_unique_value%type, ds_display_name_p cp_intervention.ds_display_name%type, ds_obs_item_label_part1_p cp_intervention.ds_obs_item_label_part1%type, ds_obs_item_label_part2_p cp_intervention.ds_obs_item_label_part2%type, ds_obs_item_display_name_p cp_intervention.ds_obs_item_display_name%type, ie_data_type_p cp_intervention.ie_data_type%type, ie_language_p cp_intervention.ie_language%type, ds_version_p cp_intervention.ds_version%type, ie_active_p cp_intervention.ie_active%type, nm_usuario_p cp_intervention.nm_usuario%type, nr_sequencia_p INOUT cp_intervention.nr_sequencia%type ) AS $body$
DECLARE


ds_version_w				cp_intervention.ds_version%type;
nr_seq_pe_procedimento_w	cp_intervention.nr_seq_pe_procedimento%type;
nr_seq_origem_w				origem_diagnostico.nr_sequencia%type;
ds_display_name_w			cp_intervention.ds_display_name%type;
si_record_changed_w			cp_intervention.si_record_changed%type;


BEGIN

begin
	select	nr_sequencia,
			ds_version,
			ds_display_name
	into STRICT	nr_sequencia_p,
			ds_version_w,
			ds_display_name_w
	from	cp_intervention
	where	nr_sequencia = (
		SELECT	max(nr_sequencia)
		from	cp_intervention
		where	ds_unique_value = ds_unique_value_p
	);
exception
	when no_data_found then
	begin
		nr_sequencia_p		:= null;
		ds_version_w		:= null;
		ds_display_name_w	:= null;
	end;
end;

select	CASE WHEN count(1)=0 THEN  'N'  ELSE 'Y' END
into STRICT	si_record_changed_w
from	cp_intervention
where	(ds_version IS NOT NULL AND ds_version::text <> '')
and		ds_version <> ds_version_p;

if (ds_version_w IS NOT NULL AND ds_version_w::text <> '') and (si_record_changed_w = 'Y') then

	select	CASE WHEN count(1)=0 THEN  'Y'  ELSE 'N' END
	into STRICT	si_record_changed_w
	from	cp_intervention
	where	ds_unique_value = ds_unique_value_p;
	
	if (si_record_changed_w = 'N') then
		select	CASE WHEN ds_display_name_p=coalesce(ds_display_name_w, ds_display_name_p) THEN  'N'  ELSE 'Y' END
		into STRICT	si_record_changed_w
		;
	end if;

end if;

if (coalesce(nr_sequencia_p::text, '') = '' or ds_version_w <> ds_version_p) then
	select	coalesce(max(nr_sequencia), null)
	into STRICT	nr_seq_pe_procedimento_w
	from	pe_procedimento
	where	ds_intervencao_orig = ds_unique_value_p;

	if (coalesce(nr_seq_pe_procedimento_w::text, '') = '') then
		-- Find nr_sequencia from origem_diagnostico to use on pe_procedimento
		select	coalesce(max(nr_sequencia), 0)
		into STRICT	nr_seq_origem_w
		from	origem_diagnostico
		where	upper(ds_origem) = 'ELSEVIER'
		and	ie_situacao = 'A';

		if (nr_seq_origem_w = 0) then
			select	nextval('origem_diagnostico_seq')
			into STRICT	nr_seq_origem_w
			;

			insert into origem_diagnostico(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				ds_origem,
				ie_situacao,
				dt_atualizacao_nrec,
				nm_usuario_nrec
			) values (
				nr_seq_origem_w,
				clock_timestamp(),
				nm_usuario_p,
				'ELSEVIER',
				'A',
				clock_timestamp(),
				nm_usuario_p
			);
		end if;

		select	nextval('pe_procedimento_seq')
		into STRICT	nr_seq_pe_procedimento_w
		;

		insert into pe_procedimento(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			ds_procedimento,
			ie_situacao,
			ie_origem,
			nr_seq_origem,
			ds_intervencao_orig,
			ie_adep
		) values (
			nr_seq_pe_procedimento_w,
			clock_timestamp(),
			nm_usuario_p,
			ds_display_name_p,
			'A',
			'O',
			nr_seq_origem_w,
			ds_unique_value_p,
			'S'
		);
	end if;

	select	nextval('cp_intervention_seq')
	into STRICT	nr_sequencia_p
	;

	insert into cp_intervention(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ds_unique_value,
		ds_display_name,
		ds_obs_item_label_part1,
		ds_obs_item_label_part2,
		ds_obs_item_display_name,
		ie_data_type,
		ie_language,
		ds_version,
		ie_active,
		ie_origin,
		si_import_status,
		ie_situacao,
		nr_seq_pe_procedimento,
		si_record_changed
	) values (
		nr_sequencia_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		ds_unique_value_p,
		ds_display_name_p,
		ds_obs_item_label_part1_p,
		ds_obs_item_label_part2_p,
		ds_obs_item_display_name_p,
		ie_data_type_p,
		ie_language_p,
		ds_version_p,
		ie_active_p,
		'E', -- From Elsevier
		'SP',
		'I',
		nr_seq_pe_procedimento_w,
		coalesce(si_record_changed_w, 'N')
	);
	
	update	cp_intervention
	set		si_record_changed = 'N'
	where 	ds_version = ds_version_w;
	
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cp_create_intervention ( ds_unique_value_p cp_intervention.ds_unique_value%type, ds_display_name_p cp_intervention.ds_display_name%type, ds_obs_item_label_part1_p cp_intervention.ds_obs_item_label_part1%type, ds_obs_item_label_part2_p cp_intervention.ds_obs_item_label_part2%type, ds_obs_item_display_name_p cp_intervention.ds_obs_item_display_name%type, ie_data_type_p cp_intervention.ie_data_type%type, ie_language_p cp_intervention.ie_language%type, ds_version_p cp_intervention.ds_version%type, ie_active_p cp_intervention.ie_active%type, nm_usuario_p cp_intervention.nm_usuario%type, nr_sequencia_p INOUT cp_intervention.nr_sequencia%type ) FROM PUBLIC;
