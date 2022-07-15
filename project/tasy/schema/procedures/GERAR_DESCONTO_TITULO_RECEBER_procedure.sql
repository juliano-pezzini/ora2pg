-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_desconto_titulo_receber (nr_seq_protocolo_p bigint, nr_interno_conta_p bigint, nr_seq_lote_prot_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
/* 
Procedure criada para gerar o desconto nos títulos do protocolo ou conta, com base no valor de descontro gerado na Nota Fiscal. 
Irá funcionar apenas se a NF for gerada antes do título a receber. 
Procedure chamada no FatAct_E1 e gerar_nf_lote_protocolo 
*/
 
 
vl_saldo_total_w	double precision;
vl_saldo_titulo_w	double precision;
nr_titulo_w		bigint;
vl_desconto_w		double precision;
vl_desconto_total_w	double precision;
nr_sequencia_w		bigint;
cd_estabelecimento_w	bigint;
cd_tipo_recebimento_w	integer;
nr_seq_trans_fin_desc_w	bigint;

c01 CURSOR FOR 
SELECT	nr_titulo, 
	vl_saldo_titulo 
from	titulo_receber 
where	nr_seq_protocolo	= nr_seq_protocolo_p 
and	nr_seq_protocolo_p	> 0 
and	coalesce(nr_seq_lote_prot_p,0) = 0 
and	ie_situacao		= '1' 

union
 
SELECT	nr_titulo, 
	vl_saldo_titulo 
from	titulo_receber 
where	nr_interno_conta	= nr_interno_conta_p 
and	nr_interno_conta_p	> 0 
and	ie_situacao		= '1' 

union
 
select	nr_titulo, 
	vl_saldo_titulo 
from	titulo_receber 
where	nr_seq_lote_prot	= nr_seq_lote_prot_p 
and	nr_seq_lote_prot_p	> 0 
and	ie_situacao		= '1' 

union
 
select	a.nr_titulo, 
	a.vl_saldo_titulo 
from	titulo_receber a, 
	protocolo_convenio b 
where	a.nr_seq_protocolo	= b.nr_seq_protocolo 
and	b.nr_seq_lote_protocolo	= nr_seq_lote_prot_p 
and	a.ie_situacao		= '1' 
and	nr_seq_lote_prot_p	> 0;


BEGIN 
 
if (nr_interno_conta_p > 0) then 
 
	select	max(cd_estabelecimento) 
	into STRICT	cd_estabelecimento_w 
	from	conta_paciente 
	where	nr_interno_conta	= nr_interno_conta_p;
 
	select	coalesce(sum(vl_saldo_titulo),0) /*Total de saldo dos títulos da conta*/
 
	into STRICT	vl_saldo_total_w 
	from	titulo_receber 
	where	nr_interno_conta	= nr_interno_conta_p 
	and	nr_interno_conta_p	> 0 
	and	ie_situacao		= '1';
 
	select	coalesce(sum(vl_descontos),0) /*Total de desconto das NFs da conta*/
 
	into STRICT	vl_desconto_total_w 
	from	nota_fiscal 
	where	nr_interno_conta	= nr_interno_conta_p 
	and	nr_interno_conta_p	> 0;
 
elsif (nr_seq_protocolo_p > 0) and (coalesce(nr_seq_lote_prot_p,0) = 0) then 
 
	select	max(cd_estabelecimento) 
	into STRICT	cd_estabelecimento_w 
	from	protocolo_convenio 
	where	nr_seq_protocolo	= nr_seq_protocolo_p;
 
	select	coalesce(sum(vl_saldo_titulo),0) /*Total de saldo dos títulos do protocolo*/
 
	into STRICT	vl_saldo_total_w 
	from	titulo_receber 
	where	nr_seq_protocolo	= nr_seq_protocolo_p 
	and	nr_seq_protocolo_p	> 0 
	and	ie_situacao		= '1';
 
	select	coalesce(sum(vl_descontos),0) /*Total de desconto das NFs do protocolo*/
 
	into STRICT	vl_desconto_total_w 
	from	nota_fiscal 
	where	nr_seq_protocolo	= nr_seq_protocolo_p 
	and	nr_seq_protocolo_p	> 0;
 
elsif (nr_seq_lote_prot_p > 0) then 
 
	select	max(cd_estabelecimento) 
	into STRICT	cd_estabelecimento_w 
	from	protocolo_convenio 
	where	nr_seq_lote_protocolo	= nr_seq_lote_prot_p;
 
	select	sum(x.vl_saldo_titulo) 
	into STRICT	vl_saldo_total_w 
	from (SELECT	coalesce(sum(vl_saldo_titulo),0) vl_saldo_titulo /*Total de saldo dos títulos do lote de protocolo*/
 
		from	titulo_receber 
		where	nr_seq_lote_prot	= nr_seq_lote_prot_p 
		and	nr_seq_lote_prot_p	> 0 
		and	ie_situacao		= '1' 
		
union
 
		SELECT	coalesce(sum(vl_saldo_titulo),0) vl_saldo_titulo /*Total de saldo dos títulos de cada protocolo do lote*/
 
		from	titulo_receber a, 
			protocolo_convenio b 
		where	a.nr_seq_protocolo	= b.nr_seq_protocolo 
		and	b.nr_seq_lote_protocolo	= nr_seq_lote_prot_p 
		and	a.ie_situacao		= '1' 
		and	nr_seq_lote_prot_p	> 0) x;
 
 
	select	coalesce(sum(vl_descontos),0) /*Total de desconto das NFs do protocolo*/
 
	into STRICT	vl_desconto_total_w 
	from	nota_fiscal 
	where	nr_seq_lote_prot	= nr_seq_lote_prot_p 
	and	nr_seq_lote_prot_p	> 0;
 
end if;
 
select	max(cd_tipo_receb_desc_tit), 
	max(nr_seq_trans_fin_desc) 
into STRICT	cd_tipo_recebimento_w, 
	nr_seq_trans_fin_desc_w 
from	parametro_contas_receber 
where	cd_estabelecimento	= cd_estabelecimento_w;
 
if (cd_tipo_recebimento_w IS NOT NULL AND cd_tipo_recebimento_w::text <> '') and (vl_desconto_total_w > 0) then 
 
	open C01;
	loop 
	fetch C01 into 
		nr_titulo_w, 
		vl_saldo_titulo_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
 
		/*Ratear o desconto para os títulos do protocolo ou conta*/
 
		vl_desconto_w	:= dividir_sem_round(vl_saldo_titulo_w,vl_saldo_total_w) * vl_desconto_total_w;
 
		if (vl_desconto_w > 0) then 
 
			select	coalesce(max(nr_sequencia),0) + 1 
			into STRICT	nr_sequencia_w 
			from	titulo_receber_liq 
			where	nr_titulo	= nr_titulo_w;
 
			insert into titulo_receber_liq(cd_tipo_recebimento, 
				cd_moeda, 
				ds_observacao, 
				dt_atualizacao, 
				dt_recebimento, 
				ie_acao, 
				ie_lib_caixa, 
				nm_usuario, 
				nr_sequencia, 
				nr_titulo, 
				vl_descontos, 
				vl_glosa, 
				vl_juros, 
				vl_multa, 
				vl_recebido, 
				vl_rec_maior, 
				nr_seq_trans_fin) 
			values (cd_tipo_recebimento_w, 
				1, 
				Wheb_mensagem_pck.get_Texto(305944), /*'Baixa gerada com base no valor de desconto da nota fiscal da conta/protocolo/lote protocolo',*/
 
				clock_timestamp(), 
				clock_timestamp(), 
				'I', 
				'S', 
				nm_usuario_p, 
				nr_sequencia_w, 
				nr_titulo_w, 
				vl_desconto_w, 
				0, 
				0, 
				0, 
				0, 
				0, 
				nr_seq_trans_fin_desc_w);
 
			CALL atualizar_saldo_tit_rec(nr_titulo_w,nm_usuario_p);
		end if;
 
		end;
	end loop;
	close C01;
 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_desconto_titulo_receber (nr_seq_protocolo_p bigint, nr_interno_conta_p bigint, nr_seq_lote_prot_p bigint, nm_usuario_p text) FROM PUBLIC;

