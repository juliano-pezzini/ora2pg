-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE executa_regra_calculo_rxt ( ie_opcao_p text, nr_sequencia_p bigint) AS $body$
DECLARE


ds_formula_aux_w	varchar(80);
ds_formula_w	varchar(80);
ie_campo_w	varchar(2);
ie_tipo_w	varchar(1);
ie_tipo_x_w	varchar(1);
ie_tipo_y_w	varchar(1);
ie_situacao_w	varchar(1);
qt_regra_w	bigint;
qt_x_w	double precision;
qt_x1_w	double precision;
qt_x2_w	double precision;
qt_y_w	double precision;
qt_y1_w	double precision;
qt_y2_w	double precision;

C01 CURSOR FOR
	SELECT	ds_formula,
		ie_campo,
		ie_tipo
	from	rxt_regra_calculo_campo
	where	ie_situacao = 'A'
	order by ie_ordem;


BEGIN

	select	count(nr_sequencia)
	into STRICT	qt_regra_w
	from	rxt_regra_calculo_campo
	where	ie_situacao = 'A';

	if((ie_opcao_p IS NOT NULL AND ie_opcao_p::text <> '')
	and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '')
	and (qt_regra_w > 0)) then
		if (ie_opcao_p = 'CF')then
			select	qt_tam_x,
				qt_x1,
				qt_x2,
				qt_tam_y,
				qt_y1,
				qt_y2,
				ie_tipo_x,
				ie_tipo_y
			into STRICT 	qt_x_w,
				qt_x1_w,
				qt_x2_w,
				qt_Y_w,
				qt_y1_w,
				qt_y2_w,
				ie_tipo_x_w,
				ie_tipo_y_w
			from	rxt_campo
			where	nr_sequencia = nr_sequencia_p;
		elsif (ie_opcao_p = 'PF') then
			select	qt_tam_x,
				qt_x1,
				qt_x2,
				qt_tam_y,
				qt_y1,
				qt_y2,
				ie_tipo_x,
				ie_tipo_y
			into STRICT 	qt_x_w,
				qt_x1_w,
				qt_x2_w,
				qt_Y_w,
				qt_y1_w,
				qt_y2_w,
				ie_tipo_x_w,
				ie_tipo_y_w
			from	rxt_planejamento_fisico
			where	nr_sequencia = nr_sequencia_p;
		end if;

		open C01;
		loop
		fetch C01 into
			ds_formula_w,
			ie_campo_w,
			ie_tipo_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
			if((ie_campo_w in ('X','X1','X2') and ie_tipo_x_w = ie_tipo_w)
			or (ie_campo_w in ('Y','Y1','Y2') and ie_tipo_y_w = ie_tipo_w))then

				ds_formula_aux_w := ds_formula_w;
				ds_formula_aux_w := replace_macro(ds_formula_aux_w, '@X1', to_char(qt_x1_w));
				ds_formula_aux_w := replace_macro(ds_formula_aux_w, '@X2', to_char(qt_x2_w));
				ds_formula_aux_w := replace_macro(ds_formula_aux_w, '@Y1', to_char(qt_y1_w));
				ds_formula_aux_w := replace_macro(ds_formula_aux_w, '@Y2', to_char(qt_y2_w));
				ds_formula_aux_w := replace_macro(ds_formula_aux_w, '@X', to_char(qt_x_w));
				ds_formula_aux_w := replace_macro(ds_formula_aux_w, '@Y', to_char(qt_y_w));
				ds_formula_aux_w := replace_macro(ds_formula_aux_w,',','.');

				if (ie_campo_w = 'X') then
					qt_x_w := obter_valor_dinamico('select ' || ds_formula_aux_w || ' from dual', qt_x_w);
				elsif (ie_campo_w = 'Y') then
					qt_y_w := obter_valor_dinamico('select ' || ds_formula_aux_w || ' from dual', qt_y_w);
				elsif (ie_campo_w = 'X1') then
					qt_x1_w := obter_valor_dinamico('select ' || ds_formula_aux_w || ' from dual', qt_x1_w);
				elsif (ie_campo_w = 'X2') then
					qt_x2_w := obter_valor_dinamico('select ' || ds_formula_aux_w || ' from dual', qt_x2_w);
				elsif (ie_campo_w = 'Y1') then
					qt_y1_w := obter_valor_dinamico('select ' || ds_formula_aux_w || ' from dual', qt_y1_w);
				elsif (ie_campo_w = 'Y2') then
					qt_y2_w := obter_valor_dinamico('select ' || ds_formula_aux_w || ' from dual', qt_y2_w);
				end if;
			end if;
			end;
		end loop;
		close C01;

		if (ie_opcao_p = 'CF') then
			update	rxt_campo
			set	qt_tam_x = qt_x_w,
				qt_x1 = qt_x1_w,
				qt_x2 = qt_x2_w,
				qt_tam_y = qt_y_w,
				qt_y1 = qt_y1_w,
				qt_y2 = qt_y2_w
			where	nr_sequencia = nr_sequencia_p;
		elsif (ie_opcao_p = 'PF') then
			update	rxt_planejamento_fisico
			set	qt_tam_x = qt_x_w,
				qt_x1 = qt_x1_w,
				qt_x2 = qt_x2_w,
				qt_tam_y = qt_y_w,
				qt_y1 = qt_y1_w,
				qt_y2 = qt_y2_w
			where	nr_sequencia = nr_sequencia_p;
		end if;
		commit;
	end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE executa_regra_calculo_rxt ( ie_opcao_p text, nr_sequencia_p bigint) FROM PUBLIC;
