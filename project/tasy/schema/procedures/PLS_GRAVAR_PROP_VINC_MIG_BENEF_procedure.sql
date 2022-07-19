-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gravar_prop_vinc_mig_benef ( nr_seq_proposta_p pls_proposta_adesao.nr_sequencia%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type, nr_seq_segurado_proposta_p pls_proposta_beneficiario.nr_seq_beneficiario%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


qt_benef_proposta_w		bigint;
nr_contrato_w			pls_contrato.nr_contrato%type;
nr_seq_contrato_migracao_w	bigint;
cd_pessoa_fisica_benef_w	pessoa_fisica.cd_pessoa_fisica%type;
cd_pessoa_fisica_prop_w		pessoa_fisica.cd_pessoa_fisica%type;


BEGIN

select	max(a.cd_pessoa_fisica),
	max(b.nr_contrato)
into STRICT	cd_pessoa_fisica_benef_w,
	nr_contrato_w
from	pls_segurado a,
	pls_contrato b
where	b.nr_sequencia	= a.nr_seq_contrato
and	a.nr_sequencia	= nr_seq_segurado_p;

if (coalesce(nr_contrato_w::text, '') = '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(276631);--Beneficiario invalido.
end if;

select	max(nr_seq_contrato_mig)
into STRICT	nr_seq_contrato_migracao_w
from	pls_proposta_adesao
where	nr_sequencia = nr_seq_proposta_p;

if (nr_contrato_w <> nr_seq_contrato_migracao_w) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(276634);--Beneficiario selecionado nao pertence ao contrato origem desta proposta.
end if;

select	max(cd_beneficiario)
into STRICT	cd_pessoa_fisica_prop_w
from	pls_proposta_beneficiario
where	nr_sequencia	= nr_seq_segurado_proposta_p;

if (cd_pessoa_fisica_benef_w <> cd_pessoa_fisica_prop_w) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1166409); --O beneficiario selecionado tem pessoa fisica diferente do beneficiario da proposta
end if;

select	count(1)
into STRICT	qt_benef_proposta_w
from	pls_proposta_beneficiario
where	nr_seq_proposta		= nr_seq_proposta_p
and	nr_seq_beneficiario	= nr_seq_segurado_p
and	nr_sequencia		<> nr_seq_segurado_proposta_p;

if (qt_benef_proposta_w > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(276636);--Beneficiario selecionado ja foi vinculado a proposta.
end if;

update	pls_proposta_beneficiario
set	nr_seq_beneficiario	= nr_seq_segurado_p,
	dt_atualizacao		= clock_timestamp(),
	nm_usuario		= nm_usuario_p
where	nr_sequencia		= nr_seq_segurado_proposta_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gravar_prop_vinc_mig_benef ( nr_seq_proposta_p pls_proposta_adesao.nr_sequencia%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type, nr_seq_segurado_proposta_p pls_proposta_beneficiario.nr_seq_beneficiario%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;

