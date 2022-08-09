-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_update_solicit_resci_web (nr_seq_solicitacao_p bigint, ie_tipo_operacao_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
Liberar e desfazer liberação de solicitação
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [X] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
Verificar o ie_tipo_solicitação
'D' - Desfazer liberação da solicitação
'L' - Liberar solicitação
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_exige_lib_web_w	pls_rescisao_contrato.ie_exige_liberacao_web%type;


BEGIN

if (nr_seq_solicitacao_p IS NOT NULL AND nr_seq_solicitacao_p::text <> '') then

	select	coalesce(max(ie_exige_liberacao_resc),'N')  ie_exige_liberacao_resc
	into STRICT	ie_exige_lib_web_w
	from	pls_web_param_geral
	where	cd_estabelecimento	= cd_estabelecimento_p;

	if (ie_tipo_operacao_p = 'L') then
		update pls_rescisao_contrato
		set	dt_liberacao 	 	= clock_timestamp(),
			dt_solicitacao		= clock_timestamp(),
			ie_exige_liberacao_web 	= ie_exige_lib_web_w
		where nr_sequencia = nr_seq_solicitacao_p;

	elsif (ie_tipo_operacao_p = 'D') then
		update pls_rescisao_contrato
		set	dt_liberacao 		 = NULL,
			ie_exige_liberacao_web 	= ie_exige_lib_web_w
		where nr_sequencia = nr_seq_solicitacao_p;
	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_update_solicit_resci_web (nr_seq_solicitacao_p bigint, ie_tipo_operacao_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
