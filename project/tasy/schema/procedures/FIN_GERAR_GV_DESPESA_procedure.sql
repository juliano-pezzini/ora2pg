-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fin_gerar_gv_despesa ( nr_seq_viagem_p bigint, nm_usuario_p text, ie_opcao_p text DEFAULT 'X', qt_dias_prev_p bigint DEFAULT NULL, ds_obs_p text DEFAULT '', ds_msg_out_p INOUT text DEFAULT NULL, vl_pend_hosp_p bigint DEFAULT 0, vl_pend_transp_p bigint DEFAULT 0, ds_mtvo_itinerario_p text DEFAULT '', ie_regra_just_p text default 'X', ie_enviar_ci_email text default 'S', ds_out_p INOUT text DEFAULT NULL) AS $body$
DECLARE


cd_pessoa_fisica_w  	varchar(10);
cd_pessoa_aprov_w  	varchar(10);
cd_pessoa_aprov_ww	varchar(10) := 'X';
cd_coordenador_w		varchar(10);
cd_gerente_projeto_w	varchar(10);
cd_pessoa_aprov_rel_w	varchar(10);   -- Pessoa de aprovacao dos relatorios de despesas
cd_pessoa_aprov_rel_sub_w		varchar(10);   -- Substituto de aprovacao dos relatorios de despesas
cd_pessoa_aprov_comunic_w		varchar(10);
cd_pessoa_aprov_comunic_sub_w	varchar(10);
vl_hospedagem_w 		double precision;
vl_transporte_w  		double precision;
vl_reslat_desp_w		double precision;
vl_relat_desp_w			double precision;
vl_pend_adia_w			double precision;
qt_registro_w  			bigint;
nr_seq_classif_w  		bigint;
ie_origem_w 			proj_projeto.ie_origem%TYPE;
ds_origem_w				varchar(255);
ds_destino_w			varchar(255);
ds_destino_sub_w		varchar(255);
ie_transp_w				varchar(1);
ie_hosp_w				varchar(1);
nr_seq_projeto_w		bigint;
nr_seq_centro_custo_w	bigint;
cd_aprov_sub_w			varchar(10);
cd_cgc_agencia_w		varchar(14);
nr_seq_aeroporto_ori_w	bigint;
nr_seq_aeroporto_des_w	bigint;
vl_reserva_w			double precision;
vl_medio_w				double precision;
vl_limite_w				double precision;
vl_limite_sup_w			double precision;
qt_dias_prev_w			bigint;
ie_resp_custo_w			bigint;
ie_nosso_custo_w		varchar(1);
ds_observacao_w			varchar(4000);
ds_obs_politica_w		varchar(4000);
nm_usuario_pf_w			varchar(15);

cd_aprov_diretor_geral_w	varchar(10);
cd_aprov_diretor_w		varchar(10);
cd_aprov_subdiretor_w	varchar(10);
cd_aprov_gerente_w		varchar(10);
cd_aprov_subgerente_w	varchar(10);
ie_cargo_viajante_w		varchar(1);
ie_justificativa_w		varchar(1);

cd_aprov_sub_geral_w	varchar(10);

qt_email_w				bigint;

qt_meio_transporte_w	bigint;

/* Utilizado para verificar se necessita da aprovacao do gerento do projeto. No caso da viagem quando for custo do cliente, e  no relatorio de despesas, quando gv de projeto*/

ie_aprovacao_projeto_w varchar(1);


c01 CURSOR FOR
SELECT	a.cd_cnpj,
	a.nr_seq_aeroporto_ori,
	a.nr_seq_aeroporto_des,
	b.vl_reserva
FROM	via_reserva b,
	via_transporte a
WHERE	a.nr_sequencia = b.nr_seq_itinerario
AND	b.nr_seq_viagem = nr_seq_viagem_p
AND	b.ie_responsavel_custo = 'N'
AND	(b.nr_seq_meio_transp IS NOT NULL AND b.nr_seq_meio_transp::text <> '');

c02 CURSOR FOR
SELECT	CASE WHEN qt_dias_prev_w=7 THEN a.vl_medio_7_dias WHEN qt_dias_prev_w=30 THEN a.vl_medio_30_dias WHEN qt_dias_prev_w=60 THEN a.vl_medio_60_dias END ,
	CASE WHEN qt_dias_prev_w=7 THEN a.vl_limite_7_dias WHEN qt_dias_prev_w=30 THEN a.vl_limite_30_dias WHEN qt_dias_prev_w=60 THEN a.vl_limite_60_dias END ,
	CASE WHEN qt_dias_prev_w=7 THEN a.vl_limite_sup_7_dias WHEN qt_dias_prev_w=30 THEN a.vl_limite_sup_30_dias WHEN qt_dias_prev_w=60 THEN a.vl_limite_sup_60_dias END
FROM	via_regra_valor_viagem a
WHERE	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
AND	a.cd_cgc_agencia = cd_cgc_agencia_w
AND	a.nr_seq_aero_origem = nr_seq_aeroporto_ori_w
AND	a.nr_seq_aero_destino = nr_seq_aeroporto_des_w
AND	((clock_timestamp() BETWEEN dt_ini_vigencia AND dt_fim_vigencia)
OR (coalesce(dt_ini_vigencia::text, '') = '')
OR (coalesce(dt_fim_vigencia::text, '') = ''));


BEGIN
ds_msg_out_p := '';

select	max(obter_cd_pessoa_substituta(a.cd_pessoa_fisica))
into STRICT	cd_aprov_sub_geral_w
from	departamento_philips a
where	a.nr_sequencia = 4;

IF (coalesce(qt_dias_prev_p,0) <= 7) then
	qt_dias_prev_w := 7;
elsif (coalesce(qt_dias_prev_p,0) > 7) AND (coalesce(qt_dias_prev_p,0) <= 30) then
	qt_dias_prev_w := 30;
elsif (coalesce(qt_dias_prev_p,0) > 30) then
	qt_dias_prev_w := 60;
END IF;


SELECT 	COUNT(nr_sequencia)
INTO STRICT 	qt_registro_w
FROM 	fin_gv_pend_aprov
WHERE 	nr_seq_viagem = nr_seq_viagem_p;

SELECT 	MAX(cd_pessoa_fisica)
INTO STRICT 	cd_pessoa_fisica_w
FROM 	via_viagem
WHERE 	nr_sequencia = nr_seq_viagem_p;

-- Carga das informacoes de aprovacao
SELECT	MAX(cd_diretoria_geral),
	MAX(cd_diretor),
	MAX(cd_aprov_substituto),
	MAX(cd_aprov_gerente),
	MAX(cd_sub_gerente),
	MAX(ie_cargo)
INTO STRICT	cd_aprov_diretor_geral_w,
	cd_aprov_diretor_w,
	cd_aprov_subdiretor_w,
	cd_aprov_gerente_w,
	cd_aprov_subgerente_w,
	ie_cargo_viajante_w
FROM   organograma_v
WHERE  cd_viajante = cd_pessoa_fisica_w;


SELECT	MAX(nm_usuario)
INTO STRICT	nm_usuario_pf_w
FROM	usuario
WHERE	cd_pessoa_fisica = cd_pessoa_fisica_w
AND	ie_situacao = 'A';

SELECT 	sum(coalesce(VL_RESERVA,0))
INTO STRICT	vl_transporte_w
FROM 	via_reserva
WHERE 	nr_seq_viagem = nr_seq_viagem_p
AND 	nr_seq_meio_transp > 0;

SELECT 	sum(coalesce(obter_valor_total_hotel(a.nr_sequencia),0))
INTO STRICT	vl_hospedagem_w
FROM 	via_reserva a
WHERE 	a.nr_seq_viagem = nr_seq_viagem_p
AND 	a.nr_seq_hotel > 0;

select	sum(coalesce(a.vl_adiantamento,0))
into STRICT	vl_pend_adia_w
from	via_adiantamento a
where	a.nr_seq_viagem = nr_seq_viagem_p;

SELECT	SUM(coalesce(a.vl_despesa,0))
INTO STRICT	vl_relat_desp_w
FROM 	via_despesa a,
	via_relat_desp b
WHERE	b.nr_sequencia = a.nr_seq_relat
AND	b.nr_seq_viagem = nr_seq_viagem_p
AND	(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '');

SELECT	SUM(coalesce(a.vl_despesa,0))
INTO STRICT	vl_reslat_desp_w
FROM 	via_despesa a,
	via_relat_desp b
WHERE	b.nr_sequencia = a.nr_seq_relat
AND	b.nr_seq_viagem = nr_seq_viagem_p;

SELECT	DISTINCT
	CASE WHEN coalesce(a.nr_seq_classif::text, '') = '' THEN 19  ELSE a.nr_seq_classif END ,
	ie_origem
INTO STRICT	nr_seq_classif_w,
	ie_origem_w
FROM via_destino b
LEFT OUTER JOIN proj_projeto a ON (b.nr_seq_proj = a.nr_sequencia)
WHERE b.nr_seq_viagem = nr_seq_viagem_p;

ie_nosso_custo_w := 'N';

SELECT	count(1)
INTO STRICT	ie_resp_custo_w
FROM	via_reserva a
WHERE	ie_responsavel_custo = 'N'      -- Nossa Empresa	
AND 	nr_seq_viagem = nr_seq_viagem_p;

IF (ie_resp_custo_w > 0) then
		ie_nosso_custo_w := 'S';
END IF;

SELECT	count(*)
into STRICT	qt_meio_transporte_w
FROM	via_reserva b,
		via_transporte a
WHERE	a.nr_sequencia = b.nr_seq_itinerario
AND		b.nr_seq_viagem = nr_seq_viagem_p
AND		b.ie_responsavel_custo = 'N'
AND		b.nr_seq_meio_transp not in (2,3);

ds_msg_out_p := '';

/*
Aprovacao					Projeto		Aprov normal	Aprov superior
Projetos - Relatorios despesas			X		
Projetos - Viagem(custo cliente)			X		
Projetos - Viagem 15dias(custo cliente)		X		
Demais - Relatorios despesas					X	
Demais - Viagem						X	
Demais - Viagem 15dias								X
*/
ie_aprovacao_projeto_w := 'N';
if (ie_origem_w = 'P' and (coalesce(nr_seq_classif_w,19) not in (19,15)) and (ie_opcao_p = 'R' or ie_nosso_custo_w <> 'S')) then	
		ie_aprovacao_projeto_w := 'S';
end if;

if ie_aprovacao_projeto_w = 'N' then
	if (ie_opcao_p = 'R' or qt_dias_prev_p >=15 )then
		if (ie_cargo_viajante_w in ('F', 'L')) then	--Funcionario, Lider				
			cd_pessoa_aprov_w := cd_aprov_gerente_w; 	
			cd_aprov_sub_w := cd_aprov_subgerente_w;
			
			cd_pessoa_aprov_rel_w := cd_aprov_gerente_w; 	
			cd_pessoa_aprov_rel_sub_w := cd_aprov_subgerente_w;
		elsif (ie_cargo_viajante_w = 'G') then		--Gerente		
			cd_pessoa_aprov_w := cd_aprov_diretor_w;
			cd_aprov_sub_w := cd_aprov_subdiretor_w;
			
			cd_pessoa_aprov_rel_w := cd_aprov_diretor_w;
			cd_pessoa_aprov_rel_sub_w := cd_aprov_subdiretor_w;		
		elsif (ie_cargo_viajante_w = 'D') then		--Diretor		
			cd_pessoa_aprov_w := cd_aprov_diretor_geral_w;
			cd_aprov_sub_w := cd_aprov_sub_geral_w;
			
			cd_pessoa_aprov_rel_w := cd_aprov_diretor_geral_w;
			cd_pessoa_aprov_rel_sub_w := cd_aprov_sub_geral_w;		
		end if;
	else
		ds_msg_out_p := 'Y';
		IF (ie_cargo_viajante_w IN ('F', 'L', 'G')) then	--Funcionario, Lider, Gerente		
			cd_pessoa_aprov_w := cd_aprov_diretor_w;
			cd_aprov_sub_w := cd_aprov_subdiretor_w;
			cd_pessoa_aprov_rel_w := cd_aprov_diretor_w;
			cd_pessoa_aprov_rel_sub_w := cd_aprov_subdiretor_w;		
		elsif (ie_cargo_viajante_w IN ('D')) then		--Diretor		
			cd_pessoa_aprov_w := cd_aprov_diretor_geral_w;
			cd_aprov_sub_w := cd_aprov_sub_geral_w;
			cd_pessoa_aprov_rel_w := cd_aprov_diretor_geral_w;
			cd_pessoa_aprov_rel_sub_w := cd_aprov_sub_geral_w;		
		end if;
	end if;
end if;

if ie_aprovacao_projeto_w = 'S' then	
	SELECT	MAX(coalesce(a.nr_seq_proj,0))
	INTO STRICT	nr_seq_projeto_w
	FROM	via_destino a
	WHERE	a.nr_seq_viagem = nr_seq_viagem_p;

	SELECT	max(cd_coordenador),
		max(cd_gerente_projeto)
	INTO STRICT	cd_coordenador_w,
		cd_gerente_projeto_w
	FROM	proj_projeto
	WHERE	nr_sequencia = nr_seq_projeto_w;

	IF (cd_pessoa_fisica_w = cd_coordenador_w) then
		BEGIN
		cd_pessoa_aprov_w := cd_gerente_projeto_w;
		cd_pessoa_aprov_rel_w := cd_gerente_projeto_w;		

		SELECT	MAX(a.nr_seq_centro_custo),
			max(obter_cd_pessoa_substituta(b.cd_responsavel)),
			max(obter_cd_pessoa_substituta(b.cd_responsavel))
		INTO STRICT	nr_seq_centro_custo_w,
			cd_aprov_sub_w,
			cd_pessoa_aprov_rel_sub_w
		FROM	depto_gerencia_philips a,
			gerencia_wheb b
		WHERE	a.nr_seq_gerencia = b.nr_sequencia
		AND	b.cd_responsavel = cd_pessoa_aprov_w;
		END;
	elsif (cd_pessoa_fisica_w = cd_gerente_projeto_w) then
		BEGIN
		SELECT	MAX(a.cd_pessoa_fisica),
			max(obter_cd_pessoa_substituta(a.cd_pessoa_fisica)),
			max(obter_cd_pessoa_substituta(a.cd_pessoa_fisica))
		INTO STRICT 	cd_pessoa_aprov_w,
			cd_aprov_sub_w,
			cd_pessoa_aprov_rel_sub_w
		FROM 	departamento_philips a,
			depto_gerencia_philips b,
			gerencia_wheb c
		WHERE 	b.nr_seq_gerencia = c.nr_sequencia
		AND	b.nr_seq_departamento = a.nr_sequencia
		AND	c.cd_responsavel = cd_pessoa_fisica_w;

		SELECT	MAX(a.nr_seq_centro_custo)
		INTO STRICT	nr_seq_centro_custo_w
		FROM	depto_gerencia_philips a,
			gerencia_wheb b
		WHERE	a.nr_seq_gerencia = b.nr_sequencia
		AND	b.cd_responsavel = cd_pessoa_fisica_w;
		END;
	ELSE
		BEGIN
		cd_pessoa_aprov_w := cd_coordenador_w;
		cd_pessoa_aprov_rel_w := cd_coordenador_w;

		SELECT	MAX(a.nr_seq_centro_custo),
			MAX(obter_cd_pessoa_substituta(obter_cd_pessoa_responsavel(a.nr_seq_gerencia))),
			MAX(obter_cd_pessoa_substituta(obter_cd_pessoa_responsavel(a.nr_seq_gerencia)))
		INTO STRICT	nr_seq_centro_custo_w,
			cd_aprov_sub_w,
			cd_pessoa_aprov_rel_sub_w
		FROM	depto_gerencia_philips a,
			gerencia_wheb b,
			gerencia_wheb_grupo c
		WHERE	b.nr_sequencia = a.nr_seq_gerencia
		AND	b.nr_sequencia = c.nr_seq_gerencia
		AND	c.nm_usuario_lider = nm_usuario_pf_w;
		END;
	END IF;	
end if;

ie_justificativa_w := '';
IF (ds_msg_out_p = 'X') then
	ie_justificativa_w := 'V';
	ds_msg_out_p := obter_desc_expressao(1033129) || ' ' || obter_nome_pf(cd_pessoa_aprov_w) || CHR(13) || CHR(10) ||
			obter_desc_expressao(1033131);
elsif (ds_msg_out_p = 'Y') then
	ie_justificativa_w := 'D';
	ds_msg_out_p := obter_desc_expressao(1033129) || ' ' || obter_nome_pf(cd_pessoa_aprov_w) || CHR(13) || CHR(10) ||
			obter_desc_expressao(1033133);
ELSE	ds_msg_out_p := 'X';
END IF;

IF	((coalesce(cd_pessoa_aprov_w,'x') = 'x') and (coalesce(cd_pessoa_aprov_rel_w,'x') = 'x')) then
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(244324);
END IF;

nr_seq_centro_custo_w := 0;

IF (qt_registro_w = 0) then
	BEGIN
	INSERT INTO fin_gv_pend_aprov(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_viagem,
		cd_pessoa_fisica,
		cd_pessoa_aprov,
		cd_aprov_sub,
		cd_pessoa_aprov_rel_desp,
		cd_pessoa_aprov_rel_desp_sub,
		ie_situacao_pend,
		vl_hospedagem,
		vl_transporte,
		vl_adiantamento,
		vl_relat_desp,
		vl_pend_adia,
		dt_aprov_adia,
		dt_aprov_desp,
		dt_aprov_transp,
		dt_aprov_hosp,
		dt_aprov_gv,
		dt_reprov_adia,
		dt_reprov_desp,
		dt_reprov_transp,
		dt_reprov_hosp,
		dt_reprov_gv,
		dt_aprov_relatorio,
		dt_reprov_relatorio,
		ds_mtvo_reprov_adia,
		ds_mtvo_reprov_desp,
		nr_mtvo_reprov_desp,
		nr_mtvo_reprov_adia,
		nr_seq_centro_custo,
		qt_dias_prev_solic,
		ds_just_7_dias,
		vl_pend_hosp,
		vl_pend_transp,
		ds_mtvo_regra_valor)
	VALUES (nextval('fin_gv_pend_aprov_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_viagem_p,
		cd_pessoa_fisica_w,
		cd_pessoa_aprov_w,
		coalesce(cd_aprov_sub_w,cd_pessoa_aprov_w),
		cd_pessoa_aprov_rel_w,
		coalesce(cd_pessoa_aprov_rel_sub_w, cd_pessoa_aprov_rel_w),		
		CASE WHEN ie_opcao_p='R' THEN 'PR'  ELSE 'PG' END ,
		0,
		0,
		vl_relat_desp_w,
		NULL,
		vl_pend_adia_w,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		null,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		nr_seq_centro_custo_w,
		qt_dias_prev_p,
		CASE WHEN ie_regra_just_p='D' THEN  ds_obs_p  ELSE null END ,
		vl_hospedagem_w,
		vl_transporte_w,
		CASE WHEN ie_regra_just_p='V' THEN  ds_obs_p  ELSE null END );
	END;
ELSE				
	BEGIN
	SELECT	CASE WHEN coalesce(a.dt_reprov_transp::text, '') = '' THEN 'N'  ELSE 'S' END ,
		CASE WHEN coalesce(a.dt_reprov_hosp::text, '') = '' THEN 'N'  ELSE 'S' END
	INTO STRICT	ie_transp_w,
		ie_hosp_w
	FROM	fin_gv_pend_aprov a
	WHERE	a.nr_seq_viagem = nr_seq_viagem_p;

	UPDATE 	fin_gv_pend_aprov
	SET 	nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp(),
		vl_pend_transp = vl_transporte_w,
		vl_pend_hosp = vl_hospedagem_w,
		vl_pend_adia = vl_pend_adia_w,
		ie_situacao_pend = CASE WHEN ie_opcao_p='R' THEN 'PR'  ELSE 'PG' END ,
		vl_relat_desp = vl_relat_desp_w,
		nr_seq_centro_custo = nr_seq_centro_custo_w,
		qt_dias_prev_solic = qt_dias_prev_p,
		ds_mtvo_etinerario = ds_mtvo_itinerario_p,
		ds_mtvo_regra_valor = CASE WHEN ie_justificativa_w='V' THEN  ds_obs_p  ELSE null END
	WHERE 	nr_seq_viagem = nr_seq_viagem_p;

	IF (ie_transp_w = 'S') then
		BEGIN
		UPDATE 	fin_gv_pend_aprov
		SET 	dt_aprov_transp  = NULL,
			dt_reprov_transp  = NULL
		WHERE 	nr_seq_viagem = nr_seq_viagem_p;
		END;
	elsif (ie_hosp_w = 'S') then
		BEGIN
		UPDATE 	fin_gv_pend_aprov
		SET 	dt_aprov_hosp  = NULL,
			dt_reprov_hosp  = NULL
		WHERE 	nr_seq_viagem = nr_seq_viagem_p;
		END;
	END IF;
	IF (ie_opcao_p = 'R') then
		BEGIN
		UPDATE	via_relat_desp
		SET	dt_liberacao = clock_timestamp(),
			nm_usuario_libera = nm_usuario_p
		WHERE	nr_seq_viagem = nr_seq_viagem_p;

		UPDATE 	fin_gv_pend_aprov
		SET 	dt_reprov_relatorio  = NULL,
			dt_aprov_relatorio  = NULL,
			dt_reprov_gv  = NULL
		WHERE 	nr_seq_viagem = nr_seq_viagem_p;
		END;
	END IF;
	END;
END IF;

IF ((ie_opcao_p = 'R') and ((cd_pessoa_aprov_rel_w IS NOT NULL AND cd_pessoa_aprov_rel_w::text <> '') or (cd_pessoa_aprov_rel_sub_w IS NOT NULL AND cd_pessoa_aprov_rel_sub_w::text <> ''))) then
	BEGIN	
	cd_pessoa_aprov_comunic_w := cd_pessoa_aprov_rel_w;
	cd_pessoa_aprov_comunic_sub_w := cd_pessoa_aprov_rel_sub_w;
	END;
ELSE
	BEGIN
	cd_pessoa_aprov_comunic_w := cd_pessoa_aprov_w;
	cd_pessoa_aprov_comunic_sub_w := cd_aprov_sub_w;
	END;
END IF;	

SELECT 	coalesce(MAX(ds_email), '') email_origem
INTO STRICT 	ds_origem_w
FROM 	usuario
WHERE 	cd_pessoa_fisica = cd_pessoa_fisica_w;

qt_email_w := coalesce(position(';' in ds_origem_w),0);

if (qt_email_w > 0) then
	ds_origem_w := substr(ds_origem_w,0,qt_email_w -1);
end if;

SELECT 	coalesce(MAX(ds_email), '') email_destino
INTO STRICT 	ds_destino_w
FROM 	usuario
WHERE 	cd_pessoa_fisica = cd_pessoa_aprov_comunic_w;

IF (coalesce(cd_pessoa_aprov_comunic_w,'0') <> coalesce(cd_pessoa_aprov_comunic_sub_w,'0')) then
	BEGIN
	SELECT 	coalesce(MAX(ds_email), '') email_destino
	INTO STRICT 	ds_destino_sub_w
	FROM 	usuario
	WHERE 	cd_pessoa_fisica = cd_pessoa_aprov_comunic_sub_w;

	ds_destino_w := ds_destino_w || ';' || ds_destino_sub_w;
	END;
END IF;

ds_obs_politica_w := '';
IF (coalesce(ds_obs_p,'X') <> 'X') then
	ds_obs_politica_w := (ds_obs_politica_w || CHR(13) || CHR(10) || obter_desc_expressao(1033145) || CHR(13) || CHR(10) || ds_obs_p);
END IF;

IF (ds_msg_out_p <> 'X')  then
	ds_observacao_w := (obter_desc_expressao(560602) || CHR(13) || CHR(10) || ds_msg_out_p);
ELSE	ds_observacao_w := '';
END IF;

ds_observacao_w := (ds_observacao_w || ds_obs_politica_w);

IF (ie_opcao_p = 'A' and ie_enviar_ci_email = 'S') then
	BEGIN
	CALL gerar_comunic_padrao(	clock_timestamp(),
				obter_desc_expressao(1033149),
				obter_desc_expressao(1033155) || ' '  || nr_seq_viagem_p || CHR(13) || CHR(10) ||
				obter_desc_expressao(329239) || obter_nome_pf(cd_pessoa_fisica_w) || CHR(13) || CHR(10) ||
				ds_observacao_w,
				nm_usuario_p,
				'N',
				obter_usuario_pf(cd_pessoa_aprov_comunic_w) || ',',
				'S',
				NULL,
				'',
				'',
				'',
				clock_timestamp(),
				'',
				'');
	
	begin
		CALL enviar_email(	obter_desc_expressao(1033149),
			obter_desc_expressao(1033155) || ' ' || nr_seq_viagem_p || CHR(13) || CHR(10) ||
			obter_desc_expressao(329239) || obter_nome_pf(cd_pessoa_aprov_comunic_w) || CHR(13) || CHR(10) ||
			ds_observacao_w,
			ds_origem_w,
			ds_destino_w,
			nm_usuario_p,
			'M');
	exception
	when others then
		ds_out_p := Obter_desc_expressao(766619) ||chr(13)|| chr(10)|| chr(13)|| chr(10)||
					Obter_desc_expressao(716501, 'Seq viagem') || ': ' || nr_seq_viagem_p ||chr(13)||chr(10)||
					Obter_desc_expressao(505965) ||chr(13)|| chr(10);
					if (cd_pessoa_aprov_w IS NOT NULL AND cd_pessoa_aprov_w::text <> '') then
						ds_out_p := ds_out_p || obter_nome_pf(cd_pessoa_aprov_w) ||chr(13)|| chr(10);
					end if;
					if (cd_aprov_sub_w IS NOT NULL AND cd_aprov_sub_w::text <> '') then
						ds_out_p := ds_out_p || obter_nome_pf(cd_aprov_sub_w) ||chr(13)|| chr(10);
					end if;
					if (cd_pessoa_aprov_rel_w IS NOT NULL AND cd_pessoa_aprov_rel_w::text <> '') then
						ds_out_p := ds_out_p || obter_nome_pf(cd_pessoa_aprov_rel_w) ||chr(13)|| chr(10);
					end if;
					if (cd_pessoa_aprov_rel_sub_w IS NOT NULL AND cd_pessoa_aprov_rel_sub_w::text <> '') then
						ds_out_p := ds_out_p || obter_nome_pf(cd_pessoa_aprov_rel_sub_w) ||chr(13)|| chr(10);
					end if;					
					ds_out_p := ds_out_p || Obter_desc_expressao(612263) || substr(ds_destino_w, 1, 255);
										
		ds_out_p := substr(ds_out_p, 1, 255);	
	end;		
	END;
elsif (ie_opcao_p = 'P' and ie_enviar_ci_email = 'S') then
	BEGIN
	CALL gerar_comunic_padrao(	clock_timestamp(),
				obter_desc_expressao(1033149),
				obter_desc_expressao(1033157) || ' ' || nr_seq_viagem_p || CHR(13) || CHR(10) ||
				obter_desc_expressao(329239) || obter_nome_pf(cd_pessoa_fisica_w) || CHR(13) || CHR(10) ||
				ds_observacao_w,
				nm_usuario_p,
				'N',
				obter_usuario_pf(cd_pessoa_aprov_comunic_w) || ',',
				'S',
				NULL,
				'',
				'',
				'',
				clock_timestamp(),
				'',
				'');

	begin
		CALL enviar_email(	obter_desc_expressao(1033149),
			obter_desc_expressao(1033149) || ' ' || nr_seq_viagem_p || CHR(13) || CHR(10) ||
			obter_desc_expressao(329239) || obter_nome_pf(cd_pessoa_fisica_w) || CHR(13) || CHR(10) ||
			ds_observacao_w,
			ds_origem_w,
			ds_destino_w,
			nm_usuario_p,
			'M');
	exception
	when others then	
		ds_out_p := Obter_desc_expressao(766619) ||chr(13)|| chr(10)|| chr(13)|| chr(10)||
					Obter_desc_expressao(716501, 'Seq viagem') || ': ' || nr_seq_viagem_p ||chr(13)||chr(10)||
					Obter_desc_expressao(505965) ||chr(13)|| chr(10);
					if (cd_pessoa_aprov_w IS NOT NULL AND cd_pessoa_aprov_w::text <> '') then
						ds_out_p := ds_out_p || obter_nome_pf(cd_pessoa_aprov_w) ||chr(13)|| chr(10);
					end if;
					if (cd_aprov_sub_w IS NOT NULL AND cd_aprov_sub_w::text <> '') then
						ds_out_p := ds_out_p || obter_nome_pf(cd_aprov_sub_w) ||chr(13)|| chr(10);
					end if;
					if (cd_pessoa_aprov_rel_w IS NOT NULL AND cd_pessoa_aprov_rel_w::text <> '') then
						ds_out_p := ds_out_p || obter_nome_pf(cd_pessoa_aprov_rel_w) ||chr(13)|| chr(10);
					end if;
					if (cd_pessoa_aprov_rel_sub_w IS NOT NULL AND cd_pessoa_aprov_rel_sub_w::text <> '') then
						ds_out_p := ds_out_p || obter_nome_pf(cd_pessoa_aprov_rel_sub_w) ||chr(13)|| chr(10);
					end if;					
					ds_out_p := ds_out_p || Obter_desc_expressao(612263) || substr(ds_destino_w, 1, 255);
										
		ds_out_p := substr(ds_out_p, 1, 255);			
	end;					
				
	
	END;
elsif (ie_opcao_p = 'R' and ie_enviar_ci_email = 'S') then
	BEGIN
	CALL gerar_comunic_padrao(	clock_timestamp(),
				obter_desc_expressao(1033149),
				obter_desc_expressao(1033165) || ' ' || nr_seq_viagem_p || CHR(13) || CHR(10) ||
				obter_desc_expressao(329239) || obter_nome_pf(cd_pessoa_fisica_w) || CHR(13) || CHR(10) ||
				ds_observacao_w,
				nm_usuario_p,
				'N',
				obter_usuario_pf(cd_pessoa_aprov_comunic_w) || ',',
				'S',
				NULL,
				'',
				'',
				'',
				clock_timestamp(),
				'',
				'');

	
	begin
		CALL enviar_email(	obter_desc_expressao(1033149),
			obter_desc_expressao(1033167) || ' ' || nr_seq_viagem_p || CHR(13) || CHR(10) ||
			obter_desc_expressao(329239) || obter_nome_pf(cd_pessoa_fisica_w) || CHR(13) || CHR(10) ||
			ds_observacao_w,
			ds_origem_w,
			ds_destino_w,
			nm_usuario_p,
			'M');
	exception
	when others then
		ds_out_p := Obter_desc_expressao(766619) ||chr(13)|| chr(10)|| chr(13)|| chr(10)||
					Obter_desc_expressao(716501, 'Seq viagem') || ': ' || nr_seq_viagem_p ||chr(13)||chr(10)||
					Obter_desc_expressao(505965) ||chr(13)|| chr(10);
					if (cd_pessoa_aprov_w IS NOT NULL AND cd_pessoa_aprov_w::text <> '') then
						ds_out_p := ds_out_p || obter_nome_pf(cd_pessoa_aprov_w) ||chr(13)|| chr(10);
					end if;
					if (cd_aprov_sub_w IS NOT NULL AND cd_aprov_sub_w::text <> '') then
						ds_out_p := ds_out_p || obter_nome_pf(cd_aprov_sub_w) ||chr(13)|| chr(10);
					end if;
					if (cd_pessoa_aprov_rel_w IS NOT NULL AND cd_pessoa_aprov_rel_w::text <> '') then
						ds_out_p := ds_out_p || obter_nome_pf(cd_pessoa_aprov_rel_w) ||chr(13)|| chr(10);
					end if;
					if (cd_pessoa_aprov_rel_sub_w IS NOT NULL AND cd_pessoa_aprov_rel_sub_w::text <> '') then
						ds_out_p := ds_out_p || obter_nome_pf(cd_pessoa_aprov_rel_sub_w) ||chr(13)|| chr(10);
					end if;					
					ds_out_p := ds_out_p || Obter_desc_expressao(612263) || substr(ds_destino_w, 1, 255);
										
		ds_out_p := substr(ds_out_p, 1, 255);
	end;		
	END;
END IF;

COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fin_gerar_gv_despesa ( nr_seq_viagem_p bigint, nm_usuario_p text, ie_opcao_p text DEFAULT 'X', qt_dias_prev_p bigint DEFAULT NULL, ds_obs_p text DEFAULT '', ds_msg_out_p INOUT text DEFAULT NULL, vl_pend_hosp_p bigint DEFAULT 0, vl_pend_transp_p bigint DEFAULT 0, ds_mtvo_itinerario_p text DEFAULT '', ie_regra_just_p text default 'X', ie_enviar_ci_email text default 'S', ds_out_p INOUT text DEFAULT NULL) FROM PUBLIC;

