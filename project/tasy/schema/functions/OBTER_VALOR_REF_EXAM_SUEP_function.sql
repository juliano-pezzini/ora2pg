-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_ref_exam_suep (nr_seq_exame_p bigint, ie_tipo_valor_p bigint, ie_opcao_p text, nr_seq_resultado_p bigint default 0, nr_seq_lab_result_item_p bigint default 0) RETURNS varchar AS $body$
DECLARE

/*
ie_tipo_valor_p
0 = Valor referencia da tabela EXAME_LAB_PADRAO

ie_opcao_p
MAX = Valor maximo
MIN - Valor minimo
*/
qt_valor_w	exame_lab_padrao.qt_maxima%type;	

qtd_reg_lab_fleury_w integer;
is_referencia_valida_fleury_w integer;

ds_referencia_fleury_min_w  exame_lab_result_item.ds_referencia%type;
ds_referencia_fleury_max_w  exame_lab_result_item.ds_referencia%type;


BEGIN

if (nr_seq_resultado_p > 0 and nr_seq_lab_result_item_p > 0) then

  select count(1)
  into STRICT qtd_reg_lab_fleury_w
  from exame_lab_result_item
  where nr_seq_resultado = nr_seq_resultado_p
  and nr_sequencia = nr_seq_lab_result_item_p;

  select position(' a ' in ds_referencia)
  into STRICT is_referencia_valida_fleury_w
  from exame_lab_result_item
  where nr_seq_resultado = nr_seq_resultado_p
  and nr_sequencia = nr_seq_lab_result_item_p;

  if (qtd_reg_lab_fleury_w > 0 and is_referencia_valida_fleury_w > 0)  then

    select substr(ds_referencia, 0, position(' a ' in ds_referencia)),
          substr(ds_referencia, position(' a ' in ds_referencia) +3)
    into STRICT ds_referencia_fleury_min_w,
        ds_referencia_fleury_max_w
    from exame_lab_result_item 
    where nr_seq_resultado = nr_seq_resultado_p
    and nr_sequencia = nr_seq_lab_result_item_p;

    if (ie_opcao_p = 'MIN') then
      return ds_referencia_fleury_min_w;
    elsif (ie_opcao_p = 'MAX') then
      return ds_referencia_fleury_max_w;
    end if;
  end if;

end if;


if (ie_opcao_p = 'MAX') then

	select	coalesce(max(qt_maxima),'0')
	into STRICT	qt_valor_w
	from 	exame_lab_padrao
	where 	nr_seq_exame = nr_seq_exame_p
	and		ie_tipo_valor = ie_tipo_valor_p;

elsif (ie_opcao_p = 'MIN') then

	select	coalesce(min(qt_minima),'0')
	into STRICT	qt_valor_w
	from 	exame_lab_padrao
	where 	nr_seq_exame = nr_seq_exame_p
	and 	ie_tipo_valor = ie_tipo_valor_p;

end if;

return	qt_valor_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_ref_exam_suep (nr_seq_exame_p bigint, ie_tipo_valor_p bigint, ie_opcao_p text, nr_seq_resultado_p bigint default 0, nr_seq_lab_result_item_p bigint default 0) FROM PUBLIC;
