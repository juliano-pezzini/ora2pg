-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION aval_e ( nr_seq_avaliacao_p bigint, nr_seq_item_p bigint) RETURNS varchar AS $body$
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
  U - Seleção Simples (Radio Group);
*/
ds_resultado_w			varchar(4000);
qt_resultado_w			double precision;
ie_resultado_w			varchar(02);
cd_funcao_w			integer;
cd_dominio_w			integer;
ds_complemento_w			varchar(4000);

i				integer;
ds_texto_w			varchar(255);
qt_reg_w			bigint;



BEGIN


select		coalesce(a.cd_funcao, 0)
into STRICT		cd_funcao_w
from		med_item_avaliar b,
		med_tipo_avaliacao a
where		a.nr_sequencia	= b.nr_seq_tipo
and		b.nr_sequencia	= nr_seq_item_p;


ds_resultado_w			:= '';

select	ie_resultado,
	cd_dominio,
	ds_complemento || ';'
into STRICT 	ie_resultado_w,
	cd_dominio_w,
	ds_complemento_w
from 	med_item_avaliar
where nr_sequencia	= nr_seq_item_p;


select		max(qt_resultado),
		max(ds_resultado)
into STRICT 		qt_resultado_w,
		ds_resultado_w
from		orientacao_alta_enf_result
where		NR_SEQ_ORIENTACAO	= nr_seq_avaliacao_p
and		nr_seq_item		= nr_seq_item_p;



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
elsif (ie_resultado_w = 'U') then	/*Elemar e Philippe OS 186211*/
	ds_resultado_w	:= '';
	if (coalesce(cd_dominio_w::text, '') = '') then
		for i in 0..100 loop
			ds_texto_w		:= substr(ds_complemento_w, 1, position(';' in ds_complemento_w) - 1);
			ds_complemento_w        := replace(ds_complemento_w, ds_texto_w || ';', '');
			if (i = qt_resultado_w) then
				ds_resultado_w	:= ds_texto_w;
				exit;
			end if;
		end loop;
	else
		select	coalesce(max(ds_valor_dominio),'')
		into STRICT	ds_resultado_w
		from	med_valor_dominio
		where	nr_seq_dominio = cd_dominio_w
		  and	(vl_dominio)::numeric  = qt_resultado_w;
	end if;
	if (coalesce(ds_resultado_w,'') = '') then
		ds_resultado_w	:= qt_resultado_w;
	end if;
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


select	count(*)
into STRICT	qt_reg_w
from	MED_ITEM_AVALIAR_RES
where	nr_seq_item	= nr_seq_item_p;

if (qt_reg_w	> 0) then
	select	coalesce(max(ds_resultado),DS_RESULTADO_W)
	into STRICT	DS_RESULTADO_W
	from	MED_ITEM_AVALIAR_RES
	where	nr_seq_item	= nr_seq_item_p
	and	NR_SEQ_RES	= qt_resultado_w;
end if;


return ds_resultado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION aval_e ( nr_seq_avaliacao_p bigint, nr_seq_item_p bigint) FROM PUBLIC;

