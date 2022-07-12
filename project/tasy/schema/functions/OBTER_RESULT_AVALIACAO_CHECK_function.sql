-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_result_avaliacao_check ( nr_seq_avaliacao_p bigint, nr_seq_item_p bigint) RETURNS varchar AS $body$
DECLARE

/*
  B - Booleano
  D - Descrição
  M - Multiseleção
  S - Seleção Simples
  O - Valor Domínio
  C - Seleção Simples
  L - Cálculo
  T - Título
  V - Valor
*/
ds_resultado_w			varchar(4000);
qt_resultado_w			double precision;
ie_resultado_w			varchar(02);
cd_funcao_w				integer;


BEGIN


select	coalesce(a.cd_funcao, 0)
into STRICT		cd_funcao_w
from		med_item_avaliar b,
		med_tipo_avaliacao a
where		a.nr_sequencia	= b.nr_seq_tipo
and		b.nr_sequencia	= nr_seq_item_p;


ds_resultado_w			:= '';

select ie_resultado
into STRICT 	ie_resultado_w
from 	med_item_avaliar
where nr_sequencia	= nr_seq_item_p;

if (cd_funcao_w	= 2000) then
	begin
	select	qt_resultado,
			ds_resultado
	into STRICT 		qt_resultado_w,
			ds_resultado_w
	from		sac_pesquisa_result
	where		nr_seq_pesquisa	= nr_seq_avaliacao_p
	and		nr_seq_item		= nr_seq_item_p;
	end;
else
	begin
	select		max(qt_resultado),
			max(ds_resultado)
	into STRICT 		qt_resultado_w,
			ds_resultado_w
	from		atend_check_list_result
	where		nr_seq_checklist	= nr_seq_avaliacao_p
	and		nr_seq_item		= nr_seq_item_p;
	end;
end if;

if (ie_resultado_w = 'B') then
	begin
	if (coalesce(qt_resultado_w,0) = 0) then
		ds_resultado_w	:= 'N';
	else
		ds_resultado_w	:= 'S';
	end if;
	end;
elsif (ie_resultado_w = 'D') or (ie_resultado_w = 'C') then
	begin
	ds_resultado_w	:= ds_resultado_w;
	end;
elsif (ie_resultado_w = 'V') then
	ds_resultado_w	:= qt_resultado_w;
elsif (ie_resultado_w = 'L') then
	ds_resultado_w	:= to_char(qt_resultado_w, '999999999999999.9999');
elsif (ie_resultado_w = 'O') or (ie_resultado_w = 'S') then
	begin
	if (qt_resultado_w = 0) or (coalesce(qt_resultado_w::text, '') = '') then
		ds_resultado_w	:= ds_resultado_w;
	else
		ds_resultado_w	:= qt_resultado_w;
	end if;
	end;
end if;

RETURN ds_resultado_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_result_avaliacao_check ( nr_seq_avaliacao_p bigint, nr_seq_item_p bigint) FROM PUBLIC;

