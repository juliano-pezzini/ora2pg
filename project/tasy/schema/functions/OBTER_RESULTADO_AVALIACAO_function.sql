-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_resultado_avaliacao ( nr_seq_avaliacao_p bigint, nr_seq_item_p bigint, nr_seq_tipo_avaliacao_p bigint, nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ie_tipo_item_w		varchar(10);
ds_regra_w		varchar(4000);
ds_resultado_w		varchar(4000);
ds_resultado_aval_w	varchar(4000);
qt_resultado_aval_w	double precision;
ds_resultado_regra_w	varchar(255);
nr_posicao_regra_w	bigint;
nr_dominio_w bigint;
ds_result_long_w text;



BEGIN

--Selecionar o tipo de retorno do resultado
select	ie_resultado,
	ds_regra,CD_DOMINIO
	into STRICT	ie_tipo_item_w,
	ds_regra_w,nr_dominio_w
	from	med_item_avaliar
	where	nr_sequencia	= nr_seq_item_p
	and	nr_seq_tipo	= nr_seq_tipo_avaliacao_p;

--Resultado de acordo com o tipo
if (ie_tipo_item_w in ('Z','C','D','A','O','R')) then
	begin
	select	ds_resultado
	into STRICT	ds_resultado_aval_w
	from	med_avaliacao_result
	where	nr_seq_avaliacao	= nr_seq_avaliacao_p
	and	nr_seq_item		= nr_seq_item_p;
	ds_resultado_w	:= ds_resultado_aval_w;
	end;
elsif (ie_tipo_item_w in ('B','V','S','L','E','U')) then
	begin
	begin
	select	qt_resultado
	into STRICT	qt_resultado_aval_w
	from	med_avaliacao_result
	where	nr_seq_avaliacao	= nr_seq_avaliacao_p
	and	nr_seq_item		= nr_seq_item_p;

if ((nr_dominio_w IS NOT NULL AND nr_dominio_w::text <> '') and ie_tipo_item_w = 'U') then
  select max(DS_VALOR_DOMINIO) into STRICT ds_resultado_w from MED_VALOR_DOMINIO where vl_dominio = qt_resultado_aval_w and NR_SEQ_DOMINIO = nr_dominio_w;
  end if;

if (ie_tipo_item_w in ('L','E') and coalesce(qt_resultado_aval_w::text, '') = '') then
	select ds_result_long into STRICT	ds_result_long_w	from	med_avaliacao_result 	where	nr_seq_avaliacao	= nr_seq_avaliacao_p and	nr_seq_item		= nr_seq_item_p;
  ds_resultado_w := substr(ds_result_long_w,1,400);
  end if;


	exception
		when others then
			qt_resultado_aval_w := null;
	end;

	if (ie_tipo_item_w = 'B') then
		if (qt_resultado_aval_w = 1) then
			ds_resultado_w	:= Wheb_mensagem_pck.get_texto(309672); --'Sim';
		else	
			ds_resultado_w	:= Wheb_mensagem_pck.get_texto(309673); --'No';
		end if;
	elsif (ie_tipo_item_w in ('S','E')) then

		if (ds_regra_w IS NOT NULL AND ds_regra_w::text <> '') then

			nr_posicao_regra_w := (position(';' in ds_regra_w))::numeric;
			
			if (nr_posicao_regra_w > 0) then
				ds_resultado_w := substr(ds_regra_w, 1, nr_posicao_regra_w-1);
			else		
				ds_resultado_w := substr(ds_regra_w, 1, 2000);
			end if;
			
			if (ie_tipo_item_w = 'S') then
				ds_resultado_w := 'select ds from (' || ds_resultado_w ||') where cd = :cd';
			end if;

			select	substr(obter_select_concatenado_bv(ds_resultado_w,'cd='|| qt_resultado_aval_w,''),1,2000)
			into STRICT	ds_resultado_w
			;
		else
			select	ds_resultado
			into STRICT	ds_resultado_w
			from	med_item_avaliar_res
			where	nr_seq_item	= nr_seq_item_p
			and	nr_seq_res	= qt_resultado_aval_w;
		end if;
	else
		ds_resultado_w	:= qt_resultado_aval_w;
	end if;
	end;
elsif (ie_tipo_item_w in ('X','H','T')) then
	ds_resultado_w	:= '';
end if;

return ds_resultado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_resultado_avaliacao ( nr_seq_avaliacao_p bigint, nr_seq_item_p bigint, nr_seq_tipo_avaliacao_p bigint, nr_atendimento_p bigint) FROM PUBLIC;

