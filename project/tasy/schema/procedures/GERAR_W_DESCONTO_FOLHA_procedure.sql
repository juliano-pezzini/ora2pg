-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_desconto_folha ( nm_usuario_p text) AS $body$
DECLARE

 
ds_tipo_colab_w		varchar(1);
ds_cadastro_colab_w	varchar(6);
ds_dt_vencimento_w	varchar(10);
dt_vencimento_w		timestamp;
ds_tipo_vale_w		varchar(2);
ds_dt_inicio_desc_w	varchar(7);
dt_inicio_desc_w	timestamp;
ds_qt_parcela_w		varchar(2);
qt_parcela_w		bigint;
ds_vl_liquido_w		varchar(10);
ds_dt_baixa_w		varchar(10);
dt_baixa_w		timestamp;
ds_vl_baixa_w		varchar(10);
vl_baixa_w		double precision;
ds_nr_titulo_w		varchar(10);
nr_titulo_w		bigint;
nr_linha_w		bigint;
vl_liquido_w		double precision;

C01 CURSOR FOR 
SELECT	substr(obter_valor_campo_separador(ds_conteudo,2,';'),1,1) ds_tipo_colab, 
	substr(obter_valor_campo_separador(ds_conteudo,2,';'),3,6) ds_cadastro_colab, 
	substr(obter_valor_campo_separador(ds_conteudo,4,';'),1,10) dt_vencimento, 
	substr(obter_valor_campo_separador(ds_conteudo,5,';'),1,2) ds_tipo_vale, 
	substr(obter_valor_campo_separador(ds_conteudo,6,';'),1,6) ds_dt_inicio_desc, 
	trim(both substr(obter_valor_campo_separador(ds_conteudo,7,';'),1,2)) ds_qt_parcela, 
	substr(obter_valor_campo_separador(ds_conteudo,8,';'),1,10) ds_vl_liquido, 
	substr(obter_valor_campo_separador(ds_conteudo,9,';'),1,10) ds_nr_titulo, 
	substr(obter_valor_campo_separador(ds_conteudo,10,';'),1,10) ds_dt_baixa, 
	substr(obter_valor_campo_separador(ds_conteudo,11,';'),1,10) ds_vl_baixa 
from	w_interf_sefip 
where	nm_usuario	= nm_usuario_p 
and	nr_sequencia > (SELECT min(nr_sequencia) from w_interf_sefip where nm_usuario = nm_usuario_p);

 

BEGIN 
 
nr_linha_w	:= 1;
 
open C01;
loop 
fetch C01 into 
	ds_tipo_colab_w, 
	ds_cadastro_colab_w, 
	ds_dt_vencimento_w, 
	ds_tipo_vale_w, 
	ds_dt_inicio_desc_w, 
	ds_qt_parcela_w, 
	ds_vl_liquido_w, 
	ds_nr_titulo_w, 
	ds_dt_baixa_w, 
	ds_vl_baixa_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
 
	nr_linha_w	:= nr_linha_w + 1;
 
	begin 
 
	nr_titulo_w	:= (ds_nr_titulo_w)::numeric;
 
	exception 
	when others then 
	/* Número do título inválido na linha nr_linha_w! 
	Número do título: ds_nr_titulo_w */
 
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(259889, 
						'NR_LINHA_W=' || nr_linha_w || 
						';DS_NR_TITULO_W=' || ds_nr_titulo_w);
	end;
 
	begin 
 
	dt_baixa_w	:= to_date(ds_dt_baixa_w,'dd/mm/yyyy');
 
	exception 
	when others then 
	/* Data da baixa inválida na linha nr_linha_w! 
	Data da baixa: ds_dt_baixa_w */
 
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(259890, 
						'NR_LINHA_W=' || nr_linha_w || 
						';DS_DT_BAIXA_W=' || ds_dt_baixa_w);
	end;
 
	begin 
 
	vl_baixa_w	:= (ds_vl_baixa_w)::numeric  / 100;
 
	exception 
	when others then 
	/* Valor da baixa inválido na linha nr_linha_w! 
	Valor da baixa: ds_vl_baixa_w */
 
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(259891, 
						'NR_LINHA_W=' || nr_linha_w || 
						';DS_VL_BAIXA_W=' || ds_vl_baixa_w);
	end;
 
	begin 
 
	dt_vencimento_w	:= to_date(ds_dt_vencimento_w,'dd/mm/yyyy');
 
	exception 
	when others then 
	/* Data do vencimento inválida na linha nr_linha_w! 
	Data do vencimento: ds_dt_vencimento_w */
 
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(259892, 
						'NR_LINHA_W=' || nr_linha_w || 
						';DS_DT_VENCIMENTO_W=' || ds_dt_vencimento_w);
	end;
 
	begin 
 
	dt_inicio_desc_w	:= to_date(ds_dt_inicio_desc_w,'mm/yyyy');
 
	exception 
	when others then 
	/* Data do início do vencimento inválida na linha nr_linha_w! 
	Data do início do vencimento: ds_dt_inicio_desc_w */
 
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(259893, 
						'NR_LINHA_W=' || nr_linha_w || 
						';DS_DT_INICIO_DESC_W=' || ds_dt_inicio_desc_w);
	end;
 
	begin 
 
	vl_liquido_w	:= (ds_vl_liquido_w)::numeric  / 100;
 
	exception 
	when others then 
	/* Valor líquido inválido na linha nr_linha_w! 
	Valor líquido: ds_vl_liquido_w */
 
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(259894, 
						'NR_LINHA_W=' || nr_linha_w || 
						';DS_VL_LIQUIDO_W=' || ds_vl_liquido_w);
	end;
 
	begin 
 
	qt_parcela_w	:= (coalesce(qt_parcela_w,'0'))::numeric;
 
	exception 
	when others then 
	/* Quantidade de parcelas inválida na linha nr_linha_w! 
	Quantidade de parcelas: ds_qt_parcela_w */
 
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(259895, 
						'NR_LINHA_W=' || nr_linha_w || 
						';DS_QT_PARCELA_W=' || ds_qt_parcela_w);
	end;
	 
	insert	into w_desconto_folha( 
		nr_sequencia, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		ie_baixa, 
		nr_titulo, 
		vl_baixa, 
		dt_baixa, 
		ds_tipo_colaborador, 
		ds_cadastro_colaborador, 
		dt_vencimento, 
		ds_tipo_vale, 
		dt_inicio_desconto, 
		qt_parcela, 
		vl_liquido) 
	values ( nextval('w_desconto_folha_seq'), 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		'N', 
		nr_titulo_w, 
		vl_baixa_w, 
		dt_baixa_w, 
		ds_tipo_colab_w, 
		ds_cadastro_colab_w, 
		dt_vencimento_w, 
		ds_tipo_vale_w, 
		dt_inicio_desc_w, 
		qt_parcela_w, 
		vl_liquido_w);
 
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_desconto_folha ( nm_usuario_p text) FROM PUBLIC;

