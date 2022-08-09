-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_exportar_lote_contab_csv ( nr_lote_contabil_p bigint, ie_tipo_movimento_p text, nm_usuario_p text) AS $body$
DECLARE


nr_planilha_w			smallint;
qt_registros_w			bigint;
qt_limite_w			bigint := 999999;

/*Variaveis para geração do arquivo*/

ds_erro_w			varchar(255);
ds_local_w			varchar(255);
nm_arquivo_w			varchar(255);
arq_texto_w			utl_file.file_type;

c_movimento_contabil CURSOR FOR
	SELECT	a.nr_sequencia							|| ';' ||
		a.dt_movimento							|| ';' ||
		a.vl_movimento							|| ';' ||
		a.cd_conta_debito						|| ';' ||
		a.cd_conta_credito						|| ';' ||
		a.cd_centro_custo						|| ';' ||
		a.ds_compl_historico						|| ';' ||
		a.cd_historico							|| ';' ||
		a.ds_historico_original						|| ';' ||
		a.ds_conta_contabil						|| ';' ||
		a.ds_centro_custo						|| ';' ||
		a.cd_classificacao						|| ';' ||
		a.nr_seq_agrupamento						|| ';' ||
		a.cd_estab_movto						|| ';' ||
		substr(obter_nome_estabelecimento(a.cd_estab_movto),1,80)	|| ';' ||
		a.nr_seq_trans_fin						|| ';' ||
		a.ie_transitorio						|| ';' ||
		a.nr_documento							|| ';' ||
		substr(obter_valor_dominio(6091, a.ie_origem_documento),1,255) ds_linha
	from	movimento_contabil_v a
	where	a.nr_lote_contabil	= nr_lote_contabil_p
	and (ie_tipo_movimento_p	= 'A'
	or (ie_tipo_movimento_p	= 'D'
	and	coalesce(cd_conta_debito,0) <> 0)
	or (ie_tipo_movimento_p	= 'C'
	and	coalesce(cd_conta_credito,0) <> 0))
	order by a.nr_sequencia;

BEGIN

qt_registros_w	:= 1;
nr_planilha_w	:= 2;

SELECT * FROM obter_evento_utl_file(1, null, ds_local_w, ds_erro_w) INTO STRICT ds_local_w, ds_erro_w;
nm_arquivo_w	:= 'WCTB03243_' || to_char(clock_timestamp(),'ddmmyyyyhh24miss') || nm_usuario_p || '.csv';
arq_texto_w := utl_file.fopen(ds_local_w,nm_arquivo_w,'W');
utl_file.put_line(arq_texto_w, obter_desc_expressao(779072));

for vet in c_movimento_contabil loop
	begin
	if (mod(qt_registros_w,qt_limite_w) = 0) then
		utl_file.fclose(arq_texto_w);

		nm_arquivo_w	:= 'WCTB03243_' || to_char(clock_timestamp(),'ddmmyyyyhh24miss') || nm_usuario_p || '_' || to_char(nr_planilha_w) ||'.csv';
		arq_texto_w 	:= utl_file.fopen(ds_local_w,nm_arquivo_w,'W');

		utl_file.put_line(arq_texto_w, obter_desc_expressao(779072));
		utl_file.fflush(arq_texto_w);

		qt_registros_w	:= qt_registros_w + 1;
		nr_planilha_w := nr_planilha_w + 1;
	end if;

	utl_file.put_line(arq_texto_w,vet.ds_linha);
	utl_file.fflush(arq_texto_w);

	qt_registros_w	:= qt_registros_w + 1;
	end;
end loop;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_exportar_lote_contab_csv ( nr_lote_contabil_p bigint, ie_tipo_movimento_p text, nm_usuario_p text) FROM PUBLIC;
