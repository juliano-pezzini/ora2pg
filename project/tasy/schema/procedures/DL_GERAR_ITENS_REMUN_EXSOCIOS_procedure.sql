-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE dl_gerar_itens_remun_exsocios ( nr_seq_distribuicao_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, vl_distribuicao_p bigint) AS $body$
DECLARE

 
nr_seq_lote_w		bigint;		
nr_seq_socio_w		bigint;	
nr_seq_tipo_distrib_w	bigint;
nr_seq_distrib_item_w	bigint;	
qt_anos_serv_socio_w	bigint;
qt_anos_serv_socios_w	bigint;
vl_distribuicao_w	double precision;
vl_remuneracao_mes_w	double precision;
pr_representatividade_w	double precision;
ds_msg_tp_distrib_w	varchar(255);


BEGIN 
 
select	a.nr_seq_socio, 
	a.nr_seq_lote 
into STRICT	nr_seq_socio_w, 
	nr_seq_lote_w 
from 	dl_distribuicao a 
where	a.nr_sequencia	= nr_seq_distribuicao_p;
 
if (dl_obter_dados_socio(nr_seq_socio_w,'T') = 'E') then 
 
	qt_anos_serv_socio_w	:= 0;
	qt_anos_serv_socios_w	:= 0;
	vl_distribuicao_w	:= 0;
	vl_remuneracao_mes_w	:= 0;
	pr_representatividade_w	:= 0;
 
	select (to_char(coalesce(a.dt_saida,clock_timestamp()), 'yyyy') - to_char(a.dt_entrada, 'yyyy')) 
	into STRICT	qt_anos_serv_socio_w 
	from	dl_socio a 
	where	a.nr_sequencia		= nr_seq_socio_w 
	and	a.cd_estabelecimento	= cd_estabelecimento_p;
 
	select	sum(to_char(coalesce(a.dt_saida,clock_timestamp()), 'yyyy') - to_char(a.dt_entrada, 'yyyy')) 
	into STRICT	qt_anos_serv_socios_w 
	from	dl_socio a 
	where	a.ie_situacao		= 'A' 
	and	a.cd_estabelecimento	= cd_estabelecimento_p;
 
	select	coalesce(coalesce(vl_distribuicao_p,a.vl_distribuicao),0) 
	into STRICT	vl_distribuicao_w 
	from	dl_lote_distribuicao a 
	where	a.nr_sequencia	= nr_seq_lote_w;
 
	pr_representatividade_w	:= ((dividir_sem_round(qt_anos_serv_socio_w,qt_anos_serv_socios_w) / 3) * 2) * 100;
	vl_remuneracao_mes_w	:= vl_distribuicao_w * pr_representatividade_w;
 
	/* dominio DL - Tipo de item para calculo da distribuicao / Remuneracao de ex-socio */
 
	select	max(a.nr_sequencia) 
	into STRICT	nr_seq_tipo_distrib_w 
	from	dl_tipo_item a 
	where	a.ie_tipo_item		= 12 
	and	a.nr_seq_socio		= nr_seq_socio_w 
	and	a.cd_estabelecimento	= cd_estabelecimento_p;
 
	if (coalesce(nr_seq_tipo_distrib_w::text, '') = '') then 
		select	max(a.nr_sequencia) 
		into STRICT	nr_seq_tipo_distrib_w 
		from	dl_tipo_item a 
		where	a.ie_tipo_item		= 12 
		and	coalesce(a.nr_seq_socio::text, '') = '' 
		and	a.cd_estabelecimento	= cd_estabelecimento_p;
	end if;
 
	if (coalesce(nr_seq_tipo_distrib_w::text, '') = '') then -- afstringari 236244 28/07/2010 
 
		ds_msg_tp_distrib_w	:= substr(dl_obter_msg_tp_distrib(1,12),1,255);
 
		/* ds_msg_tp_distrib_w */
 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(262112,'DS_MSG_TP_DISTRIB_W='||ds_msg_tp_distrib_w);
 
	end if;	
	 
	select	max(coalesce(b.nr_sequencia,0)) 
	into STRICT	nr_seq_distrib_item_w 
	from	dl_distribuicao a, 
		dl_distribuicao_item b		 
	where	a.nr_sequencia	= b.nr_seq_distribuicao 
	and	a.nr_seq_lote	= nr_seq_lote_w 
	and	a.nr_sequencia	= nr_seq_distribuicao_p 
	and	b.nr_seq_item	= nr_seq_tipo_distrib_w;
	 
	if (coalesce(nr_seq_distrib_item_w::text, '') = '') and (coalesce(vl_distribuicao_p::text, '') = '') then 
		insert into dl_distribuicao_item( 
			nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			nr_seq_distribuicao, 
			nr_seq_item, 
			tx_item, 
			vl_item, 
			qt_item, 
			vl_calculado) 
		values ( nextval('dl_distribuicao_item_seq'), 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			nr_seq_distribuicao_p, 
			nr_seq_tipo_distrib_w, 
			coalesce(pr_representatividade_w,0), 
			0, 
			qt_anos_serv_socio_w, 
			coalesce(vl_remuneracao_mes_w,0));	
	else 
		update 	dl_distribuicao_item 
		set	dt_atualizacao		= clock_timestamp(), 
			nm_usuario		= nm_usuario_p, 
			vl_item			= coalesce(vl_remuneracao_mes_w,0) 
		where	nr_sequencia		= nr_seq_distrib_item_w 
		and	nr_seq_distribuicao	= nr_seq_distribuicao_p;
	end if;			
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dl_gerar_itens_remun_exsocios ( nr_seq_distribuicao_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, vl_distribuicao_p bigint) FROM PUBLIC;
