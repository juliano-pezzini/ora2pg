-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_mov_mens_pck.gerar_titulo_pagar_classif ( nr_titulo_pagar_p titulo_pagar.nr_titulo%type, nr_seq_lote_p pls_mov_mens_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE

nr_contador_w				bigint := 0;
nr_seq_classif_w			integer := 0;

c_itens CURSOR FOR
	SELECT	a.cd_conta_ato_cooperado,
		a.cd_conta_ato_auxiliar,
		a.cd_conta_ato_nao_coop,
		a.cd_conta_rec,
		sum(a.vl_ato_auxiliar) vl_ato_auxiliar,
		sum(a.vl_ato_cooperado) vl_ato_cooperado,
		sum(a.vl_ato_nao_cooperado) vl_ato_nao_cooperado,
		sum(a.vl_item) vl_item
	from	pls_mensalidade_seg_item	a,
		pls_mov_mens_benef_item		b,
		pls_mov_mens_benef		c,
		pls_mov_mens_operadora		o,
		pls_mov_mens_operador_venc	l
	where	b.nr_seq_item_mens	= a.nr_sequencia
	and	b.nr_seq_mov_benef	= c.nr_sequencia
	and	c.nr_seq_mov_operadora	= o.nr_sequencia
	and	o.nr_sequencia		= l.nr_seq_mov_operadora
	and	l.nr_titulo_pagar	= nr_titulo_pagar_p
	group by a.cd_conta_ato_cooperado,
		a.cd_conta_ato_auxiliar,
		a.cd_conta_ato_nao_coop,
		a.cd_conta_rec;

c_itens_w	c_itens%rowtype;
	
c_valor CURSOR FOR
	-- Valor ato cooperado
	SELECT	'AC' ie_ato_cooperado
	
	where	((coalesce(c_itens_w.vl_ato_cooperado,0) <> 0)
	or (coalesce(c_itens_w.vl_ato_auxiliar,0) <> 0)
	or (coalesce(c_itens_w.vl_ato_nao_cooperado,0) <> 0))
	
union all

	-- Valor ato auxiliar
	SELECT	'AA' ie_ato_cooperado
	
	where	((coalesce(c_itens_w.vl_ato_cooperado,0) <> 0)
	or (coalesce(c_itens_w.vl_ato_auxiliar,0) <> 0)
	or (coalesce(c_itens_w.vl_ato_nao_cooperado,0) <> 0))
	
union all

	-- Valor ato não cooperado
	select	'AN' ie_ato_cooperado
	
	where	((coalesce(c_itens_w.vl_ato_cooperado,0) <> 0)
	or (coalesce(c_itens_w.vl_ato_auxiliar,0) <> 0)
	or (coalesce(c_itens_w.vl_ato_nao_cooperado,0) <> 0))
	
union all

	-- Sem valor de ato cooperado
	select	'N' ie_ato_cooperado
	
	where	((coalesce(c_itens_w.vl_ato_cooperado,0) = 0)
	or (coalesce(c_itens_w.vl_ato_auxiliar,0) = 0)
	or (coalesce(c_itens_w.vl_ato_nao_cooperado,0) = 0));
	
c_valor_w	c_valor%rowtype;


BEGIN

open c_itens;
loop
fetch c_itens into
	c_itens_w;
EXIT WHEN NOT FOUND; /* apply on c_itens */
	begin
	nr_contador_w 		:= nr_contador_w + 1;
	
	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_seq_classif_w
	from	titulo_pagar_classif
	where	nr_titulo = nr_titulo_pagar_p;
	
	open c_valor;
	loop
	fetch c_valor into
		c_valor_w;
	EXIT WHEN NOT FOUND; /* apply on c_valor */
		begin		
		nr_seq_classif_w		:= nr_seq_classif_w + 1;
		if (c_valor_w.ie_ato_cooperado = 'AC') then
			c_itens_w.cd_conta_rec		:= c_itens_w.cd_conta_ato_cooperado;
			c_itens_w.vl_item		:= c_itens_w.vl_ato_cooperado;
		elsif (c_valor_w.ie_ato_cooperado = 'AA') then
			c_itens_w.cd_conta_rec		:= c_itens_w.cd_conta_ato_auxiliar;
			c_itens_w.vl_item		:= c_itens_w.vl_ato_auxiliar;
		elsif (c_valor_w.ie_ato_cooperado = 'AN') then
			c_itens_w.cd_conta_rec		:= c_itens_w.cd_conta_ato_nao_coop;
			c_itens_w.vl_item		:= c_itens_w.vl_ato_nao_cooperado;
		elsif (c_valor_w.ie_ato_cooperado = 'N') then
			c_itens_w.cd_conta_rec		:= c_itens_w.cd_conta_rec;
			c_itens_w.vl_item		:= c_itens_w.vl_item;
		end if;
		
		insert into titulo_pagar_classif(
			nr_sequencia,
			dt_atualizacao, 
			nm_usuario, 
			cd_conta_contabil, 
			vl_titulo,
			nr_titulo)
		values ( nr_seq_classif_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			c_itens_w.cd_conta_rec, 
			c_itens_w.vl_item,
			nr_titulo_pagar_p);
			
		if (mod(nr_contador_w,1000) = 0) then
			commit;
		end if;
		
		end;
	end loop;
	close c_valor;	
	end;
end loop;
close c_itens;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_mov_mens_pck.gerar_titulo_pagar_classif ( nr_titulo_pagar_p titulo_pagar.nr_titulo%type, nr_seq_lote_p pls_mov_mens_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;