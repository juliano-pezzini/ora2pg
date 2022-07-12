-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tasy_legenda_cor_pep ( nr_seq_schematic_p bigint, nr_seq_legenda_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE



ds_resultado_w			varchar(15)	:= '';
ds_cor_html_w			varchar(15)	:= '';
cd_estabelecimento_w	smallint;
cd_perfil_w				bigint;
nr_seq_padrao_w			bigint;



BEGIN

cd_estabelecimento_w	:= wheb_usuario_pck.get_cd_estabelecimento;
cd_perfil_w	:= obter_perfil_ativo;

Select 	max(C.DS_COR_HTML),
		max(c.nr_sequencia)
into STRICT	ds_cor_html_w,
		nr_seq_padrao_w
from   	OBJETO_SCHEMATIC a,
		OBJETO_SCHEMATIC_LEGENDA b,
		tasy_padrao_cor c,
		regra_condicao d,
		regra_condicao_item e
where  	a.nr_Sequencia = nr_seq_schematic_p
and   	 b.NR_SEQ_OBJETO = a.nr_sequencia
and    	b.NR_SEQ_LEGENDA = nr_seq_legenda_p
and    	c.NR_SEQ_LEGENDA = b.NR_SEQ_LEGENDA
and    	d.NR_SEQ_LEGENDA = c.NR_SEQUENCIA
and    	e.nr_seq_regra = d.nr_Sequencia
and    	e.ie_valor = ie_opcao_p;


select	coalesce(max(ds_cor_html),ds_cor_html_w)
into STRICT	ds_resultado_w
from	tasy_padrao_cor_perfil
where	cd_estabelecimento	= cd_estabelecimento_w
and		nr_seq_padrao		= nr_seq_padrao_w
and		cd_perfil		= cd_perfil_w;


return ds_resultado_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tasy_legenda_cor_pep ( nr_seq_schematic_p bigint, nr_seq_legenda_p bigint, ie_opcao_p text) FROM PUBLIC;

