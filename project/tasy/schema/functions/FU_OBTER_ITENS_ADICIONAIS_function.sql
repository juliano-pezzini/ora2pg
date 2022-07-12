-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fu_obter_itens_adicionais (nr_sequencia_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255) := null;
nr_retorno_w	varchar(255) := null;

ds_desc_w					varchar(255);
nr_seq_w					nut_atend_serv_dia_dieta.nr_sequencia%type;
qt_porcentagem_W			nut_atend_serv_dia_dieta.qt_porcentagem%type;
qt_dose_w					nut_atend_serv_dia_dieta.qt_dose%type;
cd_unidade_medida_dosa_w	nut_atend_serv_dia_dieta.cd_unidade_medida_dosa%type;


C01 CURSOR FOR
	SELECT SUBSTR(nut_obter_dados_produto(NR_SEQ_PRODUTO,'DS'),1,100),
			nr_sequencia,
			qt_porcentagem,
			qt_dose,
			cd_unidade_medida_dosa
	from  nut_atend_serv_dia_dieta
	where nr_sequencia_diluicao = nr_sequencia_p;


BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '' AND ie_opcao_p IS NOT NULL AND ie_opcao_p::text <> '') then
	open C01;
	loop
	fetch C01 into
		ds_desc_w,
		nr_seq_w,
		qt_porcentagem_W,
		qt_dose_w,
		cd_unidade_medida_dosa_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		if (qt_dose_w IS NOT NULL AND qt_dose_w::text <> '') then
			ds_retorno_w := ds_retorno_w||', '||ds_desc_w||'('||qt_dose_w||' '||cd_unidade_medida_dosa_w||')';
		else
			ds_retorno_w := ds_retorno_w||', '||ds_desc_w||' ('||qt_porcentagem_w||'%)';
		end if;

		nr_retorno_w := nr_retorno_w||', '||to_char(nr_seq_w);

		end;
	end loop;
	close C01;

	if (ie_opcao_p = 'DS') then
		return	substr(ds_retorno_w,3,255);
	else
		return substr(nr_retorno_w,3,255);
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fu_obter_itens_adicionais (nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;
