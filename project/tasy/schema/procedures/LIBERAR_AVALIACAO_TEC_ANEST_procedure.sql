-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_avaliacao_tec_anest ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


  nr_seq_item_w       bigint;
  ds_item_w           varchar(32000);
  ds_resultado_w      varchar(32000);
  ds_conteudo_w       varchar(32000);
  ds_complemento_w    varchar(32000);
  ie_resultado_w      varchar(10);
  ds_anestesia_w      varchar(32000);
  ds_texto_aval_w     varchar(32000);
  ds_fonte_w          varchar(100);
  ds_tam_fonte_w      varchar(10);
  nr_tam_fonte_w      integer;
  ds_cabecalho_w      varchar(32000);
  ds_rodape_w         varchar(32000);
  ie_sem_resposta_w   varchar(1);
  cd_dominio_w        bigint;
  ds_titulo_w         varchar(100);
  ds_enter_w          varchar(15);
  ds_titulo_rft_w     varchar(255);
  nr_seq_tecnica_w    bigint;
  nr_cirurgia_w       bigint;
  nr_seq_pepo_w       bigint;
  ds_anestesia_old_w  varchar(32000);
  nr_seq_rtf_w        bigint;
  nr_seq_anest_desc_w bigint;

  C01 CURSOR FOR
    SELECT c.nr_sequencia,
      coalesce(ds_label_relat,c.ds_item) ds_item,
      c.IE_RESULTADO,
      coalesce(
      (SELECT d.ds_resultado
      FROM med_item_avaliar_res d
      WHERE d.nr_seq_item                                                                  = c.nr_sequencia
      AND obter_somente_numero(REPLACE(upper(Aval(a.nr_sequencia,c.nr_sequencia)),'E','')) = d.nr_Seq_res
      AND coalesce(c.cd_dominio::text, '') = ''
      ),SUBSTR(Aval(a.nr_sequencia,c.nr_sequencia),1,4000)) ds_resultado,
      cd_dominio,
      c.ds_complemento ds_complemento
    FROM med_Avaliacao_paciente a,
      med_tipo_avaliacao b,
      med_item_avaliar c
    WHERE b.nr_sequencia        = c.nr_seq_tipo
    AND coalesce(c.ie_situacao, 'A') = 'A'
    AND a.nr_seq_tipo_avaliacao = b.nr_sequencia
    AND ((ie_sem_resposta_w     = 'N')
    OR ((c.ie_resultado        IN ('T','H'))
    AND ( EXISTS (SELECT 1
      FROM med_item_avaliar f
      WHERE f.nr_seq_superior                                 = c.nr_sequencia
      AND SUBSTR(Aval(a.nr_sequencia,f.nr_sequencia),1,4000) IS NOT NULL
      )))
    OR (coalesce(
      (SELECT d.ds_resultado
      FROM med_item_avaliar_res d
      WHERE d.nr_seq_item                                                                  = c.nr_sequencia
      AND obter_somente_numero(REPLACE(upper(Aval(a.nr_sequencia,c.nr_sequencia)),'E','')) = d.nr_Seq_res
      AND coalesce(c.cd_dominio::text, '') = ''
      ),SUBSTR(Aval(a.nr_sequencia,c.nr_sequencia),1,4000))                               IS NOT NULL))
    AND ((ie_sem_resposta_w                                                                = 'N')
    OR ((c.ie_resultado                                                                   IN ('T','H'))
    AND ( EXISTS (SELECT 1
      FROM med_item_avaliar f
      WHERE f.nr_seq_superior                                 = c.nr_sequencia
      AND SUBSTR(Aval(a.nr_sequencia,f.nr_sequencia),1,4000) <> 'N'
      )))
    OR (coalesce(
      (SELECT d.ds_resultado
      FROM med_item_avaliar_res d
      WHERE d.nr_seq_item                                                                  = c.nr_sequencia
      AND obter_somente_numero(REPLACE(upper(Aval(a.nr_sequencia,c.nr_sequencia)),'E','')) = d.nr_Seq_res
      AND coalesce(c.cd_dominio::text, '') = ''
      ),SUBSTR(Aval(a.nr_sequencia,c.nr_sequencia),1,4000))                               <> 'N'))
    AND a.nr_sequencia                                                                     = nr_sequencia_p
    ORDER BY c.nr_seq_apresent;
	
    C02 CURSOR FOR
      SELECT 	nr_sequencia
      FROM 		anestesia_descricao
      WHERE 	nr_seq_tecnica = nr_seq_tecnica_w
      AND (nr_cirurgia      = nr_cirurgia_w
				OR nr_seq_pepo = nr_seq_pepo_w)
      AND 		coalesce(dt_liberacao::text, '') = '';
	
  
BEGIN
    IF (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') THEN
	
      ds_enter_w       := wheb_rtf_pck.get_quebra_linha || wheb_rtf_pck.get_quebra_linha;
      ds_titulo_rft_w  := '';
	
      CALL liberar_avaliacao(nr_sequencia_p,nm_usuario_p);
	
      SELECT MAX(ds_tipo)
      INTO STRICT ds_titulo_w
      FROM med_Avaliacao_paciente a,
        med_tipo_avaliacao b
      WHERE b.nr_sequencia = a.nr_seq_tipo_avaliacao
      AND a.nr_sequencia   = nr_sequencia_p;
	
      ds_fonte_w := Obter_Param_Usuario(281, 5, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ds_fonte_w);
      ds_tam_fonte_w := Obter_Param_Usuario(281, 6, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ds_tam_fonte_w);
      nr_tam_fonte_w := somente_numero(ds_tam_fonte_w)*2;
	
      SELECT coalesce(MAX(ie_campos_preench_evol_aval),'N')
      INTO STRICT ie_sem_resposta_w
      FROM parametro_medico
      WHERE cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;
	
      OPEN C01;
      LOOP
        FETCH C01
        INTO nr_seq_item_w,
          ds_item_w,
          ie_resultado_w,
          ds_resultado_w,
          cd_dominio_w,
          ds_complemento_w;
        EXIT WHEN NOT FOUND; /* apply on C01 */
        BEGIN
          ds_resultado_w := REPLACE(ds_resultado_w,chr(13),'\par-');
          ds_resultado_w := REPLACE(ds_resultado_w,chr(10),'\par ');
          ds_resultado_w := REPLACE(ds_resultado_w,'\par-\par ', wheb_rtf_pck.get_quebra_linha);
          ds_resultado_w := REPLACE(ds_resultado_w,'\par-', wheb_rtf_pck.get_quebra_linha);
          IF (ie_resultado_w IN ('X','T')) THEN
            ds_conteudo_w              := ds_conteudo_w|| wheb_rtf_pck.get_quebra_linha ||wheb_rtf_pck.get_negrito(true)||wheb_rtf_pck.get_sublinhado(true) ||ds_item_w||wheb_rtf_pck.get_negrito(false)||wheb_rtf_pck.get_sublinhado(false) || wheb_rtf_pck.get_quebra_linha || wheb_rtf_pck.get_quebra_linha;
            IF ((trim(both ds_complemento_w) IS NOT NULL AND (trim(both ds_complemento_w))::text <> '')) AND (ie_resultado_w IN ('X')) THEN
              ds_conteudo_w            := ds_conteudo_w|| wheb_rtf_pck.get_quebra_linha ||wheb_rtf_pck.get_negrito(true)||wheb_rtf_pck.get_sublinhado(true) ||ds_complemento_w||wheb_rtf_pck.get_negrito(false)||wheb_rtf_pck.get_sublinhado(false) || wheb_rtf_pck.get_quebra_linha || wheb_rtf_pck.get_quebra_linha;
            END IF;
          elsif (ie_resultado_w = 'B') THEN
            IF (ds_resultado_w  = 'S') OR (ds_resultado_w = '1') THEN
              ds_resultado_w   := WHEB_MENSAGEM_PCK.get_texto(298977,NULL); --'Sim';
            ELSE
              ds_resultado_w := WHEB_MENSAGEM_PCK.get_texto(298976,NULL); --'Não';
            END IF;
            ds_conteudo_w      := ds_conteudo_w ||' '||wheb_rtf_pck.get_negrito(true)||ds_item_w||' : '||wheb_rtf_pck.get_negrito(false)||ds_resultado_w|| wheb_rtf_pck.get_quebra_linha;
          elsif (ie_resultado_w = 'O') THEN
            IF (cd_dominio_w    > 0) THEN
              SELECT MAX(ds_valor_dominio)
              INTO STRICT ds_resultado_w
              FROM med_valor_dominio
              WHERE nr_seq_dominio = cd_dominio_w
              AND vl_dominio       = ds_resultado_w;
              ds_conteudo_w       := ds_conteudo_w ||' '||wheb_rtf_pck.get_negrito(true)||ds_item_w||' : '||wheb_rtf_pck.get_negrito(false)||ds_resultado_w|| wheb_rtf_pck.get_quebra_linha;
            END IF;
          elsif (ie_resultado_w IN ('V','C')) THEN
            ds_conteudo_w := ds_conteudo_w ||' '||wheb_rtf_pck.get_negrito(true)||ds_item_w||' : '||wheb_rtf_pck.get_negrito(false)||ds_resultado_w|| ' ' || ds_complemento_w || wheb_rtf_pck.get_quebra_linha;
          ELSE
            ds_conteudo_w := ds_conteudo_w ||' '||wheb_rtf_pck.get_negrito(true)||ds_item_w||' : '||wheb_rtf_pck.get_negrito(false)||ds_resultado_w|| wheb_rtf_pck.get_quebra_linha;
          END IF;
        END;
      END LOOP;
      CLOSE C01;
	
      ds_titulo_rft_w := '\b '|| wheb_mensagem_pck.get_texto(326719)|| '\b0 '||ds_titulo_w || ds_enter_w;
      ds_cabecalho_w  := '{\rtf1\ansi\ansicpg1252\deff0\deflang1046{\fonttbl{\f0\fswiss\fcharset0 '||ds_fonte_w||';}}'|| '{\*\generator Msftedit 5.41.15.1507;}\viewkind4\uc1\pard\f0\fs'||nr_tam_fonte_w||' ';
      ds_rodape_w     := '}';
      ds_texto_aval_w := SUBSTR((ds_cabecalho_w|| ds_titulo_rft_w ||ds_conteudo_w||ds_rodape_w),1,32000);
	
      SELECT 	coalesce(b.nr_seq_tecnica, 0),
				coalesce(b.nr_cirurgia, 0),
				coalesce(b.nr_seq_pepo, 0)
      INTO STRICT 		nr_seq_tecnica_w,
				nr_cirurgia_w,
				nr_seq_pepo_w
      FROM 	med_avaliacao_paciente a,
			cirurgia_tec_anestesica b
      WHERE a.nr_seq_tec_anest = b.nr_sequencia
      AND 	a.nr_sequencia       = nr_sequencia_p;
	
      IF (nr_seq_tecnica_w     > 0 AND (nr_cirurgia_w > 0 OR nr_seq_pepo_w > 0)) THEN
        BEGIN
          OPEN C02;
          LOOP
            FETCH C02 INTO nr_seq_anest_desc_w;
            EXIT WHEN NOT FOUND; /* apply on C02 */
            BEGIN
              ds_anestesia_w     := ds_texto_aval_w;
              ds_anestesia_old_w := SUBSTR(CONVERT_LONG_TO_STRING('DS_ANESTESIA', 'ANESTESIA_DESCRICAO', ' NR_SEQUENCIA = ' || nr_seq_anest_desc_w),1,32000);
			
              UPDATE anestesia_descricao
              SET ds_anestesia   = ds_anestesia_w
              WHERE nr_sequencia = nr_seq_anest_desc_w;
			
              nr_seq_rtf_w := CONVERTE_RTF_HTML( 'select DS_ANESTESIA from ANESTESIA_DESCRICAO where NR_SEQUENCIA = :nr_sequencia_p', nr_seq_anest_desc_w, nm_usuario_p, nr_seq_rtf_w);
			
              SELECT ds_texto
              INTO STRICT ds_anestesia_w
              FROM tasy_conversao_rtf
              WHERE nr_sequencia = nr_seq_rtf_w;
			
              ds_anestesia_w    := SUBSTR((ds_anestesia_w || ds_anestesia_old_w),1,32000);
			
              UPDATE anestesia_descricao
              SET ds_anestesia   = ds_anestesia_w
              WHERE nr_sequencia = nr_seq_anest_desc_w;
            END;
          END LOOP;
          CLOSE C02;
          COMMIT;
        END;
      END IF;
    END IF;
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_avaliacao_tec_anest ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

