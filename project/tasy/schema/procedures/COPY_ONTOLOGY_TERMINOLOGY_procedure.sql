-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copy_ontology_terminology ( NM_TABELA_P text, NM_ATRIBUTO_P text, COPY_NM_TABELA_P text, COPY_NM_ATRIBUTO_P text, CD_VALOR_TASY_P text, IE_ONTOLOGIA_P text) AS $body$
DECLARE


nm_usuario_w                                      RES_CADASTRO_ONTOLOGIA_PHI.nm_usuario%type;
cd_valor_ontologia_w                              RES_CADASTRO_ONTOLOGIA_PHI.cd_valor_ontologia%type;
ds_documentacao_w                                 RES_CADASTRO_ONTOLOGIA_PHI.ds_documentacao%type;

c01 CURSOR FOR
SELECT CD_VALOR_TASY,
       IE_ONTOLOGIA,
       CD_VALOR_ONTOLOGIA,
       DS_DOCUMENTACAO
  from RES_CADASTRO_ONTOLOGIA_PHI
 where nm_tabela = COPY_NM_TABELA_P 
   and nm_atributo = COPY_NM_ATRIBUTO_P
   and ((coalesce(CD_VALOR_TASY_P::text, '') = '' and coalesce(cd_valor_tasy::text, '') = '')
        or ((CD_VALOR_TASY_P IS NOT NULL AND CD_VALOR_TASY_P::text <> '') and cd_valor_tasy = CD_VALOR_TASY_P))
   and ie_ontologia = IE_ONTOLOGIA_P;

BEGIN
  if (NM_TABELA_P = COPY_NM_TABELA_P and NM_ATRIBUTO_P = COPY_NM_ATRIBUTO_P) then
    /* No copy if source and destination is same table-atribute */

    return;
  end if;

   nm_usuario_w := wheb_usuario_pck.get_nm_usuario;

   for c01_w in c01 loop
   
     cd_valor_ontologia_w  := c01_w.cd_valor_ontologia;
     ds_documentacao_w     := c01_w.ds_documentacao;

    insert into RES_CADASTRO_ONTOLOGIA_PHI(nr_sequencia,
       dt_atualizacao,
       nm_usuario,
       dt_atualizacao_nrec,
       nm_usuario_nrec,
       cd_Valor_tasy,
       nm_tabela,
       nm_atributo,
       ie_ontologia,
       cd_valor_ontologia,
       ds_documentacao,
       ie_situacao
       )
    values
      (
       (SELECT min(a.nr_sequencia + 1) from res_cadastro_ontologia_phi a 
            where not exists (select 1 from res_cadastro_ontologia_phi b where b.nr_sequencia = a.nr_sequencia + 1)),
       clock_timestamp(),
       nm_usuario_w,
       clock_timestamp(),
       nm_usuario_w,
       CD_VALOR_TASY_P,
       NM_TABELA_P,
       NM_ATRIBUTO_P,
       IE_ONTOLOGIA_P,
       cd_valor_ontologia_w,
       ds_documentacao_w,
       'A'
       );

     end loop;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copy_ontology_terminology ( NM_TABELA_P text, NM_ATRIBUTO_P text, COPY_NM_TABELA_P text, COPY_NM_ATRIBUTO_P text, CD_VALOR_TASY_P text, IE_ONTOLOGIA_P text) FROM PUBLIC;
