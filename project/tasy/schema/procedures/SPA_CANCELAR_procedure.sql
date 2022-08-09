-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE spa_cancelar ( nr_seq_spa_p bigint, nr_seq_motivo_cancel_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
ie_status_w	spa.ie_status%type;


BEGIN 
select 	ie_status 
into STRICT	ie_status_w 
from 	spa 
where 	nr_sequencia = nr_seq_spa_p;
 
update	spa 
set	dt_atualizacao = clock_timestamp(), 
	nm_usuario = nm_usuario_p, 
	dt_cancelamento = clock_timestamp(), 
	nm_usuario_cancel = nm_usuario_p, 
	nr_seq_motivo_cancel = CASE WHEN nr_seq_motivo_cancel_p=0 THEN  null  ELSE nr_seq_motivo_cancel_p END , 
	ie_status = 6 
where	nr_sequencia = nr_seq_spa_p;
 
update	spa_aprovacao 
set	dt_atualizacao = clock_timestamp(), 
	nm_usuario = nm_usuario_p, 
	dt_cancelamento = clock_timestamp() 
where	nr_seq_spa = nr_seq_spa_p;
 
CALL gerar_spa_hist_email('C',nr_seq_spa_p,nm_usuario_p);
 
CALL spa_gerar_historico(nr_seq_spa_p,nm_usuario_p,ie_status_w,6,3,'','N');
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE spa_cancelar ( nr_seq_spa_p bigint, nr_seq_motivo_cancel_p bigint, nm_usuario_p text) FROM PUBLIC;
