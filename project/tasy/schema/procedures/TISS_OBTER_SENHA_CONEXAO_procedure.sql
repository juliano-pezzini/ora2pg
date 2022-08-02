-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tiss_obter_senha_conexao ( cd_estabelecimento_p bigint, cd_setor_atendimento_p text, cd_convenio_p bigint, nm_usuario_p text, nm_usuario_tiss_p INOUT text, ds_senha_tiss_p INOUT text, ie_comunicacao_p INOUT text, ds_dir_entrada_p INOUT text, ds_dir_saida_p INOUT text) AS $body$
DECLARE


nm_usuario_tiss_w	varchar(20);
ds_senha_tiss_w	varchar(20);
ds_dir_entrada_w	varchar(255);
ds_dir_saida_w	varchar(255);
ie_comunicacao_w	varchar(15);

c01 CURSOR FOR
	SELECT	nm_usuario_tiss,
		ds_senha_tiss,
		ds_dir_entrada,
		ds_dir_saida,
		ie_comunicacao
	from tiss_senha_conexao
	where cd_estabelecimento		 	= cd_estabelecimento_p
	and coalesce(cd_setor_atendimento, coalesce(cd_setor_atendimento_p,0))	= coalesce(cd_setor_atendimento_p,0)
	and coalesce(nm_usuario_senha,nm_usuario_p) 	= nm_usuario_p
	and coalesce(cd_convenio, cd_convenio_p)		= cd_convenio_p
	order by coalesce(nm_usuario_senha,'A'), coalesce(cd_convenio,0), coalesce(cd_setor_atendimento,0);


BEGIN

open c01;
loop
fetch c01 into	nm_usuario_tiss_w,
		ds_senha_tiss_w,
		ds_dir_entrada_w,
		ds_dir_saida_w,
		ie_comunicacao_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

end loop;
close c01;

nm_usuario_tiss_p	:= nm_usuario_tiss_w;
ds_senha_tiss_p		:= ds_senha_tiss_w;
ds_dir_entrada_p	:= ds_dir_entrada_w;
ds_dir_saida_p		:= ds_dir_saida_w;
ie_comunicacao_p	:= ie_comunicacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_obter_senha_conexao ( cd_estabelecimento_p bigint, cd_setor_atendimento_p text, cd_convenio_p bigint, nm_usuario_p text, nm_usuario_tiss_p INOUT text, ds_senha_tiss_p INOUT text, ie_comunicacao_p INOUT text, ds_dir_entrada_p INOUT text, ds_dir_saida_p INOUT text) FROM PUBLIC;

