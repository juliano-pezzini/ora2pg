-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualiza_infor_conta_inter ( nr_seq_inf_conta_interc_p bigint, nr_seq_resp_benef_p bigint, nr_seq_param1_p bigint, nr_seq_param2_p bigint, nr_seq_param3_p bigint, nm_usuario_p text) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Atualizar o resultado da consulta de dados do beneficiário na tabela de informações de contas de intercâmbio.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_confirmacao_w	ptu_resp_consulta_benef.ie_confirmacao%type;	--Varchar
cd_mensagem_erro_w	ptu_resp_consulta_benef.cd_mensagem_erro%type;	--Number
BEGIN

begin
	select	ie_confirmacao,
		cd_mensagem_erro
	into STRICT	ie_confirmacao_w,
		cd_mensagem_erro_w
	from	ptu_resp_consulta_benef
	where	nr_sequencia	= nr_seq_resp_benef_p;
exception
when others then
	ie_confirmacao_w	:= 'N';
end;

if (ie_confirmacao_w	= 'S') and (coalesce(cd_mensagem_erro_w::text, '') = '') then
	update	pls_analise_inf_conta_int
	set	ie_situacao_origem	= 1,
		dt_atualizacao		= clock_timestamp(),
		nm_usuario		= nm_usuario_p
	where	nr_sequencia		= nr_seq_inf_conta_interc_p;
else
	update	pls_analise_inf_conta_int
	set	ie_situacao_origem	= 2,
		dt_atualizacao		= clock_timestamp(),
		nm_usuario		= nm_usuario_p
	where	nr_sequencia		= nr_seq_inf_conta_interc_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualiza_infor_conta_inter ( nr_seq_inf_conta_interc_p bigint, nr_seq_resp_benef_p bigint, nr_seq_param1_p bigint, nr_seq_param2_p bigint, nr_seq_param3_p bigint, nm_usuario_p text) FROM PUBLIC;
