-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valores_sv_graf_pepo ( nr_seq_item_p bigint, nr_cirurgia_p bigint, dt_registro_p timestamp, nr_seq_pepo_p bigint ) RETURNS varchar AS $body$
DECLARE


nm_tabela_w		varchar(50);
nm_atributo_w		varchar(50);
qt_retorno_w		double precision;
ds_retorno_w		varchar(255);
ie_retorno_w		varchar(255);
vl_padrao_w		varchar(30);



BEGIN

select	max(nm_tabela),
	max(nm_atributo),
	max(vl_padrao)
into STRICT	nm_tabela_w,
	nm_atributo_w,
	vl_padrao_w
from	pepo_sv
where	nr_sequencia	=	nr_seq_item_p
and	nr_sequencia <> 74;

if (substr(nm_atributo_w,1,2) = 'QT') then
	if (nr_seq_pepo_p > 0) then
		qt_retorno_w := obter_valor_dinamico(	'select a.'||nm_atributo_w||' from '||nm_tabela_w||' a where a.nr_sequencia = (select max(b.nr_sequencia) from ' || 			nm_tabela_w|| ' b where b.nr_seq_pepo = '||to_char(nr_seq_pepo_p)||' and b.ie_situacao = ''A'') and a.'||nm_atributo_w||' is not null ', qt_retorno_w);
	else
		qt_retorno_w := obter_valor_dinamico(	'select a.'||nm_atributo_w||' from '||nm_tabela_w||' a where a.nr_sequencia = (select max(b.nr_sequencia) from ' || 			nm_tabela_w|| ' b where b.nr_cirurgia = '||to_char(nr_cirurgia_p)||' and b.ie_situacao = ''A'') and a.'||nm_atributo_w||' is not null ', qt_retorno_w);
	end if;

	ds_retorno_w := to_char(qt_retorno_w);
	if (qt_retorno_w = 0) and (nm_atributo_w <> 'QT_SEGMENTO_ST') then
		ds_retorno_w := null;
	end if;

elsif (substr(nm_atributo_w,1,2) = 'DT') then
	ds_retorno_w := to_char(coalesce(dt_registro_p,clock_timestamp()),'dd/mm/yyyy hh24:mi:ss');
elsif (substr(nm_atributo_w,1,2) = 'IE') then
	if (nr_seq_pepo_p > 0) then
		ie_retorno_w := obter_valor_dinamico_char_bv(	'select a.'||nm_atributo_w||' from '||nm_tabela_w||' a where a.nr_sequencia = (select max(b.nr_sequencia) 		from ' || nm_tabela_w|| ' b where b.nr_seq_pepo = :nr_seq_pepo and b.ie_situacao = ''A'') and a.'||nm_atributo_w||' is not null ', 'nr_seq_pepo='||to_char(nr_seq_pepo_p)||'; ', ie_retorno_w);
	else
		ie_retorno_w := obter_valor_dinamico_char_bv(	'select a.'||nm_atributo_w||' from '||nm_tabela_w||' a where a.nr_sequencia = (select max(b.nr_sequencia) 			from ' || nm_tabela_w|| ' b where b.nr_cirurgia = :nr_cirurgia and b.ie_situacao = ''A'') and a.'||nm_atributo_w||' is not null ', 'nr_cirurgia='||to_char(nr_cirurgia_p)||'; ', ie_retorno_w);
	end if;



	ds_retorno_w := ie_retorno_w;
end if;

if (coalesce(ds_retorno_w::text, '') = '') then
	ds_retorno_w := vl_padrao_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valores_sv_graf_pepo ( nr_seq_item_p bigint, nr_cirurgia_p bigint, dt_registro_p timestamp, nr_seq_pepo_p bigint ) FROM PUBLIC;
