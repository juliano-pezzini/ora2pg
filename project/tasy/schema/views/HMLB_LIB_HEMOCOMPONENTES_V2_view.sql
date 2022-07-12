-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW hmlb_lib_hemocomponentes_v2 (nr_seq_producao, nr_seq_doacao, nr_seq_derivado, cd_pessoa_fisica, nr_lote_bolsa, qt_armazenamento, nm_usuario_lib, nm_usuario_conferencia, ds_sangue, dt_coleta, dt_validade_bolsa, dt_fracionamento, nr_bolsa, qt_volume, dt_vencimento, cd_barra, ds_derivado, nm_pessoa_fisica, nm_marca, ds_ini, ds_leuco, linha1, linha2, ds1, ds2, ds3, ds4, ds5, ds6, ds9, dsa, dsb, dsc, dsd, dse, dsf, dsg, dsh, dsi, dsj, dsk, linha3, linha4, ie_nat) AS select	b.nr_sequencia nr_seq_producao,
	a.nr_sequencia nr_seq_doacao,
	c.nr_sequencia nr_seq_derivado,
	d.cd_pessoa_fisica,
	a.nr_lote_bolsa,
	c.qt_temp_armazenamento qt_armazenamento,
	b.nm_usuario_lib,
	a.nm_usuario_conferencia,
	d.ie_tipo_sangue||d.ie_fator_rh ds_sangue,
	to_char(a.dt_coleta,'dd/mm/yyyy') dt_coleta,
	to_char(b.dt_vencimento,'dd/mm/yyyy') dt_validade_bolsa,
	to_char(b.dt_producao,'dd/mm/yyyy hh24:mi') dt_fracionamento,
	coalesce(a.nr_bolsa,a.nr_sangue) nr_bolsa,
	coalesce(b.qt_volume_apos_filtragem,b.qt_volume) qt_volume,
	coalesce(to_char(b.dt_validade_apos_filtragem,'dd/mm/yyyy'),to_char(b.dt_vencimento,'dd/mm/yyyy')) dt_vencimento,
	replace(b.cd_barras,' ','') cd_barra,
	substr(c.ds_derivado,1,30) ds_derivado,
	substr(abrevia_nome_pf(d.cd_pessoa_fisica,null),1,17) nm_pessoa_fisica,
	substr(obter_dados_marca_bolsa(a.nr_marca_bolsa, 'DM'),1,100) nm_marca,
	substr(obter_iniciais_nome(null,replace(replace(replace(replace(replace(obter_nome_pf(a.cd_pessoa_fisica),' de ',' '),' da ',' '),' das ',' '),' do ',' '),' dos ',' ')),1,20) ds_ini,
	(case
		when(a.ie_tipo_bolsa in (4) and c.nr_sequencia in (1)) then
			'HEMOCOMPONENTE LEUCORREDUZIDO'
		when(b.ie_lavado = 'S') then
			'HEMOCOMPONENTE - LAVADO'
		when(b.ie_irradiado = 'S'  and a.ie_tipo_bolsa in (4) and c.nr_sequencia in (1)) then
			'HEMOCOMPONENTE IRRADIADO - LEUCORREDUZIDO'
		when(b.dt_validade_apos_filtragem is not null)
			or (b.qt_peso_apos_filtragem is not null)
			or (b.qt_volume_apos_filtragem is not null) then
				' '
	end
	) ds_leuco,
	substr(	obter_select_concatenado_bv('
			select	ds_sigla
			from	(	select	c.ds_sigla,
						rownum nr_linha
					from	san_exame_lote a,
						san_exame_realizado b,
						san_exame c
					where  a.nr_sequencia = b.nr_seq_exame_lote
					and	b.nr_seq_exame = c.nr_sequencia
					and	c.ie_exige_senha = ''S''
					and	lower(replace(b.ds_resultado,'' '','''')) in (''negativo'',''nãoreagente'')
					and	   a.nr_seq_doacao = :nr_sequencia
				)
			where	nr_linha between 1 and 11',
			'nr_sequencia='||a.nr_sequencia,','),1,50
		) linha1,
	substr(	obter_select_concatenado_bv('
			select	ds_sigla
			from	(	select	c.ds_sigla,
						rownum nr_linha
					from	san_exame_lote a,
						san_exame_realizado b,
						san_exame c
					where	a.nr_sequencia = b.nr_seq_exame_lote
					and	b.nr_seq_exame = c.nr_sequencia
					and	c.ie_exige_senha = ''S''
					and	lower(replace(b.ds_resultado,'' '','''')) in (''negativo'',''nãoreagente'')
					and	a.nr_seq_doacao = :nr_sequencia
				)
			where	nr_linha between 22 and 11',
			'nr_sequencia='||a.nr_sequencia,','),1,50
		) linha2,
	'BOLSA COM 63 ML DE SOLUCAO CPDA1 PARA' ds1,
	'COLETA DE 450 ML DE SANGUE TOTAL.' 	   ds2,
	'- NAO PERFURE - PRODUTO ESTERIL' 	   ds3,
	'- NAO ADICIONAR MEDICAMENTOS' 	   ds4,
	'LIBERACAO HEMOCOMPONENTE:' 	   ds5,
	'PESQUISA DE ANTICORPO IRREGULAR:'||	(	select	upper(max(y.ds_resultado))
							FROM	san_exame_lote x,
								san_exame_realizado y
							where	x.nr_sequencia = y.nr_seq_exame_lote
							and	y.nr_seq_exame = 10
						) ds6,
	'SOROLOGIA NAO REAGENTE PARA:' ds9,
	'Transfundir apenas sob prescrição médica. Conferir os resultados dos exames.' dsA,
	'Transfundir componentes eritrocitário apenas após Provas de Compatibilidade' dsB,
	'Identificar adequadamente o receptor. Utilizar unicamente equipo de infusao com' dsc,
	'filtro padrao para transfusao ou com filtro de leucocitos para uso a beira do' dsD,
	'CENTRAL GOIANA DE SOROLOGIA' dsE,
	'AEROPORTO CEP 74075-030 GOIANIA/GO - RESP TECN. ROBERIO P.A.' dsF,
	'ALEMIDA CRF 5/1.1964' dsG,
	'R. 7A N. 1590, ED RIOL SL, 101 ST.' dsH,
	CASE WHEN 	e.ie_fator_rh='-' THEN 'cde - '||	(	select	upper(max(y.ds_resultado))								from	san_exame_lote x,									san_exame_realizado y								where	x.nr_sequencia = y.nr_seq_exame_lote								and	y.nr_seq_exame = 12							)  ELSE '' END  dsi,
	'RESULTADOS IMUNOLOGICOS E SOROLOGICOS LIBERADOS DE ACORDO COM A PORTARIA Nº.121' dsJ,
	'M.S./SVN E RDC Nº.153 DE 14 DE JULHO DE 2004.' dsK,
	'HIV, HEPATITE B (HBSAg, HBc), HEPATITE C (HCV), HTLV' linha3,
	'I/II. D.CHAGAS, SIFILIS E AUSÊNCIA DE HBs ANORMAIS' linha4,
	CASE WHEN a.ie_realiza_nat='S' THEN 'NAT para HIV e HCV HBV'  ELSE '' END  ie_nat
from	pessoa_fisica d,
	pessoa_fisica e,
	san_derivado c,
	san_doacao a,
	san_producao b
where	a.nr_sequencia = b.nr_seq_doacao
and	b.nr_seq_derivado = c.nr_sequencia
and	b.cd_pf_realizou = d.cd_pessoa_fisica
and	a.cd_pessoa_fisica = e.cd_pessoa_fisica
and	not exists (	select	1
				from	san_exame_lote e,
					san_exame_realizado f
				where	e.nr_sequencia = f.nr_seq_exame_lote
				and	e.nr_seq_doacao = a.nr_sequencia
				and	replace(upper(f.ds_resultado),' ','') in ('POSITIVO','ANDAMENTO','INDETERMINADO')
		);

