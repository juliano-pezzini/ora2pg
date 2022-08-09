-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desfazer_encerr_proc_conta ( nr_seq_proc_conta_p pls_processo_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, ie_impug_nova_p text ) AS $body$
DECLARE


ie_status_conta_w	pls_processo_conta.ie_status_conta%type;
ie_concil_contab_w	pls_visible_false.ie_concil_contab%type;
cd_estabelecimento_w 	estabelecimento.cd_estabelecimento%type;
qt_pendente_w		integer;
qt_reg_ctb_doc_w	smallint;
cont_w			bigint;

c_estorno_ctb_onl CURSOR FOR
	SELECT	b.nm_tabela,
		b.nm_atributo,
		coalesce(a.vl_ressarcir, 0) vl_ressarcir,
		coalesce(a.vl_deferido, 0) vl_deferido,
		b.cd_tipo_lote_contabil,
		count(case b.ie_situacao_ctb when 'P' then 1 end) qt_pendente
	from	pls_processo_conta a,
		ctb_documento b
	where	b.nr_documento = a.nr_sequencia
	and	a.nr_sequencia = nr_seq_proc_conta_p
	and	b.nm_tabela = 'PLS_PROCESSO_CONTA'
	and	b.nm_atributo in ('VL_RESSARCIR', 'VL_DEFERIDO')
	and	b.cd_tipo_lote_contabil		= 27
	and	coalesce(b.ds_origem, 'X') <> 'ESTORNO'
	group by b.nm_tabela,
		b.nm_atributo,
		a.vl_ressarcir,
		a.vl_deferido,
		b.cd_tipo_lote_contabil;

vet_itens_estorno c_estorno_ctb_onl%rowtype;


BEGIN

CALL pls_atualizar_proc_conta(nr_seq_proc_conta_p, nm_usuario_p, 'N', ie_impug_nova_p);

if (ie_impug_nova_p = 'N') then
	select	count(*)
	into STRICT	cont_w
	from	pls_impugnacao_defesa b,
		pls_impugnacao a
	where	a.nr_sequencia		= b.nr_seq_impugnacao
	and	coalesce(b.dt_cancelamento::text, '') = ''
	and	(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '')
	and	b.ie_tipo_defesa	= 'J'
	and	a.nr_seq_conta		= nr_seq_proc_conta_p;
else
	select	count(*)
	into STRICT	cont_w
	from	pls_formulario_defesa b,
		pls_formulario a
	where	a.nr_sequencia		= b.nr_seq_formulario
	and	(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '')
	and	b.ie_tipo_defesa	= 'J'
	and	a.nr_seq_conta		= nr_seq_proc_conta_p;
end if;

if (cont_w > 0) then	-- se tem defesa judicial
	ie_status_conta_w	:= 'J';
else
	ie_status_conta_w	:= 'A';
end if;

update	pls_processo_conta
set	ie_status_conta		= ie_status_conta_w,
	ie_status_pagamento	= CASE WHEN vl_ressarcir=0 THEN 'N'  ELSE 'S' END
where	nr_sequencia		= nr_seq_proc_conta_p;


cd_estabelecimento_w := wheb_usuario_pck.get_cd_estabelecimento;

select	coalesce(max(ie_concil_contab), 'N')
into STRICT	ie_concil_contab_w
from 	pls_visible_false;

if (ie_concil_contab_w = 'S') then
	begin

	open c_estorno_ctb_onl;
	loop
	fetch c_estorno_ctb_onl into
		vet_itens_estorno;
	EXIT WHEN NOT FOUND; /* apply on c_estorno_ctb_onl */
		begin
		if (vet_itens_estorno.qt_pendente > 0) then
			delete 	FROM ctb_documento
			where	nr_documento = nr_seq_proc_conta_p
			and 	nm_tabela = vet_itens_estorno.nm_tabela
			and	nm_atributo = vet_itens_estorno.nm_atributo
			and	cd_tipo_lote_contabil = vet_itens_estorno.cd_tipo_lote_contabil
			and	ie_situacao_ctb = 'P';
		else
			if (vet_itens_estorno.vl_ressarcir <> 0 and vet_itens_estorno.nm_atributo = 'VL_RESSARCIR') then
				CALL ctb_concil_financeira_pck.ctb_gravar_documento( cd_estabelecimento_w,
										pkg_date_utils.start_of(clock_timestamp(), 'DAY'),
										27,
										null, 
										27,
										nr_seq_proc_conta_p,
										null,
										null,
										vet_itens_estorno.vl_ressarcir * -1, -- Inverte o valor pois é estorno
										vet_itens_estorno.nm_tabela,
										vet_itens_estorno.nm_atributo,
										nm_usuario_p,
										'P',
										'ESTORNO');
			end if;

			if (vet_itens_estorno.vl_deferido <> 0 and vet_itens_estorno.nm_atributo = 'VL_DEFERIDO') then
				CALL ctb_concil_financeira_pck.ctb_gravar_documento( cd_estabelecimento_w,
										pkg_date_utils.start_of(clock_timestamp(), 'DAY'),
										27,
										null, 
										28, 
										nr_seq_proc_conta_p,
										null,
										null,
										vet_itens_estorno.vl_deferido * - 1, -- Inverte o valor pois é estonro
										vet_itens_estorno.nm_tabela,
										vet_itens_estorno.nm_atributo,
										nm_usuario_p,
										'P',
										'ESTORNO');
			end if;
		end if;
		end;
	end loop;
	close c_estorno_ctb_onl;
		end;
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_desfazer_encerr_proc_conta ( nr_seq_proc_conta_p pls_processo_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, ie_impug_nova_p text ) FROM PUBLIC;
