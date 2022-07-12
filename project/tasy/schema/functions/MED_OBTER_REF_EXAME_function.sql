-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION med_obter_ref_exame (cd_pessoa_fisica_p text, nr_sequencia_p bigint, qt_pessoa_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(256);
qt_minimo_w		double precision;
qt_maximo_w		double precision;
ds_dado_w		varchar(240);
qt_idade_min_w	smallint;
qt_idade_max_w	smallint;
nr_total_w		bigint;
qt_idade_w		bigint;
ie_sexo_w		varchar(1);
vl_ref_inicial_w	double precision;
vl_ref_final_w		double precision;

	--/*	ie_opcao_p
	--	MAX 	= Quantidade máxima
	--	MIN 	= Quantidade mínima
	--	TP	= Tipo de dado estastístico
	--	DFA	= Dentro da Faixa de Avaliação
	--	IMI	= Idade Mínima
	--	IMA	= Idade Máxima
	--*\
c01 CURSOR FOR
SELECT	coalesce(b.qt_minimo, vl_ref_inicial_w) ,
	coalesce(b.qt_maximo, vl_ref_final_w),
	coalesce(b.qt_idade_minima,0),
	coalesce(qt_idade_maxima,999)
from	med_exame_padrao_ref b
where	b.nr_seq_exame	= nr_sequencia_p
and	qt_idade_w between coalesce(b.qt_idade_minima,0) and coalesce(b.qt_idade_maxima,999)
and	((b.ie_sexo 	= ie_sexo_w) or (b.ie_sexo = 'A') or (coalesce(b.ie_sexo::text, '') = ''))
order by b.nr_sequencia desc;


BEGIN
ds_retorno_w	:= 'N';
select	obter_idade_pf(cd_pessoa_fisica_p,clock_timestamp(),'A'),
	obter_sexo_pf(cd_pessoa_fisica_p , 'C'),
	vl_padrao_minimo,
	vl_padrao_maximo,
	ds_exame
into STRICT	qt_idade_w,
	ie_sexo_w,
	vl_ref_inicial_w,
	vl_ref_final_w,
	ds_dado_w
from	med_exame_padrao
where	nr_sequencia = nr_sequencia_p;

if (ie_opcao_p = 'DFA') and (qt_pessoa_p >= vl_ref_inicial_w) and (qt_pessoa_p <= vl_ref_final_w) then
	ds_retorno_w	:= 'S';
end if;

OPEN C01;
LOOP
FETCH C01 into
		qt_minimo_w,
		qt_maximo_w,
		qt_idade_min_w,
		qt_idade_max_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	qt_minimo_w	:= qt_minimo_w;
	qt_maximo_w	:= qt_maximo_w;
	qt_idade_min_w	:= qt_idade_min_w;
	qt_idade_max_w	:= qt_idade_max_w;
	if (ie_opcao_p = 'DFA') and (qt_pessoa_p >= qt_minimo_w) and (qt_pessoa_p <= qt_maximo_w) then
		ds_retorno_w	:= 'S';
	end if;
	end;
END LOOP;
CLOSE C01;

if (ie_opcao_p = 'MAX') then
	ds_retorno_w := to_char(coalesce(qt_maximo_w,vl_ref_final_w));
elsif (ie_opcao_p = 'MIN') then
	ds_retorno_w := to_char(coalesce(qt_minimo_w,vl_ref_inicial_w));
elsif (ie_opcao_p = 'TP') then
	ds_retorno_w := ds_dado_w;
elsif (ie_opcao_p = 'IMI') then
	ds_retorno_w := to_char(coalesce(qt_idade_min_w,0));
elsif (ie_opcao_p = 'IMA') then
	ds_retorno_w := to_char(coalesce(qt_idade_max_w,999));
end if;

return	ds_retorno_w;

end; */;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION med_obter_ref_exame (cd_pessoa_fisica_p text, nr_sequencia_p bigint, qt_pessoa_p bigint, ie_opcao_p text) FROM PUBLIC;

