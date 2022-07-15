-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_shoppingcart_material (nr_sequencia_p bigint, ie_retrogrado_p text, ds_retorno_p INOUT text) AS $body$
DECLARE


qt_count_w	bigint;
ie_return_value_w	varchar(1);

c01 CURSOR FOR
SELECT  a.*, obter_setor_atendimento(nr_atendimento) cd_setor_atend
from 	cpoe_material a
where	nr_sequencia = nr_sequencia_p;

BEGIN
ds_retorno_p := 'S';

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then

	for r_c01_w in C01
	loop
		/* CAMPOS OBRIGATORIOS  */

		if (coalesce(r_c01_w.cd_material::text, '') = '' or coalesce(r_c01_w.cd_intervalo::text, '') = ''
			or coalesce(r_c01_w.dt_inicio::text, '') = '' or coalesce(r_c01_w.qt_dose::text, '') = '' 
			or coalesce(r_c01_w.cd_unidade_medida::text, '') = '' or coalesce(r_c01_w.dt_fim::text, '') = '') then
			ds_retorno_p := 'N';
			goto return_value;
		end if;
		
		
		if (cpoe_shoppingcart_vigencia(r_c01_w.cd_intervalo, 'P', r_c01_w.dt_inicio,
						r_c01_w.ie_urgencia, r_c01_w.ie_duracao,r_c01_w.dt_fim, 'N', ie_retrogrado_p) = 'S') then
			ds_retorno_p := 'N';
			goto return_value;
		end if;
		
		/* FIM CAMPOS OBRIGATORIOS  */


		
		
		/* CUSTOM VALIDATOR */

		
		if ((r_c01_w.cd_material IS NOT NULL AND r_c01_w.cd_material::text <> '') and coalesce(r_c01_w.qt_dose,0) = 0) then
			ds_retorno_p := 'N';
			goto return_value;
		end if;
		
		/* FIM CUSTOM VALIDATOR */



		/* INCONSISTÊNCIA DA CPOE (BARRA VERMELHA) */


		/*DUPLICIDADE*/

		if (cpoe_shoppingcart_mat_duplic(r_c01_w.nr_sequencia, r_c01_w.nr_atendimento, r_c01_w.cd_setor_atend, r_c01_w.cd_pessoa_fisica, r_c01_w.cd_material, r_c01_w.dt_inicio, r_c01_w.dt_fim) = 'S') then
			ds_retorno_p := 'N';
			goto return_value;
		end if;

		/*LACTANTE*/

		if (obter_se_permite_lactante(r_c01_w.nr_atendimento, r_c01_w.cd_material) = 'N') then
			ds_retorno_p := 'N';
			goto return_value;
		end if;

		/*LATEX*/

		if (cpoe_shoppingcart_se_latex(r_c01_w.cd_material, r_c01_w.cd_pessoa_fisica) = 'S') then
			ds_retorno_p := 'N';
			goto return_value;
		end if;

		/* FIM INCONSISTÊNCIA DA CPOE (BARRA VERMELHA) */

	end loop;
end if;

<<return_value>>
 null;
exception when others then
	CALL gravar_log_cpoe(substr('CPOE_SHOPPINGCART_MATERIAL EXCEPTION:'|| substr(to_char(sqlerrm),1,2000) || '//nr_sequencia_p: '|| nr_sequencia_p,1,40000));
	ds_retorno_p := 'N';
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_shoppingcart_material (nr_sequencia_p bigint, ie_retrogrado_p text, ds_retorno_p INOUT text) FROM PUBLIC;

