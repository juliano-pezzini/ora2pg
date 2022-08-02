-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_dados_gerar_nf ( nr_seq_lote_p bigint, cd_estabelecimento_p bigint, cd_operacao_nf_p INOUT bigint, cd_natureza_operacao_p INOUT bigint, nr_seq_classif_fiscal_p INOUT bigint, nr_seq_sit_trib_p INOUT bigint, cd_serie_nf_p INOUT text, ie_data_referencia_nf_p INOUT text, qt_gerar_nf_p INOUT bigint, qt_regra_nf_p INOUT bigint) AS $body$
DECLARE

 
ie_geracao_nota_titulo_p	varchar(2);


BEGIN 
 
select	cd_operacao_nf, 
	cd_natureza_operacao, 
	nr_seq_classif_fiscal, 
	nr_seq_sit_trib, 
	cd_serie_nf, 
	ie_data_referencia_nf, 
	ie_geracao_nota_titulo 
into STRICT	cd_operacao_nf_p, 
	cd_natureza_operacao_p, 
	nr_seq_classif_fiscal_p, 
	nr_seq_sit_trib_p, 
	cd_serie_nf_p, 
	ie_data_referencia_nf_p, 
	ie_geracao_nota_titulo_p 
from	pls_parametros 
where	cd_estabelecimento	= cd_estabelecimento_p;
 
select	count(1) 
into STRICT	qt_gerar_nf_p 
 
where	exists (SELECT	1 
		from	pls_mensalidade a 
		where	coalesce(coalesce(a.ie_nota_titulo, ie_geracao_nota_titulo_p), 'NT') = 'NT' 
		and	a.nr_seq_lote = nr_seq_lote_p);
 
select count(1) 
into STRICT	qt_regra_nf_p 
 
where	exists (SELECT	1 
		from	pls_regra_serie_nf 
		where  ie_situacao 		= 'A' 
		and   cd_estabelecimento  	= cd_estabelecimento_p);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_dados_gerar_nf ( nr_seq_lote_p bigint, cd_estabelecimento_p bigint, cd_operacao_nf_p INOUT bigint, cd_natureza_operacao_p INOUT bigint, nr_seq_classif_fiscal_p INOUT bigint, nr_seq_sit_trib_p INOUT bigint, cd_serie_nf_p INOUT text, ie_data_referencia_nf_p INOUT text, qt_gerar_nf_p INOUT bigint, qt_regra_nf_p INOUT bigint) FROM PUBLIC;

