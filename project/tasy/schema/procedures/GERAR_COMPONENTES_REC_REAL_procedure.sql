-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_componentes_rec_real ( NM_USUARIO_P text, NR_SEQUENCIA_P bigint) AS $body$
DECLARE


nr_sequencia_w			bigint;
nr_seq_gen_alim_w		bigint;
qt_componente_w			double precision;
nr_seq_receita_w		bigint;
qt_refeicao_w			bigint;
qt_refeicao_real_w		bigint;
nr_seq_cardapio_w		bigint;

C01 CURSOR FOR
	SELECT	b.nr_seq_gen_alim,
		coalesce(b.qt_componente_calc,b.qt_componente,0),
		coalesce(a.qt_refeicao,1)
	FROM	Nut_receita_comp b,
		Nut_receita a
	WHERE	a.nr_sequencia	= nr_seq_receita_w
	  AND	b.nr_seq_receita	= a.nr_sequencia
	  AND NOT EXISTS (	SELECT	1
				FROM	nut_rec_real_comp c,
					nut_receita_real d
				where   c.nr_seq_rec_real = d.nr_sequencia
				and     d.nr_seq_cardapio = nr_seq_cardapio_w
				and	coalesce(c.nr_seq_gen_alim_sub,c.nr_seq_gen_alim) = b.nr_seq_gen_alim);


BEGIN

select	nr_seq_receita,
	coalesce(qt_refeicao,1),
	nr_seq_cardapio
into STRICT	nr_seq_receita_w,
	qt_refeicao_real_w,
	nr_seq_cardapio_w
from	nut_receita_real
where	nr_sequencia	= nr_sequencia_p;

DELETE 	FROM nut_rec_real_comp
WHERE	nr_seq_rec_real = nr_sequencia_p;

OPEN C01;
LOOP
	FETCH C01 INTO
		nr_seq_gen_alim_w,
		qt_componente_w,
		qt_refeicao_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	BEGIN

	select	nextval('nut_rec_real_comp_seq')
	into STRICT	nr_sequencia_w
	;

	--Tratamento para: se o qt_refeicao_w vier como 0 ele passar 1 para não dar erro na procedure.
	if (qt_refeicao_w = 0) then
		qt_refeicao_w := 1;
	end if;
	qt_componente_w	:= qt_componente_w * qt_refeicao_real_w / qt_refeicao_w;
	INSERT INTO nut_rec_real_comp(nr_sequencia, nr_seq_rec_real, nr_seq_gen_alim,
		 dt_atualizacao, nm_usuario, qt_componente, vl_custo, ie_comp_adicional)
	VALUES (nr_sequencia_w, nr_sequencia_p, nr_seq_gen_alim_w,
		 clock_timestamp(), nm_usuario_p , qt_componente_w, 0, 'N');
	END;
END LOOP;
CLOSE C01;
COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_componentes_rec_real ( NM_USUARIO_P text, NR_SEQUENCIA_P bigint) FROM PUBLIC;
