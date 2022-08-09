-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tasy_fase_offline () AS $body$
DECLARE


ds_script_w		 text;
ds_erro_w		 varchar(4000);
ie_online_w				varchar(1);
ie_enterprise_w			varchar(1);
nm_fase_w           	cloud_upgrade_log.ds_mensagem%type := 'TASY_FASE_OFFLINE';

C0100 CURSOR FOR
	SELECT	/*+parallel*/ ds_comando
	from	tabela_versao_offline_w
	where	nr_ordem > 100
	order by nr_ordem, nr_Sequencia;

  r1 RECORD;

BEGIN

begin
    -- Verifica se possui Enterprise
    select	count(1)
    into STRICT	ie_enterprise_w
    from	v$version
    where	upper(banner) like '%ENTERPRISE%'
    or 		upper(banner) like '%EE%EXTREME%PERF%';

    if (ie_enterprise_w = 1) then
        ie_enterprise_w := 'S';
        EXECUTE 'ALTER SESSION ENABLE PARALLEL DDL';
        EXECUTE 'ALTER SESSION ENABLE PARALLEL DML';
    else
        ie_enterprise_w := 'N';
        ie_online_w := 'N';
    end if;
exception
    when others then
    begin
        ds_erro_w := substr(sqlerrm,1,1000);
        CALL insert_log_cloud(null,null, 'atualizacao', 'Verificando Oracle Enterprise - '||ds_erro_w, null, nm_fase_w);
        ie_enterprise_w := 'N';
        ie_online_w := 'N';
    end;
end;

if (ie_enterprise_w = 'S') then
begin
    -- Verifica se possui Online OBS somente Enterprise
    select 	CASE WHEN value='TRUE' THEN 'S'  ELSE 'N' END
    into STRICT    ie_online_w
    from	gv$option 
    where	lower(parameter) = 'online index build'
    and	upper(value) = 'TRUE'  LIMIT 1;
exception
    when others then
    begin
        ds_erro_w := substr(sqlerrm,1,1000);
        CALL insert_log_cloud(null,null, 'atualizacao', 'Verificando Indices online - '||ds_erro_w, null, nm_fase_w);
        ie_enterprise_w := 'N';
        ie_online_w := 'N';
    end;
end;
end if;

open C0100;
loop
fetch C0100 into	
	ds_script_w;
EXIT WHEN NOT FOUND; /* apply on C0100 */
	begin	
		CALL tasy_versao_executa_comando('atualizacao',ds_script_w, nm_fase_w);
	end;
end loop;
close C0100;

for r1 in (SELECT 'alter table ' || table_name || ' noparallel' cmd, table_name from user_tables where
trim(both degree) not in ('1','0') and table_name in (select nm_tabela from tabela_sistema)) loop
    begin
        EXECUTE r1.cmd;
    exception
        when others then
        begin
            ds_erro_w := substr(sqlerrm,1,1000);
            CALL insert_log_cloud(null,null, 'atualizacao', 'Desativando paralelismo all_tables: '||r1.table_name||' - '||ds_erro_w, r1.cmd, nm_fase_w);
        end;
    end;
end loop;

for r1 in (SELECT 'alter index ' || INDEX_NAME || ' noparallel' cmd, table_name from user_indexes
where trim(both degree) not in ('1','0') and table_name in (select nm_tabela from tabela_sistema)) loop
    begin
        EXECUTE r1.cmd;
    exception
        when others then
        begin
            ds_erro_w := substr(sqlerrm,1,1000);
            CALL insert_log_cloud(null,null, 'atualizacao', 'Desativando paralelismo all_indexes: '||r1.table_name||' - '||ds_erro_w, r1.cmd, nm_fase_w);
        end;
    end;
end loop;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tasy_fase_offline () FROM PUBLIC;
