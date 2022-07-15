-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_banda_padrao_relatorio ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE

  qt_registro_w        bigint;
  query_dominio        varchar(550);
  qt_tamanho_banda_w   bigint;
  qt_altura_banda_w    bigint;
  nm_atributo_w        varchar(60);
  ds_conteudo_w        varchar(60);
  ds_label_w_v         varchar(60);
  ie_tipo_campo_w_v    varchar(10);
  nr_sequencia_w       bigint;

  nm_label_w           varchar(80);
  ds_label_w           varchar(255);
  nr_seq_apres_w       bigint;
  ie_ajustar_tamanho_w varchar(38);
  nr_altura_w          numeric(38);
  nr_comprimento_w     numeric(38);
  nr_eixo_y_w          numeric(38);
  nr_eixo_x_w          numeric(38);
  ie_tipo_fonte_w      varchar(1);
  cd_tipo_w            varchar(10);
  nr_tamanho_fonte_w   smallint;
  nr_seq_banda_w       banda_relatorio.nr_sequencia%type;

  C01 CURSOR FOR
    SELECT a.nm_label,
      a.ds_label,
      a.nr_seq_apres,
      a.ie_ajustar_tamanho,
      a.nr_altura,
      a.nr_comprimento,
      a.nr_eixo_y,
      a.nr_eixo_x,
      a.ie_tipo_fonte,
      a.cd_tipo,
      a.nr_tam_fonte
    FROM relatorio_dinamico a
    WHERE a.nr_tipo_banda      = 2;


BEGIN
  CALL limpar_relatorio_dinamico(nr_sequencia_p);

  SELECT COUNT(*)
  INTO STRICT qt_registro_w
  FROM banda_relatorio
  WHERE nr_seq_relatorio = nr_sequencia_p
  AND ie_tipo_banda      = 'C';

  IF (qt_registro_w      = 0) THEN
    INSERT
    INTO banda_relatorio(
        nr_sequencia,             -- 1
        ie_tipo_banda,            -- 2
        ds_banda,                 -- 3
        dt_atualizacao,           -- 4
        nm_usuario,               -- 5
        qt_altura,                -- 6
        ds_cor_fundo,             -- 7
        ie_quebra_pagina,         -- 8
        ie_reimprime_nova_pagina, -- 9
        ie_alterna_cor_fundo,     -- 10
        ie_imprime_vazio,         -- 11
        ie_imprime_primeiro,      -- 12
        ie_borda_sup,             -- 13
        ie_borda_inf,             -- 14
        ie_borda_esq,             -- 15
        ie_borda_dir,             -- 16
        nr_seq_relatorio,         -- 17
        nr_seq_apresentacao,      -- 18
        ds_cor_header,            -- 19
        ds_cor_footer,            -- 20
        ds_cor_quebra,            -- 21
        ie_banda_padrao           -- 22
      )
      VALUES (
        nextval('banda_relatorio_seq'),              -- 1
        'C',                                      -- 2
        obter_desc_expressao(486585,'Cabecalho'), -- 3
        clock_timestamp(),                                  -- 4
        nm_usuario_p,                             -- 5
        70,                                       -- 6
        'clwhite',                                -- 7
        'N',                                      -- 8
        'N',                                      -- 9
        'N',                                      -- 10
        'N',                                      -- 11
        'N',                                      -- 12
        'N',                                      -- 13
        'S',                                      -- 14
        'N',                                      -- 15
        'N',                                      -- 16
        nr_sequencia_p,                           -- 17
        1,                                        -- 18
        'clsilver',                               -- 19
        'clwhite',                                -- 20
        '$00E5E5E5',                              -- 21
        'S'                                       -- 22
      );
  END IF;

  SELECT COUNT(*)
  INTO STRICT qt_registro_w
  FROM banda_relatorio
  WHERE nr_seq_relatorio = nr_sequencia_p
  AND ie_tipo_banda      = 'R';

  IF (qt_registro_w      = 0) THEN
    INSERT
    INTO banda_relatorio(
        nr_sequencia,             -- 1
        ie_tipo_banda,            -- 2
        ds_banda,                 -- 3
        dt_atualizacao,           -- 4
        nm_usuario,               -- 5
        qt_altura,                -- 6
        ds_cor_fundo,             -- 7
        ie_quebra_pagina,         -- 8
        ie_reimprime_nova_pagina, -- 9
        ie_alterna_cor_fundo,     -- 10
        ie_imprime_vazio,         -- 11
        ie_imprime_primeiro,      -- 12
        ie_borda_sup,             -- 13
        ie_borda_inf,             -- 14
        ie_borda_esq,             -- 15
        ie_borda_dir,             -- 16
        nr_seq_relatorio,         -- 17
        nr_seq_apresentacao,      -- 18
        ds_cor_header,            -- 19
        ds_cor_footer,            -- 20
        ds_cor_quebra,            -- 21
        ie_banda_padrao           -- 22
      )
      VALUES (
        nextval('banda_relatorio_seq'),
        'R',
        obter_desc_expressao(486586,'Rodape'),
        clock_timestamp(),
        nm_usuario_p,
        18,
        'clwhite',
        'N',
        'N',
        'N',
        'N',
        'N',
        'S',
        'N',
        'N',
        'N',
        nr_sequencia_p,
        10,
        'clsilver',
        'clwhite',
        '$00E5E5E5',
        'S'
      );
  END IF;
  COMMIT;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_banda_padrao_relatorio ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

