-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_gest_env_res_cont_benef ( nr_seq_pedido_cont_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: Realizar a verificação da versão do PTU utilizada e chamar a respectiva rotina. 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ ] Objetos do dicionário [ X] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção:Performance. 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 
nr_versao_ptu_w			varchar(255);


BEGIN 
 
nr_versao_ptu_w	:= pls_obter_versao_scs;
 
if (nr_versao_ptu_w	= '040') then 
	CALL ptu_gerar_resp_cont_benef_v40(nr_seq_pedido_cont_p,cd_estabelecimento_p,nm_usuario_p);
elsif (nr_versao_ptu_w	= '050') then 
	CALL ptu_gerar_resp_cont_benef_v50(nr_seq_pedido_cont_p,cd_estabelecimento_p,nm_usuario_p);
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_gest_env_res_cont_benef ( nr_seq_pedido_cont_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
