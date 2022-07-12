-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW kill_v2 (ds_comando, program, module) AS select	substr('ALTER SYSTEM DISCONNECT SESSION ' || chr(39) || sid || ',' || serial# || chr(39) || ' IMMEDIATE; ',1,70) ds_comando,
	substr(program,1,35) program,
	substr(module,1,35) module
FROM	v$session
where	status = 'ACTIVE'
and	audsid <> (select	userenv('SESSIONID')
		   )
and	sid not in (select	sid
		   from		processo_longo_v)
and	upper(program)	in ('TASY.EXE','SQLPLUS.EXE','SQLPLUSW.EXE');
