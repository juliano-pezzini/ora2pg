-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_saldo_tit_pagar_trib (nr_titulo_p bigint, nm_usuario_p text) AS $body$
DECLARE



vl_titulo_w			double precision;
vl_imposto_w		double precision;
nr_sequencia_w		bigint;
nr_seq_tit_baixa_w	bigint;
vl_baixa_w			double precision;
vl_pagamento_w		double precision;
vl_tit_baixa_trib_w		double precision;
nr_seq_tit_pagar_trib_w	bigint;
nr_seq_trans_financ_w	titulo_pagar_imposto.nr_seq_trans_baixa%type;	
vl_baixa_consistencia_w		titulo_pagar_baixa.vl_baixa%type;
vl_saldo_multa_w		titulo_pagar.vl_saldo_multa%type;
vl_multa_w			titulo_pagar_baixa.vl_multa%type;
vl_saldo_juros_w		titulo_pagar.vl_saldo_juros%type;
vl_juros_w			titulo_pagar_baixa.vl_juros%type;
vl_saldo_titulo_w		titulo_pagar.vl_saldo_titulo%type;
dt_baixa_w			titulo_pagar_baixa.dt_baixa%type;			
vl_outras_despesas_w		titulo_pagar.vl_outras_despesas%type;
vl_outros_acrescimos_w		titulo_pagar.vl_outros_acrescimos%type;
ds_erro_w			varchar(4000);


c01 CURSOR FOR
SELECT	a.vl_imposto,
	a.nr_sequencia,
	a.nr_seq_trans_baixa
from	tributo b,
	titulo_pagar_imposto a
where	a.nr_titulo	= nr_titulo_p
and		a.cd_tributo = b.cd_tributo;

c02 CURSOR FOR
SELECT	a.vl_baixa,
	a.nr_sequencia
from	titulo_pagar_baixa a
where	a.nr_titulo	= nr_titulo_p
and	not exists (select	1
		 from	titulo_pagar_trib_baixa x
		 where	x.nr_titulo = a.nr_titulo
		 and	x.nr_seq_tit_baixa = a.nr_sequencia
		 and	x.nr_seq_tit_trib = nr_sequencia_w);

c03 CURSOR FOR
SELECT  a.nr_sequencia,
        a.dt_baixa,
        a.nr_seq_trans_fin,
        obter_vl_iva_ret(0,nr_titulo_p,a.nr_sequencia) vl_transacao,
        b.cd_estabelecimento
from    titulo_pagar_baixa a,
        titulo_pagar b
where   a.nr_titulo = nr_titulo_p
and     a.nr_titulo = b.nr_titulo
and     obter_vl_iva_ret(0,nr_titulo_p,a.nr_sequencia) <> 0
and not exists (
    SELECT 	1
    from   	ctb_documento c
    where  	c.nr_documento = a.nr_titulo
    and    	c.nr_seq_doc_compl = a.nr_sequencia
    and    	c.vl_movimento = obter_vl_iva_ret(0, nr_titulo_p, a.nr_sequencia)
    and    	c.nm_atributo = 'VL_IVA_LIQ'

union all

    select 	1 /* Adicionado esse select para verificar baixas de titulos que foram realizadas na contabilidade offiline e nao geraram documentos - MARCELO 21/12/21 - Cliente HSJ*/
    from 	movimento_contabil_doc m
    where 	m.nr_documento = a.nr_titulo
    and 	m.nr_seq_doc_compl = a.nr_sequencia
    and 	m.nm_atributo = 'VL_IVA_LIQ'
    );

c03_w c03%rowtype;


BEGIN

if (coalesce(philips_param_pck.get_cd_pais,1) = 2) then --MX
	select	vl_titulo
	into STRICT	vl_titulo_w
	from	titulo_pagar
	where	nr_titulo	= nr_titulo_p;

	open c01;
	loop
	fetch c01 into
		vl_imposto_w,
		nr_sequencia_w,
		nr_seq_trans_financ_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

		open c02;
		loop
		fetch c02 into
			vl_pagamento_w,
			nr_seq_tit_baixa_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */

			vl_baixa_w := round(((((vl_pagamento_w * 100) / vl_titulo_w) * vl_imposto_w) / 100), 2);
			
			select	nextval('titulo_pagar_trib_baixa_seq')
			into STRICT	nr_seq_tit_pagar_trib_w
			;		
			
			insert into titulo_pagar_trib_baixa(nr_sequencia,
					vl_baixa, 
					dt_atualizacao, 
					nm_usuario, 
					nr_seq_tit_trib, 
					nr_titulo,
					nr_seq_tit_baixa,
					nr_seq_trans_financ)
			values (nr_seq_tit_pagar_trib_w, 
					vl_baixa_w, 
					clock_timestamp(),
					nm_usuario_p, 
					nr_sequencia_w, 
					nr_titulo_p,
					nr_seq_tit_baixa_w,
					nr_seq_trans_financ_w);
			
			CALL atualiza_tributo_baixa_mx(nr_titulo_p,nr_seq_tit_baixa_w,nm_usuario_p);
			
		end loop;
		close c02;

		/*Mesma procedure utilizada na Atualizar_Saldo_Tit_Pagar, que verifica e define o saldo do titulo. 
		Precisamos saber o saldo do titulo aqui, se for 0, vamos veriifcar se a soma das baixas de tributos existentes  se equivale com o valor do imposto no titulo*/
		SELECT * FROM consistir_tit_pagar_baixa(	nr_titulo_p, vl_baixa_consistencia_w, vl_saldo_multa_w, vl_multa_w, vl_saldo_juros_w, vl_juros_w, vl_saldo_titulo_w, dt_baixa_w, vl_outras_despesas_w, vl_outros_acrescimos_w, ds_erro_w ) INTO STRICT vl_baixa_consistencia_w, vl_saldo_multa_w, vl_multa_w, vl_saldo_juros_w, vl_juros_w, vl_saldo_titulo_w, dt_baixa_w, vl_outras_despesas_w, vl_outros_acrescimos_w, ds_erro_w;
		
		/*Se o saldo for 0, significa que o titulo sera liquidado, entao temos que verificar o arredondamento desta ultima baixa*/

		if (vl_saldo_titulo_w = 0) then
			select	sum(vl_baixa)
			into STRICT	vl_tit_baixa_trib_w
			from 	titulo_pagar_trib_baixa
			where 	nr_seq_tit_trib = nr_sequencia_w;

			if (coalesce(vl_tit_baixa_trib_w,0) <> 0) and (coalesce(vl_imposto_w,0) <> coalesce(vl_tit_baixa_trib_w,0)) then

				if (coalesce(vl_imposto_w,0) > coalesce(vl_tit_baixa_trib_w,0)) then
					
					update	titulo_pagar_trib_baixa
					set	vl_baixa	= coalesce(vl_baixa,0) + coalesce(vl_imposto_w,0) - coalesce(vl_tit_baixa_trib_w,0)
					where nr_sequencia = nr_seq_tit_pagar_trib_w;

					
				elsif (coalesce(vl_tit_baixa_trib_w,0) > coalesce(vl_imposto_w,0)) then

					update	titulo_pagar_trib_baixa
					set	vl_baixa	= coalesce(vl_baixa,0) - (coalesce(vl_tit_baixa_trib_w,0) - coalesce(vl_imposto_w,0))
					where nr_sequencia = nr_seq_tit_pagar_trib_w;


				end if;
			end if;
		end if;

	end loop;
	close c01;
end if;

open c03;
loop
fetch c03 into
    c03_w;
EXIT WHEN NOT FOUND; /* apply on c03 */

    CALL ctb_concil_financeira_pck.ctb_gravar_documento( c03_w.cd_estabelecimento,
                                                    c03_w.dt_baixa,
                                                    7,
                                                    c03_w.nr_seq_trans_fin,
                                                    13,
                                                    nr_titulo_p,
                                                    c03_w.nr_sequencia,
                                                    null,
                                                    c03_w.vl_transacao,
                                                    'TITULO_PAGAR_BAIXA',
                                                    'VL_IVA_LIQ',
                                                    nm_usuario_p);
end loop;
close c03;

update  ctb_documento a
set     ie_situacao_ctb = 'P'
where   a.cd_tipo_lote_contabil = 7
and     a.nm_atributo = 'VL_IMPOSTO_BAIXA'
and     a.nr_documento = nr_titulo_p
and     ie_situacao_ctb = 'N'
and not exists (SELECT 1
         from   titulo_pagar_trib_baixa x
         where  x.nr_titulo = a.nr_documento
         and    x.nr_seq_tit_baixa = a.nr_seq_doc_compl
         and    x.nr_sequencia = a.nr_doc_analitico
        );

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_saldo_tit_pagar_trib (nr_titulo_p bigint, nm_usuario_p text) FROM PUBLIC;

