-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_calc_lacs_receita ( nr_seq_lote_p bigint ) AS $body$
DECLARE


vl_receitas_w		double precision := 0.0;  -- 01  Receitas - Resultado da Aplicao dos Percentuais
vl_outras_receitas_w	double precision := 0.0;  -- 02  Outras Receitas
vl_BCCSLL_w		double precision := 0.0;  -- 03  Base de Clculo da CSLL
vl_CSLLAA9_w		double precision := 0.0;  -- 04 CSLL Apurada - Alquota 9%
vl_deducoes_w		double precision := 0.0;  -- 05  Dedues
vl_deducoes_parte1_w	double precision := 0.0;  --06  Dedues parte 1
vl_deducoes_parte2_w	double precision := 0.0;  --07  Dedues parte 2
vl_CSLL_dma_w		double precision := 0.0;  -- 08  CSLL devida no mes anterior
vl_CSLL_dm_w		double precision := 0.0;  -- 09  CSLL devida no mes
vl_CSLL_pagar_w		double precision := 0.0;  -- 10  CSLL a Pagar
vl_atividade_w		double precision := 0.0;  -- 01  Atividade
vl_adicoes_w		double precision := 0.0;  -- 02  Adies
vl_exclusoes_w		double precision := 0.0;  -- 03  Excluses
vl_BCAC_w		double precision := 0.0;  -- 04  Base de Clculo Antes das Compensaes
vl_CBCNPA_w		double precision := 0.0;  --  05  (-) Compensao de BC Negativa de Perodos Anteriores
vl_auxiliar_w		double precision := 0.0;
vl_mes_ref_w		double precision := 0.0;
ds_comando_w		varchar(255);
ie_somar_w		varchar(2);
nr_mes_ref_w		integer;
dt_referencia_w		timestamp;
dt_mes_ant_ini_w	timestamp;
dt_mes_ant_fim_w	timestamp;
vl_mes_01_w		fis_calculo_estrut.vl_mes_01%type;
vl_mes_02_w		fis_calculo_estrut.vl_mes_02%type;
vl_mes_03_w		fis_calculo_estrut.vl_mes_03%type;
vl_mes_04_w     	fis_calculo_estrut.vl_mes_04%type;
vl_mes_05_w		fis_calculo_estrut.vl_mes_05%type;
vl_mes_06_w		fis_calculo_estrut.vl_mes_06%type;
vl_mes_07_w		fis_calculo_estrut.vl_mes_07%type;
vl_mes_08_w		fis_calculo_estrut.vl_mes_08%type;
vl_mes_09_w		fis_calculo_estrut.vl_mes_09%type;
vl_mes_10_w		fis_calculo_estrut.vl_mes_10%type;
vl_mes_11_w		fis_calculo_estrut.vl_mes_11%type;
vl_mes_12_w		fis_calculo_estrut.vl_mes_12%type;
vl_anual_w		fis_calculo_estrut.vl_anual%type;
nr_seq_calc_estrut1_w	fis_calculo_estrut.nr_sequencia%type;
nr_seq_calc_estrut2_w	fis_calculo_estrut.nr_sequencia%type;
nr_seq_estrut_calc_w	fis_lote_apuracao.nr_seq_estrutura%type;
nr_seq_lote_ant_w	fis_lote_apuracao.nr_sequencia%type;
ie_encerramento_w	varchar(2) := 'N';
ie_forma_apuracao_w 	varchar(2);
qt_modelo_estrutura_w	bigint := 0;

c01 CURSOR FOR
SELECT	row_number() OVER () AS linha,
		nr_seq_calc_estrut,
		nr_seq_estrut_item
from ( 	SELECT 	a.nr_sequencia nr_seq_calc_estrut,
		b.nr_sequencia nr_seq_estrut_item
	from	fis_calculo_estrut a,
		fis_estrutura_item b,
		fis_lote_apuracao c,
		fis_estrutura_calculo d
	where	a.nr_seq_item = b.nr_sequencia
	and	b.nr_seq_estrutura = c.nr_seq_estrutura
	and 	d.nr_sequencia = c.nr_seq_estrutura
	and	c.nr_sequencia = nr_seq_lote_p
	and	c.nr_sequencia = a.nr_seq_lote
	and	coalesce(b.nr_seq_superior::text, '') = ''
	order by b.nr_sequencia) alias1;
c01_w	c01%rowtype;

c02 CURSOR FOR
SELECT	row_number() OVER () AS linha,
		vl_mes_01,
		vl_mes_02,
		vl_mes_03,
		vl_mes_04,
		vl_mes_05,
		vl_mes_06,
		vl_mes_07,
		vl_mes_08,
		vl_mes_09,
		vl_mes_10,
		vl_mes_11,
		vl_mes_12,
		vl_anual,
		ie_tipo_estrutura
from (	SELECT	coalesce(a.vl_mes_01, 0) vl_mes_01,
		coalesce(a.vl_mes_02, 0) vl_mes_02,
		coalesce(a.vl_mes_03, 0) vl_mes_03,
		coalesce(a.vl_mes_04, 0) vl_mes_04,
		coalesce(a.vl_mes_05, 0) vl_mes_05,
		coalesce(a.vl_mes_06, 0) vl_mes_06,
		coalesce(a.vl_mes_07, 0) vl_mes_07,
		coalesce(a.vl_mes_08, 0) vl_mes_08,
		coalesce(a.vl_mes_09, 0) vl_mes_09,
		coalesce(a.vl_mes_10, 0) vl_mes_10,
		coalesce(a.vl_mes_11, 0) vl_mes_11,
		coalesce(a.vl_mes_12, 0) vl_mes_12,
		coalesce(a.vl_anual, 0)  vl_anual,
		b.ie_tipo_estrutura
	from	fis_calculo_estrut a,
		fis_estrutura_item b,
		fis_lote_apuracao c
	where	a.nr_seq_item = b.nr_sequencia
	and	b.nr_seq_estrutura = c.nr_seq_estrutura
	and	c.nr_sequencia = nr_seq_lote_p
	and	c.nr_sequencia = a.nr_seq_lote
	and	b.nr_seq_superior = c01_w.nr_seq_estrut_item
	order by b.nr_sequencia) alias13;
c02_w	c02%rowtype;

c03 CURSOR FOR
SELECT	row_number() OVER () AS linha,
		ds_item,
		ie_forma_apuracao,
		ie_anual_trimestral,
		vl_mes_01,
		vl_mes_02,
		vl_mes_03,
		vl_mes_04,
		vl_mes_05,
		vl_mes_06,
		vl_mes_07,
		vl_mes_08,
		vl_mes_09,
		vl_mes_10,
		vl_mes_11,
		vl_mes_12,
		vl_anual,
		nr_seq_calc_estrut,
		nr_seq_estrut_item
from (	SELECT	b.ds_item,
		d.ie_forma_apuracao,
		d.ie_anual_trimestral,
		coalesce(a.vl_mes_01, 0) vl_mes_01,
		coalesce(a.vl_mes_02, 0) vl_mes_02,
		coalesce(a.vl_mes_03, 0) vl_mes_03,
		coalesce(a.vl_mes_04, 0) vl_mes_04,
		coalesce(a.vl_mes_05, 0) vl_mes_05,
		coalesce(a.vl_mes_06, 0) vl_mes_06,
		coalesce(a.vl_mes_07, 0) vl_mes_07,
		coalesce(a.vl_mes_08, 0) vl_mes_08,
		coalesce(a.vl_mes_09, 0) vl_mes_09,
		coalesce(a.vl_mes_10, 0) vl_mes_10,
		coalesce(a.vl_mes_11, 0) vl_mes_11,
		coalesce(a.vl_mes_12, 0) vl_mes_12,
		coalesce(a.vl_anual, 0)  vl_anual,
		a.nr_sequencia nr_seq_calc_estrut,
		b.nr_sequencia nr_seq_estrut_item
	from	fis_calculo_estrut a,
		fis_estrutura_item b,
		fis_lote_apuracao c,
		fis_estrutura_calculo d
		where	a.nr_seq_item = b.nr_sequencia
		and 	d.nr_sequencia = c.nr_seq_estrutura
		and	c.nr_sequencia = nr_seq_lote_p
		and	c.nr_sequencia = a.nr_seq_lote
		and	b.ie_receita_anual = ie_encerramento_w
		and	coalesce(b.nr_seq_superior::text, '') = ''
		order by b.nr_sequencia) alias14;
c03_w	c03%rowtype;

c04 CURSOR FOR
SELECT	row_number() OVER () AS linha,
		nr_seq_calc_estrut,
		ds_item,
		vl_mes_01,
		vl_mes_02,
		vl_mes_03,
		vl_mes_04,
		vl_mes_05,
		vl_mes_06,
		vl_mes_07,
		vl_mes_08,
		vl_mes_09,
		vl_mes_10,
		vl_mes_11,
		vl_mes_12,
		vl_anual
from (	SELECT	a.nr_sequencia nr_seq_calc_estrut,
		b.ds_item,
		coalesce(a.vl_mes_01, 0) vl_mes_01,
		coalesce(a.vl_mes_02, 0) vl_mes_02,
		coalesce(a.vl_mes_03, 0) vl_mes_03,
		coalesce(a.vl_mes_04, 0) vl_mes_04,
		coalesce(a.vl_mes_05, 0) vl_mes_05,
		coalesce(a.vl_mes_06, 0) vl_mes_06,
		coalesce(a.vl_mes_07, 0) vl_mes_07,
		coalesce(a.vl_mes_08, 0) vl_mes_08,
		coalesce(a.vl_mes_09, 0) vl_mes_09,
		coalesce(a.vl_mes_10, 0) vl_mes_10,
		coalesce(a.vl_mes_11, 0) vl_mes_11,
		coalesce(a.vl_mes_12, 0) vl_mes_12,
		coalesce(a.vl_anual, 0)  vl_anual
		from	fis_calculo_estrut a,
			fis_estrutura_item b,
			fis_lote_apuracao c
		where	a.nr_seq_item = b.nr_sequencia
		and	b.nr_seq_estrutura = c.nr_seq_estrutura
		and	c.nr_sequencia = nr_seq_lote_p
		and	c.nr_sequencia = a.nr_seq_lote
		and	b.nr_seq_superior = c03_w.nr_seq_estrut_item
		and	b.ie_receita_anual = ie_encerramento_w
		order by b.nr_sequencia) alias13;
c04_w	c04%rowtype;


BEGIN

select	max(nr_seq_estrutura),
	max(dt_mes_apuracao),
	max(ie_lote_anual)
into STRICT	nr_seq_estrut_calc_w,
	dt_referencia_w,
	ie_encerramento_w
from	fis_lote_apuracao
where	nr_sequencia = nr_seq_lote_p;

select	b.ie_forma_apuracao
into STRICT 	ie_forma_apuracao_w
from	fis_estrutura_calculo b
where	b.nr_sequencia	= nr_seq_estrut_calc_w;

select 	max(l.nr_seq_estrutura)
into STRICT   	qt_modelo_estrutura_w
from 	fis_estrutura_calculo c,
		fis_estrutura_livros l
where 	c.nr_sequencia = nr_seq_estrut_calc_w
and 	c.ie_lalur_lacs  = l.ie_lalur_lacs
and 	c.ie_forma_apuracao = l.ie_forma_apuracao;

ie_somar_w := 'S';

open c01;
loop
fetch c01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	vl_mes_01_w := 0;
	vl_mes_02_w := 0;
	vl_mes_03_w := 0;
	vl_mes_04_w := 0;
	vl_mes_05_w := 0;
	vl_mes_06_w := 0;
	vl_mes_07_w := 0;
	vl_mes_08_w := 0;
	vl_mes_09_w := 0;
	vl_mes_10_w := 0;
	vl_mes_11_w := 0;
	vl_mes_12_w := 0;
	vl_anual_w  := 0;

	if	( ( c01_w.linha in (1,2) and ie_encerramento_w = 'N' ) or ( c01_w.linha in (1,2,3) and ie_encerramento_w = 'S' ) ) then
		begin

		open c02;
		loop
		fetch c02 into
			c02_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin

			if (ie_encerramento_w = 'S') then
				begin
				if (c02_w.ie_tipo_estrutura <> 'DE') then
					begin

					vl_mes_01_w := vl_mes_01_w + c02_w.vl_mes_01;
					vl_mes_02_w := vl_mes_02_w + c02_w.vl_mes_02;
					vl_mes_03_w := vl_mes_03_w + c02_w.vl_mes_03;
					vl_mes_04_w := vl_mes_04_w + c02_w.vl_mes_04;
					vl_mes_05_w := vl_mes_05_w + c02_w.vl_mes_05;
					vl_mes_06_w := vl_mes_06_w + c02_w.vl_mes_06;
					vl_mes_07_w := vl_mes_07_w + c02_w.vl_mes_07;
					vl_mes_08_w := vl_mes_08_w + c02_w.vl_mes_08;
					vl_mes_09_w := vl_mes_09_w + c02_w.vl_mes_09;
					vl_mes_10_w := vl_mes_10_w + c02_w.vl_mes_10;
					vl_mes_11_w := vl_mes_11_w + c02_w.vl_mes_11;
					vl_mes_12_w := vl_mes_12_w + c02_w.vl_mes_12;
					vl_anual_w  := vl_anual_w  + c02_w.vl_anual;

					update fis_calculo_estrut set
					vl_mes_01 = vl_mes_01_w,
					vl_mes_02 = vl_mes_02_w,
					vl_mes_03 = vl_mes_03_w,
					vl_mes_04 = vl_mes_04_w,
					vl_mes_05 = vl_mes_05_w,
					vl_mes_06 = vl_mes_06_w,
					vl_mes_07 = vl_mes_07_w,
					vl_mes_08 = vl_mes_08_w,
					vl_mes_09 = vl_mes_09_w,
					vl_mes_10 = vl_mes_10_w,
					vl_mes_11 = vl_mes_11_w,
					vl_mes_12 = vl_mes_12_w,
					vl_anual  = vl_anual_w
					where nr_sequencia = c01_w.nr_seq_calc_estrut;

					commit;
					end;
				end if;
				end;
			else
				begin
				if (c01_w.linha = 1) then
					begin
				select  vl_mes_01,
						vl_mes_02,
						vl_mes_03,
						vl_mes_04,
						vl_mes_05,
						vl_mes_06,
						vl_mes_07,
						vl_mes_08,
						vl_mes_09,
						vl_mes_10,
						vl_mes_11,
						vl_mes_12,
						vl_anual
				into STRICT	vl_mes_01_w,
						vl_mes_02_w,
						vl_mes_03_w,
						vl_mes_04_w,
						vl_mes_05_w,
						vl_mes_06_w,
						vl_mes_07_w,
						vl_mes_08_w,
						vl_mes_09_w,
						vl_mes_10_w,
						vl_mes_11_w,
						vl_mes_12_w,
						vl_anual_w
				from ( 	SELECT
							vl_mes_01_w + CASE WHEN c02_w.linha=1 THEN  c02_w.vl_mes_01 * 0.12 WHEN c02_w.linha=2 THEN  c02_w.vl_mes_01*0.12 WHEN c02_w.linha=3 THEN c02_w.vl_mes_01*0.32 WHEN c02_w.linha=4 THEN  c02_w.vl_mes_01*0.32 END vl_mes_01,
							vl_mes_02_w + CASE WHEN c02_w.linha=1 THEN  c02_w.vl_mes_02 * 0.12 WHEN c02_w.linha=2 THEN  c02_w.vl_mes_02*0.12 WHEN c02_w.linha=3 THEN c02_w.vl_mes_02*0.32 WHEN c02_w.linha=4 THEN  c02_w.vl_mes_02*0.32 END vl_mes_02,
							vl_mes_03_w + CASE WHEN c02_w.linha=1 THEN  c02_w.vl_mes_03 * 0.12 WHEN c02_w.linha=2 THEN  c02_w.vl_mes_03*0.12 WHEN c02_w.linha=3 THEN c02_w.vl_mes_03*0.32 WHEN c02_w.linha=4 THEN  c02_w.vl_mes_03*0.32 END vl_mes_03,
							vl_mes_04_w + CASE WHEN c02_w.linha=1 THEN  c02_w.vl_mes_04 * 0.12 WHEN c02_w.linha=2 THEN  c02_w.vl_mes_04*0.12 WHEN c02_w.linha=3 THEN c02_w.vl_mes_04*0.32 WHEN c02_w.linha=4 THEN  c02_w.vl_mes_04*0.32 END vl_mes_04,
							vl_mes_05_w + CASE WHEN c02_w.linha=1 THEN  c02_w.vl_mes_05 * 0.12 WHEN c02_w.linha=2 THEN  c02_w.vl_mes_05*0.12 WHEN c02_w.linha=3 THEN c02_w.vl_mes_05*0.32 WHEN c02_w.linha=4 THEN  c02_w.vl_mes_05*0.32 END vl_mes_05,
							vl_mes_06_w + CASE WHEN c02_w.linha=1 THEN  c02_w.vl_mes_06 * 0.12 WHEN c02_w.linha=2 THEN  c02_w.vl_mes_06*0.12 WHEN c02_w.linha=3 THEN c02_w.vl_mes_06*0.32 WHEN c02_w.linha=4 THEN  c02_w.vl_mes_06*0.32 END vl_mes_06,
							vl_mes_07_w + CASE WHEN c02_w.linha=1 THEN  c02_w.vl_mes_07 * 0.12 WHEN c02_w.linha=2 THEN  c02_w.vl_mes_07*0.12 WHEN c02_w.linha=3 THEN c02_w.vl_mes_07*0.32 WHEN c02_w.linha=4 THEN  c02_w.vl_mes_07*0.32 END vl_mes_07,
							vl_mes_08_w + CASE WHEN c02_w.linha=1 THEN  c02_w.vl_mes_08 * 0.12 WHEN c02_w.linha=2 THEN  c02_w.vl_mes_08*0.12 WHEN c02_w.linha=3 THEN c02_w.vl_mes_08*0.32 WHEN c02_w.linha=4 THEN  c02_w.vl_mes_08*0.32 END vl_mes_08,
							vl_mes_09_w + CASE WHEN c02_w.linha=1 THEN  c02_w.vl_mes_09 * 0.12 WHEN c02_w.linha=2 THEN  c02_w.vl_mes_09*0.12 WHEN c02_w.linha=3 THEN c02_w.vl_mes_09*0.32 WHEN c02_w.linha=4 THEN  c02_w.vl_mes_09*0.32 END vl_mes_09,
							vl_mes_10_w + CASE WHEN c02_w.linha=1 THEN  c02_w.vl_mes_10 * 0.12 WHEN c02_w.linha=2 THEN  c02_w.vl_mes_10*0.12 WHEN c02_w.linha=3 THEN c02_w.vl_mes_10*0.32 WHEN c02_w.linha=4 THEN  c02_w.vl_mes_10*0.32 END vl_mes_10,
							vl_mes_11_w + CASE WHEN c02_w.linha=1 THEN  c02_w.vl_mes_11 * 0.12 WHEN c02_w.linha=2 THEN  c02_w.vl_mes_11*0.12 WHEN c02_w.linha=3 THEN c02_w.vl_mes_11*0.32 WHEN c02_w.linha=4 THEN  c02_w.vl_mes_11*0.32 END vl_mes_11,
							vl_mes_12_w + CASE WHEN c02_w.linha=1 THEN  c02_w.vl_mes_12 * 0.12 WHEN c02_w.linha=2 THEN  c02_w.vl_mes_12*0.12 WHEN c02_w.linha=3 THEN c02_w.vl_mes_12*0.32 WHEN c02_w.linha=4 THEN  c02_w.vl_mes_12*0.32 END vl_mes_12,
							vl_anual_w  + CASE WHEN c02_w.linha=1 THEN  c02_w.vl_anual *  0.12 WHEN c02_w.linha=2 THEN  c02_w.vl_anual *0.12 WHEN c02_w.linha=3 THEN c02_w.vl_anual *0.32 WHEN c02_w.linha=4 THEN  c02_w.vl_anual *0.32 END vl_anual
						
						where qt_modelo_estrutura_w < 1141
						
union

						SELECT  --vl_mes_01_w + decode(c02_w.linha, 1, c02_w.vl_mes_01 * 0.12, 2, c02_w.vl_mes_01*0.12, 3,c02_w.vl_mes_01*0.32, 4, c02_w.vl_mes_01*0.32),
							vl_mes_01_w + CASE WHEN c02_w.linha=1 THEN  c02_w.vl_mes_01 * 0.12 WHEN c02_w.linha=2 THEN  c02_w.vl_mes_01*0.32 END vl_mes_01,
							vl_mes_02_w + CASE WHEN c02_w.linha=1 THEN  c02_w.vl_mes_02 * 0.12 WHEN c02_w.linha=2 THEN  c02_w.vl_mes_02*0.32 END vl_mes_02,
							vl_mes_03_w + CASE WHEN c02_w.linha=1 THEN  c02_w.vl_mes_03 * 0.12 WHEN c02_w.linha=2 THEN  c02_w.vl_mes_03*0.32 END vl_mes_03,
							vl_mes_04_w + CASE WHEN c02_w.linha=1 THEN  c02_w.vl_mes_04 * 0.12 WHEN c02_w.linha=2 THEN  c02_w.vl_mes_04*0.32 END vl_mes_04,
							vl_mes_05_w + CASE WHEN c02_w.linha=1 THEN  c02_w.vl_mes_05 * 0.12 WHEN c02_w.linha=2 THEN  c02_w.vl_mes_05*0.32 END vl_mes_05,
							vl_mes_06_w + CASE WHEN c02_w.linha=1 THEN  c02_w.vl_mes_06 * 0.12 WHEN c02_w.linha=2 THEN  c02_w.vl_mes_06*0.32 END vl_mes_06,
							vl_mes_07_w + CASE WHEN c02_w.linha=1 THEN  c02_w.vl_mes_07 * 0.12 WHEN c02_w.linha=2 THEN  c02_w.vl_mes_07*0.32 END vl_mes_07,
							vl_mes_08_w + CASE WHEN c02_w.linha=1 THEN  c02_w.vl_mes_08 * 0.12 WHEN c02_w.linha=2 THEN  c02_w.vl_mes_08*0.32 END vl_mes_08,
							vl_mes_09_w + CASE WHEN c02_w.linha=1 THEN  c02_w.vl_mes_09 * 0.12 WHEN c02_w.linha=2 THEN  c02_w.vl_mes_09*0.32 END vl_mes_09,
							vl_mes_10_w + CASE WHEN c02_w.linha=1 THEN  c02_w.vl_mes_10 * 0.12 WHEN c02_w.linha=2 THEN  c02_w.vl_mes_10*0.32 END vl_mes_10,
							vl_mes_11_w + CASE WHEN c02_w.linha=1 THEN  c02_w.vl_mes_11 * 0.12 WHEN c02_w.linha=2 THEN  c02_w.vl_mes_11*0.32 END vl_mes_11,
							vl_mes_12_w + CASE WHEN c02_w.linha=1 THEN  c02_w.vl_mes_12 * 0.12 WHEN c02_w.linha=2 THEN  c02_w.vl_mes_12*0.32 END vl_mes_12,
							vl_anual_w  + CASE WHEN c02_w.linha=1 THEN  c02_w.vl_anual *  0.12 WHEN c02_w.linha=2 THEN  c02_w.vl_anual *0.32 END vl_anual
						
						where qt_modelo_estrutura_w >= 1141) alias1;			
					end;
				elsif (c01_w.linha = 2) then
					begin
					vl_mes_01_w := vl_mes_01_w + c02_w.vl_mes_01;
					vl_mes_02_w := vl_mes_02_w + c02_w.vl_mes_02;
					vl_mes_03_w := vl_mes_03_w + c02_w.vl_mes_03;
					vl_mes_04_w := vl_mes_04_w + c02_w.vl_mes_04;
					vl_mes_05_w := vl_mes_05_w + c02_w.vl_mes_05;
					vl_mes_06_w := vl_mes_06_w + c02_w.vl_mes_06;
					vl_mes_07_w := vl_mes_07_w + c02_w.vl_mes_07;
					vl_mes_08_w := vl_mes_08_w + c02_w.vl_mes_08;
					vl_mes_09_w := vl_mes_09_w + c02_w.vl_mes_09;
					vl_mes_10_w := vl_mes_10_w + c02_w.vl_mes_10;
					vl_mes_11_w := vl_mes_11_w + c02_w.vl_mes_11;
					vl_mes_12_w := vl_mes_12_w + c02_w.vl_mes_12;
					vl_anual_w  := vl_anual_w  + c02_w.vl_anual;
					end;
				end if;
				end;
			end if;

			update fis_calculo_estrut set
			vl_mes_01 = vl_mes_01_w,
			vl_mes_02 = vl_mes_02_w,
			vl_mes_03 = vl_mes_03_w,
			vl_mes_04 = vl_mes_04_w,
			vl_mes_05 = vl_mes_05_w,
			vl_mes_06 = vl_mes_06_w,
			vl_mes_07 = vl_mes_07_w,
			vl_mes_08 = vl_mes_08_w,
			vl_mes_09 = vl_mes_09_w,
			vl_mes_10 = vl_mes_10_w,
			vl_mes_11 = vl_mes_11_w,
			vl_mes_12 = vl_mes_12_w,
			vl_anual  = vl_anual_w
			where nr_sequencia = c01_w.nr_seq_calc_estrut;

			commit;
			end;
		end loop;
		close c02;
		end;
	end if;
	end;
end loop;
close c01;

if (ie_encerramento_w = 'N') then
	begin

	open c03;
	loop
	fetch c03 into
		c03_w;
	EXIT WHEN NOT FOUND; /* apply on c03 */
		begin

		/* Zerar vaiaveis necessarias */

		vl_mes_ref_w := 0;

		/* Cada valor do i  um mes ento 1 = janeiro, 2 = fevereiro , ...*/

		nr_mes_ref_w := (to_char(dt_referencia_w,'mm'))::numeric;

		nr_seq_calc_estrut1_w := c03_w.nr_seq_calc_estrut;

		/* Verifica cada linha do do C03 e faz o clculo fixo de acordo com o tipo de registro */

		if (c03_w.linha in (1,2)) then
			begin
			vl_mes_ref_w := case nr_mes_ref_w
						when 1 then -- se for Janeiro
						c03_w.vl_mes_01
						when 2 then -- se for Fevereiro
						c03_w.vl_mes_02
						when 3 then -- se for Maro ...
						c03_w.vl_mes_03
						when 4 then
						c03_w.vl_mes_04
						when 5 then
						c03_w.vl_mes_05
						when 6 then
						c03_w.vl_mes_06
						when 7 then
						c03_w.vl_mes_07
						when 8 then
						c03_w.vl_mes_08
						when 9 then
						c03_w.vl_mes_09
						when 10 then
						c03_w.vl_mes_10
						when 11 then
						c03_w.vl_mes_11
						when 12 then
						c03_w.vl_mes_12
						else 0
					end;

			if (c03_w.linha = 1) then
				begin
				/* Receitas - Resultado da Aplicao dos Percentuais */

				vl_receitas_w := vl_mes_ref_w;
				end;
			elsif (c03_w.linha = 2) then
				begin
				/* Outras Receitas */

				vl_outras_receitas_w := vl_mes_ref_w;
				end;
			end if;
			end;
		elsif (c03_w.linha = 3) then
			begin
			/* Base de Clculo da CSLL*/

			vl_BCCSLL_w := vl_receitas_w + vl_outras_receitas_w;
			vl_auxiliar_w := vl_BCCSLL_w;
			end;
		elsif (c03_w.linha = 4) then
			begin
			/* CSLL Apurada - Alquota 9% */

			if (vl_BCCSLL_w > 0) then
				vl_CSLLAA9_w := vl_BCCSLL_w * 0.09; --9%
			else
				vl_CSLLAA9_w := 0.0;
			end if;
			vl_auxiliar_w := vl_CSLLAA9_w;
			end;
		elsif (c03_w.linha = 5) then
			begin

			ie_somar_w := 'S';
			-- DEDUES - PREENCHER OS ELEMENTOS FILHOS
			open c04;
			loop
			fetch c04 into
				c04_w;
			EXIT WHEN NOT FOUND; /* apply on c04 */
				begin

				if (position('CSLL Devida em Meses Anteriores' in c04_w.ds_item) > 0 or position('CSLL Devida no Mes' in remover_acentuacao(c04_w.ds_item)) > 0) then
					begin
					ie_somar_w := 'N';
					end;
				elsif (ie_somar_w = 'S') then
					begin
					vl_auxiliar_w :=  case nr_mes_ref_w
							when 1 then -- se for Janeiro
							c04_w.vl_mes_01
							when 2 then -- se for Fevereiro
							c04_w.vl_mes_02
							when 3 then -- se for Maro ...
							c04_w.vl_mes_03
							when 4 then
							c04_w.vl_mes_04
							when 5 then
							c04_w.vl_mes_05
							when 6 then
							c04_w.vl_mes_06
							when 7 then
							c04_w.vl_mes_07
							when 8 then
							c04_w.vl_mes_08
							when 9 then
							c04_w.vl_mes_09
							when 10 then
							c04_w.vl_mes_10
							when 11 then
							c04_w.vl_mes_11
							when 12 then
							c04_w.vl_mes_12
							else 0
							end;
					vl_deducoes_parte1_w := vl_deducoes_parte1_w + vl_auxiliar_w;
					end;
				else
					begin
					vl_auxiliar_w := case nr_mes_ref_w
							when 1 then -- se for Janeiro
							c04_w.vl_mes_01
							when 2 then -- se for Fevereiro
							c04_w.vl_mes_02
							when 3 then -- se for Maro ...
							c04_w.vl_mes_03
							when 4 then
							c04_w.vl_mes_04
							when 5 then
							c04_w.vl_mes_05
							when 6 then
							c04_w.vl_mes_06
							when 7 then
							c04_w.vl_mes_07
							when 8 then
							c04_w.vl_mes_08
							when 9 then
							c04_w.vl_mes_09
							when 10 then
							c04_w.vl_mes_10
							when 11 then
							c04_w.vl_mes_11
							when 12 then
							c04_w.vl_mes_12
							else 0
							end;
					vl_deducoes_parte2_w := vl_deducoes_parte2_w + vl_auxiliar_w;
					end;
				end if;

				end;
			end loop;
			close c04;

			select	a.nr_sequencia
			into STRICT 	nr_seq_calc_estrut1_w
			from	fis_calculo_estrut a,
				fis_estrutura_item b,
				fis_lote_apuracao c
			where	a.nr_seq_item = b.nr_sequencia
			and	b.nr_seq_estrutura = c.nr_seq_estrutura
			and	c.nr_sequencia = nr_seq_lote_p
			and	c.nr_sequencia = a.nr_seq_lote
			and	b.nr_seq_superior = c03_w.nr_seq_estrut_item
			and 	position('CSLL Devida em Meses Anteriores' in ds_item) > 0
			order by b.nr_sequencia;

			select	a.nr_sequencia
			into STRICT 	nr_seq_calc_estrut2_w
			from	fis_calculo_estrut a,
				fis_estrutura_item b,
				fis_lote_apuracao c
			where	a.nr_seq_item = b.nr_sequencia
			and	b.nr_seq_estrutura = c.nr_seq_estrutura
			and	c.nr_sequencia = nr_seq_lote_p
			and	c.nr_sequencia = a.nr_seq_lote
			and	b.nr_seq_superior = c03_w.nr_seq_estrut_item
			and 	position('CSLL Devida no Mes' in remover_acentuacao(ds_item)) > 0
			order by b.nr_sequencia;
			
			vl_CSLL_dma_w := 0.0;
			vl_CSLL_dm_w := vl_CSLLAA9_w - vl_deducoes_parte1_w - vl_CSLL_dma_w;

			if	( (vl_CSLL_dm_w) < 0 ) then
				begin
				vl_CSLL_dm_w := 0.0;
				end;
			end if;

			ds_comando_w := 'update fis_calculo_estrut set vl_mes_' || lpad(nr_mes_ref_w, 2, '0')|| ' = ' || vl_CSLL_dma_w || ' where nr_sequencia = '|| nr_seq_calc_estrut1_w;
			ds_comando_w := replace(ds_comando_w, ',', '.');
			CALL exec_sql_dinamico('Tasy', ds_comando_w);

			ds_comando_w := 'update fis_calculo_estrut set vl_mes_' || lpad(nr_mes_ref_w, 2, '0')|| ' = ' || vl_CSLL_dm_w || ' where nr_sequencia = '|| nr_seq_calc_estrut2_w;
			ds_comando_w := replace(ds_comando_w, ',', '.');
			CALL exec_sql_dinamico('Tasy', ds_comando_w);

			vl_deducoes_w := vl_deducoes_parte1_w;
			vl_auxiliar_w := vl_deducoes_w;
			nr_seq_calc_estrut1_w := c03_w.nr_seq_calc_estrut;
			end;
		elsif (c03_w.linha = 6) then
			begin
			if	( (vl_CSLL_dm_w) > 0 ) then
				begin
				vl_CSLL_pagar_w := vl_CSLL_dm_w - vl_deducoes_parte2_w;
				end;
			else
				begin
				vl_CSLL_pagar_w := vl_CSLLAA9_w - vl_deducoes_parte1_w - vl_CSLL_dma_w;
				end;
			end if;
			vl_auxiliar_w := vl_CSLL_pagar_w;
			end;
		end if;

		ds_comando_w := 'update fis_calculo_estrut set vl_mes_' || lpad(nr_mes_ref_w, 2, '0')|| ' = ' || vl_auxiliar_w || ' where nr_sequencia = '|| nr_seq_calc_estrut1_w;
		ds_comando_w := replace(ds_comando_w, ',', '.');

		if (c03_w.linha in (3,4,5,6)) then
			begin
			CALL exec_sql_dinamico('Tasy', ds_comando_w);
			end;
		end if;

		end;
	end loop;
	close c03;
	end;
else -- ENCERRAMENTO = 'S'
	begin
	open c03;
	loop
	fetch c03 into
		c03_w;
	EXIT WHEN NOT FOUND; /* apply on c03 */
		begin

		/* Zerar vaiaveis necessarias */

		vl_mes_ref_w := 0;

		/* Cada valor do i  um mes ento 1 = janeiro, 2 = fevereiro , ...*/

		nr_mes_ref_w := (to_char(dt_referencia_w,'mm'))::numeric;

		nr_seq_calc_estrut1_w := c03_w.nr_seq_calc_estrut;

		/* Verifica cada linha do do C03 e faz o clculo fixo de acordo com o tipo de registro */

		if (c03_w.linha in (1,2,3,5)) then
			begin
			vl_mes_ref_w :=  c03_w.vl_anual;

			if (c03_w.linha = 1) then
				begin
				/* Atividade joga para varivel o valor do mes de compatncia */

				vl_atividade_w := vl_mes_ref_w;
				end;
			elsif (c03_w.linha = 2) then
				begin
				/* Adies joga para varivel o valor do mes de compatncia */

				vl_adicoes_w := vl_mes_ref_w;
				end;
			elsif (c03_w.linha = 3) then
				begin
				/* Excluses joga para varivel o valor do mes de compatncia */

				vl_exclusoes_w := vl_mes_ref_w;
				end;
			elsif (c03_w.linha = 5) then
				begin
				vl_CBCNPA_w := vl_mes_ref_w;
				end;
			end if;
			end;
		elsif (c03_w.linha = 4) then
			begin
			/* Base de Clculo Antes das Compensaes faz o atividade mais adies menos excluses */

			vl_BCAC_w := vl_atividade_w + vl_adicoes_w - vl_exclusoes_w;
			vl_auxiliar_w := vl_BCAC_w;
			end;
		elsif (c03_w.linha = 6) then
			begin
			vl_BCCSLL_w := vl_BCAC_w - vl_CBCNPA_w;
			vl_auxiliar_w := vl_BCCSLL_w;
			end;
		elsif (c03_w.linha = 7) then
			begin
			if (vl_BCCSLL_w > 0) then
				vl_CSLLAA9_w := vl_BCCSLL_w * 0.09; --9%
			else
				vl_CSLLAA9_w := 0.0;
			end if;
			vl_auxiliar_w := vl_CSLLAA9_w; -- 9%
			end;
		elsif (c03_w.linha = 8) then
			begin
			nr_seq_calc_estrut1_w := 0;
			nr_seq_calc_estrut1_w := 0;
			ie_somar_w := 'S';
			-- DEDUES - PREENCHER OS ELEMENTOS FILHOS
			open c04;
			loop
			fetch c04 into
				c04_w;
			EXIT WHEN NOT FOUND; /* apply on c04 */
				begin

				if (position('CSLL Devida em Meses Anteriores' in c04_w.ds_item) > 0 or position('CSLL Devida no Mes' in remover_acentuacao(c04_w.ds_item)) > 0) then
					begin
					if (position('CSLL Devida em Meses Anteriores' in c04_w.ds_item) > 0) then
						nr_seq_calc_estrut1_w := c04_w.nr_seq_calc_estrut;
					else
						nr_seq_calc_estrut2_w := c04_w.nr_seq_calc_estrut;
					end if;
					ie_somar_w := 'N';
					end;
				elsif (ie_somar_w = 'S') then
					begin
					vl_auxiliar_w :=  c04_w.vl_anual;
					vl_deducoes_parte1_w := vl_deducoes_parte1_w + vl_auxiliar_w;
					end;
				else
					begin
					vl_auxiliar_w := c04_w.vl_anual;
					vl_deducoes_parte2_w := vl_deducoes_parte2_w + vl_auxiliar_w;
					end;
				end if;
				end;
			end loop;
			close c04;

			dt_mes_ant_ini_w := trunc(dt_referencia_w, 'mm');
			dt_mes_ant_fim_w := fim_mes(dt_mes_ant_ini_w);

			select	max(nr_sequencia)
			into STRICT	nr_seq_lote_ant_w
			from	fis_lote_apuracao
			where	dt_mes_apuracao between dt_mes_ant_ini_w and dt_mes_ant_fim_w
			and 	nr_seq_estrutura = nr_seq_estrut_calc_w
			and 	ie_lote_anual = 'N';

			select	coalesce(vl_mes_12, 0)
			into STRICT 	vl_CSLL_dma_w
			from	fis_calculo_estrut a,
				fis_estrutura_item b,
				fis_lote_apuracao c
			where	a.nr_seq_item = b.nr_sequencia
			and	b.nr_seq_estrutura = c.nr_seq_estrutura
			and	c.nr_sequencia = nr_seq_lote_ant_w
			and	c.nr_sequencia = a.nr_seq_lote
			and 	position('CSLL Devida em Meses Anteriores' in ds_item) > 0
			order by b.nr_sequencia;

			select	coalesce(vl_mes_12, 0)
			into STRICT 	vl_auxiliar_w
			from	fis_calculo_estrut a,
				fis_estrutura_item b,
				fis_lote_apuracao c
			where	a.nr_seq_item = b.nr_sequencia
			and	b.nr_seq_estrutura = c.nr_seq_estrutura
			and	c.nr_sequencia = nr_seq_lote_ant_w
			and	c.nr_sequencia = a.nr_seq_lote
			and 	position('CSLL Devida no Mes' in remover_acentuacao(ds_item)) > 0
			order by b.nr_sequencia;

			vl_CSLL_dma_w := vl_CSLL_dma_w + vl_auxiliar_w;
			vl_CSLL_dm_w := vl_CSLLAA9_w - vl_deducoes_parte1_w - vl_CSLL_dma_w;

			if	( (vl_CSLL_dm_w) < 0 ) then
				begin
				vl_CSLL_dm_w := 0.0;
				end;
			end if;

			ds_comando_w := 'update fis_calculo_estrut set vl_anual = ' || vl_CSLL_dma_w || ' where nr_sequencia = '|| nr_seq_calc_estrut1_w;
			ds_comando_w := replace(ds_comando_w, ',', '.');
			CALL exec_sql_dinamico('Tasy', ds_comando_w);

			ds_comando_w := 'update fis_calculo_estrut set vl_anual = ' || vl_CSLL_dm_w || ' where nr_sequencia = '|| nr_seq_calc_estrut2_w;
			ds_comando_w := replace(ds_comando_w, ',', '.');
			CALL exec_sql_dinamico('Tasy', ds_comando_w);

			vl_deducoes_w := vl_deducoes_parte1_w; -- + vl_deducoes_parte2_w + vl_CSLL_dm_w + vl_CSLL_dma_w;
			vl_auxiliar_w := vl_deducoes_w;
			nr_seq_calc_estrut1_w := c03_w.nr_seq_calc_estrut;
			end;
		elsif (c03_w.linha = 9) then
			begin
			if	( (vl_CSLL_dm_w) > 0 ) then
				begin
				vl_CSLL_pagar_w := vl_CSLL_dm_w - vl_deducoes_parte2_w;
				end;
			else
				begin
				vl_CSLL_pagar_w := vl_CSLLAA9_w - vl_deducoes_parte1_w - vl_deducoes_parte2_w - vl_CSLL_dma_w;
				end;
			end if;
			vl_auxiliar_w := vl_CSLL_pagar_w;
			end;
		end if;

		ds_comando_w := 'update fis_calculo_estrut set vl_anual = ' || vl_auxiliar_w || ' where nr_sequencia = '|| nr_seq_calc_estrut1_w;
		ds_comando_w := replace(ds_comando_w, ',', '.');

		if (c03_w.linha in (4,6,7,8,9)) then
			begin
			CALL exec_sql_dinamico('Tasy', ds_comando_w);
			end;
		end if;

		end;
	end loop;
	close c03;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_calc_lacs_receita ( nr_seq_lote_p bigint ) FROM PUBLIC;

