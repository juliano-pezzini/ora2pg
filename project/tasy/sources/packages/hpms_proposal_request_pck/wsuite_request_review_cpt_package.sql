-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE hpms_proposal_request_pck.wsuite_request_review_cpt ( nr_seq_proposta_onl_p pls_proposta_online.nr_sequencia%type, ds_observacao_p pls_proposta_hist_online.ds_historico%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE

qt_avaliacao_cpt_w	bigint;

C01 CURSOR FOR
	SELECT	coalesce(substr(b.nr_cartao_nac_sus,1,15),'000000000000000') cd_cns,
		b.cd_pessoa_fisica
	from	pls_proposta_benef_online a,
		pessoa_fisica b
	where	b.cd_pessoa_fisica = a.cd_pessoa_fisica
	and	a.nr_seq_prop_online = nr_seq_proposta_onl_p;

BEGIN

select	count(1)
into STRICT qt_avaliacao_cpt_w
from	pls_analise_adesao a,
	pls_carencia b,
	pls_proposta_benef_online c	
where	a.nr_sequencia	= b.nr_seq_analise_adesao
and	c.nr_sequencia	= a.nr_seq_prop_benef_online
and	b.ie_cpt = 'S'
and	c.nr_seq_prop_online = nr_seq_proposta_onl_p;


if ( qt_avaliacao_cpt_w = 0)then
CALL wheb_mensagem_pck.exibir_mensagem_abort(1107273); --Nao e possivel solicitar a avaliacao, pois nao ha CPT vinculada na analise para adesao do beneficiario.
end if;

-- Inicio - Mesmo tratamento que e realizado no objeto pls_consistir_contrato_sib 

for r_c01_w in c01 loop
	begin
	if	((coalesce(r_c01_w.cd_cns::text, '') = '') or (r_c01_w.cd_cns = '000000000000000')) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1098959, 'CD_PESSOA_FISICA='||r_c01_w.cd_pessoa_fisica); --Numero do cartao nacional do SUS nao informado.
	end if;
	
	if (length(r_c01_w.cd_cns) <> 15) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1098961, 'CD_PESSOA_FISICA='||r_c01_w.cd_pessoa_fisica); --Numero do cartao do SUS deve possuir 15 digitos. 
	end if;
	end;
end loop;
-- Fim - Mesmo tratamento que e realizado no objeto pls_consistir_contrato_sib


insert into pls_proposta_hist_online(nr_sequencia, dt_atualizacao, nm_usuario,
	ie_tipo_historico, ds_historico, nr_seq_prop_online,
	dt_criacao, dt_liberacao, dt_atualizacao_nrec,
	nm_usuario_nrec)
values (nextval('pls_proposta_hist_online_seq'), clock_timestamp(), nm_usuario_p,
	'SA', ds_observacao_p, nr_seq_proposta_onl_p,
	clock_timestamp(), clock_timestamp(), clock_timestamp(),
	nm_usuario_p);

update	pls_proposta_online
set	ie_estagio	= 'CP',
	ie_status	= 'U',
	nm_usuario	= nm_usuario_p,
	dt_atualizacao	= clock_timestamp()
where	nr_sequencia	= nr_seq_proposta_onl_p;

CALL hpms_proposal_request_pck.enviar_email_proposta(hpms_proposal_request_pck.obter_email_proposta_online(nr_seq_proposta_onl_p), nr_seq_proposta_onl_p, '3', nm_usuario_p, cd_estabelecimento_p);

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hpms_proposal_request_pck.wsuite_request_review_cpt ( nr_seq_proposta_onl_p pls_proposta_online.nr_sequencia%type, ds_observacao_p pls_proposta_hist_online.ds_historico%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;