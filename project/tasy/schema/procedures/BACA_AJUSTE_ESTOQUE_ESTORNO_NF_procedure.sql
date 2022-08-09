-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_ajuste_estoque_estorno_nf () AS $body$
DECLARE

 
 
nr_sequencia_w		bigint;

c01 CURSOR FOR 
	SELECT	distinct(b.nr_sequencia) 
	from	nota_fiscal b , 
		nota_fiscal_item c 
	where	b.nr_sequencia     = c.nr_sequencia 
	and	(c.cd_material IS NOT NULL AND c.cd_material::text <> '') 
	and	obter_se_local_direto(c.cd_local_estoque) = 'N' 
	and	substr(obter_se_material_estoque(1,0,c.cd_material),1,1) = 'S' 
	and	b.dt_atualizacao > clock_timestamp() - interval '15 days' 
	and	obter_se_nota_entrada_saida(b.nr_sequencia) = 'E' 
	and	(b.dt_atualizacao_estoque IS NOT NULL AND b.dt_atualizacao_estoque::text <> '') 
	and not exists ( 
		SELECT	1 
		from	movimento_estoque x 
		where	x.ie_origem_documento = '1' 
		and	x.dt_atualizacao > clock_timestamp() - interval '15 days' 
		and	x.nr_seq_tab_orig = b.nr_sequencia);

 

BEGIN 
 
open c01;
loop 
fetch c01 into 
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
 
	update	nota_fiscal 
	set	dt_atualizacao_estoque	 = NULL, 
		ds_observacao 		= substr(ds_observacao || 'Ajuste estoque WHEB' ,1,255) 
	where	nr_sequencia		= nr_sequencia_w;
 
	CALL Gerar_movto_estoque_NF(nr_sequencia_w, 'AjusteWheb');
 
	update	nota_fiscal 
	set	dt_atualizacao_estoque	= clock_timestamp() 
	where	nr_sequencia		= nr_sequencia_w;
	end;
 
end loop;
close c01;
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_ajuste_estoque_estorno_nf () FROM PUBLIC;
