-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_estorno_tit_integracao ( nm_usuario_p text, ie_retorno_p INOUT text, ds_retorno_p INOUT text) AS $body$
DECLARE

 
cd_tipo_baixa_w		titulo_pagar_baixa.cd_tipo_baixa%type;
vl_devolucao_w		titulo_pagar_baixa.vl_devolucao%type;
cd_moeda_w		titulo_pagar_baixa.cd_moeda%type;
dt_baixa_w		titulo_pagar_baixa.dt_baixa%type;
ie_acao_w		titulo_pagar_baixa.ie_acao%type;
vl_multa_w		titulo_pagar_baixa.vl_multa%type;
vl_juros_w		titulo_pagar_baixa.vl_juros%type;
nr_titulo_w		titulo_pagar_baixa.nr_titulo%type;
vl_descontos_w		titulo_pagar_baixa.vl_descontos%type;		
vl_baixa_w		titulo_pagar_baixa.vl_baixa%type;
nr_sequencia_w		titulo_pagar_baixa.nr_sequencia%type;
					
c01 CURSOR FOR 
SELECT	a.cd_tipo_baixa, 
	a.vl_devolucao, 
	a.cd_moeda, 
	a.dt_baixa, 
	a.ie_acao, 
	a.vl_multa, 
	a.vl_juros, 
	a.nr_titulo, 
	a.vl_descontos, 
	a.vl_baixa 
from	w_baixa_tit_integracao a 
where	a.nm_usuario = nm_usuario_p;


BEGIN 
 
open C01;
loop 
fetch C01 into	 
	cd_tipo_baixa_w, 
	vl_devolucao_w, 
	cd_moeda_w, 
	dt_baixa_w, 
	ie_acao_w, 
	vl_multa_w, 
	vl_juros_w, 
	nr_titulo_w, 
	vl_descontos_w, 
	vl_baixa_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
 
	select	coalesce(max(a.nr_sequencia),0) + 1 
	into STRICT	nr_sequencia_w 
	from	titulo_pagar_baixa a 
	where	a.nr_titulo	= nr_titulo_w;
 
	insert	into titulo_pagar_baixa( 
		cd_tipo_baixa, 
		vl_devolucao, 
		cd_moeda, 
		dt_baixa, 
		ie_acao, 
		vl_multa, 
		vl_juros, 
		nr_titulo, 
		vl_descontos, 
		vl_baixa, 
		nm_usuario, 
		dt_atualizacao, 
		nr_sequencia) 
	values (	cd_tipo_baixa_w, 
		vl_devolucao_w, 
		cd_moeda_w, 
		dt_baixa_w, 
		ie_acao_w, 
		vl_multa_w, 
		vl_juros_w, 
		nr_titulo_w, 
		vl_descontos_w, 
		vl_baixa_w, 
		nm_usuario_p, 
		clock_timestamp(), 
		nr_sequencia_w);
 
	CALL gerar_titulo_pagar_baixa_cc(	nr_titulo_w, 
				nr_sequencia_w, 
				'N', 
				nm_usuario_p);
					 
	CALL atualizar_saldo_tit_pagar(	nr_titulo_w, 
				nm_usuario_p);
 
end loop;
close C01;
 
delete	from w_baixa_tit_integracao 
where	nm_usuario = nm_usuario_p;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_estorno_tit_integracao ( nm_usuario_p text, ie_retorno_p INOUT text, ds_retorno_p INOUT text) FROM PUBLIC;

