-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_bloqueio_comerc ( nr_sequencia_p bigint, ie_opcao_p text, cd_estabelecimento_p bigint, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE


/*
ie_opcao_p
S - Solicitacao de lead
p - Prospecção
*/
ds_erro_w			varchar(4000);
ie_comercial_bloquiado_w	varchar(1);
dt_atividade_canal_w		timestamp;



BEGIN

ie_comercial_bloquiado_w	:= coalesce(obter_valor_param_usuario(1237, 40, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_p), 'N');
if (ie_comercial_bloquiado_w = 'N') then
	if (ie_opcao_p	= 'S') then
		select	max(dt_atividade_canal)
		into STRICT	dt_atividade_canal_w
		from	pls_solicitacao_comercial
		where	nr_sequencia	= nr_sequencia_p;

		if (dt_atividade_canal_w IS NOT NULL AND dt_atividade_canal_w::text <> '') then
			if (dt_atividade_canal_w	< clock_timestamp()) then
				ds_erro_w	:= wheb_mensagem_pck.get_texto(280206);
			end if;
		end if;
	elsif (ie_opcao_p	= 'P') then
		select	max(dt_atividade_canal)
		into STRICT	dt_atividade_canal_w
		from	pls_comercial_cliente
		where	nr_sequencia	= nr_sequencia_p;

		if (dt_atividade_canal_w IS NOT NULL AND dt_atividade_canal_w::text <> '') then
			if (dt_atividade_canal_w	< clock_timestamp()) then
				ds_erro_w	:= wheb_mensagem_pck.get_texto(280207);
			end if;
		end if;
	end if;
end if;

ds_erro_p	:= ds_erro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_bloqueio_comerc ( nr_sequencia_p bigint, ie_opcao_p text, cd_estabelecimento_p bigint, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;
