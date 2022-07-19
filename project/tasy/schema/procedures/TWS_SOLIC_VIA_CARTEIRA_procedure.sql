-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tws_solic_via_carteira ( nr_seq_carteira_p pls_segurado_carteira.nr_sequencia%type, nr_seq_motivo_via_p pls_motivo_via_adicional.nr_sequencia%type, nm_usuario_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, id_app_externo_p bigint, ie_app_externo_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ x] Outros: TWS
 ------------------------------------------------------------------------------------------------------------------

Pontos de atenção:

FALTA  VERIFICAR A SITUAÇÃO DA CRIAÇÃO DO LOTE DE EMISSÃO.
No insert da tabela pls_solic_carteira_adic, ficou o valor fixo 'N' para a criação de lote.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 

ie_exige_aprov_carteira_w	pls_web_param_geral.ie_exige_aprov_carteira%type;
nr_seq_segurado_w		pls_segurado.nr_sequencia%type;


BEGIN

select	coalesce(ie_exige_aprov_carteira, 'N')
into STRICT	ie_exige_aprov_carteira_w
from	pls_web_param_geral
where	cd_estabelecimento	= cd_estabelecimento_p;

select	max(nr_seq_segurado)
into STRICT	nr_seq_segurado_w
from	pls_segurado_carteira
where	nr_sequencia	= nr_seq_carteira_p;

insert into tws_solicitacao_carteira(	nr_sequencia, dt_atualizacao, nm_usuario,
					dt_atualizacao_nrec, nm_usuario_nrec, id_app_externo,
					ie_app_externo, nr_seq_carteira, nr_seq_segurado,
					ie_tipo_processo)
			values (	nextval('tws_solicitacao_carteira_seq'), clock_timestamp(), nm_usuario_p,
					clock_timestamp(), nm_usuario_p, id_app_externo_p,          
					ie_app_externo_p, nr_seq_carteira_p, nr_seq_segurado_w,
					'S');				

if (ie_exige_aprov_carteira_w = 'S') then
	insert into pls_solic_carteira_adic(	nr_sequencia, dt_atualizacao, nm_usuario,
						dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_carteira,
						nr_seq_motivo_via, cd_funcao, ie_tipo_processo,
						ie_criar_lote_via_adic, nm_usuario_solic, dt_solicitacao,
						ie_status)
				values (	nextval('pls_solic_carteira_adic_seq'), clock_timestamp(), nm_usuario_p,
						clock_timestamp(), nm_usuario_p, nr_seq_carteira_p, 
						nr_seq_motivo_via_p, 1248, 'W',
						'N', nm_usuario_p, clock_timestamp(),
						0);
else
	CALL pls_gerar_via_carteira(nr_seq_carteira_p,nr_seq_motivo_via_p,nm_usuario_p,1248,'W','N');
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tws_solic_via_carteira ( nr_seq_carteira_p pls_segurado_carteira.nr_sequencia%type, nr_seq_motivo_via_p pls_motivo_via_adicional.nr_sequencia%type, nm_usuario_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, id_app_externo_p bigint, ie_app_externo_p text) FROM PUBLIC;

