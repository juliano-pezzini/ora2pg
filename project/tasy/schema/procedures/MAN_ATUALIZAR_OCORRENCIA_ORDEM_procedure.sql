-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_atualizar_ocorrencia_ordem ( nr_sequencia_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text) AS $body$
DECLARE

								 
ie_analista_w	varchar(1);
ie_gerente_w	varchar(1);								
 

BEGIN 
	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END  
	into STRICT	ie_analista_w 
	 
	where 	obter_se_usuario_analista(nm_usuario_p,'M') = 'S' 
	or 		obter_se_usuario_analista(nm_usuario_p,'N') = 'S' 
	or 		obter_se_usuario_analista(nm_usuario_p,'S') = 'S';
	 
	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END  
	into STRICT	ie_gerente_w 
	 
	where	sis_obter_gerente(nm_usuario_p, 'C') = cd_pessoa_fisica_p;
	 
	if (ie_analista_w = 'S') then 
		update 	man_ordem_serv_ocorrencia 
		set 	dt_lib_lider = clock_timestamp(), 
				nm_usuario_lid_lib = nm_usuario_p 
		where	nr_sequencia = nr_sequencia_p;
	elsif (ie_gerente_w = 'S') then 
		update 	man_ordem_serv_ocorrencia 
		set 	dt_lib_gerente = clock_timestamp(), 
				nm_usuario_ger_lib = nm_usuario_p 
		where	nr_sequencia = nr_sequencia_p;
	end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_atualizar_ocorrencia_ordem ( nr_sequencia_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text) FROM PUBLIC;

