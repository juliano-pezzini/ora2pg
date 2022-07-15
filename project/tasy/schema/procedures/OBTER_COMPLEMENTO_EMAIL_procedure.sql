-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_complemento_email ( cd_solicitante_p text, nr_sequencia_p bigint, cd_localizacao_p bigint, ds_email_dest_p INOUT text, ds_email_cc_p INOUT text) AS $body$
DECLARE

ds_email_dest_w	varchar(255);
ds_email_cc_w	varchar(255);
ds_email_w	varchar(255);

BEGIN
	select 	substr(obter_compl_pf(cd_solicitante_p, 1, 'M'),1,255) 
	into STRICT	ds_email_dest_w 
	;	
	if (obter_parametro_usuario_js(299, 167) = 'S') then 
		select 	substr(obter_dados_usuario_opcao(substr(obter_usuario_pessoa(cd_solicitante_p),1,15), 'E'),1,255) 
		into STRICT	ds_email_dest_w 
		;
	elsif (obter_parametro_usuario_js(299, 167) = 'O') then 
		select 	substr(obter_dados_setor(man_obter_dados_localizacao(cd_localizacao_p,'S'), 'EP'),1,255) 
		into STRICT	ds_email_dest_w 
		;	
	end if;	
	if (obter_parametro_usuario_js(299, 224) = 'S') then 
		select 	substr(obter_select_concatenado_bv(' select	ds_email from usuario where nm_usuario in (select nm_usuario_exec from man_ordem_servico_exec where nr_seq_ordem = :nr_sequencia) and ds_email is not null',':nr_sequencia=' || nr_sequencia_p,', '),1,255) 
		into STRICT	ds_email_cc_w	 
		;
	end if;
ds_email_dest_p		:=	ds_email_dest_w;
ds_email_cc_p		:=	ds_email_cc_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_complemento_email ( cd_solicitante_p text, nr_sequencia_p bigint, cd_localizacao_p bigint, ds_email_dest_p INOUT text, ds_email_cc_p INOUT text) FROM PUBLIC;

