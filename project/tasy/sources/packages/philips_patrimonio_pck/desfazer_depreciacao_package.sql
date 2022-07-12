-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE philips_patrimonio_pck.desfazer_depreciacao ( dt_referencia_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_erro_w		varchar(4000);

c01 CURSOR FOR
	SELECT	a.nr_seq_bem
	from	pat_valor_bem a,
		pat_bem b
	where	a.nr_seq_bem	= b.nr_sequencia
	and	a.dt_valor	= dt_referencia_p
	and	b.ie_situacao	= 'I'
	and	pat_obter_estab_bem_periodo(b.nr_sequencia,dt_referencia_p) = cd_estabelecimento_p;

c01_w		c01%rowtype;


BEGIN

CALL philips_patrimonio_pck.consistir_desfazer_depreciacao(nm_usuario_p,cd_estabelecimento_p,dt_referencia_p);

begin
CALL philips_patrimonio_pck.set_ie_desfazendo_depreciacao('S');

open c01;
loop
fetch c01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	update	pat_bem
	set	ie_situacao	= 'A',
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia	= c01_w.nr_seq_bem;
	end;
end loop;
close c01;

/* Avaliacao negativa */


delete from pat_bem_movimento a
where	a.nr_seq_operacao = current_setting('philips_patrimonio_pck.oper_patrimonial')::r_pat_operacao.avaliacao_negativa
and	a.dt_movimento = dt_referencia_p
and	exists (SELECT	1
		from	pat_bem b
		where	b.nr_sequencia = a.nr_seq_bem
		and	pat_obter_estab_bem_periodo(b.nr_sequencia, dt_referencia_p) = cd_estabelecimento_p);

/* Avaliacao positiva */


delete from pat_bem_movimento a
where	a.nr_seq_operacao = current_setting('philips_patrimonio_pck.oper_patrimonial')::r_pat_operacao.avaliacao_positiva
and	a.dt_movimento = dt_referencia_p
and	exists (SELECT	1
		from	pat_bem b
		where	b.nr_sequencia = a.nr_seq_bem
		and	pat_obter_estab_bem_periodo(b.nr_sequencia, dt_referencia_p) = cd_estabelecimento_p);

/* Novo bem */


delete from pat_bem_movimento a
where	a.nr_seq_operacao = current_setting('philips_patrimonio_pck.oper_patrimonial')::r_pat_operacao.novo_bem
and	a.dt_movimento = dt_referencia_p
and	exists (SELECT	1
		from	pat_bem b
		where	b.nr_sequencia = a.nr_seq_bem
		and	pat_obter_estab_bem_periodo(b.nr_sequencia, dt_referencia_p) = cd_estabelecimento_p);

/* Depreciacao */


/* Rateio da depreciacao por cascade - pat_bem_movto_rateio */


delete from pat_bem_movimento a
where	a.nr_seq_operacao = current_setting('philips_patrimonio_pck.oper_patrimonial')::r_pat_operacao.depreciacao
and	a.dt_movimento = dt_referencia_p
and	exists (SELECT	1
		from	pat_bem b
		where	b.nr_sequencia = a.nr_seq_bem
		and	pat_obter_estab_bem_periodo(b.nr_sequencia, dt_referencia_p) = cd_estabelecimento_p);

/* Baixa de bem vinculado */


/* Baixa do bem original */


delete from pat_bem_movimento a
where	a.nr_seq_operacao = current_setting('philips_patrimonio_pck.oper_patrimonial')::r_pat_operacao.baixa_de_bem
and	a.dt_movimento = dt_referencia_p
and	exists (SELECT	1
		from	pat_bem b
		where	b.nr_sequencia = a.nr_seq_bem
		and	pat_obter_estab_bem_periodo(b.nr_sequencia, dt_referencia_p) = cd_estabelecimento_p);

delete from pat_bem_movimento a
where	a.nr_seq_operacao = current_setting('philips_patrimonio_pck.oper_patrimonial')::r_pat_operacao.baixa_de_bem
and	a.dt_movimento = dt_referencia_p
and	exists (SELECT	1
		from	pat_bem b
		where	b.nr_sequencia = a.nr_seq_bem
		and	pat_obter_estab_bem_periodo(b.nr_sequencia, dt_referencia_p) = cd_estabelecimento_p);

delete	from pat_valor_bem a
where	a.dt_valor = dt_referencia_p
and	exists (SELECT	1
		from	pat_bem b
		where	b.nr_sequencia = a.nr_seq_bem
		and	pat_obter_estab_bem_periodo(b.nr_sequencia, dt_referencia_p) = cd_estabelecimento_p);

update	pat_mes_ref a
set	a.dt_recalculo	 = NULL,
	a.ie_situacao	= '0'
where	a.dt_mes_ref	= dt_referencia_p
and	a.cd_estabelecimento = cd_estabelecimento_p;

CALL philips_patrimonio_pck.set_ie_desfazendo_depreciacao('N');
exception
when others then
	CALL philips_patrimonio_pck.set_ie_desfazendo_depreciacao('N');
	ds_erro_w	:= substr(sqlerrm(SQLSTATE),1,4000);
	CALL wheb_mensagem_pck.exibir_mensagem_abort(868697,'ERRO='||ds_erro_w);
end;

/* ****************************************************************************
Desfazer a contabilizacao dos movimentos caso esteja habilitada a contabilidade online
***************************************************************************** */

if ( ctb_online_pck.get_modo_lote(17, cd_estabelecimento_p) = 'S' ) then
	CALL ctb_contab_onl_patrimonio(dt_referencia_p, cd_estabelecimento_p, nm_usuario_p, 'S');
end if;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE philips_patrimonio_pck.desfazer_depreciacao ( dt_referencia_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;