-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alterar_dt_solic_rescisao ( nr_seq_solicitacao_p pls_solicitacao_rescisao.nr_sequencia%type, dt_solicitacao_p pls_solicitacao_rescisao.dt_solicitacao%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


qt_ie_iniciativa_benef_w	bigint;
dt_solicitacao_anterior_w	pls_solicitacao_rescisao.dt_solicitacao%type;
ie_status_w			pls_solicitacao_rescisao.ie_status%type;


BEGIN

select	dt_solicitacao,
	ie_status
into STRICT	dt_solicitacao_anterior_w,
	ie_status_w
from	pls_solicitacao_rescisao
where	nr_sequencia = nr_seq_solicitacao_p;

if (ie_status_w = 2) then
	select	count(1)
	into STRICT	qt_ie_iniciativa_benef_w
	from	pls_solic_rescisao_benef	a,
		pls_motivo_cancelamento		b
	where	a.nr_seq_motivo_rescisao	= b.nr_sequencia
	and	b.ie_iniciativa_beneficiario	= 'S'
	and	a.nr_seq_solicitacao		= nr_seq_solicitacao_p;

	if (qt_ie_iniciativa_benef_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1122269,'NR_SEQ_SOLICITACAO='|| nr_seq_solicitacao_p);
		--Nao e possivel alterar a data solicitada para a solicitacao de rescisao #@NR_SEQ_SOLICITACAO#@, pois existe(m) beneficiario(s) com motivo de rescisao por iniciativa do beneficiario.
	end if;

	update	pls_solicitacao_rescisao
	set	dt_solicitacao	= dt_solicitacao_p,
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia	= nr_seq_solicitacao_p;

	--gravar historico
	insert  into	pls_solicitacao_resc_hist(	nr_sequencia, nr_seq_solicitacao, dt_liberacao,
		nm_usuario, nm_usuario_nrec, dt_atualizacao, dt_atualizacao_nrec,
		ds_titulo, ds_historico)
	values ( nextval('pls_solicitacao_resc_hist_seq'), nr_seq_solicitacao_p, clock_timestamp(),
		nm_usuario_p, nm_usuario_p, clock_timestamp(), clock_timestamp(),
		wheb_mensagem_pck.get_texto(1122271),wheb_mensagem_pck.get_texto(1122274,'DT_ANTERIOR='|| to_char(dt_solicitacao_anterior_w,'dd/mm/yyyy') || ';DT_NOVA='|| to_char(dt_solicitacao_p,'dd/mm/yyyy')));
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alterar_dt_solic_rescisao ( nr_seq_solicitacao_p pls_solicitacao_rescisao.nr_sequencia%type, dt_solicitacao_p pls_solicitacao_rescisao.dt_solicitacao%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;

