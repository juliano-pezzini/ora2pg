-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW lock_v (bd, sid, "serial#", programa, machine, acao, modulo, username, nm_objeto, locked_mode, os_user_name, status, ds_status, audsid, terminal, type, lockwait, logon_time) AS SELECT 	   S.inst_id BD,
	   S.sid,
	   S.serial#,
	   SUBSTR(S.program,1,15) programa,
	   SUBSTR(S.machine,1,16) machine,
	   SUBSTR(S.action,1,15) acao,
	   SUBSTR(S.MODULE,1,15) modulo,
	   null username,
	   SUBSTR(u.object_name,1,25) nm_objeto,
	   SUBSTR(CASE WHEN L.lmode=0 THEN  'None' WHEN L.lmode=1 THEN  'Null (NULL)' WHEN L.lmode=2 THEN  'Row-S (SS)' WHEN L.lmode=3 THEN  'Row-X (SX)' WHEN L.lmode=4 THEN  'Share (S)' WHEN L.lmode=5 THEN  'S/Row-X (SSX)' WHEN L.lmode=6 THEN  'Exclusive (X)'  ELSE L.lmode END ,1,13) locked_mode,
	null os_user_name,
	S.status,
	SUBSTR(CASE WHEN L.request=0 THEN  'Lock'  ELSE 'Wait' END ,1,4) ds_status,
	S.audsid,
	S.terminal,
	S.TYPE,
	S.LOCKWAIT,
	S.LOGON_TIME
FROM 	GV$LOCK L,
	GV$SESSION S,
	user_objects u
WHERE	S.sid = L.sid
AND	u.object_id = L.ID1

union

SELECT	c.inst_id BD,
	c.SID,
	c.serial#,
	SUBSTR(c.program, 1, 15) programa,
	SUBSTR(c.machine, 1, 15) machine,
	SUBSTR(c.action,1,15) acao,
	SUBSTR(c.module, 1, 15) modulo,
	SUBSTR(coalesce(b.oracle_username, '(oracle)'), 1, 15) AS username,
        SUBSTR(a.object_name, 1, 30) nm_objeto,
        SUBSTR(CASE WHEN b.locked_mode=0 THEN  'None' WHEN b.locked_mode=1 THEN  'Null (NULL)' WHEN b.locked_mode=2 THEN  'Row-S (SS)' WHEN b.locked_mode=3 THEN  'Row-X (SX)' WHEN b.locked_mode=4 THEN  'Share (S)' WHEN b.locked_mode=5 THEN  'S/Row-X (SSX)' WHEN b.locked_mode=6 THEN  'Exclusive (X)'  ELSE b.locked_mode END ,
                    1,
                    30
                   ) locked_mode,
        SUBSTR(b.os_user_name, 1, 20) os_user_name,
	c.status,
	null ds_status,
	c.audsid,
	c.terminal,
	c.TYPE,
	c.LOCKWAIT,
	c.LOGON_TIME
       FROM	user_objects a,
		gv$locked_object b,
		gv$session c
      WHERE	a.object_id = b.object_id
      AND	b.session_id = c.SID

union

select	distinct
	null BD,
	a.SID,
	a.serial#,
	a.PROGRAM PROGRAMA,
	a.MACHINE,
	a.ACTION acao,
	a.MODULE modulo,
	a.USERNAME,
	null nm_objeto,
	CASE WHEN x.block=0 THEN  'Esperando'  ELSE 'Bloqueando' END  locked_mode,
	a.OSUSER os_user_name,
	a.STATUS,
	null ds_status,
	a.audsid,
	a.TERMINAL,
	a.TYPE,
	a.LOCKWAIT,
	a.LOGON_TIME
from 	v_$session a,
	v_$lock x
where	x.sid = a.sid
and (x.request > 0 OR x.block > 0)
 ORDER BY 1, 2, 3, 4;
