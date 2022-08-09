-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_tit_rec_liq_convret (nr_seq_retorno_p bigint, nr_seq_protocolo_p bigint, nr_interno_conta_p bigint, vl_pago_guia_p bigint, vl_adicional_guia_p bigint, vl_glosado_guia_p bigint, vl_adequado_guia_p bigint, vl_desconto_guia_p bigint, vl_perdas_guia_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
/* 
Edgar 16/04/2009 
Esta procedure foi feita para acertar os arredondamentos e atualizar os saldos dos títulos do retorno convênio 
*/
 
 
vl_recebido_w		double precision;
vl_descontos_w		double precision;
vl_rec_maior_w		double precision;
vl_glosa_w		double precision;
vl_adequado_w		double precision;
vl_perdas_w		double precision;

vl_recebido_liq_w		double precision;
vl_descontos_liq_w		double precision;
vl_rec_maior_liq_w		double precision;
vl_glosa_liq_w			double precision;
vl_adequado_liq_w		double precision;
vl_perdas_liq_w			double precision;

nr_titulo_w		bigint;
nr_titulo_ant_w		bigint;
nr_sequencia_w		bigint;
vl_saldo_titulo_w	double precision;
vl_saldo_tit_w		double precision;

vl_difer_rec_w		double precision;
vl_difer_desc_w		double precision;
vl_difer_glosa_w	double precision;
vl_difer_maior_w	double precision;
vl_difer_adeq_w		double precision;
vl_difer_perdas_w	double precision;

c01 CURSOR FOR 
SELECT	b.nr_titulo, 
	a.nr_sequencia, 
	b.vl_saldo_titulo, 
	a.vl_recebido, 
	a.vl_descontos, 
	a.vl_rec_maior, 
	a.vl_glosa, 
	a.vl_adequado, 
	a.vl_perdas 
from	titulo_receber b, 
	titulo_receber_liq a 
where	a.nr_titulo		= b.nr_titulo 
and	b.nr_interno_conta	= nr_interno_conta_p 
and	a.nr_seq_retorno	= nr_seq_retorno_p 

union
 
SELECT	b.nr_titulo, 
	a.nr_sequencia, 
	b.vl_saldo_titulo, 
	a.vl_recebido, 
	a.vl_descontos, 
	a.vl_rec_maior, 
	a.vl_glosa, 
	a.vl_adequado, 
	a.vl_perdas 
from	titulo_receber b, 
	titulo_receber_liq a 
where	a.nr_titulo		= b.nr_titulo 
and	coalesce(b.nr_interno_conta::text, '') = '' 
and	b.nr_seq_protocolo	= nr_seq_protocolo_p 
and	a.nr_seq_retorno	= nr_seq_retorno_p 
order by 
	nr_titulo, 
	nr_sequencia;

 

BEGIN 
 
select	sum(vl_recebido), 
	sum(vl_descontos), 
	sum(vl_rec_maior), 
	sum(vl_glosa), 
	sum(vl_adequado), 
	sum(vl_perdas) 
into STRICT	vl_recebido_w, 
	vl_descontos_w, 
	vl_rec_maior_w, 
	vl_glosa_w, 
	vl_adequado_w, 
	vl_perdas_w 
from (SELECT	coalesce(b.vl_recebido, 0) vl_recebido, 
		coalesce(b.vl_descontos, 0) vl_descontos, 
		coalesce(b.vl_rec_maior, 0) vl_rec_maior, 
		coalesce(b.vl_glosa, 0) vl_glosa, 
		coalesce(b.vl_adequado, 0) vl_adequado, 
		coalesce(b.vl_perdas, 0) vl_perdas 
	from	titulo_receber_liq b, 
		titulo_receber a 
	where	a.nr_titulo		= b.nr_titulo 
	and	a.nr_interno_conta	= nr_interno_conta_p 
	and	b.nr_seq_retorno	= nr_seq_retorno_p 
	
union all
 
	SELECT	coalesce(b.vl_recebido, 0) vl_recebido, 
		coalesce(b.vl_descontos, 0) vl_descontos, 
		coalesce(b.vl_rec_maior, 0) vl_rec_maior, 
		coalesce(b.vl_glosa, 0) vl_glosa, 
		coalesce(b.vl_adequado, 0) vl_adequado, 
		coalesce(b.vl_perdas, 0) vl_perdas 
	from	titulo_receber_liq b, 
		titulo_receber a 
	where	a.nr_titulo		= b.nr_titulo 
	and	coalesce(a.nr_interno_conta::text, '') = '' 
	and	a.nr_seq_protocolo	= nr_seq_protocolo_p 
	and	b.nr_seq_retorno	= nr_seq_retorno_p) alias19;
 
if (vl_recebido_w		<> vl_pago_guia_p) or (vl_descontos_w		<> vl_desconto_guia_p) or (vl_glosa_w		<> vl_glosado_guia_p) or (vl_rec_maior_w		<> vl_adicional_guia_p) or (vl_adequado_w		<> vl_adequado_guia_p) or (vl_perdas_w		<> vl_perdas_guia_p) then 
 
	vl_difer_rec_w		:= vl_pago_guia_p - vl_recebido_w;
	vl_difer_desc_w		:= vl_desconto_guia_p - vl_descontos_w;
	vl_difer_glosa_w	:= vl_glosado_guia_p - vl_glosa_w;
	vl_difer_maior_w	:= vl_adicional_guia_p - vl_rec_maior_w;
	vl_difer_adeq_w		:= vl_adequado_guia_p - vl_adequado_w;
	vl_difer_perdas_w	:= vl_perdas_guia_p - vl_perdas_w;
 
	nr_titulo_ant_w	:= 0;	
 
	open c01;
	loop 
	fetch c01 into 
		nr_titulo_w, 
		nr_sequencia_w, 
		vl_saldo_tit_w, 
		vl_recebido_liq_w, 
		vl_descontos_liq_w, 
		vl_rec_maior_liq_w, 
		vl_glosa_liq_w, 
		vl_adequado_liq_w, 
		vl_perdas_liq_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
 
		if (nr_titulo_ant_w <> nr_titulo_w) then 
			vl_saldo_titulo_w	:= vl_saldo_tit_w;
		end if;
 
		/* Verificar recebido - Influi no saldo do titulo */
 
 
		if (vl_difer_rec_w > 0) and (vl_saldo_titulo_w > 0) and (vl_recebido_liq_w > 0) then 
 
			if (vl_difer_rec_w <= vl_saldo_titulo_w) then 
				 
				update	titulo_receber_liq 
				set	vl_recebido	= vl_recebido + vl_difer_rec_w 
				where	nr_titulo	= nr_titulo_w 
				and	nr_sequencia	= nr_sequencia_w;
 
				vl_saldo_titulo_w	:= vl_saldo_titulo_w - vl_difer_rec_w;
				vl_difer_rec_w		:= 0;
			else 
				update	titulo_receber_liq 
				set	vl_recebido	= vl_recebido + vl_saldo_titulo_w 
				where	nr_titulo	= nr_titulo_w 
				and	nr_sequencia	= nr_sequencia_w;	
 
				vl_saldo_titulo_w	:= 0;
				vl_difer_rec_w		:= vl_difer_rec_w - vl_saldo_titulo_w;
			end if;
 
		end if;
 
		/* Verificar descontos - Influi no saldo do titulo */
 
 
		if (vl_difer_desc_w > 0) and (vl_saldo_titulo_w > 0) and (vl_descontos_liq_w > 0) then 
 
			if (vl_difer_desc_w <= vl_saldo_titulo_w) then 
 
				update	titulo_receber_liq 
				set	vl_descontos	= vl_descontos + vl_difer_desc_w 
				where	nr_titulo	= nr_titulo_w 
				and	nr_sequencia	= nr_sequencia_w;
 
				vl_saldo_titulo_w	:= vl_saldo_titulo_w - vl_difer_desc_w;
				vl_difer_desc_w		:= 0;
			else 
				update	titulo_receber_liq 
				set	vl_descontos	= vl_descontos + vl_saldo_titulo_w 
				where	nr_titulo	= nr_titulo_w 
				and	nr_sequencia	= nr_sequencia_w;	
 
				vl_saldo_titulo_w	:= 0;
				vl_difer_desc_w		:= vl_difer_desc_w - vl_saldo_titulo_w;
			end if;
		end if;
		 
 
		/* Verificar glosa - Influi no saldo do titulo */
 
 
		if (vl_difer_glosa_w > 0) and (vl_saldo_titulo_w > 0) and (vl_glosa_liq_w > 0) then 
 
			if (vl_difer_glosa_w <= vl_saldo_titulo_w) then 
 
				update	titulo_receber_liq 
				set	vl_glosa	= vl_glosa + vl_difer_glosa_w 
				where	nr_titulo	= nr_titulo_w 
				and	nr_sequencia	= nr_sequencia_w;
 
				vl_saldo_titulo_w	:= vl_saldo_titulo_w - vl_difer_glosa_w;
				vl_difer_glosa_w		:= 0;
			else 
				update	titulo_receber_liq 
				set	vl_glosa	= vl_glosa + vl_saldo_titulo_w 
				where	nr_titulo	= nr_titulo_w 
				and	nr_sequencia	= nr_sequencia_w;	
 
				vl_saldo_titulo_w	:= 0;
				vl_difer_glosa_w	:= vl_difer_glosa_w - vl_saldo_titulo_w;
			end if;
 
		end if;
 
		/* Verificar perda - Influi no saldo do titulo */
 
 
		if (vl_difer_perdas_w > 0) and (vl_saldo_titulo_w > 0) and (vl_perdas_liq_w > 0) then 
 
			if (vl_difer_perdas_w <= vl_saldo_titulo_w) then 
 
				update	titulo_receber_liq 
				set	vl_perdas	= vl_perdas + vl_difer_perdas_w 
				where	nr_titulo	= nr_titulo_w 
				and	nr_sequencia	= nr_sequencia_w;
 
				vl_saldo_titulo_w	:= vl_saldo_titulo_w - vl_difer_perdas_w;
				vl_difer_perdas_w		:= 0;
			else 
				update	titulo_receber_liq 
				set	vl_perdas	= vl_perdas + vl_saldo_titulo_w 
				where	nr_titulo	= nr_titulo_w 
				and	nr_sequencia	= nr_sequencia_w;	
 
				vl_saldo_titulo_w	:= 0;
				vl_difer_perdas_w	:= vl_difer_perdas_w - vl_saldo_titulo_w;
			end if;
 
		end if;
 
		/* Verificar a maior - Nao Influi no saldo do titulo */
 
 
		if (vl_difer_maior_w > 0) and (vl_rec_maior_liq_w > 0) then 
 
			update	titulo_receber_liq 
			set	vl_rec_maior	= vl_rec_maior + vl_difer_maior_w 
			where	nr_titulo	= nr_titulo_w 
			and	nr_sequencia	= nr_sequencia_w;
 
			vl_difer_maior_w	:= 0;
		end if;
 
		/* Verificar adequado - Nao Influi no saldo do titulo */
 
 
		if (vl_difer_adeq_w > 0) and (vl_adequado_liq_w > 0) then 
 
			update	titulo_receber_liq 
			set	vl_adequado	= vl_adequado + vl_difer_adeq_w 
			where	nr_titulo	= nr_titulo_w 
			and	nr_sequencia	= nr_sequencia_w;
 
			vl_difer_adeq_w	:= 0;
		end if;
 
 
		CALL atualizar_saldo_tit_rec(nr_titulo_w,nm_usuario_p);
 
		nr_titulo_ant_w := nr_titulo_w;
	end loop;
	close c01;
 
	 
end if;
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_tit_rec_liq_convret (nr_seq_retorno_p bigint, nr_seq_protocolo_p bigint, nr_interno_conta_p bigint, vl_pago_guia_p bigint, vl_adicional_guia_p bigint, vl_glosado_guia_p bigint, vl_adequado_guia_p bigint, vl_desconto_guia_p bigint, vl_perdas_guia_p bigint, nm_usuario_p text) FROM PUBLIC;
