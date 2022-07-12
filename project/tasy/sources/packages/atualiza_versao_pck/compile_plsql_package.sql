-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE atualiza_versao_pck.compile_plsql (p_object_type text, p_object_content text) AS $body$
DECLARE

      v_object_content     text;
      v_object_content_aux text;
      v_object_type        varchar(100);
      stmt                 dbms_sql.varchar2a;
      stmt_body            dbms_sql.varchar2a;
      line_count           bigint;
      line                 varchar(32000);
      cursor_id            bigint;
      result               bigint;
      v_buffer_size        bigint;

  r RECORD;

BEGIN
      v_buffer_size := 20000;

      v_object_content := p_object_content;
      v_object_type    := upper(p_object_type);

      if v_object_type = 'PACKAGE' then
        -- Primeira execução: Spec
        v_object_content_aux := substr(v_object_content,
                                       1,
                                       position(chr(10) || '/' || chr(10) in v_object_content));
        line_count           := 0;
        loop
          line := substr(v_object_content_aux,
                         1 + line_count * v_buffer_size,
                         v_buffer_size);
          exit when coalesce(line::text, '') = '';
          line_count := line_count + 1;
          stmt(line_count) := replace(line, chr(13), ' ');
        end loop;
        cursor_id := dbms_sql.open_cursor;
        dbms_sql.parse(cursor_id,
                       stmt,
                       1,
                       stmt.count,
                       false,
                       dbms_sql.native);
        result := dbms_sql.execute(cursor_id);
        dbms_sql.close_cursor(cursor_id);
        -- Segunda execucao: Body
        v_object_content_aux := substr(v_object_content,
                                       position(chr(10) || '/' || chr(10) in v_object_content) + 3);
        line_count           := 0;
        loop
          line := substr(v_object_content_aux,
                         1 + line_count * v_buffer_size,
                         v_buffer_size);
          exit when coalesce(line::text, '') = '';
          line_count := line_count + 1;
          stmt_body(line_count) := replace(line, chr(13), ' ');
        end loop;
        cursor_id := dbms_sql.open_cursor;
        dbms_sql.parse(cursor_id,
                       stmt_body,
                       1,
                       stmt_body.count,
                       false,
                       dbms_sql.native);
        result := dbms_sql.execute(cursor_id);
        dbms_sql.close_cursor(cursor_id);

      else
        line_count := 0;
        loop
          line := substr(v_object_content,
                         1 + line_count * v_buffer_size,
                         v_buffer_size);
          exit when coalesce(line::text, '') = '';
          line_count := line_count + 1;
          stmt(line_count) := replace(line, chr(13), ' ');
        end loop;
        cursor_id := dbms_sql.open_cursor;
        dbms_sql.parse(cursor_id,
                       stmt,
                       1,
                       stmt.count,
                       false,
                       dbms_sql.native);
        result := dbms_sql.execute(cursor_id);
        dbms_sql.close_cursor(cursor_id);
      end if;
    end;
  begin

    v_max_threads := p_max_threads;
    v_thread_id   := p_thread_id;

    if atualiza_versao_pck.is_single_thread_operation(p_operacao) = 'S' or p_exec_count >= 4 then
      -- Direciona a execução para a "Thread" 0
      v_max_threads := 1;
    end if;

    select value
      into STRICT v_charset_encode
      from nls_database_parameters
     where parameter = 'NLS_CHARACTERSET';

    if v_charset_encode = 'AL32UTF8' then
      EXECUTE 'ALTER SESSION SET NLS_LENGTH_SEMANTICS=CHAR';
    end if;

    begin
      CALL atualiza_versao_pck.disable_parallel_session();
    exception
      when others then
        null;
    end;

    if p_operacao in ('UPDATE DATABASE OBJECTS', 'SERVICE PACK UPDATE') then
      EXECUTE 'ALTER SESSION SET "_LOAD_WITHOUT_COMPILE" = PLSQL';
      dbms_lock.sleep(0.1);
    end if;

    if dbms_db_version.version >= 12 then
      if p_operacao in ('UPDATE RECORDS ON DICTIONARY TABLES',
          'INSERT NEW RECORDS ON DICTIONARY TABLES') then
        EXECUTE 'ALTER SESSION SET "_OPTIMIZER_GATHER_STATS_ON_LOAD" = FALSE';
      end if;
    end if;

    for r in (SELECT a.*
                from atualiza_versao_cmd a
               where ds_operacao = coalesce(p_operacao, ds_operacao)
                 and fl_execucao = 'WAITING'
                 and mod(nr_seq, v_max_threads) = v_thread_id
               order by nr_fase) loop
      if is_update_running = 'S' then
        begin
          v_ds_comando     := r.ds_comando;
          v_str_tablespace := ' ';
          v_str_parallel   := ' ';

          if atualiza_versao_pck.is_operation_configurable(r.ds_operacao) = 'S' then
          
            if (r.nm_tablespace IS NOT NULL AND r.nm_tablespace::text <> '') then
              v_str_tablespace := ' tablespace ' || r.nm_tablespace;
            end if;

            if coalesce(r.parallel_degree, 0) > 1 and
               get_database_edition = 'ENTERPRISE' then
              v_str_parallel := ' parallel ' || r.parallel_degree;
            end if;

          end if;

          v_ds_comando := replace(v_ds_comando,
                                  '@TABLESPACE_NAME@',
                                  v_str_tablespace);
          v_ds_comando := replace(v_ds_comando,
                                  '@PARALLEL_DEGREE@',
                                  v_str_parallel);

          v_dt_ini := clock_timestamp();
          if r.ds_operacao = 'UPDATE DATABASE OBJECTS' then
            CALL atualiza_versao_pck.compile_plsql(r.tipo_objeto, r.ds_comando);
          else
            EXECUTE v_ds_comando;
          end if;
          v_dt_fim := clock_timestamp();
          update atualiza_versao_cmd
             set fl_execucao     = 'DONE',
                 dt_ini          = v_dt_ini,
                 dt_fim          = v_dt_fim,
                 ds_comando_exec = v_ds_comando,
                 nr_execucao     = p_exec_count
           where nr_seq = r.nr_seq;

          commit;
        exception
          when others then
            v_erro        := sqlerrm;
            v_dt_fim      := clock_timestamp();
            v_fl_execucao := 'ERROR';
            if SQLSTATE in (-01418, -24344) then
              v_fl_execucao := 'DONE';
            end if;

            if SQLSTATE in (-00060, -04020) then
              -- Marca os objetos para tentar nova execução.
              v_erro        := null;
              v_fl_execucao := 'WAITING';
            end if;

            if atualiza_versao_pck.is_warning(r.ds_operacao, SQLSTATE) = 'S' then
              v_fl_execucao := 'DONE'; -- WARNING
            end if;
            update atualiza_versao_cmd
               set fl_execucao     = v_fl_execucao,
                   dt_ini          = v_dt_ini,
                   dt_fim          = v_dt_fim,
                   ds_erro         = v_erro,
                   ds_comando_exec = v_ds_comando,
                   nr_execucao     = p_exec_count
             where nr_seq = r.nr_seq;
        end;
        if r.ds_operacao = 'SERVICE PACK UPDATE' then
          update ajuste_versao_cliente c
             set c.ie_compila = 'S'
           where c.nr_sequencia = r.nr_sequencia_sp;
        end if;
        commit;
      end if;
    end loop;
  end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_versao_pck.compile_plsql (p_object_type text, p_object_content text) FROM PUBLIC;