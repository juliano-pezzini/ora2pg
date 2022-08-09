-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE spa_liberar ( nr_seq_spa_p bigint, nm_usuario_p text, ie_rota_aprov_p INOUT text) AS $body$
DECLARE

 
ie_rota_aprov_w		varchar(1);
ie_status_w		spa.ie_status%type;


BEGIN 
 
select	ie_status 
into STRICT 	ie_status_w 
from 	spa 
where 	nr_sequencia = nr_seq_spa_p;
 
update	spa 
set	ie_status = 2, 
	dt_liberacao = clock_timestamp(), 
	nm_usuario_liberacao = nm_usuario_p, 
	dt_atualizacao = clock_timestamp(), 
	nm_usuario = nm_usuario_p 
where	nr_sequencia = nr_seq_spa_p;
 
 
CALL spa_gerar_historico(nr_seq_spa_p,nm_usuario_p,ie_status_w,2,2,'','N');
 
ie_rota_aprov_w := spa_gerar_aprovacao(nr_seq_spa_p, nm_usuario_p, ie_rota_aprov_w);
 
CALL gerar_spa_hist_email('P',nr_seq_spa_p,nm_usuario_p);
 
if (coalesce(ie_rota_aprov_w,'S') = 'N') then 
	update	spa 
	set	ie_status = 1, 
		dt_liberacao  = NULL, 
		nm_usuario_liberacao  = NULL 
	where	nr_sequencia = nr_seq_spa_p;
	--se nao conseguiu rota, grava desfazer liberação 
	CALL spa_gerar_historico(nr_seq_spa_p,nm_usuario_p,2,1,8,'','N');
end if;
 
ie_rota_aprov_p	:= coalesce(ie_rota_aprov_w,'S');
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE spa_liberar ( nr_seq_spa_p bigint, nm_usuario_p text, ie_rota_aprov_p INOUT text) FROM PUBLIC;
