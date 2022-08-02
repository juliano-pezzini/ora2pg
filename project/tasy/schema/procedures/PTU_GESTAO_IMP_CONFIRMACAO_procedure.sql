-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_gestao_imp_confirmacao ( ds_arquivo_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_versao_ptu_w			varchar(255);


BEGIN 
 
--dbms_application_info.SET_ACTION('TASY_SCS'); 
 
nr_versao_ptu_w	:= pls_obter_versao_scs;
 
if (nr_versao_ptu_w	= '035') then 
	CALL ptu_importar_confirmacao(ds_arquivo_p, cd_estabelecimento_p, nm_usuario_p);
elsif (nr_versao_ptu_w	= '040') then 
	CALL ptu_importar_confirmacao_v40(ds_arquivo_p, cd_estabelecimento_p, nm_usuario_p);
elsif (nr_versao_ptu_w	= '050') then 
	CALL ptu_importar_confirmacao_v50(ds_arquivo_p, cd_estabelecimento_p, nm_usuario_p);
end if;
 
--dbms_application_info.SET_ACTION(''); 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_gestao_imp_confirmacao ( ds_arquivo_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

