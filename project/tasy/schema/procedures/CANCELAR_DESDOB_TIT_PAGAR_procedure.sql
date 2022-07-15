-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cancelar_desdob_tit_pagar (nr_titulo_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
cont_w			integer	:= 0;
nr_lote_contabil_w	bigint	:= 0;
nr_titulo_w		bigint;
nr_seq_alt_valor_w	integer;
cd_moeda_w		bigint;
vl_saldo_titulo_w	double precision;
ie_situacao_w		varchar(1);
vl_alteracao_w		double precision;
vl_anterior_w		double precision;

c01 CURSOR FOR 
SELECT	b.nr_titulo_dest 
from	titulo_pagar_desdob b, 
	titulo_pagar a 
where	a.nr_titulo	= b.nr_titulo 
and	b.nr_titulo	= nr_titulo_p 
and	(b.nr_titulo_dest IS NOT NULL AND b.nr_titulo_dest::text <> '') 
order by nr_titulo_dest;


BEGIN 
 
select	ie_situacao, 
	coalesce(nr_lote_contabil,0), 
	cd_moeda, 
	vl_titulo 
into STRICT	ie_situacao_w, 
	nr_lote_contabil_w, 
	cd_moeda_w, 
	vl_saldo_titulo_w 
from	titulo_pagar 
where	nr_titulo	= nr_titulo_p;
 
if (ie_situacao_w = 'D') and (nr_lote_contabil_w = 0) then 
	Open c01;
	loop 
	fetch c01 into 
		nr_titulo_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		CALL cancelar_titulo_pagar(nr_titulo_w, 
					nm_usuario_p, 
					clock_timestamp());
 
		delete	from titulo_pagar_desdob 
		where	nr_titulo_dest = nr_titulo_w;
	end loop;
	close c01;
 
	update	titulo_pagar 
	set	ds_observacao_titulo	 = NULL 
	where	nr_titulo		= nr_titulo_p;
 
	/* Obter a última alteração de valor para estornar */
 
	select	coalesce(max(nr_sequencia),0) 
	into STRICT	nr_seq_alt_valor_w 
	from	titulo_pagar_alt_valor 
	where	nr_titulo	= nr_titulo_p;
 
	/* Obter o valor da última alteração */
 
	select	coalesce(max(vl_alteracao),vl_saldo_titulo_w), 
		coalesce(max(vl_anterior),vl_saldo_titulo_w) 
	into STRICT	vl_alteracao_w, 
		vl_anterior_w 
	from	titulo_pagar_alt_valor 
	where	nr_titulo	= nr_titulo_p 
	and	nr_sequencia	= nr_seq_alt_valor_w;
 
	/* Obter a sequencia para a nova alteracao */
 
	select	coalesce(max(nr_sequencia),0)+1 
	into STRICT	nr_seq_alt_valor_w 
	from	titulo_pagar_alt_valor 
	where	nr_titulo	= nr_titulo_p;
 
	insert	into titulo_pagar_alt_valor(cd_moeda, 
		ds_observacao, 
		dt_alteracao, 
		dt_atualizacao, 
		nm_usuario, 
		nr_sequencia, 
		nr_titulo, 
		vl_alteracao, 
		vl_anterior, 
		nr_lote_contabil) 
	values (cd_moeda_w, 
		--'Alteração de valor lançada devido ao estorno do desdobramento do título.', 
		wheb_mensagem_pck.get_texto(303054), 
		clock_timestamp(), 
		clock_timestamp(), 
		nm_usuario_p, 
		nr_seq_alt_valor_w, 
		nr_titulo_p, 
		vl_anterior_w, 
		vl_alteracao_w, 
		0);
 
	CALL atualizar_saldo_tit_pagar(nr_titulo_p,nm_usuario_p);
	CALL Gerar_W_Tit_Pag_imposto(nr_titulo_p,nm_usuario_p);
else 
	--r.aise_application_error(-20011,'O título já possui lote contábil!'); 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(267407);
end if;
	 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cancelar_desdob_tit_pagar (nr_titulo_p bigint, nm_usuario_p text) FROM PUBLIC;

