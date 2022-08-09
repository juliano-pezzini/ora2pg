-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_atualizar_volume_producao (nr_seq_producao_p bigint, nr_seq_prod_origem_p bigint, qt_volume_p bigint, qt_peso_bolsa_p bigint, ie_calc_peso_p text, nm_usuario_p text) AS $body$
DECLARE

qt_volume_w	bigint;
qt_peso_bolsa_w	bigint;
ie_tipo_bolsa_w	varchar(5);


BEGIN

if (nr_seq_producao_p IS NOT NULL AND nr_seq_producao_p::text <> '') then

	select	qt_volume,
		qt_peso_bolsa
	into STRICT	qt_volume_w,
		qt_peso_bolsa_w
	from	san_producao x
	where	x.nr_sequencia = nr_seq_prod_origem_p;

	if (ie_calc_peso_p = 'S') then

		update	san_producao
		set	qt_volume		= (coalesce(qt_volume_w,0) - coalesce(qt_volume_p,0)),
			nm_usuario		= nm_usuario_p
		where	nr_seq_prod_origem	= nr_seq_prod_origem_p
		and	nr_sequencia 		<> nr_seq_producao_p;

	end if;

	if (ie_calc_peso_p = 'P') then

		select	max(a.ie_tipo_bolsa)
		into STRICT	ie_tipo_bolsa_w
		from	san_doacao a,
			san_producao b
		where	a.nr_sequencia		= b.nr_seq_doacao
		and	b.nr_seq_prod_origem	= nr_seq_prod_origem_p;

		select	max(san_calc_volume_hemo(	nr_seq_derivado,
						qt_peso_bolsa,
						qt_peso_bolsa_vazia,
						nr_seq_conservante,
						cd_material,
						ie_tipo_bolsa_w))
		into STRICT	qt_volume_w
		from	san_producao y
		where	y.nr_seq_prod_origem	= nr_seq_prod_origem_p
		and	y.nr_sequencia		<> nr_seq_producao_p;


		update	san_producao
		set	qt_peso_bolsa		= (coalesce(qt_peso_bolsa_w,0) - coalesce(qt_peso_bolsa_p,0)),
			qt_volume		= qt_volume_w,
			nm_usuario		= nm_usuario_p
		where	nr_seq_prod_origem	= nr_seq_prod_origem_p
		and	nr_sequencia 		<> nr_seq_producao_p;



	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_atualizar_volume_producao (nr_seq_producao_p bigint, nr_seq_prod_origem_p bigint, qt_volume_p bigint, qt_peso_bolsa_p bigint, ie_calc_peso_p text, nm_usuario_p text) FROM PUBLIC;
