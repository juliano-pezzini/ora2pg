-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reg_criar_revisao_documento ( nr_seq_documento_p bigint, cd_versao_p text ) AS $body$
DECLARE


nr_revision_w		bigint;
nr_seq_revision_w	bigint;
nr_round_w		bigint;
nr_seq_rev_control_w	bigint;
nm_usuario_w		varchar(15);
ds_comando_w		varchar(4000);
nm_tabela_w		varchar(255);
qt_occurrence_w		bigint := 0;
qt_pos_semicolon_w	bigint := 0;
qt_pos_prev_semicolon_w	bigint := 0;

nm_tabelas_w			reg_tipo_documento.nm_tabelas%type;
ds_restricao_w			reg_tipo_documento.ds_restricao%type;
ds_restricao_temp_w		reg_tipo_documento.ds_restricao%type;
nr_seq_area_customer_w		reg_documento.nr_seq_area_customer%type;
ds_content_db_w			db_document.ds_content%type;WITH RECURSIVE cte AS (


c_tabelas CURSOR(nm_tabelas_p	text) FOR
SELECT	regexp_substr(nm_tabelas_p, '[^;]+', 1, level) nm_tabela

(regexp_substr(nm_tabelas_p, '[^;]+', 1, level) IS NOT NULL AND (regexp_substr(nm_tabelas_p, '[^;]+', 1, level))::text <> '')  UNION ALL


c_tabelas CURSOR(nm_tabelas_p	text) FOR
SELECT	regexp_substr(nm_tabelas_p, '[^;]+', 1, level) nm_tabela

(regexp_substr(nm_tabelas_p, '[^;]+', 1, level) IS NOT NULL AND (regexp_substr(nm_tabelas_p, '[^;]+', 1, level))::text <> '') JOIN cte c ON ()

) SELECT * FROM cte;
;

BEGIN

	nm_usuario_w := wheb_usuario_pck.get_nm_usuario();

	-- reg_version_revision
	select	coalesce(max(nr_revision) + 1, 1)
	into STRICT	nr_revision_w
	from	reg_version_revision
	where	nr_seq_documento = nr_seq_documento_p
	and	ie_status_revisao <> 'C';
	
	select	nextval('reg_version_revision_seq')
	into STRICT	nr_seq_revision_w
	;

	begin
	select	d.ds_content
	into STRICT	ds_content_db_w
	from	db_document d
	where	nr_sequencia in (
					SELECT	max(rg.nr_seq_document)
					from	reg_documento rg
					where	rg.nr_sequencia = nr_seq_documento_p
				);
	exception
		when others then
		ds_content_db_w := null;
	end;

	insert into reg_version_revision(
		nr_sequencia,
		nr_seq_documento,
		nr_revision,
		cd_versao,
		ie_status_revisao,
		nm_usuario_nrec,
		nm_usuario,
		dt_atualizacao,
		dt_atualizacao_nrec,
		ds_doc_structure)
	values (
		nr_seq_revision_w,
		nr_seq_documento_p,
		nr_revision_w,
		cd_versao_p,
		(
			case	when		nr_revision_w = 1
					and	(ds_content_db_w IS NOT NULL AND ds_content_db_w::text <> '') then 'R'
				else	'U'
			end
		),
		nm_usuario_w,
		nm_usuario_w,
		clock_timestamp(),
		clock_timestamp(),
		ds_content_db_w);

	update	reg_documento
	set	nr_revisao = nr_revision_w,
		dt_atualizacao = clock_timestamp(),
		nm_usuario = nm_usuario_w
	where	nr_sequencia = nr_seq_documento_p;

	-- reg_revision_control
	select	nextval('reg_revision_control_seq')
	into STRICT	nr_seq_rev_control_w
	;

	select coalesce(max(nr_round) + 1, 1)
	into STRICT   nr_round_w
	from   reg_revision_control
	where  nr_seq_revisao = nr_seq_revision_w;

	insert into reg_revision_control(
		nr_sequencia,
		nr_seq_revisao,
		nr_round,
		nm_usuario_nrec,
		nm_usuario,
		dt_atualizacao_nrec,
		dt_atualizacao )
	values (
		nr_seq_rev_control_w,
		nr_seq_revision_w,
		nr_round_w,
		nm_usuario_w,
		nm_usuario_w,
		clock_timestamp(),
		clock_timestamp() );

	-- reg_version_approvers
	insert into reg_version_approvers(
		nr_sequencia,
		nr_seq_revision,
		nr_seq_rev_control,
		nm_approver,
		nm_usuario_nrec,
		nm_usuario,
		dt_atualizacao_nrec,
		dt_atualizacao,
		ie_approver_type )
	SELECT	nextval('reg_version_approvers_seq'),
		nr_seq_revision_w,
		nr_seq_rev_control_w,
		nm_usuario_revisor,
		nm_usuario_w,
		nm_usuario_w,
		clock_timestamp(),
		clock_timestamp(),
		ie_tipo_revisor
	from	reg_doc_revisor
	where	nr_seq_documento = nr_seq_documento_p
	and	ie_tipo_revisor <> 'C';

	select	rtd.nm_tabelas,
		coalesce(rtd.ds_restricao, '') ds_restricao,
		rd.nr_seq_area_customer
	into STRICT	nm_tabelas_w,
		ds_restricao_w,
		nr_seq_area_customer_w
	from	reg_documento rd,
		reg_tipo_documento rtd
	where	rd.nr_seq_tipo_documento = rtd.nr_sequencia
	and	rd.nr_sequencia = nr_seq_documento_p;

	if (nm_tabelas_w IS NOT NULL AND nm_tabelas_w::text <> '') then
		for r_c_tabelas in c_tabelas(nm_tabelas_w) loop
			qt_occurrence_w := qt_occurrence_w + 1;

			qt_pos_semicolon_w := instr(ds_restricao_w, ';', 1, qt_occurrence_w);
			
			if (qt_pos_semicolon_w <> 0) then
				ds_restricao_temp_w := substr(ds_restricao_w, qt_pos_prev_semicolon_w + 1, qt_pos_semicolon_w - (qt_pos_prev_semicolon_w + 1));

				if (ds_restricao_temp_w = ';') then
					ds_restricao_temp_w := '';
				end if;

				qt_pos_prev_semicolon_w := qt_pos_semicolon_w;
			else
				ds_restricao_temp_w := substr(ds_restricao_w, qt_pos_prev_semicolon_w + 1, length(ds_restricao_w));

				qt_pos_prev_semicolon_w := length(ds_restricao_w);
			end if;

			ds_comando_w := ' update ' || r_c_tabelas.nm_tabela || ' a ' ||
					' set	a.nr_seq_reg_version_rev = :nr_seq_reg_version_rev ' ||
					' where	a.nr_seq_reg_version_rev is null ';

			if (position(':nr_seq_area_customer' in ds_restricao_temp_w) > 0) then
				if (nr_seq_area_customer_w IS NOT NULL AND nr_seq_area_customer_w::text <> '') then
					ds_comando_w := ds_comando_w || ds_restricao_temp_w;
				end if;
			else
				ds_comando_w := ds_comando_w || ds_restricao_temp_w;
			end if;

			if (nr_seq_area_customer_w IS NOT NULL AND nr_seq_area_customer_w::text <> '') then
				CALL exec_sql_dinamico_bv('', ds_comando_w, 'nr_seq_reg_version_rev=' || nr_seq_revision_w || ';nr_seq_area_customer=' || nr_seq_area_customer_w);

				nr_seq_area_customer_w := null;
			else
				CALL exec_sql_dinamico_bv('', ds_comando_w, 'nr_seq_reg_version_rev=' || nr_seq_revision_w);
			end if;
		end loop;
	end if;

	commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reg_criar_revisao_documento ( nr_seq_documento_p bigint, cd_versao_p text ) FROM PUBLIC;
