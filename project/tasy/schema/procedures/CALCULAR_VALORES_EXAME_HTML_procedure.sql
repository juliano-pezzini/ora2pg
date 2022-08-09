-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calcular_valores_exame_html ( nr_seq_resultado_p bigint, nr_prescricao_p bigint, nr_seq_prescr_p bigint, nr_seq_material_p bigint, nr_seq_exame_p bigint, qt_resultado_p bigint, pr_resultado_p bigint, obj_exam_data_p text, ds_resultado_p INOUT text) AS $body$
DECLARE

  nr_sequencia_w     bigint;
  nr_seq_exame_w     bigint;
  ie_campo_calculo_w varchar(1);
  ds_formula_w       varchar(255);
  ds_formula_aux_w   varchar(255);
  qt_decimais_w      smallint;
  qt_resultado_ww    varchar(20);
  pr_resultado_ww    varchar(20);
--  qt_resultado_w     NUMBER(15,4);
--  pr_resultado_w     NUMBER(09,4);
  qt_resultado_w    varchar(20);
  pr_resultado_w    varchar(20);
  ie_formula_ok_w    smallint;
  vl_resultado_w     double precision;
  qt_volume_w        integer;
  qt_tempo_w         real;
  qt_minuto_w        smallint;
  nr_anos_w          smallint;
  qt_peso_w          double precision;
  qt_altura_w        varchar(20);
  ie_macro_w         varchar(1);
  ie_tamanho_w       smallint;
  i                  smallint;
  x                  smallint;
  nr_exame_w         bigint;
  ie_multi_formula_w varchar(1);
  qt_formula_w       smallint;
  ds_multi_formula_w varchar(255);
  ie_sexo_w          varchar(1);
  nr_seq_cor_pele_w  bigint;
  /*html specific
  */
  obj_exam_data varchar(500);
  exam_data     varchar(500);
  nr_exame_s    varchar(10);
  C01 CURSOR FOR
    SELECT a.nr_sequencia,
      a.nr_seq_exame,
      b.ie_campo_calculo,
      REPLACE(REPLACE(coalesce(c.ds_formula, b.ds_formula), '@'
      ||nr_seq_exame_p, REPLACE(qt_resultado_p,',','.')), '%'
      ||nr_seq_exame_p, REPLACE(pr_resultado_p,',','.')),
      coalesce(c.qt_decimais, coalesce(b.qt_decimais,0))
    FROM exame_lab_result_item a, exame_laboratorio b
LEFT OUTER JOIN exame_lab_material c ON (b.nr_seq_exame = c.nr_seq_exame AND nr_seq_material_p = c.nr_seq_material)
WHERE a.nr_seq_exame     = b.nr_seq_exame  AND a.nr_seq_resultado   = nr_seq_resultado_p AND a.nr_seq_prescr      = nr_seq_prescr_p  AND coalesce(c.ds_formula, b.ds_formula) LIKE '%@'
      || nr_seq_exame_p
      || '%'

UNION

  SELECT a.nr_sequencia,
    a.nr_seq_exame,
    b.ie_campo_calculo,
    REPLACE(REPLACE(coalesce(c.ds_formula, b.ds_formula), '@'
    ||nr_seq_exame_p, REPLACE(qt_resultado_p,',','.')), '%'
    ||nr_seq_exame_p, REPLACE(pr_resultado_p,',','.')),
    coalesce(c.qt_decimais, coalesce(b.qt_decimais,0))
  FROM exame_lab_result_item a, exame_laboratorio b
LEFT OUTER JOIN exame_lab_material c ON (b.nr_seq_exame = c.nr_seq_exame AND nr_seq_material_p = c.nr_seq_material)
WHERE a.nr_seq_exame     = b.nr_seq_exame  AND a.nr_seq_resultado   = nr_seq_resultado_p AND a.nr_seq_prescr      = nr_seq_prescr_p  AND coalesce(c.ds_formula, b.ds_formula) LIKE '%%'
    || nr_seq_exame_p
    || '%';

BEGIN
  BEGIN
    OPEN C01;
    LOOP
      FETCH C01
      INTO nr_sequencia_w,
        nr_seq_exame_w,
        ie_campo_calculo_w,
        ds_formula_w,
        qt_decimais_w;
      EXIT WHEN NOT FOUND; /* apply on C01 */
      SELECT MAX(b.ie_sexo),
        MAX(b.nr_seq_cor_pele)
      INTO STRICT ie_sexo_w,
        nr_seq_cor_pele_w
      FROM pessoa_fisica b,
        prescr_medica a
      WHERE nr_prescricao    = nr_prescricao_p
      AND a.cd_pessoa_fisica = b.cd_pessoa_fisica;
      SELECT REPLACE(ds_formula_w, '@Sexo', ie_sexo_w) INTO STRICT ds_formula_w;
      SELECT REPLACE(ds_formula_w, '@Cor_pele', nr_seq_cor_pele_w)
      INTO STRICT ds_formula_w
;
      IF (position('@Volume' in ds_formula_w) > 0) OR (position('@Tempo' in ds_formula_w) > 0) THEN
        SELECT MAX(qt_volume),
          MAX(qt_tempo),
          MAX(qt_minuto)
        INTO STRICT qt_volume_w,
          qt_tempo_w,
          qt_minuto_w
        FROM prescr_proc_material
        WHERE nr_prescricao = nr_prescricao_p
        AND nr_seq_material = nr_seq_material_p;
        SELECT REPLACE(ds_formula_w, '@Volume', qt_volume_w)
        INTO STRICT ds_formula_w
;
        SELECT REPLACE(ds_formula_w, '@Tempo', qt_tempo_w + (qt_minuto_w/60))
        INTO STRICT ds_formula_w
;
      END IF;
      IF (position('@Idade' in ds_formula_w) > 0) OR (position('@Peso' in ds_formula_w) > 0) OR (position('@Altura' in ds_formula_w) > 0) THEN
        SELECT a.qt_peso,
          REPLACE(a.qt_altura_cm,',','.'),
          --   a.qt_altura_cm,
          somente_numero(obter_idade(b.dt_nascimento, a.dt_prescricao, 'A'))
        INTO STRICT qt_peso_w,
          qt_altura_w,
          nr_anos_w
        FROM pessoa_fisica b,
          prescr_medica a
        WHERE nr_prescricao    = nr_prescricao_p
        AND a.cd_pessoa_fisica = b.cd_pessoa_fisica;
        SELECT REPLACE(ds_formula_w, '@Peso_Dose', ROUND(qt_peso_w))
        INTO STRICT ds_formula_w
;
        SELECT REPLACE(ds_formula_w, '@Peso', qt_peso_w) INTO STRICT ds_formula_w;
        SELECT REPLACE(ds_formula_w, '@Altura', qt_altura_w)
        INTO STRICT ds_formula_w
;
        SELECT REPLACE(ds_formula_w, '@Idade', nr_anos_w) INTO STRICT ds_formula_w;
      END IF;
      SELECT (LENGTH(ds_formula_w) - LENGTH(replace(ds_formula_w, chr(13)
        ||chr(10), '')))               /2
      INTO STRICT qt_formula_w
;
      ds_multi_formula_w   := ds_formula_w;
      ie_multi_formula_w   := 'S';
      IF (qt_formula_w      = 0) THEN
        qt_formula_w       := 1;
        ie_multi_formula_w := 'N';
      END IF;
      FOR x IN 0..qt_formula_w
      LOOP
        ds_formula_w     := SUBSTR(ds_multi_formula_w, 1, position(chr(13)||chr(10) in ds_multi_formula_w) - 1);
        IF (coalesce(ds_formula_w::text, '') = '') THEN
          ds_formula_w   := ds_multi_formula_w;
        END IF;
        ie_formula_ok_w    := position('@' in ds_formula_w);
        IF (ie_formula_ok_w = 0) THEN
          ie_formula_ok_w  := position('%' in ds_formula_w);
        END IF;
        IF (ie_formula_ok_w                   > 0) AND ((ie_multi_formula_w = 'N') OR (nr_seq_exame_w <> nr_seq_exame_p)) THEN
          ds_formula_aux_w                   := ds_formula_w;
          WHILE(position('@' in ds_formula_aux_w) > 0) OR (position('%' in ds_formula_aux_w) > 0)
          LOOP
            ie_formula_ok_w    := position('@' in ds_formula_aux_w);
            ie_macro_w         := '@';
            ie_tamanho_w       := 0;
            IF (ie_formula_ok_w = 0) THEN
              ie_formula_ok_w  := position('%' in ds_formula_aux_w);
              ie_macro_w       := '%';
            END IF;
            FOR i IN ie_formula_ok_w..length(ds_formula_aux_w) + 1
            LOOP
              IF
                /*(substr(ds_formula_aux_w, i, 2) not in ('-1','-2')) and*/

                (SUBSTR(ds_formula_aux_w, i, 1) IN (' ','/','*','+','-','(',')',',')) OR (i = LENGTH(ds_formula_aux_w) + 1) THEN
                ie_tamanho_w                                                               := i;
                EXIT;
              END IF;
            END LOOP;
            /*   dbms_output.put_line('Formula : ' || ds_formula_aux_w);
            dbms_output.put_line('OK : ' || ie_formula_ok_w);
            dbms_output.put_line('Tamanho : ' || ie_tamanho_w);*/
            nr_exame_w := to_number(SUBSTR(ds_formula_aux_w, ie_formula_ok_w + 1, ie_tamanho_w - (ie_formula_ok_w + 1)));
            /*   dbms_output.put_line('Exame : ' || nr_exame_w);*/

            BEGIN
              obj_exam_data := obj_exam_data_p;
              nr_exame_s    :=SUBSTR(ds_formula_aux_w, ie_formula_ok_w + 1, ie_tamanho_w - (ie_formula_ok_w + 1));
              WHILE(position(';' in obj_exam_data)>0)
              LOOP
                exam_data                                                            := SUBSTR(obj_exam_data, 1, position(';' in obj_exam_data)-1);
                obj_exam_data                                                        := SUBSTR(obj_exam_data,LENGTH(exam_data)           +2);
                IF (SUBSTR(exam_data,1,position('~' in exam_data)                      -1) = nr_exame_s ) THEN
                  nr_exame_w                                                         := (nr_exame_s)::numeric;
                  exam_data                                                          := SUBSTR(exam_data,LENGTH(nr_exame_s)     +2);
                  qt_resultado_w                                                     := SUBSTR(exam_data,1,position('~' in exam_data)-1);
                  pr_resultado_w                                                     :=SUBSTR(exam_data,instr(exam_data,'~',    -1)+1);
                  EXIT;
                END IF;
              END LOOP;
            END;
            -- commented below updates for HTML5 wLabRes Component
            --               select /*+ index (a exalari_exalare_fk_i) */
            --                nvl(a.qt_resultado,0),
            --            nvl(a.pr_resultado,0)
            --            into qt_resultado_w,
            --            pr_resultado_w
            --            from exame_lab_result_item a
            --            where a.nr_seq_resultado = nr_seq_resultado_p
            --            and a.nr_seq_exame = nr_exame_w;
            --            exception
            --            when others then
            --            select /*+ index (a exalari_exalare_fk_i) */
            --                  nvl(a.qt_resultado,0),
            --            nvl(a.pr_resultado,0)
            --            into qt_resultado_w,
            --            pr_resultado_w
            --            from exame_lab_result_item a
            --            where a.nr_seq_resultado = nr_seq_resultado_p
            --            and a.nr_seq_prescr = nr_seq_prescr_p
            --            and a.nr_seq_exame = nr_exame_w;
            --            end;
            qt_resultado_ww := REPLACE(qt_resultado_w,',','.');
            pr_resultado_ww := REPLACE(pr_resultado_w,',','.');
            /*   if ((ie_macro_w = '%') and (pr_resultado_w <> 0)) then - Elemar - 27/08/03 */

            IF (ie_macro_w      = '%') THEN
              ds_formula_aux_w := REPLACE((REPLACE(ds_formula_aux_w, ie_macro_w || nr_exame_w, pr_resultado_ww)),' ', '');
              ds_formula_w     := ds_formula_aux_w;
              /*   elsif ((ie_macro_w = '@') and (qt_resultado_w <> 0)) then - Elemar - 27/08/03 */

            elsif (ie_macro_w   = '@') THEN
              ds_formula_aux_w := REPLACE((REPLACE(ds_formula_aux_w, ie_macro_w || nr_exame_w, qt_resultado_ww)),' ', '');
              ds_formula_w     := ds_formula_aux_w;
            ELSE
              ds_formula_aux_w := REPLACE(ds_formula_aux_w, ie_macro_w || nr_exame_w, '');
            END IF;
          END LOOP;
        END IF;
        ie_formula_ok_w    := position('@' in ds_formula_w);
        IF (ie_formula_ok_w = 0) THEN
          ie_formula_ok_w  := position('%' in ds_formula_w);
        END IF;
        /* dbms_output.put_line(nr_seq_exame_w || '-' || ds_formula_w);*/

        vl_resultado_w := obter_valor_dinamico('select ' || ds_formula_w || ' from dual', vl_resultado_w);
        IF (coalesce(vl_resultado_w::text, '') = '') OR (vl_resultado_w = 0) THEN
          vl_resultado_w := obter_valor_dinamico('select ' || REPLACE(ds_formula_w, ',', '.') || ' from dual', vl_resultado_w);
        END IF;
        /* dbms_output.put_line(nr_seq_exame_w || '-' || vl_resultado_w);*/

        IF (ie_formula_ok_w = 0) THEN
          -- commented below updates for HTML5 wLabRes Component
          --          IF (ie_campo_calculo_w = 'P') OR (ie_multi_formula_w = 'S' AND x = 1) THEN
          --            UPDATE exame_lab_result_item a
          --            SET pr_resultado       = ROUND(vl_resultado_w,2)
          --            WHERE nr_seq_resultado = nr_seq_resultado_p
          --            AND nr_sequencia       = nr_sequencia_w;
          --          ELSE
          --            UPDATE exame_lab_result_item a
          --            SET qt_resultado       = ROUND(vl_resultado_w, qt_decimais_w)
          --            WHERE nr_seq_resultado = nr_seq_resultado_p
          --            AND nr_sequencia       = nr_sequencia_w;
          --          END IF;
          ds_resultado_p := ds_resultado_p || nr_seq_exame_w || ',' || REPLACE(TO_CHAR(ROUND(vl_resultado_w, qt_decimais_w)),',','.') || ';';
        END IF;
        IF (ie_multi_formula_w = 'S') THEN
          ds_multi_formula_w  := SUBSTR(ds_multi_formula_w, position(chr(13)||chr(10) in ds_multi_formula_w) + 2, 200);
        END IF;
      END LOOP;
      /* dbms_output.put_line(ds_resultado_p);*/

    END LOOP;
    CLOSE C01;
  EXCEPTION
  WHEN OTHERS THEN
    --'Erro ao calcular a fórmula !'||chr(10) ||'result '|| vl_resultado_w || 'Seq '  || nr_sequencia_w || 'Desc ' || qt_decimais_w ||
    --'Exame calculado: ' || nr_exame_w ||
    --' Fórmula: '|| ds_formula_w || ' Exame origem: ' || to_char(nr_seq_exame_p)
    CALL wheb_mensagem_pck.exibir_mensagem_abort(264007,'VL_RESULTADO='||vl_resultado_w||';NR_SEQUENCIA='||nr_sequencia_w||';QT_DECIMAIS='||qt_decimais_w|| ';NR_EXAME='||nr_exame_w||';DS_FORMULA='||ds_formula_w||';NR_SEQ_EXAME='||TO_CHAR(nr_seq_exame_p));
  END;
  COMMIT;
  ds_resultado_p := SUBSTR(ds_resultado_p,0,LENGTH(ds_resultado_p) - 1);
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcular_valores_exame_html ( nr_seq_resultado_p bigint, nr_prescricao_p bigint, nr_seq_prescr_p bigint, nr_seq_material_p bigint, nr_seq_exame_p bigint, qt_resultado_p bigint, pr_resultado_p bigint, obj_exam_data_p text, ds_resultado_p INOUT text) FROM PUBLIC;
