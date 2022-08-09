-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pat_aprovar_doc_receb_bem ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nm_usuario_resp_aprov_w			varchar(15);
cd_estabelecimento_w			bigint;

BEGIN
 
	 
update	pat_doc_transferencia 
set	dt_aprov_local_dest	= clock_timestamp(), 
	nm_usuario		= nm_usuario_p, 
	dt_atualizacao		= clock_timestamp() 
where	nr_sequencia		= nr_sequencia_p;
 
select	max(cd_estabelecimento), 
	max(obter_usuario_pessoa(cd_responsavel_transf)) 
into STRICT	cd_estabelecimento_w, 
	nm_usuario_resp_aprov_w 
from	pat_doc_transferencia 
where	nr_sequencia		= nr_sequencia_p;
 
if (coalesce(nm_usuario_resp_aprov_w, 'X') <> 'X') then 
 
	/*Enviar um comunicado interno avisando ao nm_usuario_resp_aprov_w que foi aprovado 
	o documento de traneferencia*/
 
	CALL pat_enviar_comunic_doc_aprov(	cd_estabelecimento_w, 
					nr_sequencia_p, 
					nm_usuario_resp_aprov_w, 
					'TA', 
					nm_usuario_p);
end if;
 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pat_aprovar_doc_receb_bem ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
