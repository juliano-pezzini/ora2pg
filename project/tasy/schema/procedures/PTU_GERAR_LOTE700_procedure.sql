-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE ptu_servico_pre_pagto_rec AS (	nr_seq_servico_pre	ptu_servico_pre_pagto.nr_sequencia%type,
						nr_seq_congenere	pls_congenere.nr_sequencia%type);


CREATE OR REPLACE PROCEDURE ptu_gerar_lote700 ( nr_seq_lote_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


dt_competencia_w		timestamp;
dt_geracao_lote_w		timestamp;
nr_seq_congenere_lote_w		bigint;
nr_seq_congenere_w		bigint;
nr_seq_servico_pre_w		bigint;
nr_seq_geracao_w		bigint := 0;
cd_unimed_origem_w		varchar(10);
cd_cooperativa_w		varchar(10);
cd_versao_w			varchar(255);
nr_versao_transacao_w		varchar(255);
cd_interface_w			varchar(5);
index_w				bigint;
qt_contas_w			ptu_servico_pre_total.qt_contas%type;
qt_itens_contas_w		ptu_servico_pre_total.qt_itens_contas%type;
vl_total_procedimento_w		ptu_servico_pre_total.vl_total_procedimento%type;
vl_total_materiais_w		ptu_servico_pre_total.vl_total_materiais%type;
vl_total_w			ptu_servico_pre_total.vl_total%type;
dt_inicio_pagto_w		timestamp;
dt_fim_pagto_w			timestamp;
ds_nome_congenere_w		pessoa_juridica.ds_razao_social%type;
type ptu_servico_pre_pagto_rec_v is table of ptu_servico_pre_pagto_rec index by integer;
ptu_serv_pre_pagto_rec_vetor_w		ptu_servico_pre_pagto_rec_v;

C01 CURSOR FOR
	SELECT	c.nr_seq_congenere
	from	pls_conta			a,
		pls_conta_medica_resumo		d,
  		pls_segurado			b,
		pls_lote_pagamento		e,
		pls_intercambio			c
	where	d.nr_seq_conta			= a.nr_sequencia
	and	a.nr_seq_segurado		= b.nr_sequencia
	and	d.nr_seq_lote_pgto		= e.nr_sequencia
	and	b.nr_seq_intercambio		= c.nr_sequencia
	and	b.ie_tipo_repasse		= 'P'
	and	e.ie_status			= 'D'
	and	e.dt_mes_competencia		between dt_inicio_pagto_w and fim_dia(dt_fim_pagto_w)
	and	((c.nr_seq_congenere		= nr_seq_congenere_lote_w) or (coalesce(nr_seq_congenere_lote_w::text, '') = ''))
	--and	c.nr_seq_congenere in( 189,50,354,162,130,91,67,149,122,93,120)
	and	(e.dt_geracao_titulos IS NOT NULL AND e.dt_geracao_titulos::text <> '')
	and	coalesce(d.nr_seq_serv_pre_pgto, 0) = 0
	and	coalesce(d.nr_seq_lote_pgto, 0) <> 0
	
union all

	SELECT	c.nr_seq_congenere
	from	pls_conta			a,
		pls_conta_medica_resumo		d,
  		pls_segurado			b,
		pls_lote_pagamento		e,
		PLS_PAGAMENTO_PRESTADOR		f,
		pls_intercambio			c,
		pls_prestador			g
	where	d.nr_seq_conta			= a.nr_sequencia
	and	a.nr_seq_segurado		= b.nr_sequencia
	and	d.nr_seq_lote_pgto		= e.nr_sequencia
	and	f.NR_SEQ_LOTE			= e.nr_sequencia
	and	b.nr_seq_intercambio		= c.nr_sequencia
	and	f.nr_seq_prestador		= g.nr_sequencia
	and	b.ie_tipo_repasse		= 'P'
	and	e.ie_status			= 'D'
	and	g.IE_TIPO_RELACAO		= 'P'
	and	e.dt_mes_competencia		between dt_inicio_pagto_w and fim_dia(dt_fim_pagto_w)
	and	((c.nr_seq_congenere		= nr_seq_congenere_lote_w) or (coalesce(nr_seq_congenere_lote_w::text, '') = ''))
	--and	c.nr_seq_congenere in( 189,50,354,162,130,91,67,149,122,93,120)

	--and	e.dt_geracao_titulos is not null
	and	(e.DT_GERACAO_VENCIMENTOS IS NOT NULL AND e.DT_GERACAO_VENCIMENTOS::text <> '')
	and	coalesce(d.nr_seq_serv_pre_pgto, 0) = 0
	and	coalesce(d.nr_seq_lote_pgto, 0) <> 0
	group by c.nr_seq_congenere;
	
C02 CURSOR( nr_seq_lote_pc	ptu_servico_pre_pagto.nr_sequencia%type) FOR
	SELECT	a.cd_cooperativa,
		a.nr_sequencia nr_seq_congenere
	from	pls_congenere	a
	where	a.ie_gerar_a700_vazio	= 'S'
	and	a.ie_tipo_congenere	= 'CO'
	and	exists	(SELECT	1
			from	pls_segurado	c,
				pls_intercambio	b
			where	b.nr_seq_congenere	= a.nr_sequencia
			and	b.nr_sequencia		= c.nr_seq_intercambio
			and	c.ie_tipo_repasse	= 'P'
			and	(c.dt_liberacao IS NOT NULL AND c.dt_liberacao::text <> '')
			and	((coalesce(c.dt_rescisao::text, '') = '' and coalesce(dt_cancelamento::text, '') = '') or ((c.dt_rescisao IS NOT NULL AND c.dt_rescisao::text <> '') and coalesce(c.dt_limite_utilizacao,c.dt_rescisao) >= clock_timestamp())))
	and	not exists (select	1
				from	ptu_servico_pre_pagto	x
				where	x.nr_seq_lote		= nr_seq_lote_pc
				and	x.cd_unimed_destino	= a.cd_cooperativa);

BEGIN
select	dt_inicio,
	dt_geracao_lote,
	nr_seq_congenere
into STRICT	dt_competencia_w,
	dt_geracao_lote_w,
	nr_seq_congenere_lote_w
from	ptu_lote_serv_pre_pgto
where	nr_sequencia	= nr_seq_lote_p;

cd_unimed_origem_w	:= pls_obter_unimed_estab(cd_estabelecimento_p);

index_w			:= 0;

dt_inicio_pagto_w := trunc(dt_competencia_w,'month');
dt_fim_pagto_w := last_day(dt_competencia_w);

-- Data final nunca pode ser maior que a data atual
if (dt_fim_pagto_w > clock_timestamp()) then
	dt_fim_pagto_w := clock_timestamp();
end if;

open C01;
loop
fetch C01 into	
	nr_seq_congenere_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	--nr_seq_geracao_w	:= nr_seq_geracao_w + 1;
	
	select	max(cd_cooperativa)
	into STRICT	cd_cooperativa_w
	from	pls_congenere
	where	nr_sequencia	= nr_seq_congenere_w;
	
	cd_interface_w := pls_obter_interf_ptu(cd_estabelecimento_p,nr_seq_congenere_w,clock_timestamp(),'A700');
	
	select	ptu_obter_versao('A700',cd_interface_w)
	into STRICT	cd_versao_w
	;

	nr_versao_transacao_w	:= ptu_obter_versao_transacao('A700',cd_versao_w);
	
	select	nextval('ptu_servico_pre_pagto_seq')
	into STRICT	nr_seq_servico_pre_w
	;
	
	index_w	:= ptu_serv_pre_pagto_rec_vetor_w.count+1;
	ptu_serv_pre_pagto_rec_vetor_w[index_w].nr_seq_servico_pre	:= nr_seq_servico_pre_w;
	ptu_serv_pre_pagto_rec_vetor_w[index_w].nr_seq_congenere	:= nr_seq_congenere_w;
	
	select	coalesce(max(nr_seq_geracao),0) + 1
	into STRICT	nr_seq_geracao_w
	from	ptu_servico_pre_pagto
	where	cd_unimed_destino = cd_cooperativa_w
	and	ie_envio_recebimento	= 'E';
	
	insert into ptu_servico_pre_pagto(nr_sequencia,
			cd_estabelecimento,
			dt_geracao,
			dt_inicio_pagto,
			dt_fim_pagto,
			nr_versao_transacao, 
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec, 
			nm_usuario_nrec,
			nr_seq_geracao,
			ie_envio_recebimento, 
			cd_unimed_destino,
			cd_unimed_origem,
			nr_seq_lote)
	values (	nr_seq_servico_pre_w,
			cd_estabelecimento_p,
			clock_timestamp(),
			dt_inicio_pagto_w,
			dt_fim_pagto_w,
			nr_versao_transacao_w, 
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(), 
			nm_usuario_p,
			nr_seq_geracao_w,
			'E',
			cd_cooperativa_w,
			cd_unimed_origem_w,
			nr_seq_lote_p);
	
	end;
end loop;
close C01;

index_w	:= 0;

for index_w in 1..ptu_serv_pre_pagto_rec_vetor_w.count loop
	begin
	CALL ptu_gerar_nota_cobr_pre_pgto(	ptu_serv_pre_pagto_rec_vetor_w[index_w].nr_seq_servico_pre,
					ptu_serv_pre_pagto_rec_vetor_w[index_w].nr_seq_congenere,
					dt_inicio_pagto_w,dt_fim_pagto_w,cd_interface_w,nm_usuario_p);
	
	select	count(1)
	into STRICT	qt_contas_w
	from	ptu_nota_cobranca
	where	nr_seq_serv_pre_pagto	= ptu_serv_pre_pagto_rec_vetor_w[index_w].nr_seq_servico_pre;
	
	if (qt_contas_w = 0) then
		delete	FROM ptu_servico_pre_pagto
		where	nr_sequencia	= ptu_serv_pre_pagto_rec_vetor_w[index_w].nr_seq_servico_pre;
	else
	
		select	count(1)
		into STRICT	qt_itens_contas_w
		from	ptu_nota_cobranca	b,
			ptu_nota_servico	a
		where	a.nr_seq_nota_cobr	= b.nr_sequencia
		and	b.nr_seq_serv_pre_pagto	= ptu_serv_pre_pagto_rec_vetor_w[index_w].nr_seq_servico_pre;
	
		select	coalesce(sum(a.vl_procedimento),0) + coalesce(sum(a.vl_filme),0) + coalesce(sum(a.vl_custo_operacional),0)
		into STRICT	vl_total_procedimento_w
		from	ptu_nota_cobranca	b,
			ptu_nota_servico	a
		where	a.nr_seq_nota_cobr	= b.nr_sequencia
		and	b.nr_seq_serv_pre_pagto	= ptu_serv_pre_pagto_rec_vetor_w[index_w].nr_seq_servico_pre
		and	a.ie_tipo_tabela	in (0,1,4);
		
		select	coalesce(sum(a.vl_procedimento),0) + coalesce(sum(a.vl_filme),0) + coalesce(sum(a.vl_custo_operacional),0)
		into STRICT	vl_total_materiais_w
		from	ptu_nota_cobranca	b,
			ptu_nota_servico	a
		where	a.nr_seq_nota_cobr	= b.nr_sequencia
		and	b.nr_seq_serv_pre_pagto	= ptu_serv_pre_pagto_rec_vetor_w[index_w].nr_seq_servico_pre
		and	a.ie_tipo_tabela	in (2,3,5,6);
		
		vl_total_w	:= vl_total_procedimento_w + vl_total_materiais_w;
		
		insert into ptu_servico_pre_total(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
				nr_seq_serv_pre_pagto,qt_contas,qt_itens_contas,vl_total_procedimento,vl_total_materiais,
				vl_total)
		values (	nextval('ptu_servico_pre_total_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
				ptu_serv_pre_pagto_rec_vetor_w[index_w].nr_seq_servico_pre,qt_contas_w,qt_itens_contas_w,vl_total_procedimento_w,vl_total_materiais_w,
				vl_total_w);		
	end if;
	
	end;
end loop;

/*select	nvl(max(nr_seq_geracao),0)
into	nr_seq_geracao_w
from	ptu_servico_pre_pagto
where	nr_seq_lote	= nr_seq_lote_p;*/
for r_C02_w in C02(nr_seq_lote_p) loop
	--nr_seq_geracao_w := nr_seq_geracao_w + 1;
	cd_interface_w := pls_obter_interf_ptu( cd_estabelecimento_p, r_C02_w.nr_seq_congenere, clock_timestamp(), 'A700');
	
	if (coalesce(cd_interface_w::text, '') = '') then
		
		ds_nome_congenere_w := pls_obter_nome_congenere(r_C02_w.nr_seq_congenere);
		CALL wheb_mensagem_pck.exibir_mensagem_abort(452110, 'NM_CONGENERE='||r_C02_w.nr_seq_congenere || ' - ' || ds_nome_congenere_w);		
	end if;
	
	select	ptu_obter_versao( 'A700', cd_interface_w)
	into STRICT	cd_versao_w
	;
	
	if (coalesce(cd_versao_w::text, '') = '') then
		
		CALL wheb_mensagem_pck.exibir_mensagem_abort(452113, 'NR_SEQ_INTERFACE='||cd_interface_w);		
	end if;

	nr_versao_transacao_w	:= ptu_obter_versao_transacao( 'A700', cd_versao_w);
	
	select	nextval('ptu_servico_pre_pagto_seq')
	into STRICT	nr_seq_servico_pre_w
	;
	
	select	coalesce(max(nr_seq_geracao),0) + 1
	into STRICT	nr_seq_geracao_w
	from	ptu_servico_pre_pagto
	where	cd_unimed_destino 	= r_C02_w.cd_cooperativa
	and	ie_envio_recebimento	= 'E';

	insert into ptu_servico_pre_pagto(nr_sequencia,
		cd_estabelecimento,
		dt_geracao,
		dt_inicio_pagto,
		dt_fim_pagto,
		nr_versao_transacao,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_geracao,
		ie_envio_recebimento,
		cd_unimed_destino,
		cd_unimed_origem,
		nr_seq_lote)
	values (	nextval('ptu_servico_pre_pagto_seq'),
		cd_estabelecimento_p,
		clock_timestamp(),
		dt_inicio_pagto_w,
		dt_fim_pagto_w,
		nr_versao_transacao_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_geracao_w,
		'E',
		r_C02_w.cd_cooperativa,
		cd_unimed_origem_w,
		nr_seq_lote_p);
end loop;

update	ptu_lote_serv_pre_pgto
set	dt_geracao_lote		= clock_timestamp()
where	nr_sequencia		= nr_seq_lote_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_gerar_lote700 ( nr_seq_lote_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

