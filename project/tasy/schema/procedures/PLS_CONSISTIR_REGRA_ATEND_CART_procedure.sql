-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_regra_atend_cart ( nr_seq_segurado_p bigint, nr_seq_regra_atend_cart_p bigint, ie_glosou_p INOUT text) AS $body$
DECLARE


cd_usuario_plano_w		varchar(30);
cd_faixa_carteira_w		varchar(30);
ie_glosou_w			varchar(1)	:= 'N';
nr_seq_oc_atend_cart_regra_w	bigint;
qt_pos_inicio_w			bigint;
qt_pos_final_w			bigint;

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.qt_pos_inicio,
		a.qt_pos_final
	from	pls_oc_atend_cart_regra	a
	where	a.nr_seq_regra	= nr_seq_regra_atend_cart_p;

C02 CURSOR FOR
	SELECT	a.cd_carteira
	from	pls_oc_atend_cart_cod	a
	where	a.nr_seq_regra_cart	= nr_seq_oc_atend_cart_regra_w
	and	a.cd_carteira 		= cd_faixa_carteira_w;

BEGIN

if (nr_seq_segurado_p IS NOT NULL AND nr_seq_segurado_p::text <> '') then
	select	pls_obter_dados_segurado(a.nr_sequencia,'C')
	into STRICT	cd_usuario_plano_w
	from	pls_segurado	a
	where	a.nr_sequencia	= nr_seq_segurado_p;

	open C01;
	loop
	fetch C01 into
		nr_seq_oc_atend_cart_regra_w,
		qt_pos_inicio_w,
		qt_pos_final_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		cd_faixa_carteira_w	:= substr(cd_usuario_plano_w,qt_pos_inicio_w,(qt_pos_final_w - qt_pos_inicio_w)+1);
		for r_c02_w in C02() loop
			begin

				ie_glosou_w	:= 'S';
				exit;

			end;
		end loop;

		if (ie_glosou_w = 'S') then
			exit;
		end if;
		end;
	end loop;
	close c01;
end if;

ie_glosou_p	:= ie_glosou_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_regra_atend_cart ( nr_seq_segurado_p bigint, nr_seq_regra_atend_cart_p bigint, ie_glosou_p INOUT text) FROM PUBLIC;

