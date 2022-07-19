-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desfazer_recalculo ( nr_seq_lote_p bigint, nm_usuario_p text) AS $body$
DECLARE

				
dt_aplicacao_w			timestamp;
aux_w				bigint;
ie_concil_contab_w		pls_visible_false.ie_concil_contab%type;
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;


C01 CURSOR(nr_seq_lote_pc	pls_conta_recalculo.nr_seq_lote%type)FOR
	SELECT	nr_sequencia
	from	pls_conta_recalculo
	where	nr_seq_lote 	= nr_seq_lote_pc;
BEGIN

cd_estabelecimento_w 	:= wheb_usuario_pck.get_cd_estabelecimento;

select	coalesce(max(ie_concil_contab), 'N')
into STRICT	ie_concil_contab_w
from	pls_visible_false
where	cd_estabelecimento = cd_estabelecimento_w;

select	max(dt_aplicacao)
into STRICT	dt_aplicacao_w
from	pls_lote_recalculo
where	nr_sequencia	= nr_seq_lote_p;

if (dt_aplicacao_w IS NOT NULL AND dt_aplicacao_w::text <> '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort( 267010, null); /* Ja foi aplicado o recalculo nas contas, nao e possivel desfazer o lote! */
end if;

select	count(1)
into STRICT	aux_w
from	sip_nv_dados a
where	a.ie_conta_enviada_ans = 'S'
and	a.nr_seq_conta in (	SELECT	nr_seq_conta
				from	pls_conta_recalculo
				where	nr_seq_lote 	= nr_seq_lote_p)
and	exists (	select	1
		from	pls_lote_sip b
		where	b.nr_sequencia = a.nr_seq_lote_sip
		and	(b.dt_envio IS NOT NULL AND b.dt_envio::text <> ''));

if (aux_w > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(338028);
end if;

for r_c01_w in C01(nr_seq_lote_p) loop
	begin
	delete	FROM pls_item_recalculo	a
	where	a.nr_seq_conta = r_c01_w.nr_sequencia;
	commit;
	end;
end loop;

if (ie_concil_contab_w = 'S') then
	CALL pls_ctb_onl_gravar_movto_pck.gravar_movto_desf_lote_recalc(nr_seq_lote_p, cd_estabelecimento_w, nm_usuario_p);
end if;

delete	FROM pls_conta_recalculo
where	nr_seq_lote = nr_seq_lote_p;

commit;

update	pls_lote_recalculo
set	dt_geracao_lote	 = NULL,
	nm_usuario	= nm_usuario_p,
	dt_atualizacao	= clock_timestamp()
where	nr_sequencia	= nr_seq_lote_p;

commit;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_desfazer_recalculo ( nr_seq_lote_p bigint, nm_usuario_p text) FROM PUBLIC;

