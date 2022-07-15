-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE agenda_additionals_crud ( nr_seq_agenda_p bigint, nm_table_p text, nr_seq_col_ref_p text, nm_column_p text, nm_value_p text, ie_value_type_p text, ie_crud_type_p text, ie_commit_p text default 'S', ie_nrec_exist_p text default 'S', nm_pk_column_p text default null, nm_pk_seq_p text default null) AS $body$
DECLARE


ie_exist_w			smallint;
nm_column_w			varchar(500) := '';
nm_value_w			varchar(500) := '';


BEGIN

EXECUTE
'select nvl(max(1), 0) from ' || nm_table_p ||
' where ' || nr_seq_col_ref_p || ' = ' || nr_seq_agenda_p
into STRICT ie_exist_w;

if (ie_exist_w = 0 and ie_crud_type_p != 'D') then

	if (nm_pk_column_p IS NOT NULL AND nm_pk_column_p::text <> '') then
		nm_column_w := nm_pk_column_p || ', ';
		if (nm_pk_seq_p IS NOT NULL AND nm_pk_seq_p::text <> '')	then
			nm_value_w := nm_pk_seq_p || '.nextval, ';
		else
		SELECT  max(object_name)
            into STRICT    nm_value_w
            FROM    all_objects
            WHERE   object_type = 'SEQUENCE' AND object_name = upper(nm_table_p || '_SEQ') and status = 'VALID';
            if (nm_value_w IS NOT NULL AND nm_value_w::text <> '') then
                nm_value_w := nm_value_w || '.nextval, ';
            else
			nm_value_w := '(select max(' || nm_pk_column_p || ')+1 from '|| nm_table_p || '), ';
			end if;
		end if;
	end if;

	if (ie_nrec_exist_p = 'S') then
		nm_column_w := nm_column_w || 'nm_usuario_nrec, dt_atualizacao_nrec, ';
		nm_value_w := nm_value_w || 'wheb_usuario_pck.get_nm_usuario, sysdate, ';
	end if;

    if (coalesce(nm_value_p::text, '') = '') then
    	EXECUTE 'insert into ' || nm_table_p ||
		' (' || nm_column_w || nr_seq_col_ref_p || ', ' || nm_column_p || ', nm_usuario, dt_atualizacao) values (' ||
		nm_value_w || nr_seq_agenda_p || ', ' || 'null' || ', wheb_usuario_pck.get_nm_usuario, sysdate)';
    else
    	EXECUTE 'insert into ' || nm_table_p ||
		' (' || nm_column_w || nr_seq_col_ref_p || ', ' || nm_column_p || ', nm_usuario, dt_atualizacao) values (' ||
		nm_value_w || nr_seq_agenda_p || ', ' || get_value_by_type(nm_value_p, ie_value_type_p) || ', wheb_usuario_pck.get_nm_usuario, sysdate)';
    end if;
else

    if (ie_crud_type_p = 'U' or (ie_crud_type_p = 'I' and ie_exist_w > 0)) then
      if (coalesce(nm_value_p::text, '') = '') then
        EXECUTE 'update ' || nm_table_p || ' set ' || nm_column_p || ' = null' ||
			   ', nm_usuario = wheb_usuario_pck.get_nm_usuario, dt_atualizacao = sysdate where ' ||
			   nr_seq_col_ref_p || ' = ' || nr_seq_agenda_p;
      else
        EXECUTE 'update ' || nm_table_p ||
			   ' set ' || nm_column_p || ' = ' || get_value_by_type(nm_value_p, ie_value_type_p) ||
			   ', nm_usuario = wheb_usuario_pck.get_nm_usuario, dt_atualizacao = sysdate where ' ||
			   nr_seq_col_ref_p || ' = ' || nr_seq_agenda_p;
      end if;
    elsif (ie_crud_type_p = 'D') then
        EXECUTE 'delete from ' || nm_table_p ||
			' where ' || nr_seq_col_ref_p || ' = ' || nr_seq_agenda_p;
    end if;

end if;

if (ie_commit_p = 'S') then
    commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE agenda_additionals_crud ( nr_seq_agenda_p bigint, nm_table_p text, nr_seq_col_ref_p text, nm_column_p text, nm_value_p text, ie_value_type_p text, ie_crud_type_p text, ie_commit_p text default 'S', ie_nrec_exist_p text default 'S', nm_pk_column_p text default null, nm_pk_seq_p text default null) FROM PUBLIC;

