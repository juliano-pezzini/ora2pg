-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ageint_ret_item_fonetica_pck.return_fonetica_item_java (NR_SEQ_GRUPO_P bigint ,DS_ITEM_P text ,IE_UTILIZA_DESC_PACOTE_P text ,IE_PACOTE_P text ,CD_CONVENIO_P bigint ,CD_ESTABELECIMENTO_P bigint ,IE_SADT_P text ,CD_CATEGORIA_P text ,CD_PLANO_P text ,NM_PESSOA_FISICA_P text default null) RETURNS SETOF LS_ITEM_GRUPO_TABLE_IT AS $body$
DECLARE


	TABLE_ITEM_IT ITEM_GRUPO_TYPE_IT;
	IE_UTILIZA_FONETICA_W bigint;
	EXIBE_ITEM_V varchar(1) := 'S';
	DS_ITEM_FONETICA_V varchar(2000) := gera_fonetica(DS_ITEM_P,'S');
  NM_PESSOA_FONET_W varchar(2000) := gera_fonetica(NM_PESSOA_FISICA_P,'S');
  ds_fonetica_cns_w pessoa_fisica.ds_fonetica_cns%type;
  nm_pessoa_w pessoa_fisica.nm_pessoa_fisica%type;
  nm_social_w pessoa_fisica.nm_social%type;
  nm_pessoa_grupo_font_w varchar(2000);
  ie_nome_social_w  varchar(1);
	
	C02_FONETICA_IT CURSOR FOR
	SELECT 	a.nr_sequencia cd,
		substr(coalesce(coalesce(a.nm_curto,(coalesce(b.ds_proc_exame,coalesce(SUBSTR(obter_nome_pf(a.cd_medico),1,255),coalesce(c.ds_especialidade,e.ds_grupo_proc))))),' '),1,255) ds,
		'N' ie_pacote,
		a.ds_observacao ds_observacao,
		a.nr_seq_grupo,
		a.nr_seq_apres,
		a.cd_medico cd_medico,
		a.nr_seq_proc_interno,
		a.ie_localiza_prof,
		a.cd_especialidade,
		a.nr_seq_topografia
	FROM agenda_int_grupo_item a
LEFT OUTER JOIN proc_interno b ON (a.nr_seq_proc_interno = b.nr_sequencia)
LEFT OUTER JOIN especialidade_medica c ON (a.cd_especialidade = c.cd_especialidade)
LEFT OUTER JOIN ageint_grupo_proc e ON (a.nr_seq_grupo_proc = e.nr_sequencia) order BY nr_seq_grupo, nr_seq_apres, ds;

	
BEGIN
    IE_UTILIZA_FONETICA_W := ageint_ret_item_fonetica_pck.return_cad_local();
    ie_nome_social_w := obter_se_nome_social;
    for TABLE_ITEM_IT in C02_FONETICA_IT loop
      if IE_UTILIZA_FONETICA_W > 0 then
        if (DS_ITEM_P IS NOT NULL AND DS_ITEM_P::text <> '') then
          if (lower(TABLE_ITEM_IT.DS) like  lower('%'||DS_ITEM_P||'%')) then
            EXIBE_ITEM_V := 'S';
          else
            EXIBE_ITEM_V := ageint_ret_item_fonetica_pck.valida_exibicao_item(DS_ITEM_P, TABLE_ITEM_IT.DS, TABLE_ITEM_IT.NR_SEQ_PROC_INTERNO, DS_ITEM_FONETICA_V);
          end if;
        end if;
        if (NM_PESSOA_FISICA_P IS NOT NULL AND NM_PESSOA_FISICA_P::text <> '') and coalesce(DS_ITEM_P::text, '') = '' then
          select max(ds_fonetica_cns),
              max(nm_social),
              max(nm_pessoa_fisica)
          into STRICT ds_fonetica_cns_w,
              nm_social_w,
              nm_pessoa_w
          from pessoa_fisica
          where cd_pessoa_fisica = TABLE_ITEM_IT.CD_MEDICO;
          if (ie_nome_social_w = 'N') then
            nm_pessoa_grupo_font_w := gera_fonetica(nm_pessoa_w,'S');
          else
            nm_pessoa_grupo_font_w := gera_fonetica(coalesce(nm_social_w,nm_pessoa_w),'S');
          end if;

          if upper(ds_fonetica_cns_w) like upper('%' ||  NM_PESSOA_FISICA_P || '%') or
          ((ie_nome_social_w in ('S','T')) and upper(coalesce(nm_social_w,nm_pessoa_w)) like upper('%' || NM_PESSOA_FISICA_P || '%')) or   
          ((coalesce(ie_nome_social_w,'N') = 'N') and upper(nm_pessoa_w) like upper('%' ||  NM_PESSOA_FISICA_P || '%')) OR (nm_pessoa_grupo_font_w like(NM_PESSOA_FONET_W))
          then
            EXIBE_ITEM_V := 'S';
          else
            EXIBE_ITEM_V := 'N';
          end if;
        end if;
      else
        if upper(TABLE_ITEM_IT.DS) like '%'||upper(DS_ITEM_P)||'%' then
          EXIBE_ITEM_V := 'S';
        else
          EXIBE_ITEM_V := 'N';
        end if;

        if (NM_PESSOA_FISICA_P IS NOT NULL AND NM_PESSOA_FISICA_P::text <> '') and EXIBE_ITEM_V = 'S' then
          select max(nm_social),
              max(nm_pessoa_fisica)
          into STRICT nm_social_w,
              nm_pessoa_w
          from pessoa_fisica
          where cd_pessoa_fisica = TABLE_ITEM_IT.CD_MEDICO;
          if ((ie_nome_social_w in ('S','T')) and upper(coalesce(nm_social_w,nm_pessoa_w)) like upper('%' || NM_PESSOA_FISICA_P || '%')) or
              ((coalesce(ie_nome_social_w,'N') = 'N') and upper(nm_pessoa_w) like upper('%' ||  NM_PESSOA_FISICA_P || '%')) then
            EXIBE_ITEM_V := 'S';
          else
            EXIBE_ITEM_V := 'N';
          end if;
        end if;
      end if;

      IF (EXIBE_ITEM_V = 'S') THEN
        RETURN NEXT TABLE_ITEM_IT;
      END IF;
    END LOOP;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ageint_ret_item_fonetica_pck.return_fonetica_item_java (NR_SEQ_GRUPO_P bigint ,DS_ITEM_P text ,IE_UTILIZA_DESC_PACOTE_P text ,IE_PACOTE_P text ,CD_CONVENIO_P bigint ,CD_ESTABELECIMENTO_P bigint ,IE_SADT_P text ,CD_CATEGORIA_P text ,CD_PLANO_P text ,NM_PESSOA_FISICA_P text default null) FROM PUBLIC;