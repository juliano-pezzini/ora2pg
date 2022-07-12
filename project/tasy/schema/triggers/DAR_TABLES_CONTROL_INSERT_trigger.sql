-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS dar_tables_control_insert ON dar_tables_control CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_dar_tables_control_insert() RETURNS trigger AS $BODY$
DECLARE
  qp RECORD;
   sql_stmt_w dar_tables_control.ds_sql%TYPE;
   message_w dar_consist_sql.ds_consistencia%TYPE;
   segment_size_w bigint;

BEGIN

    delete from dar_consist_sql where nr_seq_tab_controle = NEW.nr_sequencia;

    sql_stmt_w := NEW.ds_sql;

    EXECUTE
    'EXPLAIN PLAN SET STATEMENT_ID = '''|| NEW.nr_sequencia || ''' INTO PLAN_TABLE FOR ' || to_char(sql_stmt_w);

    for qp in (
        select 
            a.operation, 
            a.options, 
            a.object_owner, 
            a.object_name, 
            a.object_type, 
            a.id, 
            a.parent_id, 
            a.depth, 
            a.cardinality,
            coalesce(CASE WHEN t.num_rows=0 THEN 1  ELSE t.num_rows END ,CASE WHEN i.num_rows=0 THEN 1  ELSE i.num_rows END ,1) as obj_num_rows,
            a.access_predicates, 
            a.filter_predicates
        from plan_table a
    left join user_tables t on (a.object_name = t.table_name)
    left join user_indexes i ON (a.object_name = i.index_name)
    where statement_id = to_char(NEW.nr_sequencia))
    
    loop
        -- If the object is a table or an index and the access method is %FULL%
        if ((qp.object_type = 'TABLE' or qp.object_type like 'INDEX%') 
            and qp.options like '%FULL%')
        then
            -- Return segment size
            select round(bytes/1024/1024)
            into STRICT segment_size_w
            from user_segments
            where segment_name = upper(qp.object_name);
            -- Check if the object is bigger than 2GB 
            --  or the resulting cardinality of the operation is bigger than 50% of rows in the object
            --      (possibly meaning bad filters / lot of rows for the parent operation)
            --      and the object has at least 10 thousand rows
            --  or the full access have no filter predicates (meaning it will pass the rows to the parent for filtering)
            --      and the object has at least 5 thousand rows
            if (segment_size_w > 2048
                or (round(qp.cardinality*100/qp.obj_num_rows) > 50 and qp.obj_num_rows > 10000)
                or ((qp.obj_num_rows > 5000  and qp.filter_predicates is null) or qp.cardinality > 10000)
                )
            then
                -- Build a message that explains the finding
                message_w := message_w || 'Identified "' || qp.operation || ' ' || qp.options || '" on a ' || segment_size_w || 
                ' MB ' || lower(qp.object_type) || ' ' || qp.object_owner || '.' || qp.object_name 
                || '. Estimated operation cardinality: ' || qp.cardinality || '. Filter predicates: ' || coalesce(qp.filter_predicates, 'NONE')
                || '. Plan operation id: ' || qp.id || '. Object number of rows: ' || qp.obj_num_rows || '. ';
            end if;
        -- If the method is not a full scan, check for inneficient range/skip scans
        -- If the operation estimated cardinality return more than 10% of object's rows or more than X thousand rows
        -- Ex.: 5 thousand rows probably means 5 thousand accesses to the table associated with the index
        elsif (qp.operation = 'INDEX'
            and qp.options in ('RANGE SCAN','SKIP SCAN')
            and qp.object_owner = sys_context('USERENV','SESSION_USER')
            and ((round(qp.cardinality*100/qp.obj_num_rows) > 10 and qp.obj_num_rows > 2000) or qp.cardinality > 2000)
            )
        then
            message_w := message_w || 'Identified a possibly bad index access method: "' || qp.operation || ' ' || qp.options || '" on ' ||
            qp.object_owner || '.' || qp.object_name || '. Plan operation id: ' || qp.id || '. ';
        end if;

    if (coalesce(message_w,'X') <> 'X')then
    
        insert into dar_consist_sql(nr_sequencia,
            dt_atualizacao,
            nm_usuario, 
            nr_seq_tab_controle,
            ds_consistencia,
			nr_seq_sql)
        values (nextval('dar_consist_sql_seq'),
            LOCALTIMESTAMP,
            wheb_usuario_pck.get_nm_usuario,
            NEW.nr_sequencia,
            message_w,
			NEW.nr_seq_sql);
    end if;
    end loop;

RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_dar_tables_control_insert() FROM PUBLIC;

CREATE TRIGGER dar_tables_control_insert
	AFTER INSERT ON dar_tables_control FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_dar_tables_control_insert();

