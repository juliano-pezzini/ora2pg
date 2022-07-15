-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE nut_delete_cardapio_dia ( dt_vigencia_inicial_p text, dt_vigencia_final_p text, ie_semana_p text) AS $body$
BEGIN

if((dt_vigencia_inicial_p IS NOT NULL AND dt_vigencia_inicial_p::text <> '')
	and (dt_vigencia_final_p IS NOT NULL AND dt_vigencia_final_p::text <> '')
	and (ie_semana_p IS NOT NULL AND ie_semana_p::text <> '')) then
	
	delete 	from 	nut_cardapio_refeicao b
	where 	exists (SELECT a.nr_sequencia
			from	nut_cardapio_dia a
			where	a.dt_vigencia_inicial 	>= to_date(dt_vigencia_inicial_p, 'dd/mm/yyyy')
			and	a.dt_vigencia_final	<= to_date(dt_vigencia_final_p, 'dd/mm/yyyy')
			and	obter_se_contido(a.ie_semana,ie_semana_p)  = 'S'
			and	a.nr_sequencia = b.nr_seq_cardapio_dia
			and 	a.cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento);
	
	delete	from NUT_CARDAPIO_DIA
	where	dt_vigencia_inicial 	>= to_date(dt_vigencia_inicial_p, 'dd/mm/yyyy')
	and	dt_vigencia_final	<= to_date(dt_vigencia_final_p, 'dd/mm/yyyy')
	and	obter_se_contido(ie_semana,ie_semana_p)  = 'S'
	and 	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;
	
commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nut_delete_cardapio_dia ( dt_vigencia_inicial_p text, dt_vigencia_final_p text, ie_semana_p text) FROM PUBLIC;

