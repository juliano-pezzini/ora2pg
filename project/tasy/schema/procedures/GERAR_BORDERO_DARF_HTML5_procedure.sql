-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_bordero_darf_html5 ( nr_seq_darf_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, cd_darf_p text, dt_vencimento_p timestamp) AS $body$
DECLARE


qt_registro_w				bigint;
nr_bordero_w				bigint;
nr_titulo_w				bigint;
ie_selec_tit_outro_bordero_w		varchar(1);
vl_titulo_w				double precision;
qt_cancelado_w				bigint;
vl_juros_bordero_w			double precision;
vl_multa_bordero_w			double precision;
vl_percomp_w				darf_perdcomp.vl_perdcomp%type;
vl_juros_total_w			double precision := 0;
vl_multa_total_w			double precision := 0;
vl_desconto_total_w			double precision := 0;
vl_soma_titulo_w			double precision := 0;
nr_ult_titulo_w				bigint := 0;
nr_ult_bordero_w			bigint := 0;
ds_retorno_w                varchar(1000);

c01 CURSOR FOR
  SELECT    a.nr_titulo
	from	    darf_titulo_pagar a,
            titulo_pagar c
  left join classe_titulo_pagar b on c.nr_seq_classe = b.nr_sequencia
	where	 a.nr_titulo                    = c.nr_titulo
  and    coalesce(b.ie_permite_bordero, 'S') = 'S'
  and    nr_seq_darf	                  = nr_seq_darf_p;


BEGIN

/*total dos Titulos*/

select	coalesce(sum(a.vl_titulo),0)
into STRICT	vl_soma_titulo_w
from 	titulo_pagar a,
	darf_titulo_pagar b	
where	a.nr_titulo = b.nr_titulo
and	b.nr_seq_darf	= nr_seq_darf_p;

/*Recebe os valores informados na DARF*/

select	coalesce(max(a.vl_juros),0),
	coalesce(max(a.vl_multa),0)
into STRICT	vl_juros_bordero_w,
	vl_multa_bordero_w
from 	darf a
where	a.nr_sequencia	= nr_seq_darf_p;

select	coalesce(sum(a.vl_perdcomp),0)
into STRICT	vl_percomp_w
from	darf_perdcomp a
where 	a.nr_seq_darf = nr_seq_darf_p;

-- Verificar se a DARF ja foi inserida em algum outro bordero
select	coalesce(max(nr_bordero),0)
into STRICT	nr_bordero_w
from	darf
where	nr_sequencia	= nr_seq_darf_p;

if (nr_bordero_w <> 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(212257);
end if;


-- Buscar o numero do bordero a ser criado
select 	nextval('bordero_pagamento_seq')
into STRICT	nr_bordero_w
;

select 	count(1)
into STRICT 	qt_cancelado_w
from 	titulo_pagar a,
	darf_titulo_pagar	b,
	darf			c
where	a.nr_titulo 	= b.nr_titulo
and 	b.nr_seq_darf 	= c.nr_sequencia
and 	a.ie_situacao 	= 'C'
and 	c.nr_sequencia 	= nr_seq_darf_p  LIMIT 1;

if (qt_cancelado_w > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(290461);
end if;

	-- inserir na tabela do bordero
	insert into bordero_pagamento(nr_bordero,
		dt_prev_pagamento,
		dt_atualizacao,
		nm_usuario,
		dt_real_pagamento,
		cd_banco,
		cd_agencia_bancaria,
		nr_cheque,
		ds_bordero,
		nr_seq_conta_banco,
		nr_seq_trans_financ,
		nr_documento,
		dt_cancelamento,
		cd_estabelecimento,
		cd_tipo_baixa,
		ds_observacao,
		ie_titulo_bordero,
		dt_inicio_bordero,
		dt_final_bordero,
		dt_liberacao,
		nm_usuario_lib,
		qt_min_usuario_lib,
        ie_bordero_banco)
	values (nr_bordero_w,
		dt_vencimento_p,
		clock_timestamp(),
		'Tasy',
		null,
		null,
		null,
		null,
		'DARF ' || cd_darf_p || ' - ' || dt_vencimento_p,
		null,
		null,
		null,
		null,
		cd_estabelecimento_p,
		null,
		null,
		'S',
		null,
		null,
		null,
		null,
		null,
        'P');

if vl_percomp_w > 0 then

		open c01;
		loop
		fetch c01 into	
			nr_titulo_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin
			
			nr_ult_titulo_w := nr_titulo_w;	
			nr_ult_bordero_w := nr_bordero_w;
			
			select obter_dados_tit_pagar(nr_titulo_w,'V')
			into STRICT vl_titulo_w
			;

            ds_retorno_w := obter_se_inclui_tit_bordero(nr_bordero_w, nr_titulo_w, nm_usuario_p);

            if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
                CALL wheb_mensagem_pck.exibir_mensagem_abort(ds_retorno_w);
            else
			
			-- inserir na tabela de titulos a pagar do bordero
			insert into bordero_tit_pagar(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_bordero,
				nr_titulo,
				vl_bordero,
				vl_juros_bordero,
				vl_desconto_bordero,
				vl_out_desp_bordero,
				vl_multa_bordero,
				cd_centro_custo,
				vl_outras_deducoes)
			values (nextval('bordero_tit_pagar_seq'),
				clock_timestamp(),
				'Tasy',
				clock_timestamp(),
				'Tasy',
				nr_bordero_w,
				nr_titulo_w,
				vl_titulo_w,
				(vl_titulo_w * vl_juros_bordero_w / vl_soma_titulo_w),
				(vl_titulo_w * vl_percomp_w / vl_soma_titulo_w),
				0,
				(vl_titulo_w * vl_multa_bordero_w / vl_soma_titulo_w),
				null,
				0);			
			
			vl_desconto_total_w	:= vl_desconto_total_w + (vl_titulo_w * vl_percomp_w / vl_soma_titulo_w);
			vl_juros_total_w 	:= vl_juros_total_w + (vl_titulo_w * vl_juros_bordero_w / vl_soma_titulo_w);
			vl_multa_total_w 	:= vl_multa_total_w + (vl_titulo_w * vl_multa_bordero_w / vl_soma_titulo_w);
            end if;
			end;
		end loop;
		close c01;
		if (nr_ult_titulo_w <> 0) then					
			update	bordero_tit_pagar
			set	vl_juros_bordero	= vl_juros_bordero + vl_juros_bordero_w - vl_juros_total_w,
				vl_multa_bordero	= vl_multa_bordero + vl_multa_bordero_w - vl_multa_total_w,
				vl_desconto_bordero	= vl_desconto_bordero + vl_percomp_w - vl_desconto_total_w
			where	nr_titulo		= nr_ult_titulo_w
			and 	nr_bordero		= nr_ult_bordero_w;	
		end if;
else

		open c01;
		loop
		fetch c01 into	
			nr_titulo_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin
			
			nr_ult_titulo_w := nr_titulo_w;	
			nr_ult_bordero_w := nr_bordero_w;
			
			select obter_dados_tit_pagar(nr_titulo_w,'V')
			into STRICT vl_titulo_w
			;
			
			/*select	sum(nvl(vl_saldo_juros,0)),
				sum(nvl(vl_saldo_multa,0))
			into	vl_juros_bordero_w,
				vl_multa_bordero_w
			from	titulo_pagar p
			where	nr_titulo = nr_titulo_w;*/
			
			vl_percomp_w := 0;
            ds_retorno_w := obter_se_inclui_tit_bordero(nr_bordero_w, nr_titulo_w, nm_usuario_p);

            if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
                CALL wheb_mensagem_pck.exibir_mensagem_abort(ds_retorno_w);
            else

			-- inserir na tabela de titulos a pagar do bordero
			insert into bordero_tit_pagar(nr_sequencia, 
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_bordero,
				nr_titulo,
				vl_bordero,
				vl_juros_bordero,
				vl_desconto_bordero,
				vl_out_desp_bordero,
				vl_multa_bordero,
				cd_centro_custo,
				vl_outras_deducoes)
			values (nextval('bordero_tit_pagar_seq'),
				clock_timestamp(),
				'Tasy',
				clock_timestamp(),
				'Tasy',
				nr_bordero_w,
				nr_titulo_w,
				vl_titulo_w,
				vl_juros_bordero_w,
				vl_percomp_w,
				0,
				vl_multa_bordero_w,
				null,
				0);			
			
			vl_desconto_total_w	:= vl_desconto_total_w + vl_percomp_w;
			vl_juros_total_w 	:= vl_juros_total_w + vl_juros_bordero_w;
			vl_multa_total_w 	:= vl_multa_total_w + vl_multa_bordero_w;
            end if;
			end;
		end loop;
		close c01;
		
		if (nr_ult_titulo_w <> 0) then					
			update	bordero_tit_pagar
			set	vl_juros_bordero	= vl_juros_bordero + vl_juros_bordero_w - vl_juros_total_w,
				vl_multa_bordero	= vl_multa_bordero + vl_multa_bordero_w - vl_multa_total_w,
				vl_desconto_bordero	= vl_desconto_bordero + vl_percomp_w - vl_desconto_total_w
			where	nr_titulo		= nr_ult_titulo_w
			and 	nr_bordero		= nr_ult_bordero_w;	
		end if;
		
end if;
	
-- Gravar na DARF o numero do bordero
update	darf
set	nr_bordero	= nr_bordero_w
where	nr_sequencia	= nr_seq_darf_p;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_bordero_darf_html5 ( nr_seq_darf_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, cd_darf_p text, dt_vencimento_p timestamp) FROM PUBLIC;
