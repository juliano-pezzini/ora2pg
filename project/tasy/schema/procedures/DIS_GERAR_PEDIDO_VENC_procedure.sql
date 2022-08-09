-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE dis_gerar_pedido_venc ( nr_pedido_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
cd_condicao_pagamento_w	bigint;
cd_estabelecimento_w	smallint;
dt_prevista_entrega_w		timestamp;
dt_geracao_w			timestamp;
dt_pedido_w				timestamp;
qt_vencimentos_w		integer;
ds_vencimentos_w		varchar(2000);
dt_vencimento_w		timestamp;
nr_vencimento_w		integer;
vl_vencimento_w		double precision	:= 0;
vl_total_pedido_w		double precision;
tx_fracao_parcela_w	double precision;
qt_venc_w		integer;
ie_forma_pagamento_w	smallint;
vl_mercadoria_w		double precision;
vl_base_venc_w		double precision;
vl_desconto_w		double precision;
vl_desconto_venc_w	double precision;
vl_desc_financ_w		double precision;
vl_desc_fin_venc_w	double precision;
vl_total_vencimento_w	double precision;
dt_ultimo_vencimento_w	timestamp;
vl_total_pedido_ww		double precision;
vl_diferenca_w		double precision;
ie_data_base_venc_ordem_w	varchar(1);
qt_registro_w			smallint;

C01 CURSOR FOR 
SELECT	tx_fracao_parcela 
from	parcela 
where	cd_condicao_pagamento = cd_condicao_pagamento_w;


BEGIN 
CALL dis_atualizar_valores_pedido(nr_pedido_p, nm_usuario_p);
 
select	cd_estabelecimento, 
	cd_cond_pagto, 
	vl_total_pedido, 
	dt_entrega, 
	dt_pedido 
into STRICT	cd_estabelecimento_w, 
	cd_condicao_pagamento_w, 
	vl_total_pedido_w, 
	dt_prevista_entrega_w, 
	dt_pedido_w 
from	dis_pedido 
where	nr_sequencia = nr_pedido_p;
 
select	ie_forma_pagamento 
into STRICT	ie_forma_pagamento_w 
from	condicao_pagamento 
where	cd_condicao_pagamento	= cd_condicao_pagamento_w;
 
if (ie_forma_pagamento_w = 10) then 
	begin 
	/*se for condição de pagamento com tipo (conforme vencimentos)*/
 
	select	count(*) 
	into STRICT	qt_registro_w 
	from	dis_pedido_venc 
	where	nr_seq_pedido	= nr_pedido_p;
	 
	if (qt_registro_w > 0) then 
		begin 
		select	coalesce(sum(vl_vencimento),0) 
		into STRICT	vl_vencimento_w 
		from	dis_pedido_venc 
		where	nr_seq_pedido	= nr_pedido_p;
 
		select	round((coalesce(sum(vl_total_pedido),0))::numeric,2) 
		into STRICT	vl_total_pedido_w 
		from	dis_pedido 
		where	nr_sequencia = nr_pedido_p;
 
		update	dis_pedido_venc 
		set	vl_vencimento 		= vl_vencimento + dividir((vl_total_pedido_w - vl_vencimento_w), qt_registro_w) 
		where	nr_seq_pedido	= nr_pedido_p;
		end;
	end if;
	end;
else 
	begin 
	delete	from dis_pedido_venc 
	where	nr_seq_pedido = nr_pedido_p;
	 
	select	coalesce(max(ie_data_base_venc_ordem),'E') 
	into STRICT	ie_data_base_venc_ordem_w 
	from	parametro_compras 
	where	cd_estabelecimento = cd_estabelecimento_w;
 
	dt_geracao_w	:= dt_prevista_entrega_w;
	if (ie_data_base_venc_ordem_w = 'A') then 
		 dt_geracao_w	:= clock_timestamp();
	elsif (ie_data_base_venc_ordem_w = 'O') then 
		 dt_geracao_w	:= dt_pedido_w;
	end if;
		 
	if (ie_forma_pagamento_w = 1) then	/* Se for a vista*/
 
		begin 
		insert into dis_pedido_venc( 
					nr_seq_pedido, 
					nr_sequencia, 
					dt_vencimento, 
					vl_vencimento, 
					dt_atualizacao, 
					nm_usuario) 
				values (nr_pedido_p, 
					nextval('dis_pedido_venc_seq'), 
					dt_geracao_w, 
					vl_vencimento_w, 
					clock_timestamp(), 
					nm_usuario_p);
		end;
	else 
		begin 
		SELECT * FROM Calcular_Vencimento( 
			cd_estabelecimento_w, cd_condicao_pagamento_w, dt_geracao_w, qt_vencimentos_w, ds_vencimentos_w) INTO STRICT qt_vencimentos_w, ds_vencimentos_w;	
		OPEN C01;
		LOOP 
		FETCH C01 INTO 
			tx_fracao_parcela_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin 
			 
			dt_vencimento_w		:= To_Date(substr(ds_vencimentos_w,1,10),'dd/mm/yyyy');
			ds_vencimentos_w	:= substr(ds_vencimentos_w,12, length(ds_vencimentos_w));		
			vl_vencimento_w		:= dividir((vl_total_pedido_w * tx_fracao_parcela_w),100);
			 
			insert into dis_pedido_venc( 
					nr_seq_pedido, 
					nr_sequencia, 
					dt_vencimento, 
					vl_vencimento, 
					dt_atualizacao, 
					nm_usuario) 
				values (nr_pedido_p, 
					nextval('dis_pedido_venc_seq'), 
					dt_vencimento_w, 
					vl_vencimento_w, 
					clock_timestamp(), 
					nm_usuario_p);
			commit;
			end;
		END LOOP;
		close c01;
		end;
	end if;
	/*Tratamento abaixo para jogar a diferença para o último vencimento*/
 
	select	coalesce(sum(vl_vencimento),0), 
		max(dt_vencimento) 
	into STRICT	vl_total_vencimento_w, 
		dt_ultimo_vencimento_w 
	from	dis_pedido_venc 
	where	nr_seq_pedido = nr_pedido_p;
	 
	select	vl_total_pedido 
	into STRICT	vl_total_pedido_ww 
	from	dis_pedido 
	where	nr_sequencia = nr_pedido_p;
	 
	if (vl_total_vencimento_w <> vl_total_pedido_ww) then 
		begin 
		vl_diferenca_w := vl_total_vencimento_w - vl_total_pedido_ww;
		 
		update	dis_pedido_venc 
		set	vl_vencimento	= vl_vencimento - vl_diferenca_w 
		where	nr_seq_pedido = nr_pedido_p 
		and	dt_vencimento	= dt_ultimo_vencimento_w;
		end;
	end if;
	end;
end if;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dis_gerar_pedido_venc ( nr_pedido_p bigint, nm_usuario_p text) FROM PUBLIC;
