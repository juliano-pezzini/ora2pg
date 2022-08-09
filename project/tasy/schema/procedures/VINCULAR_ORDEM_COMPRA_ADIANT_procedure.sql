-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE vincular_ordem_compra_adiant ( nr_adiant_pago_p bigint, nr_ordem_compra_p bigint, ie_acao_p text, nm_usuario_p text, ds_historico_p text) AS $body$
DECLARE

 
/* ie_acao_p 
 
V	Vincular 
D	Desvincular 
 
*/
 
 
vl_vinculado_w		double precision	:= 0;
dt_baixa_w		timestamp;
ds_erro_w		varchar(255)	:= '';
qt_ordem_w		bigint;


BEGIN 
 
select	count(*) 
into STRICT	qt_ordem_w 
from	ordem_compra 
where	nr_ordem_compra	= nr_ordem_compra_p;
 
if (qt_ordem_w = 0) then 
	--(-20011,'Ordem de compra inexistente, favor verificar o número digitado!'); 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(254821);
end if;
	 
 
if (nr_adiant_pago_p IS NOT NULL AND nr_adiant_pago_p::text <> '') then 
 
	select	dt_baixa 
	into STRICT	dt_baixa_w 
	from	ordem_compra 
	where	nr_ordem_compra	= nr_ordem_compra_p;
 
	if (dt_baixa_w IS NOT NULL AND dt_baixa_w::text <> '') then 
		--(-20011,'A ordem de compra selecionada já possui data de baixa!'); 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(254822);
		 
	end if;
 
	if (coalesce(ie_acao_p,'V') = 'V') and (nr_ordem_compra_p IS NOT NULL AND nr_ordem_compra_p::text <> '') then 
 
		select	vl_saldo 
		into STRICT	vl_vinculado_w 
		from	adiantamento_pago 
		where	nr_adiantamento	= nr_adiant_pago_p;
 
		ds_erro_w := consistir_ordem_compra_adiant(nr_ordem_compra_p, nr_adiant_pago_p, vl_vinculado_w, ds_erro_w, nm_usuario_p);
 
		if (coalesce(ds_erro_w,'X') <> 'X') then 
			--(-20011,ds_erro_w); 
			CALL wheb_mensagem_pck.exibir_mensagem_abort(254823,'DS_ERRO='||ds_erro_w);
		end if;
 
		insert	into	ordem_compra_adiant_pago(nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			nr_ordem_compra, 
			nr_adiantamento, 
			vl_vinculado) 
		values (nextval('ordem_compra_adiant_pago_seq'), 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			nr_ordem_compra_p, 
			nr_adiant_pago_p, 
			vl_vinculado_w);
 
	elsif (ie_acao_p	= 'D') then 
 
		insert	into adiantamento_pago_hist(ds_historico, 
			dt_atualizacao, 
			nm_usuario, 
			nr_adiantamento, 
			nr_sequencia) 
		values (WHEB_MENSAGEM_PCK.get_texto(298005,'NR_ORDEM_COMPRA_P=' || nr_ordem_compra_p || ';' || 
							'DS_HISTORICO_P=' || ds_historico_p), 
			clock_timestamp(), 
			nm_usuario_p, 
			nr_adiant_pago_p, 
			nextval('adiantamento_pago_hist_seq'));
 
		delete	from ordem_compra_adiant_pago 
		where	nr_adiantamento	= nr_adiant_pago_p 
		and	nr_ordem_compra	= nr_ordem_compra_p;
 
	end if;
 
	CALL atualiza_adiantamento_pago(0,nr_adiant_pago_p,vl_vinculado_w,0,nm_usuario_p,'I');
 
	commit;
 
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vincular_ordem_compra_adiant ( nr_adiant_pago_p bigint, nr_ordem_compra_p bigint, ie_acao_p text, nm_usuario_p text, ds_historico_p text) FROM PUBLIC;
