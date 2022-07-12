-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_result_avaliacao ( nr_seq_avaliacao_p bigint, nr_seq_item_p bigint) RETURNS varchar AS $body$
DECLARE

/*
  S - Seleção Simples
  O - Valor Domínio
*/
ds_resultado_w                     varchar(2000);
qt_resultado_w                     double precision;
ds_result_ref_w                    varchar(255);
ie_resultado_w                     varchar(02);
cd_dominio_w                       bigint;


BEGIN
ds_resultado_w                     := '';
select 	ie_resultado,
		cd_dominio
into STRICT	ie_resultado_w,
		cd_dominio_w
from       	med_item_avaliar
where 		nr_sequencia = nr_seq_item_p;

select 	max(obter_result_avaliacao(nr_seq_avaliacao_p,nr_seq_item_p))
into STRICT       	ds_resultado_w
;

if (ie_resultado_w = 'O') then
	begin
   	select          coalesce(max(cd_dominio),0)
   	into STRICT            cd_dominio_w
   	from            Med_item_avaliar
   	where           nr_sequencia    = nr_seq_item_p;

   	select          max(ds_valor_dominio)
   	into STRICT            ds_resultado_w
   	from            med_valor_dominio
   	where           nr_seq_dominio  = cd_dominio_w
   	and           vl_dominio              = ds_resultado_w;
   	end;
elsif (ie_resultado_w = 'S') then
   	begin

	if (coalesce(cd_dominio_w::text, '') = '') then

		select	coalesce(max(ds_resultado),''),
				coalesce(max(qt_resultado),0)
		into STRICT	ds_result_ref_w,
				qt_resultado_w
		from	med_item_avaliar_res
		where	nr_seq_item             = nr_seq_item_p
		and		nr_seq_res              = somente_numero(ds_resultado_w);

		if (coalesce(qt_resultado_w,0) <> 0) then
			 ds_resultado_w  := qt_resultado_w;
		elsif (ds_result_ref_w IS NOT NULL AND ds_result_ref_w::text <> '') then
			 ds_resultado_w  := ds_result_ref_w;
		end if;

	elsif (cd_dominio_w IS NOT NULL AND cd_dominio_w::text <> '') then

		select	coalesce(max(ds_valor_dominio),'')
		into STRICT	ds_resultado_w
		from	med_valor_dominio
		where	nr_seq_dominio = cd_dominio_w
		and		vl_dominio = ds_resultado_w;
	end if;

   end;
end if;
RETURN ds_resultado_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_result_avaliacao ( nr_seq_avaliacao_p bigint, nr_seq_item_p bigint) FROM PUBLIC;

