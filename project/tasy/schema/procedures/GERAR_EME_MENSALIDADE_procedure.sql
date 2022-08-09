-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_eme_mensalidade ( cd_contrato_p text, nr_seq_regra_preco_p bigint, nr_seq_cobertura_p bigint, dt_competencia_p timestamp, ie_gera_nota_titulo_p text, cd_convenio_p bigint, cd_categoria_p text, cd_setor_atendimento_p bigint, cd_estabelecimento_p bigint, dt_emissao_p timestamp, qt_dia_vencimento_p bigint, nm_usuario_p text, dt_vencimento_p timestamp, faturas_nao_geradas_p INOUT text, ie_emissao_alterada_p INOUT text) AS $body$
DECLARE

 
nr_faturamento_w		bigint;
nr_seq_contrato_w		bigint;
vl_preco_w			double precision;
qt_dia_vencimento_w		smallint;
ie_reajuste_w			varchar(3);
dt_vencimento_w			timestamp;
dt_anual_w			timestamp;
dt_mensal_w			timestamp;
dt_trimestre_w			timestamp;
cd_contrato_w			varchar(20);
contratos_nao_gerados_w		varchar(4000);
faturas_nao_geradas_w		varchar(4000);
ie_numero_nota_w		varchar(1);
ie_perm_gerar_nt_tit_w		varchar(1) := obter_valor_param_usuario(929, 1,obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_p);
ds_parametro_w			varchar(1) := obter_valor_param_usuario(929,28,obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_p);
ie_dt_competencia_w		varchar(1) := obter_valor_param_usuario(929,25,obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_p);
chamados_faturar_w		bigint;
ie_base_calculo_w		varchar(1);
dt_emissao_w			timestamp;
ie_emissao_alterada_w		varchar(1) := 'N';
dt_limite_chamado_w		timestamp := clock_timestamp();

C01 CURSOR FOR 
	SELECT	a.nr_sequencia, 
		coalesce(Obter_eme_valor_fatura(a.nr_sequencia,dt_competencia_p, null, 'X'),0), 
		qt_dia_vencimento, 
		ie_reajuste 
	FROM	eme_contrato a, 
		eme_regra_preco b 
	WHERE	b.nr_sequencia		= a.nr_seq_regra_preco 
	AND	a.cd_contrato		= coalesce(cd_contrato_p, a.cd_contrato) 
	AND	a.nr_seq_regra_preco	= coalesce(nr_seq_regra_preco_p, nr_seq_regra_preco) 
	AND	a.nr_seq_cobertura	= coalesce(nr_seq_cobertura_p, nr_seq_cobertura) 
	AND	a.cd_categoria		= coalesce(cd_categoria_p, cd_categoria) 
	AND	a.cd_convenio		= coalesce(cd_convenio_p, cd_convenio) 
	AND	a.qt_dia_vencimento	= coalesce(qt_dia_vencimento_p, qt_dia_vencimento) 
	AND	coalesce(a.dt_cancelamento::text, '') = '' 
	AND	b.ie_base_calculo <> 'N' 
	AND (coalesce(a.dt_validade::text, '') = '' 
	OR (ie_dt_competencia_w = 'S' AND pkg_date_utils.get_datetime(pkg_date_utils.end_of(a.dt_validade, 'MONTH'), coalesce(a.dt_validade, PKG_DATE_UTILS.GET_TIME('00:00:00')), 0) > dt_competencia_p) 
	OR (ie_dt_competencia_w = 'N' AND pkg_date_utils.get_datetime(pkg_date_utils.end_of(a.dt_validade, 'MONTH'), coalesce(a.dt_validade, PKG_DATE_UTILS.GET_TIME('00:00:00')), 0) > clock_timestamp())) 
	AND	NOT EXISTS (	SELECT	b.nr_seq_contrato, b.dt_emissao 
				FROM	eme_faturamento b 
				WHERE	TO_CHAR(dt_competencia_p,'mm/yyyy') = TO_CHAR(b.dt_competencia,'mm/yyyy') 
				AND	coalesce(dt_cancelamento::text, '') = '' 
				AND	b.nr_seq_contrato = a.nr_sequencia) 
	ORDER BY	a.nr_sequencia;

C02 CURSOR FOR 
	SELECT	a.cd_contrato 
	FROM	eme_contrato a, 
		eme_regra_preco b 
	WHERE	b.nr_sequencia		= a.nr_seq_regra_preco 
	AND	a.cd_contrato		= coalesce(cd_contrato_p, a.cd_contrato) 
	AND	a.nr_seq_regra_preco	= coalesce(nr_seq_regra_preco_p, nr_seq_regra_preco) 
	AND	a.nr_seq_cobertura	= coalesce(nr_seq_cobertura_p, nr_seq_cobertura) 
	AND	a.cd_categoria		= coalesce(cd_categoria_p, cd_categoria) 
	AND	a.cd_convenio		= coalesce(cd_convenio_p, cd_convenio) 
	AND	a.qt_dia_vencimento	= coalesce(qt_dia_vencimento_p, qt_dia_vencimento) 
	AND	coalesce(a.dt_cancelamento::text, '') = '' 
	AND	b.ie_base_calculo <> 'N' 
	AND (coalesce(a.dt_validade::text, '') = '' 
	OR (ie_dt_competencia_w = 'S' AND pkg_date_utils.get_datetime(pkg_date_utils.end_of(a.dt_validade, 'MONTH'), coalesce(a.dt_validade, PKG_DATE_UTILS.GET_TIME('00:00:00')), 0)> dt_competencia_p) 
	OR (ie_dt_competencia_w = 'N' AND pkg_date_utils.get_datetime(pkg_date_utils.end_of(a.dt_validade, 'MONTH'), coalesce(a.dt_validade, PKG_DATE_UTILS.GET_TIME('00:00:00')), 0)> clock_timestamp())) 
	AND	EXISTS (	SELECT	b.nr_seq_contrato, b.dt_emissao 
			FROM	eme_faturamento b 
			WHERE	TO_CHAR(dt_competencia_p,'mm/yyyy') = TO_CHAR(b.dt_competencia,'mm/yyyy') 
			AND	coalesce(dt_cancelamento::text, '') = '' 
			AND	b.nr_seq_contrato = a.nr_sequencia) 
	ORDER BY	a.nr_sequencia;


BEGIN 
 
OPEN C02;
LOOP 
FETCH C02 INTO 
	cd_contrato_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	BEGIN 
 
	contratos_nao_gerados_w := contratos_nao_gerados_w||cd_contrato_w||',';
 
	END;
END LOOP;
CLOSE C02;
 
if (ie_dt_competencia_w = 'S') then 
	select	pkg_date_utils.get_datetime(pkg_date_utils.end_of(dt_competencia_p, 'MONTH'), coalesce(dt_competencia_p, PKG_DATE_UTILS.GET_TIME('00:00:00')), 0) 
	into STRICT	dt_limite_chamado_w 
	;
end if;
 
select	count(1) 
into STRICT	chamados_faturar_w 
from	eme_chamado 
where	ie_faturamento = 'S' 
and	coalesce(nr_seq_faturamento::text, '') = '' 
and	PKG_DATE_UTILS.start_of(dt_chamado,'dd',0) <= PKG_DATE_UTILS.start_of(dt_limite_chamado_w,'dd',0);
 
OPEN C01;
LOOP 
FETCH C01 INTO 
	nr_seq_contrato_w, 
	vl_preco_w, 
	qt_dia_vencimento_w, 
	ie_reajuste_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	BEGIN 
	select	max(a.ie_base_calculo) 
	into STRICT	ie_base_calculo_w 
	from	eme_regra_preco a, 
		eme_contrato b 
	where	b.nr_seq_regra_preco	= a.nr_sequencia 
	and	b.nr_sequencia		= nr_seq_contrato_w;
 
	if (ie_base_calculo_w = 'A') then 
		dt_emissao_w := clock_timestamp();
		ie_emissao_alterada_w := 'S';
	else 
		dt_emissao_w := dt_emissao_p;
	end if;
 
	IF	((ie_base_calculo_w = 'A') and 
		(( vl_preco_w > 0) or (chamados_faturar_w > 0))) or 
		((ie_base_calculo_w <> 'A') and 
		((vl_preco_w > 0) or (eme_obter_valor_fatura(nr_seq_contrato_w,0) > 0))) THEN 
		BEGIN 
			SELECT	PKG_DATE_UTILS.ADD_MONTH(PKG_DATE_UTILS.start_of(clock_timestamp(),'DD',0),-12,0), 
				PKG_DATE_UTILS.ADD_MONTH(PKG_DATE_UTILS.start_of(clock_timestamp(),'DD',0),-1,0), 
				PKG_DATE_UTILS.ADD_MONTH(PKG_DATE_UTILS.start_of(clock_timestamp(),'DD',0),-3,0) 
			INTO STRICT	dt_anual_w, 
				dt_mensal_w, 
				dt_trimestre_w 
			;
 
			IF (dt_vencimento_p IS NOT NULL AND dt_vencimento_p::text <> '') then 
				dt_vencimento_w := dt_vencimento_p;
			ELSE 
				IF (ds_parametro_w = 'C') THEN 
					SELECT	pkg_date_utils.get_date(qt_dia_vencimento_w , pkg_date_utils.start_of(dt_competencia_p,'MONTH',0),0) 
					INTO STRICT	dt_vencimento_w 
					;
				ELSIF (ds_parametro_w = 'E') THEN 
					SELECT	pkg_date_utils.get_date(qt_dia_vencimento_w, pkg_date_utils.start_of(dt_emissao_w,'MONTH', 0),0) 
					INTO STRICT	dt_vencimento_w 
					;
				END IF;
			END IF;
 
			IF	(((ie_reajuste_w = 'A') AND (PKG_DATE_UTILS.start_of(dt_vencimento_w,'dd',0) >= dt_anual_w)) OR (ie_reajuste_w = 'M') OR 
				 ((ie_reajuste_w = 'T') AND (PKG_DATE_UTILS.start_of(dt_vencimento_w,'dd',0) >= dt_trimestre_w))) THEN 
 
				BEGIN 
 
					SELECT	nextval('eme_faturamento_seq') 
					INTO STRICT	nr_faturamento_w 
					;
 
					INSERT	INTO eme_faturamento( 
						nr_sequencia, 
						nr_seq_contrato, 
						dt_atualizacao, 
						nm_usuario, 
						dt_emissao, 
						dt_vencimento, 
						vl_fatura, 
						dt_competencia, 
						cd_estabelecimento) 
					VALUES ( 
						nr_faturamento_w, 
						nr_seq_contrato_w, 
						clock_timestamp(), 
						nm_usuario_p, 
						PKG_DATE_UTILS.start_of(dt_emissao_w,'dd',0), 
						PKG_DATE_UTILS.start_of(dt_vencimento_w,'dd',0), 
						vl_preco_w, 
						dt_competencia_p, 
						cd_estabelecimento_p);
 
					CALL eme_atua_fatura_valor(nr_faturamento_w, dt_emissao_w, dt_competencia_p, nr_seq_contrato_w, nm_usuario_p);
 
					/* Gera Nota Fiscal */
 
					IF (ie_gera_nota_titulo_p = 'S') THEN 
 
						select	max(c.ie_numero_nota) 
						into STRICT 	ie_numero_nota_w 
						from	serie_nota_fiscal c, 
							eme_contrato a 
						where	c.cd_serie_nf 		= a.cd_serie_nf 
						and	c.cd_estabelecimento 	= cd_estabelecimento_p 
						and	a.nr_sequencia		= nr_seq_contrato_w;
 
						if	(ie_perm_gerar_nt_tit_w = 'S' AND ie_numero_nota_w = 'M') then 
							faturas_nao_geradas_w := faturas_nao_geradas_w||nr_faturamento_w||',';
						else 
							CALL Gerar_eme_nota_fiscal(nm_usuario_p,cd_estabelecimento_p,nr_faturamento_w,cd_setor_atendimento_p,'S',0);
						end if;
					END IF;
				END;
			END IF;
		END;
	END IF;
	END;
END LOOP;
CLOSE C01;
 
COMMIT;
 
IF (contratos_nao_gerados_w IS NOT NULL AND contratos_nao_gerados_w::text <> '') THEN 
	contratos_nao_gerados_w := SUBSTR(contratos_nao_gerados_w,1,LENGTH(contratos_nao_gerados_w)-1);
	--As mensalidades não foram geradas para os seguintes contratos: #@DS_CONTRATOS#@ pois já foram geradas para o período informado. 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(188765,'DS_CONTRATOS='||contratos_nao_gerados_w);
END IF;
 
if (faturas_nao_geradas_w IS NOT NULL AND faturas_nao_geradas_w::text <> '') then 
	faturas_nao_geradas_p 	:= faturas_nao_geradas_w;
end if;
 
ie_emissao_alterada_p := ie_emissao_alterada_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_eme_mensalidade ( cd_contrato_p text, nr_seq_regra_preco_p bigint, nr_seq_cobertura_p bigint, dt_competencia_p timestamp, ie_gera_nota_titulo_p text, cd_convenio_p bigint, cd_categoria_p text, cd_setor_atendimento_p bigint, cd_estabelecimento_p bigint, dt_emissao_p timestamp, qt_dia_vencimento_p bigint, nm_usuario_p text, dt_vencimento_p timestamp, faturas_nao_geradas_p INOUT text, ie_emissao_alterada_p INOUT text) FROM PUBLIC;
