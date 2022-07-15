-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_recalcular_repasse_hs (nm_usuario_p text) AS $body$
DECLARE

 
nr_interno_conta_w		bigint;

c01 CURSOR FOR 
SELECT	b.nr_interno_conta 
from	atendimento_paciente a, 
	conta_paciente b 
where	a.nr_atendimento	= b.nr_atendimento 
and	b.ie_status_acerto	= 2 
and	coalesce(b.ie_cancelamento::text, '') = '';


BEGIN 
 
/*insert into logxxxx_tasy 
	(DT_ATUALIZACAO, 
	NM_USUARIO, 
	CD_LOG, 
	DS_LOG) 
values	(sysdate, 
	nm_usuario_p, 
	55754, 
	'Executado baca BACA_RECALCULAR_REPASSE_HS (OS 161951)');*/
 
 
open c01;
loop 
fetch c01 into 
	nr_interno_conta_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
 
	CALL RECALCULAR_CONTA_REPASSE(nr_interno_conta_w,null,null,nm_usuario_p);
 
	commit;
 
end loop;
close c01;
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_recalcular_repasse_hs (nm_usuario_p text) FROM PUBLIC;

