-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_vincular_tit_nota_lote ( nr_seq_lote_p bigint, cd_serie_nf_p text, cd_operacao_nf_p bigint, dt_emissao_p timestamp, cd_natureza_operacao_p bigint, ds_observacao_p text, ds_complemento_p text, dt_base_venc_p timestamp, nr_nota_fiscal_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
nr_titulo_w			bigint;
nr_seq_nota_fiscal_w		bigint;
ds_consistencia_w		varchar(255);
nr_nota_fiscal_w		varchar(10);
dt_emissao_w			timestamp;
nr_titulo_trib_w		bigint;
dt_vencimento_w			timestamp;

C01 CURSOR FOR 
	SELECT	b.nr_titulo 
	from	titulo_pagar b, 
		pls_lote_protocolo a 
	where	a.nr_sequencia		= b.nr_seq_lote_res_pls 
	and	b.ie_tipo_titulo	<> '4' 
	and	a.nr_sequencia		= nr_seq_lote_p 
	and	b.ie_situacao		= 'A';

C02 CURSOR FOR 
	SELECT	b.nr_titulo 
	from	titulo_pagar_imposto a, 
		titulo_pagar b 
	where	a.nr_sequencia	= b.nr_seq_tributo 
	and	a.nr_titulo	= nr_titulo_w;

BEGIN
 
select	max(nr_sequencia) 
into STRICT	nr_seq_nota_fiscal_w 
from	nota_fiscal 
where	nr_seq_prot_res_pls = nr_seq_lote_p;
 
if (coalesce(nr_seq_nota_fiscal_w,0) > 0) then 
	--'Já existe nota fiscal gerada para este lote.#@#@'); 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(203716);
end if;
 
update	pls_lote_protocolo 
set	nr_nota_fiscal	= nr_nota_fiscal_p 
where	nr_sequencia	= nr_seq_lote_p;
 
select	nr_nota_fiscal 
into STRICT	nr_nota_fiscal_w 
from	pls_lote_protocolo 
where	nr_sequencia = nr_seq_lote_p;
 
CALL pls_gerar_notas_lote(	nr_seq_lote_p, 
			cd_serie_nf_p, 
			cd_operacao_nf_p, 
			dt_emissao_p, 
			cd_natureza_operacao_p, 
			ds_observacao_p, 
			ds_complemento_p, 
			dt_base_venc_p, 
			null, 
			nm_usuario_p, 
			'S', 
			cd_estabelecimento_p);
 
select	max(nr_sequencia) 
into STRICT	nr_seq_nota_fiscal_w 
from	nota_fiscal 
where	nr_seq_lote_res_pls = nr_seq_lote_p;
 
if (coalesce(nr_seq_nota_fiscal_w,0) = 0) then 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(203717);
else 
	select	dt_emissao 
	into STRICT	dt_emissao_w 
	from	nota_fiscal 
	where	nr_sequencia	= nr_seq_nota_fiscal_w;
end if;
 
open C01;
loop 
fetch C01 into	 
	nr_titulo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	ds_consistencia_w := Vincular_titulo_pagar_nf(nr_seq_nota_fiscal_w, nr_titulo_w, nm_usuario_p, 'A', 'S', ds_consistencia_w);
	 
	/* Francisco - 18/02/2010 - OS - 188292 - Comentei pois o título será gerado com a data emissão digitada no lote 
	update	titulo_pagar 
	set	dt_emissao		= dt_emissao_w, 
		dt_vencimento_original	= dt_vencimento_atual 
	where	nr_titulo		= nr_titulo_w; 
	 
	select	dt_vencimento_atual 
	into	dt_vencimento_w 
	from	titulo_pagar 
	where	nr_titulo	= nr_titulo_w; 
	 
	open C02; 
	loop 
	fetch C02 into	 
		nr_titulo_trib_w; 
	exit when C02%notfound; 
		begin 
		update	titulo_pagar 
		set	dt_emissao		= dt_emissao_w, 
			dt_vencimento_original	= dt_vencimento_w, 
			dt_vencimento_atual	= dt_vencimento_w 
		where	nr_titulo		= nr_titulo_trib_w; 
		end; 
	end loop; 
	close C02; 
	*/
 
	 
	end;
end loop;
close C01;
 
--pls_atualizar_tributos_lote(nr_seq_lote_p, nm_usuario_p, cd_estabelecimento_p); 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_vincular_tit_nota_lote ( nr_seq_lote_p bigint, cd_serie_nf_p text, cd_operacao_nf_p bigint, dt_emissao_p timestamp, cd_natureza_operacao_p bigint, ds_observacao_p text, ds_complemento_p text, dt_base_venc_p timestamp, nr_nota_fiscal_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

