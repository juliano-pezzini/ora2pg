-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE criar_campo_relatorio ( nr_seq_banda_p bigint, ds_campo_p text, nr_seq_apresentacao_p bigint, ie_tipo_campo_p bigint, qt_topo_p bigint, qt_esquerda_p bigint, qt_tamanho_p bigint, nm_atributo_p text, nm_usuario_p text, nr_seq_campo_p INOUT bigint, ds_label_p text default null, ie_alinhamento_p text default null, ie_estender_p text default null) AS $body$
DECLARE


/* Tabela Banda_Relat_Campo Campos que não alteram: */

ie_tipo_campo_w			smallint;
ie_borda_sup_w			varchar(1)		:= 'N';
ie_borda_inf_w			varchar(1)		:= 'N';
ie_borda_esq_w			varchar(1)		:= 'N';
ie_borda_dir_w			varchar(1)		:= 'N';
ie_totalizar_w			varchar(1)		:= 'N';
ie_campo_quebra_w			varchar(1)		:= 'N';
ie_quebra_pagina_w		varchar(1)		:= 'N';
ie_zera_apos_imprimir_w		varchar(1)		:= 'N';
ie_transparente_w			varchar(1)		:= 'S';
ie_alinhamento_w			varchar(1)		:= 'E';
ie_alinhar_banda_w		varchar(1)		:= 'N';
ds_cor_fundo_w			varchar(10)	:= 'clWhite';
qt_tam_fonte_w			smallint		:= 8;
ds_cor_fonte_w			varchar(10)	:= 'clBlack';
ds_tipo_fonte_w			varchar(20)	:= 'Arial';
ie_tipo_barcode_w			varchar(12)	:= 'CODE128_C';
ie_humano_barcode_w		varchar(1)		:= 'S';
pr_altura_barcode_w		smallint		:= 50;
qt_fonte_barcode_w		smallint		:= 100;
ds_cor_label_w			varchar(10)	:= 'clWhite';
ie_altera_valor_w			varchar(1)		:= 'N';
ds_estilo_fonte_w			varchar(20)	:= '';

/* Campos variáveis */

nr_seq_campo_w			bigint;
ie_ajustar_tamanho_w		varchar(1)		:= 'N';
ie_estender_w			varchar(1)		:= 'N';
qt_altura_w				real		:= 17;
ds_label_w				varchar(255)	:= '';
ds_conteudo_w			varchar(2000)	:= '';
ds_expressao_w			varchar(2000)	:= '';
ds_mascara_w			varchar(20)	:= '';
ds_sql_w				varchar(4000)	:= '';

/* Tipos de Campos:	0	Base
				1	Conteúdo
				2	Barras
				3	Logo
				4	Cálculo
				5	Desenho
				6	Imagem
				7	Página
				8	Data Sistema
				9	Usuário
				10	DB Rich Edit
				11	Rich Edit
				12	Código Relatório
				13	Data extenso
				14	Nome do Relatório
				15	Setor do Usuário
				16	Estabelecimento
				17	Parâmetro
				18	Gráfico (Chart)
				19	Imagem */
BEGIN
select	nextval('banda_relat_campo_seq')
into STRICT		nr_seq_campo_w
;

if (ie_tipo_campo_p = 0) then
	if (ds_label_p IS NOT NULL AND ds_label_p::text <> '') then
		ds_label_w	:= ds_label_p;
	else
		ds_label_w	:= '';
	end	if;
elsif (ie_tipo_campo_p = 1) then
	begin
	ds_conteudo_w		:= ds_campo_p;
	ds_cor_fundo_w		:= '$00E5E5E5';
	ie_estender_w		:= 'S';
	ie_transparente_w		:= 'N';
	end;
elsif (ie_tipo_campo_p = 2) or (ie_tipo_campo_p = 3)  then
	begin
	ie_ajustar_tamanho_w	:= 'S';
	ie_estender_w		:= 'S';
	qt_altura_w			:= 60;
	end;
elsif (ie_tipo_campo_p = 4) then
	ds_expressao_w		:= nm_atributo_p;
elsif (ie_tipo_campo_p = 5) then
	ds_conteudo_w		:= 'qrsHorLine';
elsif (ie_tipo_campo_p = 6)
	or (ie_tipo_campo_p = 19) then
	begin
	ie_ajustar_tamanho_w	:= 'S';
	ie_estender_w		:= 'S';
	qt_altura_w			:= 200;
	end;
elsif (ie_tipo_campo_p = 7)
	or (ie_tipo_campo_p = 8)
	or (ie_tipo_campo_p = 13) then
	begin
	ie_ajustar_tamanho_w	:= 'S';
	ds_label_w			:= ds_campo_p;
	end;
elsif (ie_tipo_campo_p = 9) then
	ie_ajustar_tamanho_w	:= 'S';
elsif (ie_tipo_campo_p = 10)
	or (ie_tipo_campo_p = 11) then
	ie_estender_w		:= 'S';
elsif (ie_tipo_campo_p = 12) then
	ie_alinhamento_w		:= 'D';
elsif (ie_tipo_campo_p = 14) then
	begin
	ie_alinhamento_w		:= 'C';
	qt_tam_fonte_w		:= 15;
	ds_estilo_fonte_w		:= 'N';
	end;
elsif (ie_tipo_campo_p = 15)
	or (ie_tipo_campo_p = 16) then
	ds_label_w			:= '';
elsif (ie_tipo_campo_p = 18) then
	ds_label_w			:= ds_campo_p;
	ie_alinhamento_w		:= 'C';
else
	ds_label_w			:= ds_campo_p;
end if;

Insert into	Banda_Relat_Campo(
			nr_sequencia, nr_seq_banda, ds_campo,
			nr_seq_apresentacao, ie_tipo_campo,	dt_atualizacao,
			nm_usuario,	ie_borda_sup, ie_borda_inf,
			ie_borda_esq, ie_borda_dir, ie_totalizar,
			ie_campo_quebra, ie_quebra_pagina, ie_zera_apos_imprimir,
			ie_transparente, ie_alinhamento, ie_ajustar_tamanho,
			ie_estender, ie_alinhar_banda, qt_altura,
			qt_tamanho, qt_topo, qt_esquerda,
			ds_label, nm_atributo, ds_conteudo,
			ds_expressao, ds_mascara, ds_sql,
			ds_cor_fundo, qt_tam_fonte, ds_cor_fonte,
			ds_tipo_fonte, ds_estilo_fonte, ie_tipo_barcode,
			ie_humano_barcode, pr_altura_barcode, qt_fonte_barcode,
			ds_cor_label, ie_altera_valor)
values (		nr_seq_campo_w, nr_seq_banda_p, substr(ds_campo_p,1,80),
			nr_seq_apresentacao_p, ie_tipo_campo_p, clock_timestamp(),
			nm_usuario_p, ie_borda_sup_w, ie_borda_inf_w,
			ie_borda_esq_w, ie_borda_dir_w, ie_totalizar_w,
			ie_campo_quebra_w, ie_quebra_pagina_w, ie_zera_apos_imprimir_w,
			ie_transparente_w, coalesce(ie_alinhamento_p,ie_alinhamento_w), ie_ajustar_tamanho_w,
			coalesce(ie_estender_p,ie_estender_w), ie_alinhar_banda_w, qt_altura_w,
			qt_tamanho_p, qt_topo_p, qt_esquerda_p,
			ds_label_w, nm_atributo_p, ds_conteudo_w,
			ds_expressao_w, ds_mascara_w, ds_sql_w,
			ds_cor_fundo_w, qt_tam_fonte_w, ds_cor_fonte_w,
			ds_tipo_fonte_w, ds_estilo_fonte_w, ie_tipo_barcode_w,
			ie_humano_barcode_w, pr_altura_barcode_w, qt_fonte_barcode_w,
			ds_cor_label_w, ie_altera_valor_w);

nr_seq_campo_p	:= nr_seq_campo_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE criar_campo_relatorio ( nr_seq_banda_p bigint, ds_campo_p text, nr_seq_apresentacao_p bigint, ie_tipo_campo_p bigint, qt_topo_p bigint, qt_esquerda_p bigint, qt_tamanho_p bigint, nm_atributo_p text, nm_usuario_p text, nr_seq_campo_p INOUT bigint, ds_label_p text default null, ie_alinhamento_p text default null, ie_estender_p text default null) FROM PUBLIC;
