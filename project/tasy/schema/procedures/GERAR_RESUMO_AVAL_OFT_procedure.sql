-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_resumo_aval_oft ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_item_w		bigint;
ds_item_w		varchar(32000);
ds_resultado_w		varchar(32000);
ds_conteudo_w		varchar(32000);
ie_resultado_w		varchar(10);
nr_atendimento_w		bigint;
cd_pessoa_fisica_w	varchar(10);
cd_medico_w		varchar(10);
dt_avaliacao_w		varchar(255);
cd_evolucao_w		bigint;
ds_evolucao_w		varchar(32000);
ie_gerar_resumo_w		varchar(10);
ds_fonte_w		varchar(100);
ds_tam_fonte_w		varchar(10);
nr_tam_fonte_w		integer;
ds_cabecalho_w		varchar(32000);
ds_rodape_w		 varchar(32000);
ie_sem_resposta_w		varchar(1);
ds_espaco_20_w		varchar(255) 	:= lpad(' ',1,' ');
ds_enter_w		  varchar(30)	:= chr(13) || chr(10);	
nm_profissional_w	varchar(255);
ds_tipo_avaliacao_w	varchar(255);
nr_seq_apresent_w	integer;
qt_desloc_direita_w	smallint;
nr_seq_superior_ante_w	bigint := 0;
nr_seq_superior_w		bigint;

C01 CURSOR FOR 
SELECT	c.nr_seq_apresent, 
		c.nr_sequencia, 
		coalesce(ds_label_relat,c.ds_item) ds_item, 
		c.IE_RESULTADO, 
		coalesce((SELECT d.ds_resultado FROM med_item_avaliar_res d WHERE d.nr_seq_item = c.nr_sequencia AND obter_somente_numero(Aval(a.nr_sequencia,c.nr_sequencia)) = d.nr_Seq_res AND coalesce(c.cd_dominio::text, '') = ''),SUBSTR(Aval(a.nr_sequencia,c.nr_sequencia),1,4000)) ds_resultado, 
		c.qt_desloc_direita, 
		c.nr_seq_superior 
FROM	med_Avaliacao_paciente a, 
		med_tipo_avaliacao b, 
		med_item_avaliar c 
WHERE	b.nr_sequencia = c.nr_seq_tipo 
AND		a.nr_seq_tipo_avaliacao = b.nr_sequencia 
AND		(coalesce((SELECT d.ds_resultado FROM med_item_avaliar_res d WHERE d.nr_seq_item = c.nr_sequencia AND obter_somente_numero(Aval(a.nr_sequencia,c.nr_sequencia)) = d.nr_Seq_res AND coalesce(c.cd_dominio::text, '') = ''),SUBSTR(Aval(a.nr_sequencia,c.nr_sequencia),1,4000)) IS NOT NULL) 
AND		(coalesce((SELECT d.ds_resultado FROM med_item_avaliar_res d WHERE d.nr_seq_item = c.nr_sequencia AND obter_somente_numero(Aval(a.nr_sequencia,c.nr_sequencia)) = d.nr_Seq_res AND coalesce(c.cd_dominio::text, '') = ''),SUBSTR(Aval(a.nr_sequencia,c.nr_sequencia),1,4000)) <> 'N') 
AND		a.nr_sequencia = nr_sequencia_p 

union
 
SELECT	c.nr_seq_apresent, 
		c.nr_sequencia, 
		coalesce(ds_label_relat,c.ds_item) ds_item, 
		c.IE_RESULTADO, 
		coalesce((SELECT d.ds_resultado FROM med_item_avaliar_res d WHERE d.nr_seq_item = c.nr_sequencia AND obter_somente_numero(Aval(a.nr_sequencia,c.nr_sequencia)) = d.nr_Seq_res AND coalesce(c.cd_dominio::text, '') = ''),SUBSTR(Aval(a.nr_sequencia,c.nr_sequencia),1,4000)) ds_resultado, 
		c.qt_desloc_direita, 
		c.nr_seq_superior 
FROM	med_Avaliacao_paciente a, 
		med_tipo_avaliacao b, 
		med_item_avaliar c 
WHERE	b.nr_sequencia = c.nr_seq_tipo 
AND		a.nr_seq_tipo_avaliacao = b.nr_sequencia 
AND (c.IE_RESULTADO IN ('X','T','H','B')) 
AND		a.nr_sequencia = nr_sequencia_p 
ORDER BY 1;


BEGIN 
 
SELECT MAX(cd_pessoa_fisica), 
	  MAX(nr_atendimento), 
	  MAX(cd_medico), 
	  max(TO_CHAR(a.dt_avaliacao,'dd/mm/yyyy hh24:mi:ss')), 
	  max(SUBSTR(obter_nome_pf(a.cd_medico),1,150)), 
	  MAX(ie_resumo_oftalmo), 
	  max(SUBSTR(OBTER_DESC_TIPO_AVALIACAO(NR_SEQ_TIPO_AVALIACAO),1,255)) 
INTO STRICT  cd_pessoa_fisica_w, 
	  nr_atendimento_w, 
	  cd_medico_w, 
	  dt_avaliacao_w, 
	  nm_profissional_w, 
	  ie_gerar_resumo_w, 
	  ds_tipo_avaliacao_w 
FROM	med_Avaliacao_paciente a, 
		med_tipo_avaliacao b 
WHERE	b.nr_sequencia = a.nr_seq_tipo_avaliacao 
AND		a.nr_sequencia = nr_sequencia_p;
 
 
IF (ie_gerar_resumo_w	= 'S') THEN 
	ds_fonte_w := Obter_Param_Usuario(281, 5, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ds_fonte_w);
	ds_tam_fonte_w := Obter_Param_Usuario(281, 6, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ds_tam_fonte_w);
	nr_tam_fonte_w	:= somente_numero(ds_tam_fonte_w)*2;
	 
	 
	ds_conteudo_w		:= 		wheb_mensagem_pck.get_texto(308485, 'DT_AVALIACAO_W=' || dt_avaliacao_w || ';' || 
																	'DS_ESPACO_20_W=' || ds_espaco_20_w || ';' || 
																	'NM_PROFISSIONAL_W=' || nm_profissional_w || ';' || 
																	'DS_TIPO_AVALIACAO_W=' || ds_tipo_avaliacao_w || ';' || 
																	'DS_ENTER_W=' || ds_enter_w);
							/* 
								DATA: #@DT_AVALIACAO_W#@#@DS_ESPACO_20_W#@#@DS_ESPACO_20_W#@ 
								AVALIADOR: #@NM_PROFISSIONAL_W#@DS_ESPACO_20_W#@#@DS_ESPACO_20_W#@ 
								TIPO AVALIAÇÃO: #@DS_TIPO_AVALIACAO_W#@#@DS_ENTER_W#@#@DS_ENTER_W#@ 
							*/
 
 
	OPEN C01;
	LOOP 
	FETCH C01 INTO 
		nr_seq_apresent_w, 
		nr_seq_item_w, 
		ds_item_w, 
		ie_resultado_w, 
		ds_resultado_w, 
		qt_desloc_direita_w, 
		nr_seq_superior_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		BEGIN 
			 
			if (coalesce(nr_seq_superior_ante_w,0) <> coalesce(nr_seq_superior_w,0)) then 
				ds_conteudo_w := ds_conteudo_w||ds_enter_w;
				nr_seq_superior_ante_w := nr_seq_superior_w;	
			end if;
			 
			if (coalesce(nr_seq_superior_w::text, '') = '') then 
				ds_conteudo_w := ds_conteudo_w||ds_enter_w;
			end if;
		 
		IF (ie_resultado_w IN ('X','T','H')) and (coalesce(qt_desloc_direita_w,0) = 0) then 
			ds_conteudo_w := ds_conteudo_w || ds_enter_w;
			ds_conteudo_w	:= ds_conteudo_w||ds_enter_w||ds_item_w||ds_enter_w;
		ELSIF (ie_resultado_w = 'B') then 
			IF (ds_resultado_w	= 'S') OR (ds_resultado_w	= '1') then 
				ds_resultado_w	:= wheb_mensagem_pck.get_texto(94754); -- Sim 
			ELSE
				ds_resultado_w:= wheb_mensagem_pck.get_texto(94755); -- Não 
			END IF;
			if (coalesce(qt_desloc_direita_w,0) > 0) then 
				ds_conteudo_w := ds_conteudo_w ||' '||ds_item_w||' '||ds_resultado_w||ds_espaco_20_w;
			else 
				ds_conteudo_w := ds_conteudo_w ||' '||ds_item_w||' '||ds_resultado_w||ds_enter_w;
			end if;
		ELSE 
			if (coalesce(qt_desloc_direita_w,0) > 0) then 
				ds_conteudo_w := ds_conteudo_w ||' '||ds_item_w||' '||ds_resultado_w||ds_espaco_20_w;	
			else 
				ds_conteudo_w := ds_conteudo_w || ds_enter_w;
				ds_conteudo_w := ds_conteudo_w ||' '||ds_item_w||' '||ds_resultado_w;
			end if;
		END IF;
		END;
	END LOOP;
	CLOSE C01;
	CALL gravar_registro_resumo_oft(ds_conteudo_w,220,nm_usuario_p,clock_timestamp());
END IF;
 
COMMIT;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_resumo_aval_oft ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

