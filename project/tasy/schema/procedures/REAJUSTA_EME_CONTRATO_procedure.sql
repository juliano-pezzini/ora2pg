-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reajusta_eme_contrato ( nr_seq_regra_preco_p bigint, nr_seq_cobertura_p bigint, vl_valor_p bigint, vl_porcento_p bigint, cd_contrato_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_contrato_w		bigint;
nr_seq_regra_preco_w		bigint;
ie_reajuste_w			varchar(3);
ie_base_calculo_w		varchar(1);
nr_sequencia_w		bigint;
vl_preco_individual_w	double precision;
vl_preco_usuario_w		double precision;
dt_anual_w			timestamp;
dt_mensal_w			timestamp;
dt_trimestre_w		timestamp;
dt_vigencia_w			timestamp;
qt_minima_w			integer;
qt_maxima_w			integer;
vl_preco_w			double precision;
vl_fixo_w			double precision;
nr_seq_preco_w		bigint;
vl_percentual_w		double precision;
dt_ultimo_reajuste_w		timestamp;

C01 CURSOR FOR
	SELECT		a.nr_sequencia,
			a.nr_seq_regra_preco,
			a.ie_reajuste,
			coalesce(a.dt_ultimo_reajuste,a.dt_contrato)
	from		eme_contrato a
	where		a.nr_seq_regra_preco	= coalesce(nr_seq_regra_preco_p, nr_seq_regra_preco)
	and		a.nr_seq_cobertura	= coalesce(nr_seq_cobertura_p, nr_seq_cobertura)
	and		a.cd_contrato 	= coalesce(cd_contrato_p,cd_contrato)
	and		coalesce(a.dt_cancelamento::text, '') = ''
	order by	a.nr_sequencia;

C02 CURSOR FOR
	SELECT		max(b.dt_vigencia),
			b.qt_minima,
			b.qt_maxima
	from		eme_contrato a,
			eme_contrato_preco b
	where		a.nr_sequencia	= b.nr_seq_contrato
	and		b.nr_seq_contrato	= nr_seq_contrato_w
	and		b.dt_vigencia		<= clock_timestamp()
	group by 	b.qt_minima,
		 	b.qt_maxima;

C03 CURSOR FOR
	SELECT	nr_sequencia,
		coalesce(vl_preco,0)
	from	eme_pf_contrato
	where	nr_seq_contrato = nr_seq_contrato_w;


BEGIN

OPEN C01;
LOOP
FETCH C01 INTO
	nr_seq_contrato_w,
	nr_seq_regra_preco_w,
	ie_reajuste_w,
	dt_ultimo_reajuste_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	select	PKG_DATE_UTILS.ADD_MONTH(PKG_DATE_UTILS.start_of(clock_timestamp(), 'ddd', 0),-12,0),
		PKG_DATE_UTILS.ADD_MONTH(PKG_DATE_UTILS.start_of(clock_timestamp(), 'ddd', 0),-1,0),
		PKG_DATE_UTILS.ADD_MONTH(PKG_DATE_UTILS.start_of(clock_timestamp(), 'ddd', 0),-3,0)
	into STRICT	dt_anual_w,
		dt_mensal_w,
		dt_trimestre_w
	;

	select	ie_base_calculo
	into STRICT	ie_base_calculo_w
	from	eme_regra_preco
	where	nr_sequencia = nr_seq_regra_preco_w;

	if (ie_base_calculo_w = 'I') then
		begin
		if	(((ie_reajuste_w = 'A') and (dt_anual_w >= PKG_DATE_UTILS.start_of(dt_ultimo_reajuste_w, 'ddd', 0))) or
			((ie_reajuste_w = 'M') and (dt_mensal_w >= PKG_DATE_UTILS.start_of(dt_ultimo_reajuste_w, 'ddd', 0))) or
			((ie_reajuste_w = 'T') and (dt_trimestre_w >= PKG_DATE_UTILS.start_of(dt_ultimo_reajuste_w, 'ddd', 0))))then
			begin
			OPEN C03;
			LOOP
			FETCH C03 INTO
				nr_sequencia_w,
				vl_preco_individual_w;
			EXIT WHEN NOT FOUND; /* apply on C03 */
				begin
				vl_preco_usuario_w := 0;

				if (vl_valor_p IS NOT NULL AND vl_valor_p::text <> '') then
					vl_preco_usuario_w	:= vl_valor_p;
				else
					vl_preco_usuario_w	:= (dividir((vl_preco_individual_w * vl_porcento_p),100) + vl_preco_individual_w);
				end if;

				update	eme_pf_contrato
				set	vl_preco = vl_preco_usuario_w
				where	nr_sequencia = nr_sequencia_w;
				end;
			END LOOP;
			CLOSE C03;
			update	eme_contrato
			set	dt_ultimo_reajuste = clock_timestamp()
			where	nr_sequencia = nr_seq_contrato_w;
			end;
		end if;
		end;
	elsif (ie_base_calculo_w in ('A','U','H','F')) then
		begin
		OPEN C02;
		LOOP
		FETCH C02 INTO
			dt_vigencia_w,
			qt_minima_w,
			qt_maxima_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			if	(((ie_reajuste_w = 'A') and (dt_anual_w >= PKG_DATE_UTILS.start_of(dt_vigencia_w, 'ddd', 0))) or
				((ie_reajuste_w = 'M') and (dt_mensal_w >= PKG_DATE_UTILS.start_of(dt_vigencia_w, 'ddd', 0))) or
				((ie_reajuste_w = 'T') and (dt_trimestre_w >= PKG_DATE_UTILS.start_of(dt_vigencia_w, 'ddd', 0))))then
				begin
				select	vl_preco,
					vl_fixo
				into STRICT	vl_preco_w,
					vl_fixo_w
				from	eme_contrato_preco
				where	dt_vigencia	= dt_vigencia_w
				and	qt_minima	= qt_minima_w
				and	qt_maxima	= qt_maxima_w
				and	nr_seq_contrato	= nr_seq_contrato_w;

				select	nextval('eme_contrato_preco_seq')
				into STRICT	nr_seq_preco_w
				;

				if (vl_valor_p IS NOT NULL AND vl_valor_p::text <> '') then
					insert	into eme_contrato_preco(
							nr_sequencia,
							nr_seq_contrato,
							dt_atualizacao,
							nm_usuario,
							dt_vigencia,
							qt_minima,
							qt_maxima,
							vl_preco,
							vl_fixo)
					values (	nr_seq_preco_w,
							nr_seq_contrato_w,
							clock_timestamp(),
							nm_usuario_p,
							PKG_DATE_UTILS.start_of(clock_timestamp(), 'ddd', 0),
							qt_minima_w,
							qt_maxima_w,
							vl_valor_p,
							vl_fixo_w);
				elsif (vl_porcento_p IS NOT NULL AND vl_porcento_p::text <> '') then
					begin
					vl_percentual_w	:= (dividir((vl_preco_w * vl_porcento_p),100) + vl_preco_w);
					insert	into eme_contrato_preco(
							nr_sequencia,
							nr_seq_contrato,
							dt_atualizacao,
							nm_usuario,
							dt_vigencia,
							qt_minima,
							qt_maxima,
							vl_preco,
							vl_fixo)
					values (	nr_seq_preco_w,
							nr_seq_contrato_w,
							clock_timestamp(),
							nm_usuario_p,
							PKG_DATE_UTILS.start_of(clock_timestamp(), 'ddd', 0),
							qt_minima_w,
							qt_maxima_w,
							vl_percentual_w,
							vl_fixo_w);
					end;
				end if;
				if	((vl_valor_p IS NOT NULL AND vl_valor_p::text <> '') or (vl_porcento_p IS NOT NULL AND vl_porcento_p::text <> '')) then
					update	eme_contrato
					set	dt_ultimo_reajuste = clock_timestamp()
					where	nr_sequencia = nr_seq_contrato_w;
				end if;
				end;
			end if;
			end;
		END LOOP;
		CLOSE C02;
		end;
	end if;
	end;
END LOOP;
CLOSE C01;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reajusta_eme_contrato ( nr_seq_regra_preco_p bigint, nr_seq_cobertura_p bigint, vl_valor_p bigint, vl_porcento_p bigint, cd_contrato_p text, nm_usuario_p text) FROM PUBLIC;

