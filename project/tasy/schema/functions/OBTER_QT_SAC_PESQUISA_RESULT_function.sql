-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_sac_pesquisa_result (nr_seq_item_p bigint, ds_resultado_p text, ds_item_unidade_p text, dt_inicial_p timestamp, dt_final_p timestamp) RETURNS bigint AS $body$
DECLARE


/* Não alterar
Fuction feita para Voluntários, OS 13009
*/
cont_w		bigint;


BEGIN

if (ds_item_unidade_p IS NOT NULL AND ds_item_unidade_p::text <> '') then /*Inclui este if para a OS 36527 */
	if (nr_seq_item_p IS NOT NULL AND nr_seq_item_p::text <> '') then
		select	count(*)
		into STRICT	cont_w
		from	med_item_avaliar c,
			sac_pesquisa_result b,
			sac_pesquisa a
		where	a.nr_sequencia	= b.nr_seq_pesquisa
		and	b.nr_seq_item	= c.nr_sequencia
		and	c.nr_sequencia	= nr_seq_item_p
		and	(b.qt_resultado	= ds_resultado_p
			or	((coalesce(ds_resultado_p::text, '') = '') and (b.qt_resultado in (0,1,2,3,4,5))))
		and	trunc(a.dt_avaliacao, 'dd')	between dt_inicial_p and dt_final_p
		and	exists (SELECT	1
			from	sac_pesquisa_result y,
				med_item_avaliar x
			where	x.nr_sequencia		= 2745
			and	x.nr_sequencia		= y.nr_seq_item
			and	y.nr_seq_pesquisa	= a.nr_sequencia
			and	y.qt_resultado		= ds_item_unidade_p);
	else
		select	count(*)
		into STRICT	cont_w
		from	med_item_avaliar c,
			sac_pesquisa_result b,
			sac_pesquisa a
		where	a.nr_sequencia	= b.nr_seq_pesquisa
		and	b.nr_seq_item	= c.nr_sequencia
		and	c.nr_sequencia	= nr_seq_item_p
		and	(b.qt_resultado	= ds_resultado_p
			or	((coalesce(ds_resultado_p::text, '') = '') and (b.qt_resultado in (0,1,2,3,4,5))))
		and	trunc(a.dt_avaliacao, 'dd')	between dt_inicial_p and dt_final_p
		and	exists (SELECT	1
			from	sac_pesquisa_result y,
				med_item_avaliar x
			where	x.nr_sequencia		= 2745
			and	x.nr_sequencia		= y.nr_seq_item
			and	y.nr_seq_pesquisa	= a.nr_sequencia
			and	y.qt_resultado		= ds_item_unidade_p);
	end if;
else
	if (nr_seq_item_p IS NOT NULL AND nr_seq_item_p::text <> '') then
		select	count(*)
		into STRICT	cont_w
		from	med_item_avaliar c,
			sac_pesquisa_result b,
			sac_pesquisa a
		where	a.nr_sequencia	= b.nr_seq_pesquisa
		and	b.nr_seq_item	= c.nr_sequencia
		and	c.nr_sequencia	= nr_seq_item_p
		and	(b.qt_resultado	= ds_resultado_p
			or	((coalesce(ds_resultado_p::text, '') = '') and (b.qt_resultado in (0,1,2,3,4,5))))
		and	trunc(a.dt_avaliacao, 'dd')	between dt_inicial_p and dt_final_p;
	else
		select	count(*)
		into STRICT	cont_w
		from	med_item_avaliar c,
			sac_pesquisa_result b,
			sac_pesquisa a
		where	a.nr_sequencia	= b.nr_seq_pesquisa
		and	b.nr_seq_item	= c.nr_sequencia
		and	c.nr_sequencia	= nr_seq_item_p
		and	(b.qt_resultado	= ds_resultado_p
			or	((coalesce(ds_resultado_p::text, '') = '') and (b.qt_resultado in (0,1,2,3,4,5))))
		and	trunc(a.dt_avaliacao, 'dd')	between dt_inicial_p and dt_final_p;
	end if;
end if;

return	cont_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_sac_pesquisa_result (nr_seq_item_p bigint, ds_resultado_p text, ds_item_unidade_p text, dt_inicial_p timestamp, dt_final_p timestamp) FROM PUBLIC;
