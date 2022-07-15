-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE campos AS (		nm_parametro	varchar(255));


CREATE OR REPLACE PROCEDURE gerar_novo_relatorio_sql ( ds_titulo_p text, ds_sql_p text, nm_usuario_p text, cd_relatorio_p INOUT text, cd_classif_relat_p INOUT text, ds_parametros_p text) AS $body$
DECLARE


type Vetor is table of campos index 	by integer;
Vetor_w			Vetor;										
										
nr_seq_relatorio_w		bigint;
cd_relatorio_w			bigint;
nr_seq_banda_w			bigint;
ds_parametros_w			varchar(32000);
i				integer;
ds_mascara_w			varchar(255);
IE_TIPO_ATRIBUTO_w		varchar(255);
NR_SEQ_APRESENT_w		bigint	:= 0;
DS_PARAMETRO_w			varchar(255);


C01 CURSOR FOR
 SELECT coalesce(Min(cd_relatorio+1),1) FROM RELATORIO a
   WHERE	NOT EXISTS (	SELECT	1
			       FROM	RELATORIO b
                              WHERE (a.cd_relatorio+1) = b.cd_relatorio
		              AND 	cd_classif_relat = 'CATE')
   AND	cd_relatorio > 0
   AND cd_classif_relat = 'CATE';


BEGIN

ds_parametros_w    := ds_parametros_p;
ds_parametros_w	   := replace(ds_parametros_w,'null','');
i	:= 0;

while(length(ds_parametros_w) > 0) loop
	begin
	i	:= i+1;
	if (position(';' in ds_parametros_w)	>0)  then
		Vetor_w[i].nm_parametro	:= substr(ds_parametros_w,1,position(';' in ds_parametros_w)-1);
		ds_parametros_w	:= substr(ds_parametros_w,position(';' in ds_parametros_w)+1,40000);
	else
		Vetor_w[i].nm_parametro	:=substr(ds_parametros_w,1,length(ds_parametros_w) - 1);
		ds_parametros_w	:= null;
	end if;

	end;
end loop;


open C01;
loop
fetch C01 into	
	cd_relatorio_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
end loop;
close C01;


select	nextval('relatorio_seq')
into STRICT	nr_seq_relatorio_w
;

insert into RELATORIO(
	 NR_SEQUENCIA,  
 	 DS_TITULO,  
 	 DT_ATUALIZACAO,  
 	 NM_USUARIO,  
 	 IE_BORDA_SUP,  
 	 IE_BORDA_INF,  
 	 IE_BORDA_ESQ,  
 	 IE_BORDA_DIR,  
 	 IE_ORIENTACAO,  
 	 IE_IMPRIME_VAZIO,  
 	 IE_FILTRO_HTML,  
 	 IE_FILTRO_WORD,  
 	 IE_TIPO_PAPEL,  
 	 IE_FILTRO_EXCEL,  
 	 IE_FILTRO_TEXTO,  
 	 DS_COR_FUNDO,  
 	 QT_MARGEM_SUP,  
 	 QT_MARGEM_INF,  
 	 QT_MARGEM_ESQ,  
 	 QT_MARGEM_DIR,  
 	 QT_ESPACO_COLUNA,  
 	 QT_COLUNA,  
 	 NM_TABELA,  
 	 DS_SQL,  
 	 NR_SEQ_MODULO,  
 	 IE_CHAMADA_DIRETA,  
 	 CD_CLASSIF_RELAT,  
 	 CD_RELATORIO,  
 	 CD_RELATORIO_WHEB,  
 	 CD_CGC_CLIENTE,  
 	 IE_ETIQUETA,  
 	 IE_GERAR_BASE,  
 	 DS_REGRA,  
 	 DS_PROCEDURE,  
 	 IE_GERAR_RELATORIO,  
 	 QT_ALTURA,  
 	 QT_LARGURA,  
 	 NR_SEQ_MOD_IMPL,  
 	 NR_SEQ_ORDEM_SERV,  
 	 CD_CLASSIF_RELAT_WHEB,  
 	 NR_VERSAO) 
 values (
	 nr_seq_relatorio_w,  
 	 ds_titulo_p,  
 	 clock_timestamp(),  
 	 nm_usuario_p,  
 	 'S',  
 	 'S',  
 	 'S',  
 	 'S',  
 	 'P',  
 	 'N',  
 	 'S',  
 	 'S',  
 	 'A4',  
 	 'S',  
 	 'S',  
 	 'clWhite',  
 	 10,  
 	 20,  
 	 10,  
 	 10,  
 	 0,  
 	 1,  
 	 null,  
 	 substr(ds_sql_p,1,4000),  
 	 13,  
 	 null,  
 	 'CATE',  
 	 cd_relatorio_w,  
 	 null,  
 	 'X',  
 	 'N',  
 	 'N',  
 	 null,  
 	 null,  
 	 'S',  
 	 null,  
 	 null,  
 	 null,  
 	 null,  
 	 null,  
 	 null);

select	nextval('banda_relatorio_seq')
into STRICT	nr_seq_banda_w
;

	insert into banda_relatorio(
		nr_sequencia,
		ie_tipo_banda,
		ds_banda,
		dt_atualizacao,
		nm_usuario,
		qt_altura,
		ds_cor_fundo,
		ie_quebra_pagina,
		ie_reimprime_nova_pagina,
		ie_alterna_cor_fundo,
		ie_imprime_vazio,
		ie_imprime_primeiro,
		ie_borda_sup,
		ie_borda_inf,
		ie_borda_esq,
		ie_borda_dir,
		nr_seq_relatorio,
		nr_seq_apresentacao,
		ds_cor_header,
		ds_cor_footer,
		ds_cor_quebra,
		ie_banda_padrao)
	values (nr_seq_banda_w,
		'D',
		'Detalhe',
		clock_timestamp(),
		nm_usuario_p,
		18,
		'clwhite',
		'N',
		'N',
		'S',
		'N',
		'N',
		'S',
		'N',
		'N',
		'N',
		nr_seq_relatorio_w,
		5,
		'clsilver',
		'clwhite',
		'$00E5E5E5',
		'N');

CALL gerar_colunas_sql_relat(nr_seq_banda_w,nm_usuario_p);	
	 
	 
CALL Gerar_Banda_Padrao_Relatorio(nr_seq_relatorio_w,nm_usuario_p);





	
	
for i in 1..Vetor_w.count loop
	begin
	
	
	ds_mascara_w	:= null;
	IE_TIPO_ATRIBUTO_w	:= 'VARCHAR2';
	if (substr(Vetor_w[i].nm_parametro,1,2)	= 'DT') then
		ds_mascara_w	:= 'dd/mm/yyyy hh:mm:ss';
		IE_TIPO_ATRIBUTO_w	:= 'DATE';
	end if;
	
	
	ds_parametro_w	:= substr(Vetor_w[i].nm_parametro,1,1) || substr(replace(lower(Vetor_w[i].nm_parametro),'_',' '),2,length(Vetor_w[i].nm_parametro));
	
	NR_SEQ_APRESENT_w	:= NR_SEQ_APRESENT_w + 100;
	insert into RELATORIO_PARAMETRO(
				 NR_SEQUENCIA,
				 CD_PARAMETRO,
				 DS_PARAMETRO,
				 IE_TIPO_ATRIBUTO,
				 NR_SEQ_RELATORIO,
				 IE_ORIGEM_INFORMACAO,
				 DT_ATUALIZACAO,
				 NM_USUARIO,
				 CD_DOMINIO,
				 DS_SQL,
				 VL_PADRAO,
				 IE_FORMA_APRESENT,
				 QT_TAMANHO_CAMPO,
				 DS_VALOR_PARAMETRO,
				 IE_FORMA_PASSAGEM,
				 DS_ALIAS,
				 DS_MASCARA,
				 QT_TAM_BYTE,
				 IE_MULTI_LINHA,
				 NR_SEQ_LOCALIZAR,
				 NR_SEQ_APRESENT,
				 DS_OBSERVACAO,
				 QT_DESLOC_DIREITA,
				 IE_TIPO_IN)
			values (
				 nextval('relatorio_parametro_seq'),
				 Vetor_w[i].nm_parametro,
				DS_PARAMETRO_w,
				 IE_TIPO_ATRIBUTO_w,
				 nr_seq_relatorio_w,
				 'P',
				 clock_timestamp(),
				 NM_USUARIO_p,
				 null,
				 null,
				 null,
				 'ed',
				 120,
				 null,
				 'P',
				 null,
				 ds_mascara_w,
				 null,
				 'N',
				 null,
				 NR_SEQ_APRESENT_w,
				 null,
				 null,
				 'N');
	
	
	
	end;
end loop;


cd_relatorio_p	:= cd_relatorio_w;
cd_classif_relat_p	:= 'CATE';


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_novo_relatorio_sql ( ds_titulo_p text, ds_sql_p text, nm_usuario_p text, cd_relatorio_p INOUT text, cd_classif_relat_p INOUT text, ds_parametros_p text) FROM PUBLIC;

