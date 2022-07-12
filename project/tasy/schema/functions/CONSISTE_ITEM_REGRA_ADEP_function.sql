-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION consiste_item_regra_adep ( nr_atendimento_p bigint, cd_material_p bigint, dt_horario_p timestamp) RETURNS varchar AS $body$
DECLARE


nr_sequencia_w		bigint;		-- Sequencia da regra a ser feito o tratamento
qt_minutos_w		smallint;		-- Quantidade de minutos antes do horário
ds_retorno_w		varchar(1);	-- Variável de retorno
cd_material_w		bigint;		-- Código do material que deve estar administrado
ie_material_adm_w	bigint;
/* Cursor para a busca dos medicamentos que devem estar administrados */

c01 CURSOR FOR
SELECT	cd_material
from	adep_regra_adm_mat_assoc
where	nr_seq_regra = nr_sequencia_w;


BEGIN
/* Se existir alguma regra retorna o nr_sequencia */

select	max(nr_sequencia),
		max(qt_minutos)
into STRICT	nr_sequencia_w,
		qt_minutos_w
from	adep_regra_adm_material
where	cd_material = cd_material_p;
/* Tratamento da regra */

if (nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '') then
	open c01;
	loop
	fetch c01 into cd_material_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		/* Verifica se o medicamento/material está administrado */

		select	count(*)
		into STRICT	ie_material_adm_w
		from	prescr_mat_hor	a,
				prescr_medica	b
		where	(a.dt_lib_horario IS NOT NULL AND a.dt_lib_horario::text <> '')
		and		(a.dt_fim_horario IS NOT NULL AND a.dt_fim_horario::text <> '')
		and 	coalesce(a.dt_suspensao::text, '') = ''
		and 	a.nr_prescricao = b.nr_prescricao
		and		b.nr_atendimento = nr_atendimento_p
		and 	a.cd_material = cd_material_w
		and		a.dt_horario > dt_horario_p - qt_minutos_w/1440;

		/* Faz o tratamento do retorno */

		if (ie_material_adm_w = 0) then
			ds_retorno_w := 'N';	-- Não há itens administrados
			exit;
		else
			ds_retorno_w := 'S';	-- Existe algum item administrado
		end	if;
		end;
	end loop;
	close c01;
else
	ds_retorno_w := 'S';			-- Caso não tenha regra retorna como default 'S'
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION consiste_item_regra_adep ( nr_atendimento_p bigint, cd_material_p bigint, dt_horario_p timestamp) FROM PUBLIC;
